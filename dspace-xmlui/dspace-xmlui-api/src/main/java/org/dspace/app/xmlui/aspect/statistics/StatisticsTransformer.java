/**
 * $Id: StatisticsTransformer.java 4402 2009-10-07 08:31:24Z mdiggory $
 * $URL: https://scm.dspace.org/svn/repo/modules/dspace-stats/trunk/dspace-xmlui-stats/src/main/java/org/dspace/app/xmlui/aspect/statistics/StatisticsTransformer.java $
 * *************************************************************************
 * Copyright (c) 2002-2009, DuraSpace.  All rights reserved
 * Licensed under the DuraSpace Foundation License.
 *
 * A copy of the DuraSpace License has been included in this
 * distribution and is available at: http://scm.dspace.org/svn/repo/licenses/LICENSE.txt
 */
package org.dspace.app.xmlui.aspect.statistics;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;

import org.apache.log4j.Logger;
import org.apache.solr.client.solrj.SolrServerException;
import org.dspace.app.xmlui.cocoon.AbstractDSpaceTransformer;
import org.dspace.app.xmlui.utils.HandleUtil;
import org.dspace.app.xmlui.utils.UIException;
import org.dspace.app.xmlui.wing.WingException;
import org.dspace.app.xmlui.wing.element.Body;
import org.dspace.app.xmlui.wing.element.Cell;
import org.dspace.app.xmlui.wing.element.Division;
import org.dspace.app.xmlui.wing.element.List;
import org.dspace.app.xmlui.wing.element.Row;
import org.dspace.app.xmlui.wing.element.Table;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.core.Constants;
import org.dspace.statistics.Dataset;
import org.dspace.statistics.content.DatasetDSpaceObjectGenerator;
import org.dspace.statistics.content.DatasetTimeGenerator;
import org.dspace.statistics.content.DatasetTypeGenerator;
import org.dspace.statistics.content.StatisticsDataVisits;
import org.dspace.statistics.content.StatisticsListing;
import org.dspace.statistics.content.StatisticsTable;
import org.xml.sax.SAXException;

public class StatisticsTransformer extends AbstractDSpaceTransformer {

	private static Logger log = Logger.getLogger(StatisticsTransformer.class);

	/**
	 * What to add at the end of the body
	 */
	public void addBody(Body body) throws SAXException, WingException,
			UIException, SQLException, IOException, AuthorizeException {

		DSpaceObject dso = HandleUtil.obtainHandle(objectModel);

		try
		{
			if(dso != null)
			{
				renderViewer(body, dso);
			}
			
			/* TODO: Fix rendering of Home Page Statistics
			else
			{
				renderHome(body);
			}
			*/
			
		} catch (Throwable t) {
			log.error(t.getMessage(), t);
		}

	}

	public void renderHome(Body body) throws WingException {
		
		Division home = body.addDivision("home", "primary repository");
		Division division = home.addDivision("stats", "secondary stats");
		division.setHead("Statistics");

		try {

			StatisticsTable statisticsTable = new StatisticsTable(
					new StatisticsDataVisits());

			statisticsTable.setTitle("Total Visits Per Month");
			statisticsTable.setId("tab1");

			DatasetTimeGenerator timeAxis = new DatasetTimeGenerator();
			timeAxis.setDateInterval("month", "-6", "+1");
			statisticsTable.addDatasetGenerator(timeAxis);

			addDisplayTable(division, statisticsTable);

		} catch (Exception e) {
			log.error("Error occured while creating statistics for home page",
					e);
		}
		
		try {
			StatisticsListing statListing = new StatisticsListing(
					new StatisticsDataVisits());

			statListing.setTitle("Total Visits");
			statListing.setId("list1");

			addDisplayListing(division, statListing);

		} catch (Exception e) {
			log.error("Error occured while creating statistics for home page", e);
		}

	}

	public void renderViewer(Body body, DSpaceObject dso) throws WingException {

		Division home = body.addDivision(
				Constants.typeText[dso.getType()].toLowerCase() + "-home", 
				"primary repository " + Constants.typeText[dso.getType()].toLowerCase());
		
		// Build the collection viewer division.
		Division division = home.addDivision("stats", "secondary stats");
		division.setHead("Statistics");

		
		try {
			StatisticsListing statListing = new StatisticsListing(
					new StatisticsDataVisits(dso));

			statListing.setTitle("Total Visits");
			statListing.setId("list1");

			DatasetDSpaceObjectGenerator dsoAxis = new DatasetDSpaceObjectGenerator();
			dsoAxis.addDsoChild(dso.getType(), 10, false, -1);
			statListing.addDatasetGenerator(dsoAxis);

			addDisplayListing(division, statListing);

		} catch (Exception e) {
			log.error(
					"Error occured while creating statistics for dso with ID: "
							+ dso.getID() + " and type " + dso.getType()
							+ " and handle: " + dso.getHandle(), e);
		}
		
		
		
		try {

			StatisticsTable statisticsTable = new StatisticsTable(new StatisticsDataVisits(dso));
			
			statisticsTable.setTitle("Total Visits Per Month");
			statisticsTable.setId("tab1");

			DatasetTimeGenerator timeAxis = new DatasetTimeGenerator();
			timeAxis.setDateInterval("month", "-6", "+1");
			statisticsTable.addDatasetGenerator(timeAxis);

			DatasetDSpaceObjectGenerator dsoAxis = new DatasetDSpaceObjectGenerator();
			dsoAxis.addDsoChild(dso.getType(), 10, false, -1);
			statisticsTable.addDatasetGenerator(dsoAxis);

			addDisplayTable(division, statisticsTable);

		} catch (Exception e) {
			log.error(
					"Error occured while creating statistics for dso with ID: "
							+ dso.getID() + " and type " + dso.getType()
							+ " and handle: " + dso.getHandle(), e);
		}
		
		/**
		 * 
		 * FIX ME:  Need to correct rendering of column and row headings.
		
		try {
			StatisticsListing statListing = new StatisticsListing(
					new StatisticsDataVisits(dso));

			statListing.setTitle("Total Visits By Continent");
			statListing.setId("list1");

			DatasetTypeGenerator typeGenerator = new DatasetTypeGenerator();
            typeGenerator.setType("continent");
            typeGenerator.setMax(10);
			statListing.addDatasetGenerator(typeGenerator);
			addDisplayListing(division, statListing);

		} catch (Exception e) {
			log.error(
					"Error occured while creating statistics for dso with ID: "
							+ dso.getID() + " and type " + dso.getType()
							+ " and handle: " + dso.getHandle(), e);
		}
		
		try {
			StatisticsListing statListing = new StatisticsListing(
					new StatisticsDataVisits(dso));

			statListing.setTitle("Total Visits By City");
			statListing.setId("list1");

			DatasetTypeGenerator typeGenerator = new DatasetTypeGenerator();
            typeGenerator.setType("city");
            typeGenerator.setMax(10);
			statListing.addDatasetGenerator(typeGenerator);
			addDisplayListing(division, statListing);

		} catch (Exception e) {
			log.error(
					"Error occured while creating statistics for dso with ID: "
							+ dso.getID() + " and type " + dso.getType()
							+ " and handle: " + dso.getHandle(), e);
		}
		
		*/
		
		
	}

	
	/**
	 * Adds a table layout to the page
	 * 
	 * @param mainDiv
	 *            the div to add the table to
	 * @param display
	 * @throws SAXException
	 * @throws WingException
	 * @throws ParseException
	 * @throws IOException
	 * @throws SolrServerException
	 * @throws SQLException
	 */
	private void addDisplayTable(Division mainDiv, StatisticsTable display)
			throws SAXException, WingException, SQLException,
			SolrServerException, IOException, ParseException {

		String title = display.getTitle();

		Dataset dataset = display.getDataset();

		if (dataset == null) {
			/** activate dataset query */
			dataset = display.getDataset(context);
		}

		if (dataset != null) {

			String[][] matrix = dataset.getMatrixFormatted();

			/** Generate Table */
			Division wrapper = mainDiv.addDivision("tablewrapper");
			Table table = wrapper.addTable("list-table", 1, 1,
					title == null ? "" : "tableWithTitle");
			if (title != null)
				table.setHead(title);

			/** Generate Header Row */
			Row headerRow = table.addRow();
			headerRow.addCell("spacer", Cell.ROLE_DATA, "labelcell")
					.addContent("&nbsp;");

			String[] cLabels = dataset.getColLabels().toArray(new String[0]);
			for (int row = 0; row < cLabels.length; row++) {
				Cell cell = headerRow.addCell(0 + "-" + row + "-h",
						Cell.ROLE_DATA, "labelcell");
				cell.addContent(cLabels[row]);
			}

			/** Generate Table Body */
			for (int row = 0; row < matrix.length; row++) {
				Row valListRow = table.addRow();

				/** Add Row Title */
				valListRow.addCell("" + row, Cell.ROLE_DATA, "labelcell")
						.addContent(dataset.getRowLabels().get(row));

				/** Add Rest of Row */
				for (int col = 0; col < matrix[row].length; col++) {
					Cell cell = valListRow.addCell(row + "-" + col,
							Cell.ROLE_DATA, "datacell");
					cell.addContent(matrix[row][col]);
				}
			}
		}

	}

	private void addDisplayListing(Division mainDiv, StatisticsListing display)
			throws SAXException, WingException, SQLException,
			SolrServerException, IOException, ParseException {

		String title = display.getTitle();

		Dataset dataset = display.getDataset();

		if (dataset == null) {
			/** activate dataset query */
			dataset = display.getDataset(context);
		}

		if (dataset != null) {

			String[][] matrix = dataset.getMatrixFormatted();

			// String[] rLabels = dataset.getRowLabels().toArray(new String[0]);

			Table table = mainDiv.addTable("list-table", matrix.length, 2,
					title == null ? "" : "tableWithTitle");
			if (title != null)
				table.setHead(title);

			Row headerRow = table.addRow();

			String label = "FIX ME";

			headerRow.addCell("", Cell.ROLE_DATA, "labelcell").addContent(label);
			
			headerRow.addCell("", Cell.ROLE_DATA, "labelcell").addContent("Views");

			/** Generate Table Body */
			for (int row = 0; row < matrix.length; row++) {
				Row valListRow = table.addRow();

				Cell catCell = valListRow.addCell(row + "1", Cell.ROLE_DATA,
						"labelcell");
				catCell.addContent(dataset.getRowLabels().get(row));

				Cell valCell = valListRow.addCell(row + "2", Cell.ROLE_DATA,
						"datacell");
				valCell.addContent(matrix[row][0]);

			}

			if (!"".equals(display.getCss())) {
				List attrlist = mainDiv.addList("divattrs");
				attrlist.addItem("style", display.getCss());
			}

		}

	}
}
