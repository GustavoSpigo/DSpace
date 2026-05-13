<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.List"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.services.ConfigurationService" %>
<%@ page import="org.dspace.services.factory.DSpaceServicesFactory" %>


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
          </td>
        </tr></table>
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
<%@page import="org.dspace.core.factory.CoreServiceFactory"%>
<%@page import="org.dspace.core.service.NewsService"%>
<%@page import="org.dspace.content.service.CommunityService"%>
<%@page import="org.dspace.content.factory.ContentServiceFactory"%>
<%@page import="org.dspace.content.service.ItemService"%>
<%@page import="org.dspace.core.Utils"%>
<%@page import="org.dspace.content.Bitstream"%>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="java.util.List"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.services.ConfigurationService" %>
<%@ page import="org.dspace.services.factory.DSpaceServicesFactory" %>
<%

List<Community> communities = (List<Community>) request.getAttribute("communities");

//List<Community> communities = (List<Community>) community.getSubcommunities();
//request.getAttribute("communities");
ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));
int num = 0;
for (int j = 0; j < communities.size(); j++)
{
  num += ic.getCount(communities.get(j));
}
%>
<div class="box-sidebar">
<div class="box-title">Total de Arquivos</div>
  <p class="box-content"><%= num %> arquivos</p>
</div>

<div class="box-sidebar">
  <div class="box-title">Navegar</div>
    <div class="box-content">
      <div><a href="<%= request.getContextPath() %>/browse?type=title&sort_by=2&order=DESC">Por data de documento</a></div>
      <div><a href="<%= request.getContextPath() %>/browse?type=author">Autores</a></div>
      <div><a href="<%= request.getContextPath() %>/browse?type=title">Títulos</a></div>
      <div><a href="<%= request.getContextPath() %>/browse?type=subject">Assuntos</a></div>
      <div><a href="<%= request.getContextPath() %>/browse?type=sponsorship">Cursos</a></div>
    </div>
</div>