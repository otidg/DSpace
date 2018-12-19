/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.browse;

/**
 * First support of solr Metadata query.
 * 
 * 	solrMetatdataQuery is the solr query used to find extra data fields
 * 	solrMetadataFields are all fields returned by subquery
 * 	solrMetadataPK is the field whose value is used to filter primary query
 */
public final class SolrMetadataQuery {
	private String solrMetatdataQuery = null;
    private String[] solrMetadataFields = null;
    
    public SolrMetadataQuery(String solrFilterQuery, String[] solrFilterFields) {
    	this.solrMetatdataQuery = solrFilterQuery;
    	this.solrMetadataFields = solrFilterFields;//Arrays.asList(sorlFilterFields);
    }
    
    public String getSolrMetadataQuery() {
    	return solrMetatdataQuery;
    }
    
    public String[] getSolrMetadataFields() {
    	return solrMetadataFields;
    }
}