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
public interface DissaminateStrategy {

    /**
     * Repository policy can specify to have a custom citation cover/tail page to the document, which embeds metadata.
     * We need to determine if we will intercept this bitstream download, and give out a citation dissemination rendition.
     *
     * @param context DSpace context
     * @param bitstream DSpace bitstream
     * @throws SQLException if error
     * @return true or false
     */
    public Boolean isStrategyEnabled(Context context, Bitstream bitstream) throws SQLException;

    /**
     * Get name of citation document configuration file name         
     * @param context DSpace context
     * @param bitstream DSpace bitstream
     * @return owning collection name
     */
    public String getConfigFile(Context context, Bitstream bitstream);

}
