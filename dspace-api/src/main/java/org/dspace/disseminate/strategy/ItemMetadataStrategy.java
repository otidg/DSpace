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
import java.util.LinkedHashMap;
import java.util.Map.Entry;

import org.apache.commons.lang.StringUtils;
import org.dspace.content.Bitstream;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.content.service.BitstreamService;
import org.dspace.core.Context;
import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * @author Giuseppe Digilio (giuseppe dot digilio at 4science dot it)
 */
public class ItemMetadataStrategy implements DissaminateStrategy {

	@Autowired(required = true)
    protected BitstreamService bitstreamService;

	public final String REGEX_PREFIX = "regex.";

	private LinkedHashMap<String, HashMap<String, String>> metadataKeys;

	@Override
	public Boolean isStrategyEnabled(Context context, Bitstream bitstream) throws SQLException {
		return (getConfigByMetadata(context, bitstream) != null);
	}

	@Override
	public String getConfigFile(Context context, Bitstream bitstream) {
		return getConfigByMetadata(context, bitstream);
	}

	public LinkedHashMap<String, HashMap<String, String>> getMetadataKeys() {
		return metadataKeys;
	}

	public void setMetadataKeys(LinkedHashMap<String, HashMap<String, String>> metadataKeys) {
		this.metadataKeys = metadataKeys;
	}
	
	protected String getConfigByMetadata(Context context, Bitstream bitstream) {
		String configFile = null;

		DSpaceObject owningDSO;
		try {
			owningDSO = bitstreamService.getParentObject(context, bitstream);

	        if(owningDSO instanceof Item) {
	            Item item = (Item)owningDSO;
			
				for (Entry<String, HashMap<String, String>> metadataEntry : metadataKeys.entrySet()) {
					String metadataName = metadataEntry.getKey();
					String metadataValue = item.getMetadata(metadataName);
					
					if (StringUtils.isNotBlank(metadataValue)) {
						for (String keyS : metadataEntry.getValue().keySet()) {
							System.out.println(keyS);
						}
						
						for (Entry<String, String> entry : metadataEntry.getValue().entrySet()) {
						
							String key = entry.getKey();
		
				            if (key.startsWith(REGEX_PREFIX)) {
				                String regex = key.substring(REGEX_PREFIX.length());
				                
				                if (metadataValue.matches(regex)) {
				                	configFile = entry.getValue();
				                	break;
				                }
				                
				            } else if (metadataValue.equals(key)) {
				            	configFile = entry.getValue();
				            	break;
				            }
							
						}
						
						if (configFile != null) {
							break;
						}
					}
				    
				}
	        }
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return configFile;
	}
	
}