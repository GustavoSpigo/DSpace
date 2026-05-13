<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Default navigation bar
--%>

<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="/WEB-INF/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="java.util.Map" %>
<%
    // Is anyone logged in?
    EPerson user = (EPerson) request.getAttribute("dspace.current.user");

    // Is the logged in user an admin
    Boolean admin = (Boolean)request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());

    Boolean communityAdmin = (Boolean)request.getAttribute("is.communityAdmin");
    boolean isCommunityAdmin = (communityAdmin == null ? false : communityAdmin.booleanValue());
    
    Boolean collectionAdmin = (Boolean)request.getAttribute("is.collectionAdmin");
    boolean isCollectionAdmin = (collectionAdmin == null ? false : collectionAdmin.booleanValue());

    String siteName = ConfigurationManager.getProperty("dspace.name");

    // Get the current page, minus query string
    String currentPage = UIUtil.getOriginalURL(request);
    int c = currentPage.indexOf( '?' );
    if( c > -1 )
    {
        currentPage = currentPage.substring( 0, c );
    }

    // E-mail may have to be truncated
    String navbarEmail = null;

    if (user != null)
    {
        navbarEmail = user.getEmail();
    }
    
    // get the browse indices
    
	BrowseIndex[] bis = BrowseIndex.getBrowseIndices();
    BrowseInfo binfo = (BrowseInfo) request.getAttribute("browse.info");
    String browseCurrent = "";
    if (binfo != null)
    {
        BrowseIndex bix = binfo.getBrowseIndex();
        // Only highlight the current browse, only if it is a metadata index,
        // or the selected sort option is the default for the index
        if (bix.isMetadataIndex() || bix.getSortOption() == binfo.getSortOption())
        {
            if (bix.getName() != null)
    			browseCurrent = bix.getName();
        }
    }
 // get the locale languages
    Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    Locale sessionLocale = UIUtil.getSessionLocale(request);
%>
       <div class="navbar-header">
         <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
           <span class="icon-bar"></span>
         </button>
       </div>

       <nav class="collapse navbar-collapse bs-navbar-collapse" role="navigation">
       <div>
        <div class="siteName">Repositório Institucional do Conhecimento - RIC-CPS</div> 
        

</div>
<div class="fundoMenu">
  <a class="navbar-brand" href="https://www.cps.sp.gov.br/" target="_blank"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="25" height="25" viewBox="0 0 100 60" style="float: left;">
  <path fill="#FFF" d="M69.347 25.342c.068-2.086.973-2.918 3.963-2.918h16.479v-5.842H74.354c-7.303 0-11.403 3.129-11.403 9.037 0 11.538 21.065 9.178 21.065 15.295 0 2.084-1.114 3.198-3.963 3.198H58.5c2.179-2.659 3.509-6.089 3.509-10.015 0-9.867-6.394-18.209-17.238-18.209-9.802 0-16.824 7.365-16.824 18.351v2.728H20.52c-5.77 0-11.469-3.754-11.469-10.846 0-7.089 5.699-10.844 11.469-10.844h4.729v-5.84h-5.838c-7.787 0-16.754 5.979-16.754 16.684 0 10.703 8.967 16.684 16.754 16.684h8.536v24.242h6.119V42.805h11.646v-5.838H34.066V35.35c0-9.175 4.866-13.621 10.705-13.621 6.534 0 11.123 4.792 11.123 11.607 0 5.855-3.173 9.656-8.184 10.776h-7.806v5.838h40.148c5.911 0 10.36-2.99 10.36-9.316.001-11.956-21.134-9.521-21.065-15.292z"></path>
  </svg></a>
  <a class="navbar-brand"href="https://cgd.cps.sp.gov.br/nucleo-de-biblioteca-nb-cgd/" style="padding: 9px 9px;" target="_blank">
    <img height="28" src="<%= request.getContextPath() %>/image/nbcgd.png" alt="NB/CGD logo" />
  </a>
  <a class="navbar-brand"  href="<%= request.getContextPath() %>/"> 
    <img height="25" src="<%= request.getContextPath() %>/image/ric-logo.png" alt="DSpace logo" />
  </a>
  
  <ul class="nav navbar-nav">
          <li class="<%= currentPage.endsWith("/about/")? "active" : "" %>"><a href="<%= request.getContextPath() %>/about"><i class="material-icons">info</i> <span id="msg-about"><fmt:message key="jsp.layout.navbar-default.about"/></span></a></li>
          <li class="<%= ( currentPage.endsWith( "/controlledvocabulary/info.jsp" ) ? "active" : "" ) %>"><a href="<%= request.getContextPath() %>/controlledvocabulary/info.jsp"><i class="material-icons">spellcheck</i> Vocabulário Controlado</a></li>
          <li class="<%= ( currentPage.endsWith( "/graphics/info.jsp" ) ? "active" : "" ) %>"><a href="<%= request.getContextPath() %>/graphics/info.jsp"><i class="material-icons">analytics</i> Relatórios</a></li>
          <li class="<%= ( currentPage.endsWith( "/help" ) ? "active" : "" ) %>"><a href="<%= request.getContextPath() %>/help/index.jsp"><i class="material-icons">help</i> <fmt:message key="jsp.layout.navbar-default.help"/></a></li>
          <!--li class="<%= currentPage.endsWith("/contact/")? "active" : "" %>"><a id="lbl-contato" href="<%= request.getContextPath() %>/contact"><i class="material-icons">contact_support</i> <fmt:message key="jsp.register.profile-form.phone.field"/></a></li-->
          <script>
            label = "<fmt:message key="jsp.layout.navbar-default.about"/>";
            document.getElementById("msg-about").innerHTML = label.replace("o DSpace","").replace("DSpace","");
            label2 = "<fmt:message key="jsp.layout.navbar-default.home"/>"; 
            document.getElementById("msg-home").innerHTML = label2.replace("Página inicial","").replace("Início","");
          </script>
          <% if (isAdmin || isCommunityAdmin || isCollectionAdmin) { %>
            <li class="dropdown"><a href="#"><i class="material-icons">settings</i></a>
              <div class="fundoMenu" id="menu-admin">
                <jsp:include page="/layout/navbar-admin.jsp"/>
              </div>
            </li>
          <% } %>
  </ul>
          <div class="nav navbar-nav navbar-right" style="display:table-cell">
		<ul class="nav navbar-nav navbar-right">
         <li class="dropdown">
         <%
    if (user != null)
    {
		%>
		<a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="material-icons">person</span> <b class="caret"></b></a>
		<%
    } else {
		%>
             <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="material-icons">person_outline</span> <b class="caret"></b></a>
	<% } %>             
             <ul class="dropdown-menu">
               <li><a href="<%= request.getContextPath() %>/mydspace"><fmt:message key="jsp.layout.navbar-default.users"/></a></li>
               <li><a href="<%= request.getContextPath() %>/subscribe"><fmt:message key="jsp.layout.navbar-default.receive"/></a></li>
               <li><a href="<%= request.getContextPath() %>/profile"><fmt:message key="jsp.layout.navbar-default.edit"/></a></li>

		<%
                if (isAdmin || isCommunityAdmin || isCollectionAdmin) {
                %>
			   <li class="divider"></li>
                           <% if (isAdmin) {%>
                    
                                <li><a href="<%= request.getContextPath()%>/dspace-admin">
                           <% } else if (isCommunityAdmin || isCollectionAdmin) {%>
                        
                                <li><a href="<%= request.getContextPath()%>/tools">
                <% } %>
                <fmt:message key="jsp.administer"/></a></li>
                <%
                    }
		  if (user != null) {
		%>
		<li><a href="<%= request.getContextPath() %>/logout"><span class="glyphicon glyphicon-log-out"></span> <fmt:message key="jsp.layout.navbar-default.logout"/></a></li>
		<% } %>
             </ul>
           </li>
          </ul>
       
	</div>
  <% if (supportedLocales != null && supportedLocales.length > 1)
     {
 %>
    <div class="nav navbar-nav navbar-right" style="margin-left: 20px;">
	 <ul class="nav navbar-nav navbar-right">
      <li class="dropdown">
       <a href="#" class="dropdown-toggle" data-toggle="dropdown"><span class="material-icons">translate</span><b class="caret"></b></a>
        <ul class="dropdown-menu">
 <%
    for (int i = supportedLocales.length-1; i >= 0; i--)
     {
 %>
      <li>
        <a onclick="javascript:document.repost.locale.value='<%=supportedLocales[i].toString()%>';
                  document.repost.submit();" href="<%= request.getContextPath() %>?locale=<%=supportedLocales[i].toString()%>">
         <%= supportedLocales[i].getDisplayLanguage(supportedLocales[i])%>
       </a>
      </li>
 <%
     }
 %>
     </ul>
    </li>
    </ul>
  </div>
 <%
   }
 %>
</div>
    </nav>
