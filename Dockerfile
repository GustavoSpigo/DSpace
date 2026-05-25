ARG REPO_URL=https://github.com/GustavoSpigo/DSpace.git
ARG BRANCH=dspace-6_x
ARG TARGET_DIR=dspace-installer

FROM maven:3-jdk-8 AS build
ARG REPO_URL
ARG BRANCH
ARG TARGET_DIR
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 --branch ${BRANCH} ${REPO_URL} . || (echo "git clone failed" && exit 1)
# If the repository contains a local.cfg for docker build, copy it into /app
RUN if [ -f dspace/src/main/docker/local.cfg ]; then cp dspace/src/main/docker/local.cfg /app/local.cfg; else echo "no local.cfg in repo, continuing"; fi
RUN mvn -f pom.xml -Dmirage2.on=true package && mkdir -p /install \
    && if [ -d /app/dspace/target/${TARGET_DIR} ]; then mv /app/dspace/target/${TARGET_DIR}/* /install; fi \
    && mvn -f pom.xml clean

FROM tomcat:8-jre8 AS ant_build
ARG TARGET_DIR
WORKDIR /dspace-src
COPY --from=build /install /dspace-src
ENV ANT_VERSION 1.10.7
ENV ANT_HOME /tmp/ant-$ANT_VERSION
ENV PATH $ANT_HOME/bin:$PATH
RUN apt-get update \
    && apt-get install -y --no-install-recommends wget \
    && apt-get purge -y --auto-remove \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir $ANT_HOME && \
    wget -qO- "https://archive.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz" | tar -zx --strip-components=1 -C $ANT_HOME
RUN ant init_installation update_configs update_code update_webapps update_solr_indexes

FROM tomcat:8-jre8
ENV DSPACE_INSTALL=/dspace
COPY --from=ant_build /dspace $DSPACE_INSTALL
EXPOSE 8080 8009
ENV JAVA_OPTS=-Xmx2000m
RUN ln -s $DSPACE_INSTALL/webapps/solr    /usr/local/tomcat/webapps/solr    && \
    ln -s $DSPACE_INSTALL/webapps/xmlui   /usr/local/tomcat/webapps/xmlui   && \
    ln -s $DSPACE_INSTALL/webapps/jspui   /usr/local/tomcat/webapps/ROOT   && \
    ln -s $DSPACE_INSTALL/webapps/rest    /usr/local/tomcat/webapps/rest    && \
    ln -s $DSPACE_INSTALL/webapps/oai     /usr/local/tomcat/webapps/oai     && \
    ln -s $DSPACE_INSTALL/webapps/rdf     /usr/local/tomcat/webapps/rdf     && \
    ln -s $DSPACE_INSTALL/webapps/sword   /usr/local/tomcat/webapps/sword   && \
    ln -s $DSPACE_INSTALL/webapps/swordv2 /usr/local/tomcat/webapps/swordv2 || true

RUN sed -i -e "s|\${dspace.dir}|$DSPACE_INSTALL|" $DSPACE_INSTALL/webapps/solr/WEB-INF/web.xml || true && \
    sed -i -e "s|\${dspace.dir}|$DSPACE_INSTALL|" $DSPACE_INSTALL/webapps/rest/WEB-INF/web.xml || true
