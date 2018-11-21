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

import org.dspace.content.Bitstream;
import org.dspace.content.Collection;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.content.service.BitstreamService;
import org.dspace.core.Context;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * @author Giuseppe Digilio (giuseppe dot digilio at 4science dot it)
 */
public class CollectionStrategy implements DissaminateStrategy {

    @Autowired(required = true)
    protected BitstreamService bitstreamService;

	protected HashMap<String, String> citationEnabledCollections;

	@Override
	public Boolean isStrategyEnabled(Context context, Bitstream bitstream) throws SQLException {
		return (getConfigByCollection(context, bitstream) != null);
	}

	@Override
	public String getConfigFile(Context context, Bitstream bitstream) {
		return getConfigByCollection(context, bitstream);
	}

	public HashMap<String, String> getCitationEnabledCollections() {
		return citationEnabledCollections;
	}

	public void setCitationEnabledCollections(HashMap<String, String> citationEnabledCollections) {
		this.citationEnabledCollections = citationEnabledCollections;
	}

	protected String getConfigByCollection(Context context, Bitstream bitstream) {
		String configFile = null;

        //Reject quickly if no-enabled collections
        if(citationEnabledCollections.size() == 0) {
        	return configFile;
        }

        DSpaceObject owningDSO;
		try {
			owningDSO = bitstreamService.getParentObject(context, bitstream);

	        if(owningDSO instanceof Item) {
	            Item item = (Item)owningDSO;
	
	            List<Collection> collections = item.getCollections();
	            
				for (Entry<String, String> collectionEntry : citationEnabledCollections.entrySet()) {
			
		            for(Collection collection : collections) {
		                if(collectionEntry.getKey().contains(collection.getHandle())) {
		                	configFile = collectionEntry.getValue();
		                	break;
		                }
		            }
			        
					if (configFile != null) {
						break;
					}
	
				}
	        }
		} catch (SQLException e) {
			configFile = null;
		}

        return configFile;
	}
	
}