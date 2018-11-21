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
import org.dspace.core.Context;

/**
 *
 * @author Giuseppe Digilio (giuseppe dot digilio at 4science dot it)
 */
public class BitstreamMetadataStrategy implements DissaminateStrategy {

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

		for (Entry<String, HashMap<String, String>> metadataEntry : metadataKeys.entrySet()) {
			String metadataName = metadataEntry.getKey();
			String metadataValue = bitstream.getMetadata(metadataName);
			
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
		
		return configFile;
	}
	
}