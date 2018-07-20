<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Main My DSpace page
  -
  -
  - Attributes:
  -    mydspace.user:    current user (EPerson)
  -    workspace.items:  List<WorkspaceItem> array for this user
  -    workflow.items:   List<WorkflowItem> array of submissions from this user in
  -                      workflow system
  -    workflow.owned:   List<WorkflowItem> array of tasks owned
  -    workflow.pooled   List<WorkflowItem> array of pooled tasks
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.core.ConfigurationManager"%>

<%
    String angularWebappURL = ConfigurationManager.getProperty("dspace.angularui");
	response.sendRedirect(angularWebappURL + "/mydspace");
%>
