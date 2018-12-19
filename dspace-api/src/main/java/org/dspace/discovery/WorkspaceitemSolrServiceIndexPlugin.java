/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.discovery;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.persistence.Transient;

import org.apache.commons.io.Charsets;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.apache.solr.common.SolrInputDocument;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Bitstream;
import org.dspace.content.Bundle;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.content.service.BitstreamService;
import org.dspace.core.Context;
import org.dspace.discovery.configuration.DiscoverySearchFilter;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * Add additional fields and values to Solr index:
 * 	 	rejected, set to true if Workspaceitem was rejected (bitstream "name": "Submission Rejected")
 * 	 	rejecteddate, set to the data of rejected (bitstream metadata dc.date.issued)
 * 		rejecteduser, set to the user who rejected the Workspaceitem (bitstream metadata dc.creator)
 */
public class WorkspaceitemSolrServiceIndexPlugin implements SolrServiceIndexPlugin
{
	private static final String SOLR_FIELD_NAME_FOR_REJECTED = "rejected";
	private static final String SOLR_FIELD_NAME_FOR_REJECTED_DATE = "rejecteddate";
	private static final String SOLR_FIELD_NAME_FOR_REJECTED_USER = "rejecteduser";
	private static final String SOLR_FIELD_NAME_FOR_REJECTED_REASON = "rejectedreason";
	
	private static final String BUNDLE_NAME = "MESSAGE";
	private static final String BITSTREAM_SUBMISSION_REJECTED = "Submission Rejected";
	private static final String BITSTREAM_DATE_ISSUED = "dc.date.issued";
	private static final String BITSTREAM_CREATOR = "dc.creator";
 
	/** log4j logger */
    @Transient
    private static Logger log = Logger.getLogger(WorkspaceitemSolrServiceIndexPlugin.class);
    
    @Autowired(required = true)
    private BitstreamService bitstreamService;

    @Override
    public void additionalIndex(Context context, DSpaceObject dso, SolrInputDocument document,
            Map<String, List<DiscoverySearchFilter>> searchFilters)
    {
        if (dso instanceof Item)
        {
            Item item = (Item) dso;
            
//            if (Constants.WORKSPACEITEM != item.getType() /*&& Constants.WORKFLOWITEM != item.getType()*/)
//            	return;
//            
//            log.debug("Item type: " + item.getType());
            
            List<Bundle> bundles = item.getBundles();
            if (bundles != null)
            {
                for (Bundle bundle : bundles)
                {
                    String bundleName = bundle.getName();
                	
                    if ((bundleName != null) && bundleName.equals(BUNDLE_NAME))
                    {
                    	log.debug("bundleName: " + bundleName);
                    	
                        List<Bitstream> bitstreams = bundle.getBitstreams();
                        if (bitstreams != null)
                        {
                            for (Bitstream bitstream : bitstreams)
                            {
                            	log.debug("bitstream: " + bitstream.getName());
                            	
                            	if (BITSTREAM_SUBMISSION_REJECTED.equals(bitstream.getName())) {
                            		log.debug("Adding field: " + SOLR_FIELD_NAME_FOR_REJECTED + ": true");
	                                document.addField(SOLR_FIELD_NAME_FOR_REJECTED, true);
	                                
	                                log.debug("Adding field: " + SOLR_FIELD_NAME_FOR_REJECTED_DATE + ": "
	                                		+ bitstream.getMetadata(BITSTREAM_DATE_ISSUED));
	                                document.addField(SOLR_FIELD_NAME_FOR_REJECTED_DATE, 
	                                		bitstream.getMetadata(BITSTREAM_DATE_ISSUED));
	                                
	                                log.debug("Adding field: " + SOLR_FIELD_NAME_FOR_REJECTED_USER + ": "
	                                		+ bitstream.getMetadata(BITSTREAM_CREATOR));
	                                document.addField(SOLR_FIELD_NAME_FOR_REJECTED_USER, 
	                                		bitstream.getMetadata(BITSTREAM_CREATOR));
	                                
	                                String content = retrieveBitstreamContent(context, bitstream);
	                                log.debug("Adding field: " + SOLR_FIELD_NAME_FOR_REJECTED_REASON + ": "
	                                		+ content);
	                                document.addField(SOLR_FIELD_NAME_FOR_REJECTED_REASON, 
	                                		content);
	                                

                            	}
                            }
                        }
                    }
                }
            }
        }
    }
    
    private String retrieveBitstreamContent(Context context, Bitstream bitstream) {
    	InputStream inputStream = null;
    	String content = "";
    	
    	try {
    		inputStream = bitstreamService.retrieve(context, bitstream);
        	content = IOUtils.toString(inputStream, Charsets.UTF_8); 
			inputStream.close();
		} catch (IOException | SQLException | AuthorizeException e) {
			try {
				inputStream.close();
			} catch (IOException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}
    	
		return content;
    }
}
