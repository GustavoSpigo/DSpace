<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - fragment JSP to be included in site, community or collection home to show discovery facets
  -
  - Attributes required:
  -    discovery.fresults    - the facets result to show
  -    discovery.facetsConf  - the facets configuration
  -    discovery.searchScope - the search scope 
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.discovery.configuration.DiscoverySearchFilterFacet"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.Map"%>
<%@ page import="org.dspace.discovery.DiscoverResult.FacetResult"%>
<%@ page import="java.util.List"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>

<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>

<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="org.dspace.browse.ItemCounter"%>
<%@ page import="org.dspace.content.*"%>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.eperson.Group"     %>
<%@ page import="org.dspace.services.ConfigurationService" %>
<%@ page import="org.dspace.services.factory.DSpaceServicesFactory" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%


Community  community_  = (Community) request.getAttribute("community"); 
Collection collection_ = (Collection) request.getAttribute("collection"); 


%>

<div class="box-sidebar">
	<div class="box-title">Pesquisar</div>
	<%-- Search Box --%>
		<form method="get" action="<%= request.getContextPath() %>/simple-search" class="navbar-form">
			<div class="form-group">
			<input type="text" class="form-control" placeholder="Termo de busca" name="query" id="tequery" size="25"/>
			</div>
			<table style="width:100%"><tr>
			<td>
				<label class="btn btn-danger" style="width: 100%;" onclick="this.form.submit()">no RIC-CPS
				<input type="radio" name="location" value=""  style="display:none" selected />
				</label>
			</td></tr>
<% if(community_ != null){  %>
			<tr><td> 
				<label class="btn btn-danger" style="width: 100%;" onclick="this.form.submit()">na comunidade
				<input type="radio" name="location" value="<%= community_.getHandle() %>"  style="display:none" />
				</label>
			</td></tr>
<% }  %>
<% if(collection_ != null){  %> 
			<tr>
			<td>
				<label class="btn btn-danger" style="width: 100%;" onclick="this.form.submit()">na coleção atual  
				<input type="radio" name="location" value="<%= collection_.getHandle() %>"  style="display:none" />
				</label>
			</td></tr>
<% }  %>
			</table>
			<button type="submit" style="display:none" class="btn btn-primary"><span class="glyphicon glyphicon-search"></span></button>

	<%--               <br/><a href="<%= request.getContextPath() %>/advanced-search"><fmt:message key="jsp.layout.navbar-default.advanced"/></a>
	<%
				if (ConfigurationManager.getBooleanProperty("webui.controlledvocabulary.enable"))
				{
	%>        
				<br/><a href="<%= request.getContextPath() %>/subject-search"><fmt:message key="jsp.layout.navbar-default.subjectsearch"/></a>
	<%
				}
	%> --%>
		</form>

	</div>
<%
	boolean brefine = false;
	
	Map<String, List<FacetResult>> mapFacetes = (Map<String, List<FacetResult>>) request.getAttribute("discovery.fresults");
	List<DiscoverySearchFilterFacet> facetsConf = (List<DiscoverySearchFilterFacet>) request.getAttribute("facetsConfig");
	String searchScope = (String) request.getAttribute("discovery.searchScope");
	if (searchScope == null)
	{
	    searchScope = "";
	}
	
	if (mapFacetes != null)
	{
	    for (DiscoverySearchFilterFacet facetConf : facetsConf)
		{
		    String f = facetConf.getIndexFieldName();
		    List<FacetResult> facet = mapFacetes.get(f);
		    if (facet != null && facet.size() > 0)
		    {
		        brefine = true;
		        break;
		    }
		    else
		    {
		        facet = mapFacetes.get(f+".year");
			    if (facet != null && facet.size() > 0)
			    {
			        brefine = true;
			        break;
			    }
		    }
		}
	}
	if (brefine) {
%>
<div class="col-md-<%= discovery_panel_cols %>">
<h3 class="facets"><fmt:message key="jsp.search.facet.refine" /></h3>
<div id="facets" class="facetsBox row panel">
<%
	for (DiscoverySearchFilterFacet facetConf : facetsConf)
	{
    	String f = facetConf.getIndexFieldName();
    	List<FacetResult> facet = mapFacetes.get(f);
 	    if (facet == null)
 	    {
 	        facet = mapFacetes.get(f+".year");
 	    }
 	    if (facet == null)
 	    {
 	        continue;
 	    }
	    String fkey = "jsp.search.facet.refine."+f;
	    int limit = facetConf.getFacetLimit()+1;
	    %><div id="facet_<%= f %>" class="facet col-md-<%= discovery_facet_cols %>">
	    <span class="facetName"><fmt:message key="<%= fkey %>" /></span>
	    <ul class="list-group"><%
	    int idx = 1;
	    int currFp = UIUtil.getIntParameter(request, f+"_page");
	    if (currFp < 0)
	    {
	        currFp = 0;
	    }
	    if (facet != null)
	    {
		    for (FacetResult fvalue : facet)
		    { 
		        if (idx != limit)
		        {
		        %><li class="list-group-item"><span class="badge"><%= fvalue.getCount() %></span> <a href="<%= request.getContextPath()
		            + searchScope
	                + "/simple-search?filterquery="+URLEncoder.encode(fvalue.getAsFilterQuery(),"UTF-8")
	                + "&amp;filtername="+URLEncoder.encode(f,"UTF-8")
	                + "&amp;filtertype="+URLEncoder.encode(fvalue.getFilterType(),"UTF-8") %>"
	                title="<fmt:message key="jsp.search.facet.narrow"><fmt:param><%=fvalue.getDisplayedValue() %></fmt:param></fmt:message>">
	                <%= StringUtils.abbreviate(fvalue.getDisplayedValue(),36) %></a></li><%
		        }
		        idx++;
		    }
		    if (currFp > 0 || idx > limit)
		    {
		        %><li class="list-group-item"><span style="visibility: hidden;">.</span>
		        <% if (currFp > 0) { %>
		        <a class="pull-left" href="<%= request.getContextPath()
		                + searchScope
		                + "?"+f+"_page="+(currFp-1) %>"><fmt:message key="jsp.search.facet.refine.previous" /></a>
	            <% } %>
	            <% if (idx > limit) { %>
	            <a href="<%= request.getContextPath()
		            + searchScope
	                + "?"+f+"_page="+(currFp+1) %>"><span class="pull-right"><fmt:message key="jsp.search.facet.refine.next" /></span></a>
	            <%
	            }
	            %></li><%
		    }
	    }
	    %></ul></div><%
	}
%></div></div><%
	}
%>