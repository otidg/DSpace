<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Feedback form JSP
  -
  - Attributes:
  -    feedback.problem  - if present, report that all fields weren't filled out
  -    authenticated.email - email of authenticated user, if any
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    boolean problem = (request.getParameter("feedback.problem") != null);
    String email = request.getParameter("email");

    if (email == null || email.equals(""))
    {
        email = (String) request.getAttribute("authenticated.email");
    }

    if (email == null)
    {
        email = "";
    }

    String feedback = request.getParameter("feedback");
    if (feedback == null)
    {
        feedback = "";
    }

    String fromPage = request.getParameter("fromPage");
    if (fromPage == null)
    {
		fromPage = "";
    }
    
    String crisClaimedProfile = (String)request.getAttribute("feedback.crisclaim");
%>

<dspace:layout titlekey="jsp.feedback.form.title">
    <%-- <h1>Feedback Form</h1> --%>
    
    <div class="rowimage">
        <img  class="topimgcytc img-responsive" src="<%= request.getContextPath() %>/image/1.PaginaInicial-.png" width="100%" alt=""/>  
    </div>        
    <br/>
    <br/>
    <div class=" rowtitlecytc bgcytc_blue nobrdradius">
        <h5 class=" panel-heading ">
            <div class="container">
                <dspace:include page="/layout/location-bar.jsp" />            
            </div>
        </h5>
    </div>     
    <div class="row">
    
    <div class="container">
            <br/>
            <h1 class=" clrcytc_blue font_bolder">&nbsp;<fmt:message key="jsp.feedback.form.title"/></h1>
        <%
            if (crisClaimedProfile!=null)
            {
        %>
                <p class="pcontact clrcytc_blue "><fmt:message key="jsp.feedback.form.isaclaimprofile"><fmt:param><%= crisClaimedProfile %></fmt:param></fmt:message></p>
        <%
            } else {
        %>
                <%-- <p>Thanks for taking the time to share your feedback about the
                DSpace system. Your comments are appreciated!</p> --%>
                <p class="pcontact clrcytc_blue "><fmt:message key="jsp.feedback.form.text1"/></p>
        <%
            }
        %>
        <%
            if (problem)
            {
        %>
                <%-- <p><strong>Please fill out all of the information below.</strong></p> --%>
                <p class="pcontact clrcytc_blue"><strong><fmt:message key="jsp.feedback.form.text2"/></strong></p>
        <%
            }
        %>
    </div>
    <form action="<%= request.getContextPath() %>/feedback" method="post">
        
		<div class="form-group marginboxcytc bgcytc_lightgray">
            <div class="container">
                <div class="input-group-addon ">
                    <span class="col-md-3 text-right"><label class="btn btn-primary labelpadding bgcytc_green clrcytc_white brdradius font_bolder" for="temail"><fmt:message
                                key="jsp.feedback.form.email" /></label></span> <span class="col-md-8"><input
                        class="form-control brdradius2" type="text" name="email" id="temail" size="50"
                        value="<%=StringEscapeUtils.escapeHtml(email)%>" /></span>
                </div>			
            </div>
		</div>
		<div class="form-group marginboxcytc bgcytc_lightgray">
            <div class="container">        
                <div class="input-group-addon ">
                    <span class="col-md-3 text-right"><label  class="btn btn-primary labelpadding bgcytc_lightblue clrcytc_white brdradius font_bolder"  for="tfeedback"><fmt:message
                                key="jsp.feedback.form.comment" /></label></span> <span class="col-md-8">
                                
                                <%
        if (crisClaimedProfile!=null)
        {
    %>
                <textarea class="form-control brdradius2" name="feedback" id="tfeedback" rows="6" cols="50"><fmt:message key="jsp.feedback.textclaim"><fmt:param><%= crisClaimedProfile %></fmt:param></fmt:message></textarea>
    <%
        } else {
    %>
                <textarea class="form-control brdradius2" name="feedback" id="tfeedback" rows="6" cols="50"><%=StringEscapeUtils.escapeHtml(feedback)%></textarea>
    <%
        }
    %>
                    
                    </span>
                </div>	
            </div>		
		</div>
		<div class="form-group text-right">
            <div class="container">
                <div class="input-group-addon">
                    <div class="col-md-offset-3 col-md-8 text-right">
                        <input style="width:150px" class="btn btn-default bgcytc_green clrcytc_white brdradius font_bolder" type="submit" name="submit" value="<fmt:message key="jsp.feedback.form.send"/>" />
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>
</dspace:layout>
