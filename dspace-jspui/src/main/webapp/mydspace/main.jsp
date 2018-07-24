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
	String baseWebappURL = ConfigurationManager.getProperty("dspace.baseUrl");
%>

<script type='text/javascript' src="<%= request.getContextPath() %>/static/js/jquery/jquery-1.11.3.min.js"></script>
<link href="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css" rel="stylesheet"/>
<script src="//cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>

<fmt:message var="redirectLabel" key="jsp.mydspace.success.redirect"/>
<fmt:message var="successLabel" key="jsp.mydspace.success.login"/>
<script>
    jQuery(document).ready(function() {
        var successHandler = function(result, status, xhr) {
        	var token = xhr.getResponseHeader('Authorization').split(" ")[1];
        	toastr.success('${redirectLabel}', '${successLabel}');
            setTimeout(function() {
            	window.location.href = '<%= angularWebappURL %>/login?token=' + token;
            }, 2000);
        };  

        toastr.options = {
                "closeButton": false,
                "debug": false,
                "newestOnTop": false,
                "progressBar": false,
                "positionClass": "toast-top-center",
                "preventDuplicates": false,
                "showDuration": "300",
                "hideDuration": "1000",
                "timeOut": "3000",
                "extendedTimeOut": "1000",
                "showEasing": "swing",
                "hideEasing": "linear",
                "showMethod": "fadeIn",
                "hideMethod": "fadeOut",
                "onclick" : function() { toastr.remove(); }
            }
        
        jQuery.ajax({
          type : 'POST',
          url : "<%= baseWebappURL + "/dspace-spring-rest/api/authn/login"%>",
          headers : {
              "Content-Type" : 'application/json'
          },
          success : successHandler,
          error : function(result, status, xhr) {
              if (xhr == 401) {
                  var loc = result.getResponseHeader("location");
                  if (loc != null && loc != "") {
                      document.location = loc;
                  }
              }
          }
        });

    });
</script>
