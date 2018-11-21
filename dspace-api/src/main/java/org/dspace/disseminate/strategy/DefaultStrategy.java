/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.disseminate.strategy;

import java.sql.SQLException;
import org.dspace.content.Bitstream;
import org.dspace.content.Item;
import org.dspace.core.Context;

/**
 *
 * @author Giuseppe Digilio (giuseppe dot digilio at 4science dot it)
 */
public class DefaultStrategy implements DissaminateStrategy {

	private String defaultConfigFile;

	@Override
	public Boolean isStrategyEnabled(Context context, Bitstream bitstream) throws SQLException {
		return !defaultConfigFile.isEmpty();
	}

	@Override
	public String getConfigFile(Context context, Bitstream bitstream) {
		return defaultConfigFile;
	}

	public String getDefaultConfigFile() {
		return defaultConfigFile;
	}

	public void setDefaultConfigFile(String defaultConfigFile) {
		this.defaultConfigFile = defaultConfigFile;
	}

	
}