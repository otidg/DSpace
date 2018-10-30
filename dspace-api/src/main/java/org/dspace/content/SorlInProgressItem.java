package org.dspace.content;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.Map.Entry;
import java.util.UUID;

import org.apache.solr.common.SolrDocument;
import org.dspace.browse.BrowsableDSpaceObject;
import org.dspace.core.Context;
import org.dspace.util.ItemUtils;
import org.dspace.util.MultiFormatDateParser;

import com.ibm.icu.impl.IllegalIcuArgumentException;

/***
 * SorlInProgressItem are used to store RejectedSubmission store, as BrowsableDSpaceObject.
 * The uuid item key is inprogress.item.
 * 
 * For RejectedSubmission, that is a Dspace-CRIS 7 item, id and type are:
 * 	1.  search.uniqueid, its unique id 
 *  2.	search.resourcetype, its type (whose velue is 8)
 * 	3.	search.resourceid, its id (as a legacy id)
 * 
 * Example of SorlInProgressItem:
 * 	{	lastModified=Wed Oct 24 18:18:44 CEST 2018,
 * 		read=[ws99423c27-b642-4bb9-a9cd-6d910e68dca5,
 * 			e99423c27-b642-4bb9-a9cd-6d910e68dca5], 
 * 		objectpeople=[Öner, Deniz...], 
 * 		objectpeople_ac=[öner, deniz
 * 			|||
 * 			Öner, Deniz, ghosh, manosij
 * 			|||
 * 			...], 
 * 		dc.contributor.author_hl=[Öner, Deniz, Ghosh, Manosij...], 
 * 		dc.contributor.author_stored=[Öner, Deniz
 * 			|||
 * 			null
 * 			|||
 * 			null
 * 			|||
 * 			null
 * 			|||
 * 			null, Ghosh, Manosij
 * 			|||
 * 			null
 * 			|||
 * 			null
 * 			|||
 * 			null
 * 			|||
 * 			null...], 
 * 		dc.date.issued_dt=Mon Jan 01 01:00:00 CET 2018,
 * 		dc.date.issued=[2018], 
 * 		dc.date.issued_stored=[2018...], 
 * 		dc.identifier.issn=[1743-8977],
 * 		dc.description.abstract_hl=[Background: Subtle DNA methylation
 * 			alterations mediated by carbon nanotubes (CNTs) exposure might
 * 			contribute to ...],
 * 			dc.description.abstract=[Background: Subtle DNA methylation alterations
 * 			mediated by carbon nanotubes (CNTs) exposure might contribute to
 * 			...], 
 * 		subject=[],
 * 		subject_keyword=[], 
 * 		subject_ac=[
 * 			|||
 * 			], 
 * 		subject_filter=[
 * 			]|||
 * 			], 
 * 		dc.subject_mlt=[], 
 * 		dc.subject=[], 
 * 		objectname=[Differences in MWCNT-
 * 			]and SWCNT-induced DNA methylation alterations ...], 
 * 		objectname_keyword=[Differences in MWCNT- and
 * 			]SWCNT-induced DNA methylation alterations ...], 
 * 		dc.identifier.doi=[10.1186/s12989-018-0244-6],
 * 		item.fulltext=[With Fulltext], 
 * 		item.grantfulltext=[reserved],
 * 		ORIGINAL_mvuntokenized=[0-7dc5967f-94de-4ec9-82f9-03a80d08f135],
 * 		LICENSE_mvuntokenized=[0-df1b415c-7461-4452-8411-9b9a11b0f7b2],
 * 		MESSAGE_mvuntokenized=[0-bddae05c-4529-4b2e-820a-b0b01eee7f43],
 * 		itemLastModified_dt=Wed Oct 24 18:18:44 CEST 2018,
 * 		dc.type_authority=[journal_article], 
 * 		dc.type=[journal_article],
 * 		valuepairsname_type=[journal_article], 
 * 		hasDoi=[true],
 * 		resourcetype_filter=001publications
 * 			|||
 * 			...,
 * 		has_content_in_original_bundle=[true],
 * 		has_content_in_original_bundle_keyword=[true],
 * 		has_content_in_original_bundle_filter=[true], 
 * 		bi_sort_1_sort=differences
 * 			in mwcnt- and swcnt-induced..., 
 * 		bi_sort_2_sort=2018, 
 * 		rejected=[true],
 * 		rejecteddate=[2018-10-24T16:18:29Z], 
 * 		rejecteduser=[Cadili, Francesco
 * 			<francesco.cadili@4science.it>],
 * 		rejecteditemuuid=[a74932c3-3ab7-4025-b0d3-dc41a8e8d740],
 * 		SolrIndexer.lastIndexed=Fri Oct 26 16:58:20 CEST 2018,
 * 		search.uniqueid=8-118, 
 * 		search.resourcetype=8, 
 * 		search.resourceid=118,
 * 		location=[m1328ecf1-5d83-47ec-8107-7c3c6205184d],
 * 		location.comm=[1328ecf1-5d83-47ec-8107-7c3c6205184d],
 * 		namedresourcetype_filter=[001workspace
 * 			...], 
 * 		namedresourcetype_keyword=[001workspace
 * 			...],
 * 		inprogress.item=[2-a74932c3-3ab7-4025-b0d3-dc41a8e8d740],
 * 		version_=1615400429374406656}
 * 		
 * 		// TODO: remove rejecteditemuuid and use inprogress.item...
 */
public class SorlInProgressItem implements DSpaceObjectLegacySupport, BrowsableDSpaceObject {
	
	public transient Map<String, Object> extraInfo = new HashMap<String, Object>();
	
	/***
	 * Prefix used in sorl keyword name.
	 */
	public static String sorlSchemaPrefix = "sorl";
	
	public static String metadataAuthority = null;
	public static String resoucetype = "search.resourcetype";
	public static String id = "search.resourceid";
	public static String uniqueUuid = "inprogress.item";
	public static String lastModified = sorlSchemaPrefix + "." + "lastModified";
	public static String name = sorlSchemaPrefix + "." + "objectname";
	
	private List<MetadataValueVolatile> metadata = new ArrayList<MetadataValueVolatile>();
	private UUID uuid;
	private Integer type;
	private Integer submissionType;
	
	@SuppressWarnings("unchecked")
	public SorlInProgressItem(SolrDocument doc) {
		for (Entry<String, Object> entry : doc.entrySet()) {
			String[] md = entry.getKey().split("\\.");
			MetadataValueVolatile m = null;
			
			// 
			switch (md.length) {
				case 1: {
					m = new MetadataValueVolatile(sorlSchemaPrefix, md[0], null, metadataAuthority, Item.ANY);
					break;
				}
				case 2: {
					m = new MetadataValueVolatile(md[0], md[1], null, metadataAuthority, Item.ANY);
					break;
				}
				case 3: {
					m = new MetadataValueVolatile(md[0], md[1], md[2], metadataAuthority, Item.ANY);
					break;
				}
				case 4: {
					m = new MetadataValueVolatile(md[0], md[1], md[2], metadataAuthority, md[4]);
					break;
				}
				default:
					throw new IllegalIcuArgumentException("Medatada " + entry.getKey() + " is not in a valid format.");
			}
			
			if (m != null) {
				if (entry.getValue() instanceof List && !((List<Object>)entry.getValue()).isEmpty()) {
					
					for (Object e : (List<Object>)entry.getValue()) {
						m.setValue(e.toString());
						metadata.add(m);
						
						m = clone(m);
					}
					m = null;
				}
				else {
					m.setValue(entry.getValue().toString());
				}
			}
			
			if (m != null)
				metadata.add(m);
		}
		
		String uuid = getMetadata(uniqueUuid);
		int pos = uuid.indexOf("-");
		if (pos < 0) {
			throw new IllegalIcuArgumentException("Required unique sorl index: " + uniqueUuid + "(value: " + uuid + ") is not in the right format.");
		}
		this.uuid = UUID.fromString(uuid.substring(pos + 1));
		this.type = Integer.parseInt(uuid.substring(0, pos));
		
		// submission
		this.submissionType = Integer.parseInt(getMetadata(resoucetype));
	}
	
	private MetadataValueVolatile clone(MetadataValueVolatile m) {
		return new MetadataValueVolatile(m.getSchema(), m.getElement(), m.getQualifier(), m.getAuthority(), m.getLanguage());
	}
	
	/***
	 * no handle is stored
	 */
	@Override
	public String getHandle() {
		return null;
	}

	@Override
	public List<String> getMetadataValue(String mdString) {
        List<IMetadataValue> meta = getMetadataValueInDCFormat(mdString);
        
        // conversion
        List<String> values = new ArrayList<String>();
        for (IMetadataValue m : meta) {
        	values.add(m.getValue());
        }
        
        return values;
	}

	@Override
	public List<IMetadataValue> getMetadataValueInDCFormat(String mdString) {
		StringTokenizer dcf = new StringTokenizer(mdString, ".");

        String[] tokens = { "", "", "" };
        int i = 0;
        while(dcf.hasMoreTokens())
        {
            tokens[i] = dcf.nextToken().trim();
            i++;
        }
        String schema, element, qualifier;
        if (i > 1) {
        	schema = tokens[0];
        	element = tokens[1];
        	qualifier = tokens[2];
        }
        else {
        	schema = sorlSchemaPrefix;
        	element = tokens[0];
        	qualifier = tokens[2];
        }

        List<IMetadataValue> meta;
        if (Item.ANY.equals(qualifier))
        {
        	meta = getMetadata(schema, element, Item.ANY, Item.ANY);
        }
        else if ("".equals(qualifier))
        {
        	meta = getMetadata(schema, element, null, Item.ANY);
        }
        else
        {
        	meta = getMetadata(schema, element, qualifier, Item.ANY);
        }
        
        return meta;
	}

	@Override
	public String getTypeText() {
		return type.toString();
	}

	@Override
	public int getType() {
		return type;
	}

	@Override
	public UUID getID() {
		return uuid;
	}

	/***
	 * return always false.
	 */
	@Override
	public boolean isWithdrawn() {
		return false;
	}

	@Override
	public Map<String, Object> getExtraInfo() {
		return extraInfo;
	}

	/***
	 * return always false.
	 */
	@Override
	public boolean isArchived() {
		return false;
	}

	@Override
	public List<IMetadataValue> getMetadata(String schema, String element, String qualifier, String lang) {
		// Build up list of matching values
        List<IMetadataValue> values = new ArrayList<IMetadataValue>();
        for (IMetadataValue dcv : metadata)
        {
            if (ItemUtils.match(schema, element, qualifier, lang, dcv))
            {
                values.add(dcv);
            }
        }

        // Create an array of matching values
        return values;
	}

	@Override
	public String getMetadata(String field) {
		List<IMetadataValue> meta = getMetadataValueInDCFormat(field);
		
		if (meta.isEmpty())
			return null;
		else
			return meta.get(0).getValue();
	}
	
	/***
	 * always true
	 */
	@Override
	public boolean isDiscoverable() {
		return true;
	}

	@Override
	public String getName() {
		return getMetadata(name);
	}

	/***
	 * No handle
	 */
	@Override
	public String findHandle(Context context) throws SQLException {
		return getHandle();
	}

	/***
	 * No hierarchy
	 */
	@Override
	public boolean haveHierarchy() {
		return false;
	}

	/***
	 * No parent object
	 */
	@Override
	public BrowsableDSpaceObject getParentObject() {
		return null;
	}

	@Override
	public String getMetadataFirstValue(String schema, String element, String qualifier, String language) {
		List<IMetadataValue> meta = getMetadata(schema, element, qualifier, language);
		
		if (meta.isEmpty())
			return null;
		else
			return meta.get(0).getValue();
	}

	@Override
	public Date getLastModified() {
		return MultiFormatDateParser.parse(getMetadata(lastModified));
	}

	@Override
	public Integer getLegacyId() {
		return Integer.parseInt(getMetadata(id));
	}
}
