 <%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Renders a whole HTML page for displaying item metadata.  Simply includes
  - the relevant item display component in a standard HTML page.
  -
  - Attributes:
  -    display.all - Boolean - if true, display full metadata record
  -    item        - the Item to display
  -    collections - Array of Collections this item appears in.  This must be
  -                  passed in for two reasons: 1) item.getCollections() could
  -                  fail, and we're already committed to JSP display, and
  -                  2) the item might be in the process of being submitted and
  -                  a mapping between the item and collection might not
  -                  appear yet.  If this is omitted, the item display won't
  -                  display any collections.
  -    admin_button - Boolean, show admin 'edit' button
  -    submitter_button - Boolean, show submitter "new version" button
  --%>
<%@page contentType="text/html;charset=UTF-8" %>

<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@page import="org.dspace.content.Collection" %>
<%@page import="org.dspace.content.Item" %>
<%@page import="org.dspace.core.ConfigurationManager" %>
<%@page import="org.dspace.handle.HandleServiceImpl" %>
<%@page import="org.dspace.license.CreativeCommonsServiceImpl" %>
<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%@page import="org.dspace.versioning.Version"%>
<%@page import="org.dspace.core.Context"%>
<%@page import="org.dspace.app.webui.util.VersionUtil"%>
<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%@page import="org.dspace.authorize.AuthorizeServiceImpl"%>
<%@page import="java.util.List"%>
<%@page import="org.dspace.core.Constants"%>
<%@page import="org.dspace.eperson.EPerson"%>
<%@page import="org.dspace.versioning.VersionHistory"%>
<%@page import="org.dspace.plugin.PluginException"%>
<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>
<%@page import="org.dspace.content.factory.ContentServiceFactory" %>
<%@page import="org.dspace.content.MetadataValue" %>
<%@page import="org.dspace.license.factory.LicenseServiceFactory" %>
<%@page import="org.dspace.license.service.CreativeCommonsService" %>
<%@page import="org.dspace.handle.factory.HandleServiceFactory" %>
<%@page import="org.dspace.versioning.service.VersionHistoryService" %>
<%@page import="org.dspace.versioning.factory.VersionServiceFactory" %>
<%

    Context context = UIUtil.obtainContext(request);
    EPerson user = (EPerson) context.getCurrentUser();

    String layoutNavbar = "default"; 
%>
<dspace:layout titlekey="browse.page-title" navbar="<%=layoutNavbar %>">
<iframe title="Report Section" style="width:100vw" height="804" 
	src="https://app.powerbi.com/view?r=eyJrIjoiYTk5MGM2ODYtZDUxOS00YmZkLTk4ZGItYmJkYWYzYzExZTBjIiwidCI6ImVhYmU2NGM1LTY4ZjUtNGE3Ni04MzAxLTk1NzdhNjc5ZTQ0OSIsImMiOjR9" frameborder="0" allowFullScreen="true"></iframe>       
<style>
    body.undernavigation{
        padding-top: 198px;
    }
    main .container {
    width: 100vw;
    margin-left: 0;
    margin-right: 0;
}
</style>
<script>   
  // Here "addEventListener" is for standards-compliant web browsers and "attachEvent" is for IE Browsers.
  var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
  var eventer = window[eventMethod];


  var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";

  
  // Listen to message from child IFrame window
  eventer(messageEvent, function (e) {
    var data = jQuery.parseJSON(e.data);
    document.getElementById('ifrm-spigo').style.height = data['altura'] + 'px';
  }, false); 
</script>
</dspace:layout>