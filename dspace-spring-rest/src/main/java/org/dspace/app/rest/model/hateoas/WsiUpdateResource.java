/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.rest.model.hateoas;

import java.sql.SQLException;

import org.dspace.app.rest.model.WsiUpdateRest;
import org.dspace.app.rest.model.hateoas.annotations.RelNameDSpaceResource;
import org.dspace.app.rest.utils.Utils;

/**
 * WsiUpdate Rest Resource, used to link to login, logout, status, ...
 *
* @author Giuseppe Digilio (giuseppe dot digilio at 4science dot it)
 */
@RelNameDSpaceResource("wsiupdate")
public class WsiUpdateResource extends DSpaceResource<WsiUpdateRest> {

    public WsiUpdateResource(WsiUpdateRest data, Utils utils, String... rels) throws SQLException {
        super(data, utils, rels);
    }
}
