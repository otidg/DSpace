/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.rest;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;

import javax.servlet.http.HttpServletRequest;

import org.dspace.app.rest.model.AuthnRest;
import org.dspace.app.rest.model.WsiUpdateRest;
import org.dspace.app.rest.utils.ContextUtil;
import org.dspace.content.WorkspaceItem;
import org.dspace.content.service.ItemService;
import org.dspace.content.service.WorkspaceItemService;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.event.Event;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.hateoas.Link;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Rest controller that handles authentication on the REST API together with the Spring Security filters
 * configured in {@link org.dspace.app.rest.security.WebSecurityConfiguration}
 *
 * @author Giuseppe Digilio (giuseppe dot digilio at 4science dot it)
 */
@RequestMapping("/" + WsiUpdateRest.CATEGORY)
@RestController
public class WsiUpdateRestController implements InitializingBean {

    private static final Logger log = LoggerFactory.getLogger(WsiUpdateRestController.class);

    @Autowired
    ItemService itemService;
    
    @Autowired
    WorkspaceItemService wis;

    @Autowired
    DiscoverableEndpointsService discoverableEndpointsService;

    @RequestMapping(value = "/notifyUpdate", method = { RequestMethod.POST, RequestMethod.GET })
    public boolean notifyUpdate(HttpServletRequest request, @RequestParam(name = "wsiList") String[] wsiList) {
    	String server = request.getServerName();
    	if (server.equals("localhost")) {
    		wsiUpdate(request, wsiList);
    		return true;
    	} else {
    		return false;
    	}
    }

	@Override
	public void afterPropertiesSet() throws Exception {
        discoverableEndpointsService
        .register(this, Arrays.asList(new Link("/" + WsiUpdateRest.CATEGORY, WsiUpdateRest.NAME)));
		
	}

	protected void wsiUpdate(HttpServletRequest request, String[] wsiList) {
		WorkspaceItem witem = null;
		Context context = ContextUtil.obtainContext(request);
		try {
	    	for (String id : wsiList) {
    			witem = wis.find(context, Integer.parseInt(id));
    			if (witem != null) {
	    			context.addEvent(new Event(Event.MODIFY_METADATA, Constants.ITEM, witem.getItem().getID(), null,
	    					itemService.getIdentifiers(context, witem.getItem())));
    			}
	    	}
	    	context.complete();
		} catch (SQLException e) {
			log.error(e.getMessage(), e);
		}
	}
}