/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.rest.link;

import java.util.LinkedList;

import org.dspace.app.rest.WsiUpdateRestController;
import org.dspace.app.rest.model.hateoas.WsiUpdateResource;
import org.springframework.data.domain.Pageable;
import org.springframework.hateoas.Link;
import org.springframework.stereotype.Component;

/**
 * This class' purpose is to provide a means to add links to {@link org.dspace.app.rest.model.hateoas.AuthnResource}s
 *
 * @author Giuseppe Digilio (giuseppe dot digilio at 4science dot it)
 */
@Component
public class WsiUpdateHalLinkFactory extends HalLinkFactory<WsiUpdateResource, WsiUpdateRestController> {

    @Override
    protected void addLinks(WsiUpdateResource halResource, Pageable pageable, LinkedList<Link> list) throws Exception {
    	WsiUpdateRestController methodOn = getMethodOn();

        list.add(buildLink("notifyUpdate", methodOn.notifyUpdate(null, null)));

    }

    @Override
    protected Class<WsiUpdateRestController> getControllerClass() {
        return WsiUpdateRestController.class;
    }

    @Override
    protected Class<WsiUpdateResource> getResourceClass() {
        return WsiUpdateResource.class;
    }
}
