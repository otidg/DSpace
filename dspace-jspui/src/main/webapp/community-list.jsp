<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%--
  - Display hierarchical list of communities and collections
  -
  - Attributes to be passed in:
  -    communities         - array of communities
  -    collections.map  - Map where a keys is a community IDs (Integers) and 
  -                      the value is the array of collections in that community
  -    subcommunities.map  - Map where a keys is a community IDs (Integers) and 
  -                      the value is the array of subcommunities in that community
  -    admin_button - Boolean, show admin 'Create Top-Level Community' button
  --%>

<%@page import="org.dspace.content.Bitstream"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.browse.ItemCountException" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>

<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>

<%@ page import="java.io.IOException" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.Map" %>


<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@page import="org.dspace.core.NewsManager" %>


<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    
    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);
    String topNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-top.html"));        
    
    Community[] communities = (Community[]) request.getAttribute("communities");
    Map collectionMap = (Map) request.getAttribute("collections.map");
    Map subcommunityMap = (Map) request.getAttribute("subcommunities.map");
    Boolean admin_b = (Boolean)request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());
    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));
%>

<%!
    void showCommunity(Community c, JspWriter out, HttpServletRequest request, ItemCounter ic,
    		Map collectionMap, Map subcommunityMap) throws ItemCountException, IOException, SQLException
    {
		boolean showLogos = ConfigurationManager.getBooleanProperty("jspui.community-list.logos", true);
        out.println( "<li class=\"media well\">" );
        Bitstream logo = c.getLogo();
        if (showLogos && logo != null)
        {
        	out.println("<a class=\"pull-left col-md-2\" href=\"" + request.getContextPath() + "/handle/" 
        		+ c.getHandle() + "\"><img class=\"media-object img-responsive\" src=\"" + 
        		request.getContextPath() + "/retrieve/" + logo.getID() + "\" alt=\"community logo\"></a>");
        }
        out.println( "<div class=\"media-body\"><div class=\"divtitlecomuni  brdradius2\" ><h4 class=\"media-heading  cytc_mediaheading \"><a class=\"clrcytc_blue font_bolder \" href=\"" + request.getContextPath() + "/handle/" 
        	+ c.getHandle() + "\">" + c.getMetadata("name") + "</a>");
        if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
        {
            out.println(" <span class=\"badge\">" + ic.getCount(c) + "</span>");
        }
		out.println("</h4>");
		if (StringUtils.isNotBlank(c.getMetadata("short_description")))
		{
			out.println(" <div class=\"divshortdesc bgcytc_lightblue clrcytc_white brdradiusright\">" +c.getMetadata("short_description")+ "</div>");
		}
		out.println("</div><br>");
        // Get the collections in this community
        Collection[] cols = (Collection[]) collectionMap.get(c.getID());
        if (cols != null && cols.length > 0)
        {
            out.println("<ul class=\"media-list\">");
            for (int j = 0; j < cols.length; j++)
            {
                out.println("<li class=\"media well cytc_mediawell nobrdradius\">");
                
                Bitstream logoCol = cols[j].getLogo();
                if (showLogos && logoCol != null)
                {
                	out.println("<a class=\"pull-left col-md-2\" href=\"" + request.getContextPath() + "/handle/" 
                		+ cols[j].getHandle() + "\"><img class=\"media-object img-responsive\" src=\"" + 
                		request.getContextPath() + "/retrieve/" + logoCol.getID() + "\" alt=\"collection logo\"></a>");
                }
                out.println("<div class=\"media-body\"><h4 class=\"media-heading \"><a class=\"clrcytc_darkgray \" href=\"" + request.getContextPath() + "/handle/" + cols[j].getHandle() + "\">" + cols[j].getMetadata("name") +"</a>");
				if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
                {
                    out.println(" [" + ic.getCount(cols[j]) + "]");
                }
				out.println("</h4>");
				if (StringUtils.isNotBlank(cols[j].getMetadata("short_description")))
				{
					out.println(cols[j].getMetadata("short_description"));
				}
				out.println("</div>");
                out.println("</li>");
            }
            out.println("</ul>");
        }

        // Get the sub-communities in this community
        Community[] comms = (Community[]) subcommunityMap.get(c.getID());
        if (comms != null && comms.length > 0)
        {
            out.println("<ul class=\"media-list\">");
            for (int k = 0; k < comms.length; k++)
            {
               showCommunity(comms[k], out, request, ic, collectionMap, subcommunityMap);
            }
            out.println("</ul>"); 
        }
        out.println("</div>");
        out.println("</li>");
    }
%>

<dspace:layout titlekey="jsp.community-list.title">
<div class="row nomargintop" >
    
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
        
<%
    if (admin_button)
    {
%>     
<dspace:sidebar>
			<div class="panel panel-warning">
			<div class="panel-heading">
				<fmt:message key="jsp.admintools"/>
				<span class="pull-right">
					<dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.site-admin\")%>"><fmt:message key="jsp.adminhelp"/></dspace:popup>
				</span>
			</div>
			<div class="panel-body">
                <form method="post" action="<%=request.getContextPath()%>/dspace-admin/edit-communities">
                    <input type="hidden" name="action" value="<%=EditCommunitiesServlet.START_CREATE_COMMUNITY%>" />
					<input class="btn btn-default" type="submit" name="submit" value="<fmt:message key="jsp.community-list.create.button"/>" />
                </form>
            </div>
</dspace:sidebar>
<%
    }
%>
<div class="col-md-12">
    
    <div class="container">
        
    

        <br/>
	<h1 class="clrcytc_blue htitlecomu padding_left"><fmt:message key="jsp.community-list.title"/></h1>
        <p class="clrcytc_blue padding_left"><fmt:message key="jsp.community-list.text1"/></p>

<% if (communities.length != 0)
{
%>
    <ul class="media-list cytc_comunitylist">
<%
        for (int i = 0; i < communities.length; i++)
        {
            showCommunity(communities[i], out, request, ic, collectionMap, subcommunityMap);
        }
%>
    </ul>
 
<% }
%>
    </div>
</div>
</dspace:layout>
