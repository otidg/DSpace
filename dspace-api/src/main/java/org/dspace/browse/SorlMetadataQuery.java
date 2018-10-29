/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.browse;

/**
 * First support of sorl Metadata query.
 * 
 * 	sorlMetatdataQuery is the sorl query used to find extra data fields
 * 	sorlMetadataFields are all fields returned by subquery
 * 	sorlMetadataPK is the field whose value is used to filter primary query
 */
public final class SorlMetadataQuery {
	private String sorlMetatdataQuery = null;
    private String[] sorlMetadataFields = null;
    
    public SorlMetadataQuery(String sorlFilterQuery, String[] sorlFilterFields) {
    	this.sorlMetatdataQuery = sorlFilterQuery;
    	this.sorlMetadataFields = sorlFilterFields;//Arrays.asList(sorlFilterFields);
    }
    
    public String getSorlMetadataQuery() {
    	return sorlMetatdataQuery;
    }
    
    public String[] getSolrMetadataFields() {
    	return sorlMetadataFields;
    }
}