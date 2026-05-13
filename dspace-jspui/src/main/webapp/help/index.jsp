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
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://code.getmdl.io/1.3.0/material.indigo-pink.min.css">
    <script defer src="https://code.getmdl.io/1.3.0/material.min.js"></script>

<%  if (user == null) { %>
    <form action="https://spigo.net/tamandua/getDspace.php" method="POST">
        
      <h4>Envie sua dúvida, sugestão ou problema encontrado</h4>
            
        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
            <input class="mdl-textfield__input" type="nome" id="nome" name="nome" required>
            <label class="mdl-textfield__label" for="nome">Nome (obrigatório)</label>
        </div>
    
        <br>
    
        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
            <input class="mdl-textfield__input" type="mail" id="mail" name="mail" required>
            <label class="mdl-textfield__label" for="mail">E-mail de contato (obrigatório)</label>
        </div>
    
      <h5>Tipo de dúvida</h5>
        <br>
       <label class="mdl-radio mdl-js-radio mdl-js-ripple-effect" for="option-1">
          <input type="radio" id="option-1" class="mdl-radio__button" name="options" value="Biblioteconomia" checked>
          <span class="mdl-radio__label">Biblioteconomia</span>
        </label>
        <br>
        <label class="mdl-radio mdl-js-radio mdl-js-ripple-effect" for="option-2">
          <input type="radio" id="option-2" class="mdl-radio__button" name="options" value="Tecn. da Informação">
          <span class="mdl-radio__label">Tecn. da Informação</span>
        </label>
        
        <br> 
        <br>
       
        <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
            <textarea class="mdl-textfield__input" rows= "5" id="duvida" name="duvida" required></textarea>
            <label class="mdl-textfield__label" for="duvida">Descreva a sua dúvida</label>
        </div>

        <br>

        <!-- Colored raised button -->
        <button class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored">
            Enviar
        </button>
    </form>

<% }else{ %>
    <form action="https://spigo.net/tamandua/getDspace.php" method="POST">

      <h4>Olá <%= user.getFullName() %>, envie sua dúvida, sugestão ou problema encontrado</h4>

       <input type="hidden" name="nome" value="<%=user.getFullName()%>" /> 
       <input type="hidden" name="mail" value="<%=user.getEmail()%>" />
      <br>
  
      <div class="mdl-textfield mdl-js-textfield mdl-textfield--floating-label">
          <input class="mdl-textfield__input" type="url" id="link" name="link" required >
          <label class="mdl-textfield__label" for="link">Link ou URL da página</label>
      </div>
  
      <br><br>
      
      
      <h5>Tipo de dúvida</h5>
        <br>
       <label class="mdl-radio mdl-js-radio mdl-js-ripple-effect" for="option-1">
          <input type="radio" id="option-1" class="mdl-radio__button" name="options" value="Biblioteconomia" checked>
          <span class="mdl-radio__label">Biblioteconomia</span>
        </label>
        <br>
        <label class="mdl-radio mdl-js-radio mdl-js-ripple-effect" for="option-2">
          <input type="radio" id="option-2" class="mdl-radio__button" name="options" value="Tecn. da Informação">
          <span class="mdl-radio__label">Tecn. da Informação</span>
        </label>
        


      <br>
     
      <div class="mdl-textfield mdl-js-textfield">
          <textarea class="mdl-textfield__input" type="duvida" rows= "5" id="duvida"  name="duvida" required></textarea>
          <label class="mdl-textfield__label" for="duvida">Descreva a sua dúvida</label>
      </div>

      <br>

      <!-- Colored raised button -->
      <button class="mdl-button mdl-js-button mdl-button--raised mdl-button--colored">
          Enviar
      </button>


  
  
  
  </form>
<% } %>
</dspace:layout>