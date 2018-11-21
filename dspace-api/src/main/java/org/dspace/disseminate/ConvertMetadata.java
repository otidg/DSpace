package org.dspace.disseminate;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.dspace.content.Bitstream;
import org.dspace.content.Item;
import org.dspace.util.SimpleMapConverter;
import org.dspace.utils.DSpace;

public class ConvertMetadata {
	
	Pattern pattern = null;
	public ConvertMetadata() {
		pattern = Pattern.compile("^(.*)\\((.*)\\)$");
	}
	
	/***
	 * Handle virtual metadata.
	 * i.e. dc.type(mapConverterbibtex)
	 * 
	 * @param metadata The metadata, i.e dc.type
	 * @param item The item
	 * @return The metadata list converted
	 */
	public List<String> convert(List<String> metadata, Item item) {
		List<String> convMeta = new ArrayList<String>();
		for (String m : metadata) {
			convMeta.add(convert(m , item));
		}
		return convMeta;
	}
	
	public String convert(String metadata, Item item) {
		Matcher matcher = pattern.matcher(metadata);
		if (matcher.matches() && matcher.group(1) != null && matcher.group(2) != null) {
			SimpleMapConverter c = getConverter(matcher.group(2));
			if (c != null)
				return c.getValue(item.getMetadata(matcher.group(1)));
			else
				return item.getMetadata(metadata);
		}
		else
			return item.getMetadata(metadata);
	}
	
	public String convert(String metadata, Bitstream bitstream) {
		Matcher matcher = pattern.matcher(metadata);
		if (matcher.matches() && matcher.group(1) != null && matcher.group(2) != null) {
			SimpleMapConverter c = getConverter(matcher.group(2));
			if (c != null)
				return c.getValue(bitstream.getMetadata(matcher.group(1)));
			else
				return bitstream.getMetadata(metadata);
		}
		else
			return bitstream.getMetadata(metadata);
	}
	
	/***
	 * Get a converter using its name.
	 * 
	 * @param name The name of the mapConverter, i.e.  mapConverterbibtex
	 * @return The converter
	 */
	private SimpleMapConverter getConverter(String name) {
		SimpleMapConverter converter = new DSpace()
	                .getServiceManager().getServiceByName(
	                        name, SimpleMapConverter.class);
		return converter;
	}
}