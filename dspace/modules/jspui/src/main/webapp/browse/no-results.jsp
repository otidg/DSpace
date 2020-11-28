<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Message indicating that there are no entries in the browse index.
  -
  - Attributes required:
  -    community      - community the browse was in, or null
  -    collection     - collection the browse was in, or null
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page  import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.content.Collection" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.NewsManager" %>

<%

    String topNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-top.html"));        

    request.setAttribute("LanguageSwitch", "hide");

	String layoutNavbar = "default";
	if (request.getAttribute("browseWithdrawn") != null || request.getAttribute("browsePrivate") != null)
	{
	    layoutNavbar = "admin";
	}

	// get the BrowseInfo object
	BrowseInfo bi = (BrowseInfo) request.getAttribute("browse.info");

    // Retrieve community and collection if necessary
    Community community = null;
    Collection collection = null;

    if (bi.inCommunity())
    {
    	community = (Community) bi.getBrowseContainer();
    }
    
    if (bi.inCollection())
    {
    	collection = (Collection) bi.getBrowseContainer();
    }
    
    // FIXME: this is not using the i18n
    // Description of what the user is actually browsing, and where link back
    String linkText = LocaleSupport.getLocalizedMessage(pageContext, "jsp.general.home");
    String linkBack = "/";

    if (collection != null)
    {
        linkText = collection.getMetadata("name");
        linkBack = "/handle/" + collection.getHandle();
    }
    else if (community != null)
    {
        linkText = community.getMetadata("name");
        linkBack = "/handle/" + community.getHandle();
    }
%>
<h1 class="pagehidden">no-results.jsp</h1>
<dspace:layout titlekey="browse.no-results.title" navbar="<%= layoutNavbar %>">
<div class="row nomargintop" >
    <h1 class="pagehidden">no-results.jsp</h1>
    
    <div class="rowimage">
        <img class="img-responsive" src="<%= request.getContextPath() %>/image/buscador.png" width="100%" alt=""/>  
    </div>        
    <div class="topNews_msg">
        <%= topNews %>        
		<img class="imgCtycBanner" src="<%= request.getContextPath() %>/image/l.2-.png">
    </div> 
</div>
<br/><br/>
    <div class="container ">
        <div class="row bgcytc_lightgray" class="text-center">
            
        
    
            <h1 class="text-center"><fmt:message key="browse.no-results.title"/></h1>

<p class="text-center">
    <%
	    if (collection != null)
	    {
   %>
            	<fmt:message key="browse.no-results.col">
                    <fmt:param><%= collection.getMetadata("name")%></fmt:param>
                </fmt:message>
   <%
	    }
	    else if (community != null)
	    {
   %>
   		<fmt:message key="browse.no-results.com">
            <fmt:param><%= community.getMetadata("name")%></fmt:param>
        </fmt:message>
   <%
 	    }
 	    else
 	    {
   %>
   		<fmt:message key="browse.no-results.genericScope"/>
   <%
   	    }
   %>
 </p>
   
    <p class="text-center"><a href="<%= request.getContextPath() %><%= linkBack %>"><%= linkText %></a></p>

    <%-- dump the results for debug (uncomment to enable) --%>
    <%--
	<!-- <%= bi.toString() %> -->
	--%>
        </div>
</div>
</dspace:layout>
