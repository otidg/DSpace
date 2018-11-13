package org.dspace.disseminate;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.ArrayUtils;
import org.dspace.content.Item;

/***
 * Handle the following fields:
 *	 - header1
 * 	 - header2
 * 	 - fields
 * 	 - footer
 *
 * All values used in file are described at
 * @See https://wiki.duraspace.org/display/DSDOC6x/PDF+Citation+Cover+Page
 * 
 * Note: citation-page.header1, citation-page.header2, citation-page.fields and citation-page.footer
 *       can be overriden using the object handle, one of its collection handle or its dc.type value.
 *
 * The code search the "overriding" value testing citation-page.fields, such as citation-page.123456789/29.fields
 * for and item whose handle is 123456789/29.
 * The hierarchy used to select overriding value is object handle, dc.type, owning collection, other collections that
 * include the object.
 * The value used in citation-page.header1, citation-page.header2, citation-page.fields and citation-page.footer can
 * be reused adding a the $base string.
 * A converter can be used in citation-page.fields writing a virtual name. The code support an arbitrary org.dspace.util.SimpleMapConverter
 * such as mapConverterbibtex or mapConverterrefman. The converter is applied to the metadata in the following
 * way:
 *      dc.type(mapConverterbibtex)
 *      
 * The virtual metadata value are stored in dspace/config/crosswalks/mapConverter-bibtex.properties and the filename mapConverter-bibtex.properties
 * and the converter name are stored inside the proper org.dspace.util.SimpleMapConverter bean.
 */
public class OverridableFields {
	private List<String> header1 = new ArrayList<String>();
    private List<String> header2 = new ArrayList<String>();
    private List<String> fields = new ArrayList<String>();
    private String footer;
            
    // ovverideToken
    private String ovverideToken = "$base";
    
    public OverridableFields(String[] header1, String[] header2, String[] fields, String footer) {
    	CollectionUtils.addAll(this.header1, header1);
    	CollectionUtils.addAll(this.header2, header2);
    	CollectionUtils.addAll(this.fields, fields);
    	this.footer = footer;
    }
    
    public void apply(Item item) {
        ConvertMetadata converter = new ConvertMetadata();

    	//header1 = converter.convert(header1, item);
    	//header2 = converter.convert(header2, item);
    	fields = converter.convert(fields, item);
    	//footer = converter.convert(footer, item);
    }
    
	public String[] getHeader1() {
		return header1.toArray(new String[header1.size()]);
	}
	public void setHeader1(String[] header1) {
		List<String> tokens = addTokens(this.header1, header1);
		if (tokens == null || tokens.size() <= 0) {
			return;
		}
		this.header1 = tokens;
	}
	
	public String[] getHeader2() {
		return header2.toArray(new String[header2.size()]);
	}
	public void setHeader2(String[] header2) {
		List<String> tokens = addTokens(this.header2, header2);
		if (tokens == null || tokens.size() <= 0) {
			return;
		}
		this.header2 = tokens;
	}
	
	public List<String> getFields() {
		return fields;
	}
	public void setFields(String[] fields) {
		List<String> tokens = addTokens(this.fields, fields);
		if (tokens == null || tokens.size() <= 0) {
			return;
		}
		this.fields = tokens;
	}
	
	public String getFooter() {
		return footer;
	}
	public void setFooter(String footer) {
		if (footer != null && footer.contains(ovverideToken))
			this.footer = footer.replace(ovverideToken, this.footer);
		else
			this.footer = footer;
	}
	
	/***
	 * Override base parameter with token. 
	 * Base parameters are reused if tokens contains the ovverideToken value.
	 * 
	 * @param base Base values
	 * @param tokens The tokens
	 * @return merged (or overridden) list of token
	 */
	private List<String> addTokens(List<String> base, String[] tokens) {
		if (tokens == null || tokens.length <= 0) {
			return null;
		}
		
		List<String> res = null;
		if (ArrayUtils.contains(tokens, ovverideToken) ) {
			res = base;
			
			CollectionUtils.addAll(res, ArrayUtils.removeElements(tokens, ovverideToken));
		}
		else {
			res = new ArrayList<String>();
			CollectionUtils.addAll(res, tokens);
		}
		
		return res;
	}
}
