<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<div class="row">   
<% if(mostViewedItem != null && mostViewedItem.getItems().size()!=0){ %>
        <div class="panel panel-primary vertical-carousel panelmostviewed" data-itemstoshow="3">        
        <div class="panel-heading">
          <h3 class="panel-title">
                <div class="container">
                    <fmt:message key="jsp.components.most-viewed"/>                  
                </div>
          </h3>
       </div>   
	   <div class="container panel-body">
	   		<div class="list-groups mostviewed_item">                            
<% for(MostViewedItem mvi : mostViewedItem.getItems()){
		IGlobalSearchResult item = mvi.getItem();
		if ( mvi.getVisits()==null ) {
			%>
				<fmt:message key="jsp.components.most-viewed.data-loading"/>
			<%
			break;
		}
%>
		<dspace:discovery-artifact style="global" artifact="<%= item %>" view="<%= mostViewedItem.getConfiguration() %>">
		<span class="badge" data-toggle="tooltip" data-placement="right" title="<fmt:message key="jsp.components.most-viewed.badge-tooltip"/>"><fmt:formatNumber value="<%= (mvi==null || mvi.getVisits()==null)?0.0:mvi.getVisits() %>" type="NUMBER" maxFractionDigits="0" /></span> ##artifact-item##
		</dspace:discovery-artifact>
<%
     }
%>
			</div>
		  </div>
     </div>
<%
}
%>
</div>