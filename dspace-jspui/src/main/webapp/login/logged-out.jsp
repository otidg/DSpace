<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Displays a message indicating the user has logged out
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout locbar="nolink" titlekey="jsp.login.logged-out.title">
<script>
    jQuery(document).ready(function() {
    	
    	var token = "";
    	
        var successHandler = function(result, status, xhr) {
            token = xhr.getResponseHeader('Authorization').split(" ")[1];
            setTimeout(function() {
                jQuery.ajax({ 
             	   type : "GET", 
             	   url : window.location.href.replace("logout", "dspace-spring-rest/") + 'api/authn/logout',
             	   headers: {'other': 'headers', 'Content-Type': 'application/json', 'Authorization': token},
             	   success : function(result) { 
             		  jQuery("#logoutImg").attr("src", "<%= request.getContextPath() %>/Shibboleth.sso/Logout");
             	   }, 
             	   error : function(result) { 
             	     //handle the error 
             	   } 
             	 });    
            }, 2000);
        };  

        jQuery.ajax({
          url : window.location.href.replace("logout", "dspace-spring-rest/") + 'api/authn/login',
    	  headers: {'other': 'headers', 'Content-Type': 'application/json'},
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
    <%-- <h1>Logged Out</h1> --%>
    <h1><fmt:message key="jsp.login.logged-out.title"/></h1>
    <%-- <p>Thank you for remembering to log out!</p> --%>
    <p><fmt:message key="jsp.login.logged-out.thank"/></p>
    <div style="visibility:hidden">
		<img id="logoutImg"/>
	</div>
    <%-- <p><a href="<%= request.getContextPath() %>/">Go to DSpace Home</a></p> --%>
    <p><a href="<%= request.getContextPath() %>/"><fmt:message key="jsp.general.gohome"/></a></p>

</dspace:layout>
