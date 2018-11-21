/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.disseminate.strategy;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map.Entry;

import org.apache.log4j.Logger;
import org.dspace.content.Bitstream;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.DSpaceObject;
import org.dspace.content.service.BitstreamService;
import org.dspace.content.service.CommunityService;
import org.dspace.core.Context;
import org.dspace.curate.Curator;
import org.dspace.disseminate.CitationDocumentServiceImpl;
import org.dspace.handle.service.HandleService;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * @author Giuseppe Digilio (giuseppe dot digilio at 4science dot it)
 */
public class CommunityStrategy extends CollectionStrategy {

    /**
     * Class Logger
     */
    private static Logger log = Logger.getLogger(CitationDocumentServiceImpl.class);

    private HashMap<String, String> citationEnabledCommunities;

    @Autowired(required = true)
    protected BitstreamService bitstreamService;

    @Autowired(required = true)
    protected CommunityService communityService;

    @Autowired(required = true)
    protected HandleService handleService;

	@Override
	public Boolean isStrategyEnabled(Context context, Bitstream bitstream) throws SQLException {
		setCitationEnabledCollections(context);
		return (getConfigByCollection(context, bitstream) != null);
	}

	@Override
	public String getConfigFile(Context context, Bitstream bitstream) {
		setCitationEnabledCollections(context);
		return getConfigByCollection(context, bitstream);
	}

	public HashMap<String, String> getCitationEnabledCommunities() {
		return citationEnabledCommunities;
	}

	public void setCitationEnabledCommunities(HashMap<String, String> citationEnabledCommunities) {
		this.citationEnabledCommunities = citationEnabledCommunities;	
	}

	private void setCitationEnabledCollections(Context context) {
		citationEnabledCollections = new HashMap<String, String>();

		if (citationEnabledCommunities.size() > 0) {
            try {
                for (Entry<String, String> communityEntry : citationEnabledCommunities.entrySet()) {
                	String communityString = communityEntry.getKey();
                    DSpaceObject dsoCommunity = handleService.resolveToObject(context, communityString.trim());
                    if (dsoCommunity instanceof Community) {
                        Community community = (Community)dsoCommunity;
                        List<Collection> collections = communityService.getAllCollections(context, community);

                        for (Collection collection : collections) {
                        	citationEnabledCollections.put(collection.getHandle(), communityEntry.getValue());
                        }
                    } else {
                        log.error("Invalid community for community strategy, value:" + communityString.trim());
                    }
                }
            } catch (SQLException e) {
                log.error(e.getMessage());
            }
		}	
		
	}
	
}