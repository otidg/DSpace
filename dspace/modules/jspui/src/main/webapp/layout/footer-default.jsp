<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Footer for home page
  --%>

<%@page import="org.dspace.core.ConfigurationManager"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="org.dspace.eperson.EPerson"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.NewsManager" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.util.LocaleUIHelper" %>

<%
	String footerNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-footer.html"));
    String sidebar = (String) request.getAttribute("dspace.layout.sidebar");
	String[] mlinks = new String[0];
	String mlinksConf = ConfigurationManager.getProperty("cris","navbar.cris-entities");
	if (StringUtils.isNotBlank(mlinksConf)) {
		mlinks = StringUtils.split(mlinksConf, ",");
	}
	
	boolean showCommList = ConfigurationManager.getBooleanProperty("community-list.show.all",true);
	boolean isRtl = StringUtils.isNotBlank(LocaleUIHelper.ifLtr(request, "","rtl"));
%>

            <%-- Right-hand side bar if appropriate --%>
<%
    if (sidebar != null)
    {
%>
	</div>
	<div class="col-md-3">
                    <%= sidebar %>
    </div>
    </div>       
<%
    }
%>
</div>
<br/>
</main>
    <%-- Page footer --%>
    <footer class="footercytc navbar navbar-bottom navbar-square">
        <!--
        <div class="rowfooter row bgcytc_blue">
            <fmt:message key="jsp.layout.footer-default.feedback"/>
            <fmt:message key="jsp.layout.footer-default.version-by"/>
            <fmt:message key="jsp.layout.footer-default.explore"/>
        </div>
        -->       
    <%= footerNews %>
        <div>
            <h1 class="clrcytc_white bgcytc_blue text-center htitlefooter bgcytc_white" > 
                <img src="<%= request.getContextPath() %>/image/email.png" width="40px" />repositorio@concytec.gob.pe 
                <img src="<%= request.getContextPath() %>/image/phone.png"  width="40px"/>(511) 204-9900 Anexo 712
            </h1>
        </div>
        <br/>
        <h5 class="text-center"><b>Redes de Repositorios</b></h5>
        <br/>
        <div class="col-md-3"> 
            <img class="imgcolorfooter" src="<%= request.getContextPath() %>/image/v.1-.png" />        
        </div>
        <div class="col-md-3 text-center">
            <img  src="<%= request.getContextPath() %>/image/lareferencia-logo.png"/>
        </div>
        <div class="col-md-3 text-center">
            <img class="imgalicia" src="<%= request.getContextPath() %>/image/alicialogo.png" style="padding-top:5px;padding-left: 21px;" />
        </div>
        
        <div class="col-md-3 text-center">   
            <div class="acontent">
                <a href="<%= request.getContextPath() %>/feedback" class="comentariosfooter"><fmt:message key="jsp.layout.footer-default.feedback"/></a>
            </div>      
        </div>
        
    </footer>
    </body>
</html>
