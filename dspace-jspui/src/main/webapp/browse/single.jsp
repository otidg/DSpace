<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - 
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.browse.BrowseInfo" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.content.DCDate" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@page import="org.dspace.core.NewsManager" %>

<%
    
        String topNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-top.html"));     
        
        request.setAttribute("LanguageSwitch", "hide");

	//First, get the browse info object
	BrowseInfo bi = (BrowseInfo) request.getAttribute("browse.info");
	BrowseIndex bix = bi.getBrowseIndex();

	//values used by the header
	String scope = "";
	String type = "";

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
	
	if (community != null)
	{
		scope = "\"" + community.getMetadata("name") + "\"";
	}
	if (collection != null)
	{
		scope = "\"" + collection.getMetadata("name") + "\"";
	}
	
	type = bix.getName();
	
	//FIXME: so this can probably be placed into the Messages.properties file at some point
	// String header = "Browsing " + scope + " by " + type;
	
	// get the values together for reporting on the browse values
	// String range = "Showing results " + bi.getStart() + " to " + bi.getFinish() + " of " + bi.getTotal();
	
	// prepare the next and previous links
	String linkBase = request.getContextPath() + "/";
	if (collection != null)
	{
		linkBase = linkBase + "handle/" + collection.getHandle() + "/";
	}
	if (community != null)
	{
		linkBase = linkBase + "handle/" + community.getHandle() + "/";
	}
	
	String direction = (bi.isAscending() ? "ASC" : "DESC");
	String sharedLink = linkBase + "browse?type=" + URLEncoder.encode(bix.getName(), "UTF-8") +
						"&amp;order=" + URLEncoder.encode(direction, "UTF-8") +
						"&amp;rpp=" + URLEncoder.encode(Integer.toString(bi.getResultsPerPage()), "UTF-8");
	
	// prepare the next and previous links
	String next = sharedLink;
	String prev = sharedLink;
	
	if (bi.hasNextPage())
    {
        next = next + "&amp;offset=" + bi.getNextOffset();
    }

	if (bi.hasPrevPage())
    {
        prev = prev + "&amp;offset=" + bi.getPrevOffset();
    }

	// prepare a url for use by form actions
	String formaction = request.getContextPath() + "/";
	if (collection != null)
	{
		formaction = formaction + "handle/" + collection.getHandle() + "/";
	}
	if (community != null)
	{
		formaction = formaction + "handle/" + community.getHandle() + "/";
	}
	formaction = formaction + "browse";
	
	String ascSelected = (bi.isAscending() ? "selected=\"selected\"" : "");
	String descSelected = (bi.isAscending() ? "" : "selected=\"selected\"");
	int rpp = bi.getResultsPerPage();
	
//	 the message key for the type
	String typeKey = "browse.type.metadata." + bix.getName();
%>
<c:set var="fmtkey">
 jsp.layout.navbar-default.cris.${location}
</c:set>
<c:set var="locbarType"><c:choose><c:when test="${location eq null}"><c:set var="fmtkey"></c:set></c:when><c:otherwise>link</c:otherwise></c:choose></c:set>
                
<dspace:layout titlekey="browse.page-title" locbar="${locbarType}" parenttitlekey="${fmtkey}" parentlink="/cris/explore/${location}">
<div class="row nomargintop" >
    <h1 class="pagehidden">single.jsp</h1>
    
    <div class="rowimage">
        <img class="img-responsive" src="<%= request.getContextPath() %>/image/s.2.2-.png" width="100%" alt=""/>  
    </div>       
    <div class="topNews_msg">
        <%= topNews %>            
    </div>
</div>
<br/><br/>
<div class=" rowtitlecytc bgcytc_blue nobrdradius">
    
    <h5 class=" panel-heading ">        
        <div class="container">
            <dspace:include page="/layout/location-bar.jsp" />            
        </div>        
    </h5>
</div> 
        <br/>    
<div class="container ">
    <div class="bgcytc_lightgray">
	<%-- Build the header (careful use of spacing) --%>
	<h2 class="clrcytc_blue h2full">
		<fmt:message key="browse.single.header"><fmt:param value="<%= scope %>"/></fmt:message> <fmt:message key="<%= typeKey %>"/>
	</h2>
	
<%
	if (!bix.isTagCloudEnabled())
	{
%>
	<%-- Include the main navigation for all the browse pages --%>
	<%-- This first part is where we render the standard bits required by both possibly navigations --%>
<%  if (bi.hasPrevPage() || bi.hasNextPage()) { %>
	<div id="browse_navigation" class="well text-center">
	<form method="get" action="<%= formaction %>" class="form-inline">
			<input type="hidden" name="type" value="<%= bix.getName() %>"/>
			<input type="hidden" name="order" value="<%= direction %>"/>
			<input type="hidden" name="rpp" value="<%= rpp %>"/>
				
	<%-- If we are browsing by a date, or sorting by a date, render the date selection header --%>
<%
	if (bix.isDate())
	{
%>
		<span><fmt:message key="browse.nav.date.jump"/> </span>
		<select  name="year">
            <option selected="selected" value="-1"><fmt:message key="browse.nav.year"/></option>
<%
		int thisYear = DCDate.getCurrent().getYear();
		for (int i = thisYear; i >= 1990; i--)
		{
%>
            <option><%= i %></option>
<%
		}
%>
            <option>1985</option>
            <option>1980</option>
            <option>1975</option>
            <option>1970</option>
            <option>1960</option>
            <option>1950</option>
        </select>
        <select name="month">
            <option selected="selected" value="-1"><fmt:message key="browse.nav.month"/></option>
<%
		for (int i = 1; i <= 12; i++)
		{
%>
            <option value="<%= i %>"><%= DCDate.getMonthName(i, UIUtil.getSessionLocale(request)) %></option>
<%
		}
%>
        </select>
        <br/>
        <input type="submit" class="btn btn-default" value="<fmt:message key="browse.nav.go"/>" />
		
        <label for="starts_with"><fmt:message key="browse.nav.type-year"/></label>
        <input type="text" name="starts_with" size="4" maxlength="4"/>
<%
	}
	
	// If we are not browsing by a date, render the string selection header //
	else
	{
		String browseNavKey  = "browse.type.item." + bix.getName();
		String browseStartKey = "browse.nav.enter." + bix.getName();
		String browseJumpKey = "browse.nav.jump." + bix.getName();
%>	
		<label class="sr-only" for="starts_with"><fmt:message key="<%= browseNavKey %>"/></label>
		<input type="text" name="vfocus" class="form-control" size="60" 
			placeholder="<fmt:message key="<%= browseStartKey %>" />" />
                <br/>
                <br/>
		<input type="submit" class="bgcytc_blue clrcytc_white btn btn-default brdradius" value="<fmt:message key="browse.nav.go"/>" />
		<br/>
                <br/>
		<span><fmt:message key="<%= browseJumpKey %>"/></span><br/>
<%
	    for (char c = 'A'; c <= 'Z'; c++)
	    {
%>
        <a class="labelalpha label bgcytc_lightblue" href="<%= sharedLink %>&amp;starts_with=<%= c %>"><%= c %></a>
<%
	    }
	}
%>
	</form>
	</div>
	<%-- End of Navigation Headers --%>
<% } %>
	<%-- Include a component for modifying sort by, order and results per page --%>
	<div id="browse_controls" class="well text-center">
	<form method="get" action="<%= formaction %>">
		<input type="hidden" name="type" value="<%= bix.getName() %>"/>
		
<%-- The following code can be used to force the browse around the current focus.  Without
      it the browse will revert to page 1 of the results each time a change is made --%>
<%--
		if (!bi.hasItemFocus() && bi.hasFocus())
		{
			%><input type="hidden" name="vfocus" value="<%= bi.getFocus() %>"/><%
		}
--%>
		<label for="order"><fmt:message key="browse.single.order"/></label>
		<select name="order" class="moreclass bgcytc_lightgray clrcytc_darkgray font_bolder">
			<option value="ASC" <%= ascSelected %>><fmt:message key="browse.order.asc" /></option>
			<option value="DESC" <%= descSelected %>><fmt:message key="browse.order.desc" /></option>
		</select>
		
		<label for="rpp"><fmt:message key="browse.single.rpp"/></label>
                <select name="rpp" class="moreclass bgcytc_lightgray clrcytc_darkgray font_bolder">
<%
	for (int i = 5; i <= 100 ; i += 5)
	{
		String selected = (i == rpp ? "selected=\"selected\"" : "");
%>	
			<option value="<%= i %>" <%= selected %>><%= i %></option>
<%
	}
%>
		</select>
		<input class=" bgcytc_green brdradius font_bolder clrcytc_white btn btn-default" type="submit" name="submit_browse" value="<fmt:message key="jsp.general.update"/>"/>
	</form>
	</div>

<div class="row col-md-offset-3 col-md-6">
	<%-- give us the top report on what we are looking at --%>
	<div class="panel panel-primary">
	<div class="panel-heading text-center bgcytc_blue nobrdradius">
		<fmt:message key="browse.single.range">
			<fmt:param value="<%= Integer.toString(bi.getStart()) %>"/>
			<fmt:param value="<%= Integer.toString(bi.getFinish()) %>"/>
			<fmt:param value="<%= Integer.toString(bi.getTotal()) %>"/>
		</fmt:message>
	
	<%--  do the top previous and next page links --%>
<% 
	if (bi.hasPrevPage())
	{
%>
	<a class="pull-left" href="<%= prev %>"><fmt:message key="browse.single.prev"/></a>&nbsp;
<%
	}
%>

<%
	if (bi.hasNextPage())
	{
%>
	&nbsp;<a class="pull-right" href="<%= next %>"><fmt:message key="browse.single.next"/></a>
<%
	}
%>
	</div>

<ul class="list-group ultablelinks">
<%
    String[][] results = bi.getStringResults();

    for (int i = 0; i < results.length; i++)
    {
%>
                <li class="list-group-item">
                    <a href="<%= sharedLink %><% if (results[i][1] != null) { %>&amp;authority=<%= URLEncoder.encode(results[i][1], "UTF-8") %>" class="authority <%= bix.getName() %>"><%= Utils.addEntities(results[i][0]) %></a> <% } else { %>&amp;value=<%= URLEncoder.encode(results[i][0], "UTF-8") %>"><%= Utils.addEntities(results[i][0]) %></a> <% } %>
					<%= StringUtils.isNotBlank(results[i][2])?" <span class=\"badge\">"+results[i][2]+"</span>":""%>
                </li>
<%
    }
%>
        </ul>
	<%-- give us the bottom report on what we are looking at --%>
	<div class="panel-footer text-center">
		<fmt:message key="browse.single.range">
			<fmt:param value="<%= Integer.toString(bi.getStart()) %>"/>
			<fmt:param value="<%= Integer.toString(bi.getFinish()) %>"/>
			<fmt:param value="<%= Integer.toString(bi.getTotal()) %>"/>
		</fmt:message>

	<%--  do the bottom previous and next page links --%>
<% 
	if (bi.hasPrevPage())
	{
%>
	<a class="pull-left" href="<%= prev %>"><fmt:message key="browse.single.prev"/></a>&nbsp;
<%
	}
%>

<%
	if (bi.hasNextPage())
	{
%>
	&nbsp;<a class="pull-right" href="<%= next %>"><fmt:message key="browse.single.next"/></a>
<%
	}
%>
	</div>
</div>
</div>
	<%-- dump the results for debug (uncomment to enable) --%>
	<%-- 
	<!-- <%= bi.toString() %> -->
    --%>
<%
	}
	else {
	
%>
<div class="row" style="overflow:hidden">
	<%@ include file="static-tagcloud-browse.jsp" %>
</div>
<%
	}
%>
</div>
</div>
</dspace:layout>
