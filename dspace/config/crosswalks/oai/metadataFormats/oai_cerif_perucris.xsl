<?xml version="1.0" encoding="UTF-8" ?>
<!--
 
 
 The contents of this file are subject to the license and copyright
 detailed in the LICENSE and NOTICE files at the root of the source
 tree and available online at
 
 http://www.dspace.org/license/
 Developed by DSpace @ Lyncode <dspace@lyncode.com>
 
 > http://www.openarchives.org/OAI/2.0/oai_cerif.xsd
 
 Global namespace:
 	oai_cerif		openaire tag
 	dc				used in Publication
 	xsi				used in Publication
 	
 Local Namespace:
 	Publication	oai:Type xmlns:oai="https://www.openaire.eu/cerif-profile/vocab/COAR_Publication_Types"
 	Publication	oai:Type scheme="https://w3id.org/cerif/vocab/OrganisationTypes"
 -->
<xsl:stylesheet
	xmlns="https://purl.org/pe-repo/cerif-profile/1.0/" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:doc="http://www.lyncode.com/xoai"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd https://www.openaire.eu/cerif-profile/1.1/ https://www.openaire.eu/schema/cris/1.1/openaire-cerif-profile.xsd"
    version="1.0" exclude-result-prefixes="doc dc xs">
    <xsl:output omit-xml-declaration="yes" method="xml" indent="yes" />

	<xsl:variable name="placeholder">#PLACEHOLDER_PARENT_METADATA_VALUE#</xsl:variable>

	<!-- Date format -->
	<xsl:template name="formatdate">
		<xsl:param name="datestr" />
		<xsl:choose>
			<xsl:when test="translate(., '123456789', '000000000') = '0000-00-00'">
			    <!-- result if valid -->
			    <xsl:value-of select="$datestr"/>
			</xsl:when>		
			<xsl:otherwise>
				<xsl:variable name="year"  select="substring-after(substring-after($datestr,'-'),'-')" />
				<xsl:variable name="day" select="substring-before($datestr,'-')" />
				<xsl:variable name="month"   select="substring-before(substring-after($datestr,'-'),'-')" />
				<xsl:value-of select="concat($year,'-',$month,'-',$day)"/>			
			</xsl:otherwise>		
		</xsl:choose>
	</xsl:template>
	    		
    <!-- transate dc.type to Type xmlns="https://www.openaire.eu/cerif-profile/vocab/COAR_Publication_Types" -->
    <xsl:template name="oai_publicationtype">
        <xsl:param name="type" select="other"/>
        <xsl:choose>
		<xsl:when test="$type='Publications'">Publications</xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="oai_producttype">
        <xsl:param name="type" select="other"/>
        <xsl:choose>
		<xsl:when test="$type='Products'">Products</xsl:when>
	</xsl:choose>
  	</xsl:template>
  	
  	 <xsl:template name="oai_patenttype">
        <xsl:param name="type" select="other"/>
        <xsl:choose>
	        <xsl:when test="$type='Patents'">Patents</xsl:when>
	   	</xsl:choose>
  	</xsl:template>

  	 <xsl:template name="oai_eventtype">
        <xsl:param name="type" select="other"/>
        <xsl:choose>
			<xsl:when test="$type='workshop' or $type='Workshop'">https://w3id.org/cerif/vocab/EventTypes#Workshop</xsl:when>
			<xsl:otherwise>https://w3id.org/cerif/vocab/EventTypes#Conference</xsl:otherwise>
	   	</xsl:choose>
  	</xsl:template>
  	  	
    <!-- translate ou.type to Type xmlns="https://w3id.org/cerif/vocab/OrganisationTypes" -->
    <xsl:template name="oai_outype">
        <xsl:param name="type" select="'Academic Institute'"/>
        <xsl:choose>
            
            <!-- An academic institution is an educational institution dedicated to education and research, which grants academic degrees. -->
            <xsl:when test="$type='Academic Institute'">https://w3id.org/cerif/vocab/OrganisationTypes#AcademicInstitute</xsl:when>
            <!-- A university is an institution of higher education and research, which grants academic degrees in a variety of subjects. A university is a corporation that provides both undergraduate education and postgraduate education. -->
            <xsl:when test="$type='University'">https://w3id.org/cerif/vocab/OrganisationTypes#University</xsl:when>
    		<!-- The term "university college" is used in a number of countries to denote college institutions that provide tertiary education but do not have full or independent university status. A university college is often part of a larger university. The precise usage varies from country to country.. -->
            <xsl:when test="$type='University College'">https://w3id.org/cerif/vocab/OrganisationTypes#UniversityCollege</xsl:when>
    		<!-- A research institute is an establishment endowed for doing research. Research institutes may specialize in basic research or may be oriented to applied research. -->
    		<xsl:when test="$type='Research Institute'">https://w3id.org/cerif/vocab/OrganisationTypes#ResearchInstitute</xsl:when>
    		<!-- A strategic research institute's core mission is to provide analyses that respond to the needs of decision-makers. -->
    		<xsl:when test="$type='Strategic Research Insitute'">https://w3id.org/cerif/vocab/OrganisationTypes#StrategicResearchInsitute</xsl:when>
    		<!-- A company is a form of business organization. In the United States, a company is a corporation—or, less commonly, an association, partnership, or union—that carries on an industrial enterprise." Generally, a company may be a "corporation, partnership, association, joint-stock company, trust, fund, or organized group of persons, whether incorporated or not, and (in an official capacity) any receiver, trustee in bankruptcy, or similar official, or liquidating agent, for any of the foregoing." In English law, and therefore in the Commonwealth realms, a company is a form of body corporate or corporation, generally registered under the Companies Acts or similar legislation. It does not include a partnership or any other unincorporated group of persons. -->
    		<xsl:when test="$type='Company'">https://w3id.org/cerif/vocab/OrganisationTypes#Company</xsl:when>
    		<!-- Small and medium enterprises (also SMEs, small and medium businesses, SMBs, and variations thereof) are companies whose headcount or turnover falls below certain limits. EU Member States traditionally have their own definition of what constitutes an SME, for example the traditional definition in Germany had a limit of 250 employees, while, for example, in Belgium it could have been 100. But now the EU has started to standardize the concept. Its current definition categorizes companies with fewer than 10 employees as "micro", those with fewer than 50 employees as "small", and those with fewer than 250 as "medium". -->
    		<xsl:when test="$type='SME'">https://w3id.org/cerif/vocab/OrganisationTypes#SME</xsl:when>
    		<!-- A government is the organization, or agency through which a political unit exercises its authority, controls and administers public policy, and directs and controls the actions of its members or subjects. -->
    		<xsl:when test="$type='Government'">https://w3id.org/cerif/vocab/OrganisationTypes#Government</xsl:when>
    		<!-- Higher education or post-secondary education refers to a level of education that is provided at academies, universities, colleges, seminaries, institutes of technology, and certain other collegiate- level institutions, such as vocational schools, trade schools, and career colleges, that award academic degrees or professional certifications. -->
    		<xsl:when test="$type='Higher Education'">https://w3id.org/cerif/vocab/OrganisationTypes#HigherEducation</xsl:when>
    		<!-- An organization that is incorporated under state law and whose purpose is not to make profit, but rather to further a charitable, civic, scientific, or other lawful purpose. -->
    		<xsl:when test="$type='Private non-profit'">https://w3id.org/cerif/vocab/OrganisationTypes#Privatenon-profit</xsl:when>
    		<!-- An intergovernmental organization, sometimes rendered as an international governmental organization and both abbreviated as IGO, is an organization composed primarily of sovereign states (referred to as member states), or of other intergovernmental organizations. Intergovernmental organizations are often called international organizations, although that term may also include international nongovernmental organization such as international non-profit organizations or multinational corporations. -->
    		<xsl:when test="$type='Intergovernmental'">https://w3id.org/cerif/vocab/OrganisationTypes#Intergovernmental</xsl:when>
    		<!-- A charitable organization is a type of non-profit organization (NPO). It differs from other types of NPOs in that it centers on philanthropic goals (e.g. charitable, educational, religious, or other activities serving the public interest or common good). The legal definition of charitable organization (and of Charity) varies according to the country and in some instances the region of the country in which the charitable organization operates. The regulation, tax treatment, and the way in which charity law affects charitable organizations also varies. -->
    		<xsl:when test="$type='Charity'">https://w3id.org/cerif/vocab/OrganisationTypes#Charity</xsl:when>
    		<!-- Hospitals, trusts and other bodies receiving funding from central governement through the national insurance scheme. -->
    		<xsl:when test="$type='National Health Service'">https://w3id.org/cerif/vocab/OrganisationTypes#NationalHealthService</xsl:when>
    	</xsl:choose>
    </xsl:template>
    
    <!-- translate funding.type to Type xmlns="https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types" -->
    <xsl:template name="oai_fundingtype">
        <xsl:param name="type" select="'Academic Institute'"/>
        <xsl:choose>
    		<!-- Funding Programme (https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#FundingProgramme): A funding programme or a similar scheme that funds some number of proposals. -->
    		<xsl:when test="$type='Funding Programme'">https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#FundingProgramme</xsl:when>
    		<!-- Call (https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Call): Call for proposals: a specific campaign for the funder to solicit proposals from interested researchers and institutions -->
    		<xsl:when test="$type='Call'">https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Call</xsl:when>
    		<!-- Tender (https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Tender): Tender for services or deliveries: a specific campaign for the funder to solicit offers for services or deliveries. -->
    		<xsl:when test="$type='Tender'">https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Tender</xsl:when>
    		<!-- Gift (https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Gift): A donation connected with specific terms and conditions. -->
    		<xsl:when test="$type='Gift'">https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Gift</xsl:when>
    		<!-- Internal Funding (https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#InternalFunding): Internal funds used to amend or replace external funding. -->
    		<xsl:when test="$type='Internal Funding'">https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#InternalFunding</xsl:when>
    		<!-- Contract (https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Contract) -->
    		<xsl:when test="$type='Contract'">https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Contract</xsl:when>
    		<!-- Award (https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Award): -->
    		<xsl:when test="$type='Award'">https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Award</xsl:when>
    		<!-- Grant (https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Grant): -->
    		<xsl:when test="$type='Grant'">https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#Grant</xsl:when>
    	</xsl:choose>
    </xsl:template>

  	 <xsl:template name="oai_accessrights">
        <xsl:param name="rights" select="other"/>
        <xsl:choose>
			<xsl:when test="contains($rights, 'c_f1cf')">http://purl.org/coar/access_right/c_f1cf</xsl:when>
			<xsl:otherwise><xsl:value-of select="$rights" /></xsl:otherwise>
	   	</xsl:choose>
  	</xsl:template>
  	
  	<xsl:template name="oai_dateembargoed">
        <xsl:param name="rights" select="other"/>
        <xsl:choose>
			<xsl:when test="contains($rights, 'c_f1cf')"><xsl:value-of select="substring($rights, 42, 10)" /></xsl:when>
			<xsl:otherwise></xsl:otherwise>
	   	</xsl:choose>
  	</xsl:template>
	<!--  CHOOSER RULES -->
	
	<!-- 
		item_chooser: Template that handle publication using an item selected among publications, products, patents. 
	
    	Example of parameters:
	    	selector
	 -->
	<xsl:template name="item_chooser">
		<xsl:param name="selector" />
		
		<xsl:for-each select="$selector">
			
			<!-- check type (is a publication or a product or ...) -->
        	<xsl:variable name="typeCerifEntityType">
                <xsl:value-of select="doc:metadata/doc:element[@name='item']/doc:element[@name='cerifentitytype']/doc:element/doc:field[@name='value']" />
            </xsl:variable>
            
            <!-- check product -->
            <xsl:variable name="type_product"><xsl:call-template name="oai_producttype"><xsl:with-param name="type" select="$typeCerifEntityType" /></xsl:call-template></xsl:variable>
            <!-- check patent  -->
            <xsl:variable name="type_patent"><xsl:call-template name="oai_patenttype"><xsl:with-param name="type" select="$typeCerifEntityType" /></xsl:call-template></xsl:variable>
            <!-- check publication -->
            <xsl:variable name="type_publication"><xsl:call-template name="oai_publicationtype"><xsl:with-param name="type" select="$typeCerifEntityType" /></xsl:call-template></xsl:variable>
            
            <xsl:choose>
            	<xsl:when test="$type_product != ''">
            		<xsl:call-template name="product">
		        		<xsl:with-param name="selector" select="doc:metadata" />
		        	</xsl:call-template>
            	</xsl:when>
            	<xsl:when test="$type_patent != ''">
					<xsl:call-template name="patent">
		        		<xsl:with-param name="selector" select="doc:metadata" />
		        	</xsl:call-template>
            	</xsl:when>
            	<xsl:when test="$type_publication != ''">
            		<!-- [Note] $type_publication is always not empty.  -->
            		<xsl:call-template name="publication">
		        		<xsl:with-param name="selector" select="doc:metadata" />
		        	</xsl:call-template>
            	</xsl:when>
            </xsl:choose>
            
		</xsl:for-each>
	</xsl:template>
	    
    <!--	
    	ou: Template that handle Organization Unit.
    -->
	<xsl:template name="ou">
		<xsl:param name="selector" />
		<xsl:param name="ou_id" />

		<xsl:choose>
		<xsl:when test="$ou_id!=''">		
		<xsl:for-each select="$selector">
			<OrgUnit id="OrgUnits/{$ou_id}">
				<xsl:for-each select="doc:element[@name='crisou']/doc:element[@name='type']/doc:element/doc:element">
				<xsl:variable name="ou_type">
					<xsl:value-of select="doc:field[@name='value']/text()"></xsl:value-of>
				</xsl:variable>
				<Type scheme="https://w3id.org/cerif/vocab/OrganisationTypes">
            		<xsl:call-template name="oai_outype"><xsl:with-param name="type" select="$ou_type" /></xsl:call-template>
            	</Type>
            	</xsl:for-each>
            	
            	<xsl:for-each select="doc:element[@name='crisou']/doc:element[@name='acronym']/doc:element/doc:element">
					<Acronym><xsl:value-of select="doc:field[@name='value']/text()"></xsl:value-of></Acronym>
            	</xsl:for-each>
            	
            	<xsl:for-each select="doc:element[@name='crisou']/doc:element[@name='name']/doc:element/doc:element">
					<Name xml:lang="en"><xsl:value-of select="doc:field[@name='value']" /></Name>
				</xsl:for-each>
			
				<xsl:variable name="identifiertypeid" select="doc:element[@name='ouidentifier']/doc:element[@name='ouidentifiertypeid']/doc:element/doc:element/doc:field[@name='value']" />
				<xsl:variable name="identifierid" select="doc:element[@name='ouidentifier']/doc:element[@name='ouidentifierid']/doc:element/doc:element/doc:field[@name='value']" />
				<xsl:if test="$identifiertypeid">
					<Identifier type="{$identifiertypeid}"><xsl:value-of select="$identifierid"/></Identifier>
				</xsl:if>
            	
            	<xsl:for-each select="doc:element[@name='crisou']/doc:element[@name='email']/doc:element/doc:element">
					<ElectronicAddress><xsl:value-of select="doc:field[@name='value']/text()"></xsl:value-of></ElectronicAddress>
            	</xsl:for-each>
            	
				<xsl:for-each select="doc:element[@name='crisou']/doc:element[@name='parentorgunit']/doc:element/doc:element/doc:element[@name='value']">				
					<xsl:variable name="parentorgunit_id">
						<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
					</xsl:variable>
			    	<PartOf>
             		<xsl:choose>
             		<xsl:when test="$parentorgunit_id!=''">
 					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="ou_id" select="$parentorgunit_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="ou_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>
			    	</PartOf>
				</xsl:for-each>
			</OrgUnit>			
		</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
			<OrgUnit>
				<xsl:for-each select="$selector">
					<Name xml:lang="en">
						<xsl:value-of select="." />
					</Name>
				</xsl:for-each>
			</OrgUnit>
		</xsl:otherwise>
		</xsl:choose>		
    </xsl:template>

    <!--	
    	person: Template that handle Person.
    -->
    <xsl:template name="person">
    	<xsl:param name="selector" />
    	<xsl:param name="person_id" />

    	<xsl:choose>
		<xsl:when test="$person_id!=''">    	
    	<xsl:for-each select="$selector">
	    <Person id="{$person_id}"> 
	        <PersonName>
          		<xsl:for-each select="doc:element[@name='crisrp']/doc:element[@name='fullName']/doc:element/doc:element">
          		<xsl:choose>
					<xsl:when test="contains(./doc:field[@name='value'], ',')">
						<FamilyNames><xsl:value-of select="substring-before(., ',')" /></FamilyNames>
						<FirstNames><xsl:value-of select="substring-after(., ', ')" /></FirstNames>
					</xsl:when>
					<xsl:otherwise>
						<FamilyNames><xsl:value-of select="./doc:field[@name='value']" /></FamilyNames>					
					</xsl:otherwise>
				</xsl:choose>
           		</xsl:for-each>	        
	    	</PersonName>
	    	
           	<xsl:for-each select="doc:element[@name='crisrp']/doc:element[@name='orcid']/doc:element/doc:element">
               	<ORCID><xsl:value-of select="doc:field[@name='value']" /></ORCID>
           	</xsl:for-each>
           	
           	<xsl:for-each select="doc:element[@name='crisrp']/doc:element[@name='authorid']/doc:element/doc:element">
               	<ResearcherID><xsl:value-of select="doc:field[@name='value']" /></ResearcherID>
           	</xsl:for-each>
           	
           	<xsl:for-each select="doc:element[@name='crisrp']/doc:element[@name='scopusid']/doc:element/doc:element">
               	<ScopusAuthorID><xsl:value-of select="doc:field[@name='value']" /></ScopusAuthorID>
           	</xsl:for-each>
           	
           	<xsl:for-each select="doc:element[@name='rp']/doc:element[@name='email']/doc:element">
               	<ElectronicAddress><xsl:value-of select="doc:field[@name='value']" /></ElectronicAddress>
           	</xsl:for-each>

			<xsl:variable name="affiliationstartdate" select="doc:element[@name='affiliation']/doc:element[@name='affiliationstartdate']/doc:element//doc:field[@name='value']"/>
			<xsl:variable name="affiliationenddate" select="doc:element[@name='affiliation']/doc:element[@name='affiliationenddate']/doc:element//doc:field[@name='value']"/>			
						                    
		    <!-- Affiliation [START] -->
		    <xsl:choose>
		    <xsl:when test="doc:element[@name='affiliation']/doc:element[@name='affiliationorgunit']/doc:element/doc:element">
				<xsl:for-each select="doc:element[@name='affiliation']/doc:element[@name='affiliationorgunit']/doc:element/doc:element">
		        	<xsl:variable name="counter" select="position()"/>				
					<xsl:variable name="affiliationorgunit_id">
	             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
	             	</xsl:variable>

						<Affiliation>
						<xsl:if
							test="$affiliationstartdate[$counter] != '' and $affiliationstartdate[$counter]!=$placeholder ">
							<xsl:attribute name="startDate">		
								<xsl:call-template name="formatdate">
									<xsl:with-param name="datestr" select="$affiliationstartdate[$counter]" />
								</xsl:call-template>
							</xsl:attribute>
						</xsl:if>
						<xsl:if
							test="$affiliationenddate[$counter] != '' and $affiliationenddate[$counter]!=$placeholder ">
							<xsl:attribute name="endDate">
								<xsl:call-template name="formatdate">
									<xsl:with-param name="datestr" select="$affiliationenddate[$counter]" />
								</xsl:call-template>							
							</xsl:attribute>
						</xsl:if>
			        	<!-- only value with relation equal to author uuid will be processed -->
						<xsl:call-template name="ou">
							<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
							<xsl:with-param name="ou_id" select="$affiliationorgunit_id" />
						</xsl:call-template>
	            	</Affiliation>
		      	</xsl:for-each>
	      	</xsl:when>
	      	<xsl:otherwise>
				<xsl:for-each select="doc:element[@name='crisrp']/doc:element[@name='dept']/doc:element/doc:element">
					<xsl:variable name="affiliationorgunit_id">
	             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
	             	</xsl:variable>
			        <Affiliation>
			        	<!-- only value with relation equal to author uuid will be processed -->
						<xsl:call-template name="ou">
							<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
							<xsl:with-param name="ou_id" select="$affiliationorgunit_id" />
						</xsl:call-template>
	            	</Affiliation>
		      	</xsl:for-each>	      	
	      	</xsl:otherwise>
	      	</xsl:choose>
	        <!-- Affiliation [END] -->
		</Person>
		</xsl:for-each>
		</xsl:when>
		<xsl:otherwise>
		<Person/>
		</xsl:otherwise>
		</xsl:choose>		
    </xsl:template>
    
    <!--	
    	project: Template that handle Project.
    -->
	<xsl:template name="project">
		<xsl:param name="selector" />
		<xsl:param name="project_id" />
        
        <xsl:choose>
		<xsl:when test="$project_id!=''">            
        <xsl:for-each select="$selector">
        <Project id="{$project_id}">
	        
			<xsl:variable name="type_funding"><xsl:call-template name="oai_fundingtype"><xsl:with-param name="type" select="doc:element[@name='crisproject']/doc:element[@name='granttype']/doc:element/doc:element/doc:field[@name='value']" /></xsl:call-template></xsl:variable>
			<xsl:variable name="currency_funding"><xsl:value-of select="doc:element[@name='crisproject']/doc:element[@name='grantcurrency']/doc:element/doc:element/doc:field[@name='value']" /></xsl:variable>
			<xsl:variable name="amount_funding"><xsl:value-of select="doc:element[@name='crisproject']/doc:element[@name='grantamount']/doc:element/doc:element/doc:field[@name='value']" /></xsl:variable>
			<xsl:variable name="identifier_funding"><xsl:value-of select="doc:element[@name='crisproject']/doc:element[@name='grantidentifier']/doc:element/doc:element/doc:field[@name='value']" /></xsl:variable>
	        	        	
	        <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='acronym']/doc:element/doc:element/doc:field[@name='value']">
	        	<Acronym><xsl:value-of select="." /></Acronym>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='title']/doc:element/doc:element/doc:field[@name='value']">
	        	<Title xml:lang="en"><xsl:value-of select="." /></Title>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='startdate']/doc:element/doc:element/doc:field[@name='value']">
	        	<StartDate><xsl:call-template name="formatdate"><xsl:with-param name="datestr" select="." /></xsl:call-template></StartDate>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='expdate']/doc:element/doc:element/doc:field[@name='value']">
	        	<EndDate><xsl:call-template name="formatdate"><xsl:with-param name="datestr" select="." /></xsl:call-template></EndDate>
	        </xsl:for-each>
	        
	        <xsl:if test="(doc:element[@name='crisproject']/doc:element[@name='coordinator']/doc:element/doc:element/doc:field[@name='value']!='' or doc:element[@name='crisproject']/doc:element[@name='partnerou']/doc:element/doc:element/doc:field[@name='value']!='' or doc:element[@name='crisproject']/doc:element[@name='organization']/doc:element/doc:element/doc:field[@name='value']!='')">
	        <!-- Consortium [START] -->
	        <Consortium>
	        <!-- Coordinator -->
            <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='coordinator']/doc:element/doc:element">
             	<xsl:variable name="coordinator_id">
             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
            	<Coordinator>
            		<DisplayName><xsl:value-of select="./doc:field[@name='value']/text()" /></DisplayName>
					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
						<xsl:with-param name="ou_id" select="$coordinator_id" />
					</xsl:call-template>
           		</Coordinator>
            </xsl:for-each>
            <!-- Partner -->
            <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='partnerou']/doc:element/doc:element">
             	<xsl:variable name="partner_id">
             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
            	<Partner>
            		<DisplayName><xsl:value-of select="./doc:field[@name='value']/text()" /></DisplayName>
					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
						<xsl:with-param name="ou_id" select="$partner_id" />
					</xsl:call-template>
           		</Partner>
            </xsl:for-each>
            <!-- Contractor -->
	        <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='contractorou']/doc:element/doc:element">
             	<xsl:variable name="organization_id">
             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
            	<Contractor>
            		<DisplayName><xsl:value-of select="./doc:field[@name='value']/text()" /></DisplayName>
					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
						<xsl:with-param name="ou_id" select="$organization_id" />
					</xsl:call-template>
           		</Contractor>
            </xsl:for-each>
            <!-- Member -->
	        <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='memberou']/doc:element/doc:element">
             	<xsl:variable name="organization_id">
             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
            	<Member>
            		<DisplayName><xsl:value-of select="./doc:field[@name='value']/text()" /></DisplayName>
					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
						<xsl:with-param name="ou_id" select="$organization_id" />
					</xsl:call-template>
           		</Member>
            </xsl:for-each>            
	        </Consortium>
	        <!-- Consortium [END] -->
	        </xsl:if>
	        
	       	<xsl:if test="(doc:element[@name='crisproject']/doc:element[@name='principalinvestigator']/doc:element/doc:element/doc:field[@name='value']!='' or doc:element[@name='crisproject']/doc:element[@name='coinvestigators']/doc:element/doc:element/doc:field[@name='value']!='')">
	        <!-- Team [START] -->
	        <Team>
	        <!-- PrincipalInvestigator -->
	        <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='principalinvestigator']/doc:element/doc:element">
             	<xsl:variable name="principalinvestigator_id">
             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
            	<PrincipalInvestigator>
            		<DisplayName><xsl:value-of select="./doc:field[@name='value']/text()" /></DisplayName>
					<xsl:call-template name="person">
						<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
						<xsl:with-param name="person_id" select="$principalinvestigator_id" />
					</xsl:call-template>
           		</PrincipalInvestigator>
            </xsl:for-each>
            <!-- Member -->
            <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='coinvestigators']/doc:element/doc:element">
             	<xsl:variable name="member_id">
             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
            	<Member>
					<DisplayName><xsl:value-of select="./doc:field[@name='value']/text()" /></DisplayName>            	
					<xsl:call-template name="person">
						<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
						<xsl:with-param name="person_id" select="$member_id" />
					</xsl:call-template>
           		</Member>
            </xsl:for-each>
	        </Team>
	        <!-- Team [END] -->
	        </xsl:if>
	        
	        <xsl:if test="(doc:element[@name='crisproject']/doc:element[@name='funder']/doc:element/doc:element/doc:field[@name='value']!='' or doc:element[@name='crisproject']/doc:element[@name='fundingProgram']/doc:element/doc:element/doc:field[@name='value']!='')">
	        <!-- Funded [START] -->
	        <Funded>	        
        	<xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='funder']/doc:element/doc:element">
        		<xsl:variable name="funderby_id">
             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
            	<By>
            		<DisplayName><xsl:value-of select="./doc:field[@name='value']/text()" /></DisplayName>
					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
						<xsl:with-param name="ou_id" select="$funderby_id" />
					</xsl:call-template>
           		</By>
        	</xsl:for-each>
        	<xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='fundingProgram']/doc:element/doc:element">
        		<As xmlns:oafunding="https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types">
        			<Funding>
						<xsl:choose>
							<xsl:when test="$type_funding!=''">
								<oafunding:Type><xsl:value-of select="$type_funding" /></oafunding:Type>
							</xsl:when>		
							<xsl:otherwise>
								<oafunding:Type>https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#InternalFunding</oafunding:Type>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:if test="$amount_funding!=''">
							<Amount currency="{$currency_funding}"><xsl:value-of select="$amount_funding" /></Amount>
						</xsl:if>																			        				
	        			<xsl:if test="$identifier_funding!=''">
							<Identifier type="https://w3id.org/cerif/vocab/IdentifierTypes#ProjectReference"><xsl:value-of select="$identifier_funding" /></Identifier>
						</xsl:if>
						<PartOf>
							<Funding>
								<oafunding:Type>https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types#FundingProgramme</oafunding:Type>
								<Name xml:lang="en"><xsl:value-of select="./doc:field[@name='value']" /></Name>
							</Funding>	
						</PartOf>        				
        			</Funding>	
        		</As>
        	</xsl:for-each>
	        </Funded>
	        <!-- Funded [END] -->
	        </xsl:if>
	        	        
	        <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='keywords']/doc:element/doc:element/doc:field[@name='value']">
	        	<Keyword xml:lang="en"><xsl:value-of select="." /></Keyword>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='abstract']/doc:element/doc:element/doc:field[@name='value']">
	        	<Abstract xml:lang="en"><xsl:value-of select="." /></Abstract>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='status']/doc:element/doc:element/doc:field[@name='value']">
	        	<Status scheme="https://cerif.eurocris.org/model#Project_Classification"><xsl:value-of select="." /></Status>
	        </xsl:for-each>
	        
	        <!--  REVIEW METADATA [START]: uses, oamandate -->
	        <xsl:for-each select="doc:element[@name='crisproject']/doc:element[@name='equipment']/doc:element/doc:element">
	        	<xsl:variable name="equipment_id">
             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
	        	<Uses>
					<!-- <DisplayName><xsl:value-of select="./doc:field[@name='value']/text()" /></DisplayName> -->            	
					<xsl:call-template name="equipment">
						<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
						<xsl:with-param name="equipment_id" select="$equipment_id" />
					</xsl:call-template>
	        	</Uses>
	        </xsl:for-each>
	        
	        <xsl:variable name="typeid" select="doc:element[@name='crisproject']/doc:element[@name='oamandate']/doc:element/doc:element/doc:field[@name='value']" />
			<xsl:if test="$typeid">
				<OAMandate mandated="{$typeid}" />
			</xsl:if>
	        <!--  REVIEW METADATA [END] -->
        </Project>
        </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
        <Project>
	        <xsl:for-each select="$selector">
	        	<Title xml:lang="en"><xsl:value-of select="." /></Title>
	        </xsl:for-each>
		</Project>
        </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <!--	
    	event: Template that handle Event.
    -->
	<xsl:template name="events">
		<xsl:param name="selector" />
		<xsl:param name="event_id" />

        <xsl:choose>
        <xsl:when test="$event_id!=''">            
        <xsl:for-each select="$selector">
        <Event id="{$event_id}">
                	
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventstype']/doc:element/doc:element/doc:field[@name='value']">
	        	<xsl:variable name="type_event"><xsl:call-template name="oai_eventtype"><xsl:with-param name="type" select="." /></xsl:call-template></xsl:variable>
	        	<Type scheme="https://w3id.org/cerif/vocab/EventTypes"><xsl:value-of select="$type_event" /></Type>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventsacronym']/doc:element/doc:element/doc:field[@name='value']">
	        	<Acronym><xsl:value-of select="." /></Acronym>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventsname']/doc:element/doc:element/doc:field[@name='value']">
	        	<Name xml:lang="en"><xsl:value-of select="." /></Name>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventslocation']/doc:element/doc:element/doc:field[@name='value']">
	        	<Place><xsl:value-of select="." /></Place>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventsiso-country']/doc:element/doc:element/doc:field[@name='value']">
	        	<Country><xsl:value-of select="." /></Country>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventsstartdate']/doc:element/doc:element/doc:field[@name='value']">
				<StartDate><xsl:call-template name="formatdate"><xsl:with-param name="datestr" select="." /></xsl:call-template></StartDate>				        
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventsenddate']/doc:element/doc:element/doc:field[@name='value']">
	        	<EndDate><xsl:call-template name="formatdate"><xsl:with-param name="datestr" select="." /></xsl:call-template></EndDate>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventsdescription']/doc:element/doc:element/doc:field[@name='value']">
	        	<Description xml:lang="en"><xsl:value-of select="." /></Description>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventskeywords']/doc:element/doc:element/doc:field[@name='value']">
	        	<Keyword xml:lang="en"><xsl:value-of select="." /></Keyword>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventsorganizerou']/doc:element/doc:element[@name='value']">
	        	<Organizer>
					<xsl:variable name="organizer_id">
						<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
					</xsl:variable>
             		<xsl:choose>
             		<xsl:when test="$organizer_id!=''">
 					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="ou_id" select="$organizer_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="ou_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>
	        	</Organizer>
	        </xsl:for-each>
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventsorganizerpj']/doc:element/doc:element/doc:element[@name='value']">
	        	<Organizer>
					<xsl:variable name="organizer_id">
						<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
					</xsl:variable>
             		<xsl:choose>
             		<xsl:when test="$organizer_id!=''">
 					<xsl:call-template name="project">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="project_id" select="$organizer_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="project">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="project_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>
	        	</Organizer>
	        </xsl:for-each>	        
	        
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventssponsorou']/doc:element/doc:element/doc:element[@name='value']">
	        	<Sponsor>
					<xsl:variable name="sponsor_id">
						<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
					</xsl:variable>
             		<xsl:choose>
             		<xsl:when test="$sponsor_id!=''">
 					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="ou_id" select="$sponsor_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="ou_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>
	        	</Sponsor>
	        </xsl:for-each>
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventssponsorpj']/doc:element/doc:element/doc:element[@name='value']">
	        	<Sponsor>
					<xsl:variable name="sponsor_id">
						<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
					</xsl:variable>
             		<xsl:choose>
             		<xsl:when test="$sponsor_id!=''">
 					<xsl:call-template name="project">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="project_id" select="$sponsor_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="project">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="project_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>
	        	</Sponsor>
	        </xsl:for-each>	        
	        
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventspartnerou']/doc:element/doc:element/doc:element[@name='value']">
	        	<Partner>
					<xsl:variable name="partner_id">
						<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
					</xsl:variable>
             		<xsl:choose>
             		<xsl:when test="$partner_id!=''">
 					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="ou_id" select="$partner_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="ou_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>
	        	</Partner>
	        </xsl:for-each>
	        <xsl:for-each select="doc:element[@name='crisevents']/doc:element[@name='eventspartnerpj']/doc:element/doc:element/doc:element[@name='value']">
	        	<Partner>
					<xsl:variable name="partner_id">
						<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
					</xsl:variable>
             		<xsl:choose>
             		<xsl:when test="$partner_id!=''">
 					<xsl:call-template name="project">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="project_id" select="$partner_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="project">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="project_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>
	        	</Partner>
	        </xsl:for-each>
        </Event>
        </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
	        <Event>
		        <xsl:for-each select="$selector">
		        	<Name xml:lang="en"><xsl:value-of select="." /></Name>
		        </xsl:for-each>
	        </Event>
        </xsl:otherwise>
        </xsl:choose>        
	</xsl:template>
	
	 <!--	
    	equipment: Template that handle Equipment.
    -->
	<xsl:template name="equipment">
		<xsl:param name="selector" />
		<xsl:param name="equipment_id" />

        <xsl:choose>
        <xsl:when test="$equipment_id!=''">            
        <xsl:for-each select="$selector">
        <Equipment id="{$equipment_id}">
        		        
	        <xsl:for-each select="doc:element[@name='crisequipment']/doc:element[@name='equipmentacronym']/doc:element/doc:element/doc:field[@name='value']">
	        	<Acronym><xsl:value-of select="." /></Acronym>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisequipment']/doc:element[@name='equipmentname']/doc:element/doc:element/doc:field[@name='value']">
	        	<Name xml:lang="en"><xsl:value-of select="." /></Name>
	        </xsl:for-each>

	        <xsl:for-each select="doc:element[@name='crisequipment']/doc:element[@name='equipmentidentifier']/doc:element/doc:element/doc:field[@name='value']">
	        	<Identifier type="Institution assigned unique equipment identifier"><xsl:value-of select="." /></Identifier>
	        </xsl:for-each>

	        <xsl:for-each select="doc:element[@name='crisequipment']/doc:element[@name='equipmentdescription']/doc:element/doc:element/doc:field[@name='value']">
	        	<Description xml:lang="en"><xsl:value-of select="." /></Description>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='crisequipment']/doc:element[@name='equipmentownerou']/doc:element/doc:element">
	        	<Owner>
	        		<DisplayName><xsl:value-of select="./doc:field[@name='value']/text()" /></DisplayName> 
	        		<xsl:variable name="owner_id">
             			<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             		</xsl:variable>
                    <xsl:call-template name="ou">
            			<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
            			<xsl:with-param name="ou_id" select="$owner_id" />
            		</xsl:call-template>
	        	</Owner>
	        </xsl:for-each>
	        <xsl:for-each select="doc:element[@name='crisequipment']/doc:element[@name='equipmentownerrp']/doc:element/doc:element">
	        	<Owner>
	        		<DisplayName><xsl:value-of select="./doc:field[@name='value']/text()" /></DisplayName> 
	        		<xsl:variable name="owner_id">
             			<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             		</xsl:variable>
                    <xsl:call-template name="person">
            			<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
            			<xsl:with-param name="person_id" select="$owner_id" />
            		</xsl:call-template>
	        	</Owner>
	        </xsl:for-each>	        	        	        
        </Equipment>
        </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
	        <Equipment>
	        <xsl:for-each select="$selector">
	        	<Name xml:lang="en"><xsl:value-of select="." /></Name>
	        </xsl:for-each>
	        </Equipment>
        </xsl:otherwise>
        </xsl:choose>        
   	</xsl:template>

	<!-- 
		journal: Template that handle publication using a journal
	 -->
	 <xsl:template name="journal">
		<xsl:param name="selector" />
		<xsl:param name="journal_id" />
		
		<xsl:choose>
        <xsl:when test="$journal_id!=''">
		<xsl:for-each select="$selector">
        <Publication id="{$journal_id}">
            <Type xmlns:oai_cerif="https://www.openaire.eu/cerif-profile/vocab/COAR_Publication_Types">http://purl.org/coar/resource_type/c_0640</Type>
           
    		<!-- PublishedIn, Title (crisjournals.journalsname) --> 
            <xsl:for-each select="doc:element[@name='crisjournals']/doc:element[@name='journalsname']/doc:element/doc:element/doc:field[@name='value']">
                <Title xml:lang="en"><xsl:value-of select="." /></Title>
            </xsl:for-each>
            
            <!-- PublishedIn, ISSN -->
            <xsl:for-each select="doc:element[@name='crisjournals']/doc:element[@name='journalsissn']/doc:element/doc:element/doc:field[@name='value']">
                <ISSN><xsl:value-of select="." /></ISSN>
            </xsl:for-each>
       	</Publication>
   		</xsl:for-each>
   		</xsl:when>
   		<xsl:otherwise>
	   		<Publication>
	   		<xsl:for-each select="$selector">
    	   		<Type xmlns:oai_cerif="https://www.openaire.eu/cerif-profile/vocab/COAR_Publication_Types">http://purl.org/coar/resource_type/c_0640</Type>
	        	<Title xml:lang="en"><xsl:value-of select="." /></Title>
	        </xsl:for-each>
	   		</Publication>
   		</xsl:otherwise>
   		</xsl:choose>
   	</xsl:template>
   		
    <!--	
    	publication: Template that handle publication using a publication item
    -->
	<xsl:template name="publication">
		<xsl:param name="selector" />
							
		<xsl:for-each select="$selector">
       	<xsl:variable name="item_prop_id">
            <xsl:value-of select="doc:element[@name='others']/doc:field[@name='handle']" />
        </xsl:variable>
        
        <Publication id="{$item_prop_id}">
            
            <xsl:for-each select="doc:element[@name='item']/doc:element[@name='openairecristype']/doc:element/doc:field[@name='value']">
	            <Type xmlns:oai_cerif="https://www.openaire.eu/cerif-profile/vocab/COAR_Publication_Types"><xsl:value-of select="." /></Type>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='title']/doc:element/doc:field[@name='value']">
                <Title xml:lang="en"><xsl:value-of select="." /></Title>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='title']/doc:element[@name='alternative']/doc:element/doc:field[@name='value']">
                <Subtitle xml:lang="en"><xsl:value-of select="." /></Subtitle>
            </xsl:for-each>
            
            <!-- PublishedIn [START] -->
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='publication']/doc:element/doc:element[@name='authority']">
            	<PublishedIn>
                    <xsl:call-template name="publication">
            			<xsl:with-param name="selector" select="." />
            		</xsl:call-template>
                </PublishedIn>
            </xsl:for-each>
            <!-- PublishedIn [END] -->
            
            <!-- PartOf [START] -->
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='ispartof']/doc:element">
            	<PartOf>
            	    <xsl:variable name="journals_id">
                        <xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
                    </xsl:variable>
            
                    <DisplayName><xsl:value-of select="./doc:field[@name='value']/text()" /></DisplayName>        
            		<!-- by desing dc.relation.ispartof is always a JournalAuthority -->
            		<xsl:call-template name="journal">
            			<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
            			<xsl:with-param name="journal_id" select="$journals_id" />
            		</xsl:call-template>
            	</PartOf>
           	</xsl:for-each>
            <!-- PartOf [END] -->
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='date']/doc:element[@name='issued']/doc:element/doc:field[@name='value']">
            	<xsl:if test=". != ''">
                	<PublicationDate><xsl:value-of select="." /></PublicationDate>
                </xsl:if>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='volume']/doc:element/doc:field[@name='value']">
                <Volume><xsl:value-of select="." /></Volume>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='issue']/doc:element/doc:field[@name='value']">
                <Issue><xsl:value-of select="." /></Issue>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='edition']/doc:element/doc:field[@name='value']">
                <Edition><xsl:value-of select="." /></Edition>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='startpage']/doc:element/doc:field[@name='value']">
                <StartPage><xsl:value-of select="." /></StartPage>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='endpage']/doc:element/doc:field[@name='value']">
                <EndPage><xsl:value-of select="." /></EndPage>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='doi']/doc:element/doc:field[@name='value']">
                <DOI><xsl:value-of select="." /></DOI>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='others']/doc:field[@name='handle']">
                <Handle><xsl:value-of select="." /></Handle>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='pmid']/doc:element/doc:field[@name='value']">
                <PMCID><xsl:value-of select="." /></PMCID>
            </xsl:for-each>

			<xsl:for-each select="doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='isi']/doc:element/doc:field[@name='value']">
                <ISI-Number><xsl:value-of select="." /></ISI-Number>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='scopus']/doc:element/doc:field[@name='value']">
                <SCP-Number><xsl:value-of select="." /></SCP-Number>
            </xsl:for-each>

			<xsl:for-each
				select="doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='isbn']/doc:element/doc:field[@name='value']">
				<xsl:variable name="isbn_plain">
					<xsl:value-of
						select="translate(., 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ():-', '')" />
				</xsl:variable>
				<xsl:variable name="isbn_empty">
					<xsl:value-of
						select="normalize-space(translate($isbn_plain, '1234567890-', ''))" />
				</xsl:variable>
				<xsl:choose>
					<xsl:when
						test="(contains(., 'PRINT') or contains(., 'Print') or contains(., 'print')) and $isbn_empty=''">
						<ISBN medium="http://issn.org/vocabularies/Medium#Print"><xsl:value-of select="normalize-space($isbn_plain)" /></ISBN>
					</xsl:when>
					<xsl:when
						test="(contains(., 'ONLINE') or contains(., 'Online') or contains(., 'online')) and $isbn_empty=''">
						<ISBN medium="http://issn.org/vocabularies/Medium#Online"><xsl:value-of select="normalize-space($isbn_plain)" /></ISBN>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$isbn_empty=''">
							<ISBN><xsl:value-of select="normalize-space($isbn_plain)" /></ISBN>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>

            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='url']/doc:element/doc:field[@name='value']">
            	<xsl:if test="position() = 1">
                	<URL><xsl:value-of select="." /></URL>
                </xsl:if>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='uri']/doc:element/doc:field[@name='value']">
            	<xsl:if test="position() = 1">
                	<URN><xsl:value-of select="." /></URN>
                </xsl:if>
            </xsl:for-each>
            
            <xsl:if test="doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='author']/doc:element/doc:field[@name='value']!=''">
            <!-- Authors [START] -->
            <Authors>
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='author']/doc:element">
             	<xsl:variable name="dc_contributor_author_id">
             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
            	    <Author>
            	    		<DisplayName><xsl:value-of select="./doc:field[@name='value']" /></DisplayName>
							<xsl:call-template name="person">
								<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
								<xsl:with-param name="person_id" select="$dc_contributor_author_id" />
							</xsl:call-template>
					</Author>           		
            </xsl:for-each>
            </Authors>
            <!-- Authors [END] -->
            </xsl:if>
            
            <xsl:if test="doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='editor']/doc:element/doc:field[@name='value']!=''">
            <!-- Editors [START] -->
            <Editors>
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='editor']/doc:element">
             	<xsl:variable name="dc_contributor_editor_id">
             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
            	    <Editor>
            	    		<DisplayName><xsl:value-of select="./doc:field[@name='value']" /></DisplayName>
							<xsl:call-template name="person">
								<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
								<xsl:with-param name="person_id" select="$dc_contributor_editor_id" />
							</xsl:call-template>
					</Editor>           		
            </xsl:for-each>
            </Editors>
            <!-- Editors [END] -->
            </xsl:if>
            
            <xsl:if test="doc:element[@name='dc']/doc:element[@name='publisher']/doc:element/doc:field[@name='value']!=''">
            <!-- Publishers [START] -->
            <Publishers>
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='publisher']/doc:element/doc:field[@name='value']">
             	<xsl:variable name="dc_publisher_id">
             		<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>             		
           	    	<Publisher>
						<DisplayName><xsl:value-of select="." /></DisplayName>           	    	
						<xsl:call-template name="ou">
							<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
							<xsl:with-param name="ou_id" select="$dc_publisher_id" />
						</xsl:call-template>
					</Publisher>           		
            </xsl:for-each>
            </Publishers>
            <!-- Publishers [END] -->
            </xsl:if>
            
	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='subject']/doc:element/doc:field[@name='value']">
	        	<Keyword xml:lang="en"><xsl:value-of select="." /></Keyword>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='abstract']/doc:element/doc:field[@name='value']">
	        	<Abstract xml:lang="en"><xsl:value-of select="." /></Abstract>
	        </xsl:for-each>

	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='relation']/doc:element/doc:field[@name='value']">
	        	<OriginatesFrom>	        
		        	<xsl:variable name="project_id">
	             		<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
	             	</xsl:variable>
             		
             		<xsl:choose>
             		<xsl:when test="$project_id!=''">
 					<xsl:call-template name="project">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="project_id" select="$project_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="project">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="project_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>
	        	</OriginatesFrom>					
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='conference']/doc:element/doc:field[@name='value']">
				<PresentedAt>	        
		        	<xsl:variable name="dc_relation_conference_id">
	             		<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
	             	</xsl:variable>
             		
             		<xsl:choose>
             		<xsl:when test="$dc_relation_conference_id!=''">
 					<xsl:call-template name="events">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="event_id" select="$dc_relation_conference_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="events">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="event_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>
				</PresentedAt>
	       	</xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='item']/doc:element[@name='grantfulltext']/doc:element/doc:field[@name='value']">
	        	<ns4:Access xmlns:ns4="http://purl.org/coar/access_right">
	        		<xsl:variable name="accessright">
								<xsl:choose>
									<xsl:when test="contains(., 'open')">
										<xsl:text>http://purl.org/coar/access_right/c_abf2</xsl:text>
									</xsl:when>
									<xsl:when test="contains(., 'restricted')">
										<xsl:text>http://purl.org/coar/access_right/c_16ec</xsl:text>
									</xsl:when>
									<xsl:when test="contains(., 'embargo')">
						
											<xsl:text>http://purl.org/coar/access_right/c_f1cf/</xsl:text>
											<xsl:value-of select="substring(., 9, 4)" />
											<xsl:text>-</xsl:text>
											<xsl:value-of select="substring(., 13, 2)" />
											<xsl:text>-</xsl:text>
											<xsl:value-of select="substring(., 15, 2)" />
						
									</xsl:when>
									<xsl:when test="contains(., 'reserved')">
										<xsl:text>http://purl.org/coar/access_right/c_16ec</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>http://purl.org/coar/access_right/c_14cb</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
					</xsl:variable>
	        		<xsl:variable name="accessrightdate">
							<xsl:call-template name="oai_dateembargoed">
	        					<xsl:with-param name="rights" select="$accessright"/>
	        				</xsl:call-template>	             			
             		</xsl:variable>
             		<xsl:if test="$accessrightdate!=''">
		        		<xsl:attribute name="endDate"><xsl:value-of select="$accessrightdate" /></xsl:attribute>
	        		</xsl:if>
	        		<xsl:call-template name="oai_accessrights">
	        				<xsl:with-param name="rights" select="$accessright"/>
	        		</xsl:call-template>
	        	</ns4:Access>
	        </xsl:for-each>

        </Publication>
        </xsl:for-each>
	</xsl:template>
	
	<!--	
    	product: Template that handle publication using a product item
    -->
	<xsl:template name="product">
		<xsl:param name="selector" />
							
		<xsl:for-each select="$selector">
       	<xsl:variable name="item_prop_id">
            <xsl:value-of select="doc:element[@name='others']/doc:field[@name='handle']" />
        </xsl:variable>
        
        <Product id="{$item_prop_id}">
            
            <xsl:for-each select="doc:element[@name='item']/doc:element[@name='openairecristype']/doc:element/doc:field[@name='value']">
	            <Type xmlns:oai_cerif="https://www.openaire.eu/cerif-profile/vocab/COAR_Product_Types"><xsl:value-of select="." /></Type>
            </xsl:for-each>            
                        
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='title']/doc:element/doc:field[@name='value']">
                <Name xml:lang="en"><xsl:value-of select="." /></Name>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='version']/doc:element/doc:field[@name='value']">
                <VersionInfo xml:lang="en"><xsl:value-of select="." /></VersionInfo>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='ark']/doc:element/doc:field[@name='value']">
                <ARK><xsl:value-of select="." /></ARK>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='doi']/doc:element/doc:field[@name='value']">
                <DOI><xsl:value-of select="." /></DOI>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='others']/doc:field[@name='handle']">
                <Handle><xsl:value-of select="." /></Handle>
            </xsl:for-each>
            
			<xsl:for-each select="doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='url']/doc:element/doc:field[@name='value']">
                <URL><xsl:value-of select="." /></URL>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='uri']/doc:element/doc:field[@name='value']">
                <URN><xsl:value-of select="." /></URN>
            </xsl:for-each>
            
            <xsl:if test="doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='author']/doc:element/doc:field[@name='value']!=''">
            <!-- Creators [START] -->
            <Creators>
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='author']/doc:element">
             	<xsl:variable name="dc_contributor_author_id">
             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
            	    <Creator>
            	    	<DisplayName><xsl:value-of select="./doc:field[@name='value']" /></DisplayName>
							<xsl:call-template name="person">
								<xsl:with-param name="selector" select="./doc:element[@name='authority']" />
								<xsl:with-param name="person_id" select="$dc_contributor_author_id" />
							</xsl:call-template>
					</Creator>
            </xsl:for-each>
            </Creators>
            <!-- Creators [END] -->
            </xsl:if>
                     
			<xsl:if test="doc:element[@name='dc']/doc:element[@name='publisher']/doc:element/doc:field[@name='value']!=''">                        
            <!-- Publishers [START] -->
            <Publishers>
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='publisher']/doc:element/doc:field[@name='value']">
             	<xsl:variable name="dc_publisher_id">
             		<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
           	    	<Publisher>
             			<DisplayName><xsl:value-of select="." /></DisplayName>           	    	
						<xsl:call-template name="ou">
							<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
							<xsl:with-param name="ou_id" select="$dc_publisher_id" />
						</xsl:call-template>
					</Publisher>           		
            </xsl:for-each>
            </Publishers>
            <!-- Publishers [END] -->
            </xsl:if>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='rights']/doc:element[@name='license']/doc:element/doc:field[@name='value']">
	        	<License><xsl:value-of select="." /></License>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='description']/doc:element/doc:field[@name='value']">
	        	<Description xml:lang="en"><xsl:value-of select="." /></Description>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='subject']/doc:element/doc:field[@name='value']">
	        	<Keyword xml:lang="en"><xsl:value-of select="." /></Keyword>
	        </xsl:for-each>
            
            <!-- PartOf [START] -->
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='ispartof']/doc:element/doc:element[@name='value']">
            	<PartOf>
		        	<xsl:variable name="journals_id">
	             		<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
	             	</xsl:variable>
             		
             		<xsl:choose>
             		<xsl:when test="$journals_id!=''">
 					<xsl:call-template name="journal">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="journal_id" select="$journals_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="journal">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="journal_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>
            	</PartOf>
           	</xsl:for-each>
            <!-- PartOf [END] -->

	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='relation']/doc:element/doc:field[@name='value']">
	        	<OriginatesFrom>	        
	        		<xsl:variable name="project_id">
             			<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             		</xsl:variable>
             		<!-- <DisplayName><xsl:value-of select="." /></DisplayName> -->
             		<xsl:choose>
             		<xsl:when test="$project_id!=''">
 					<xsl:call-template name="project">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="project_id" select="$project_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="project">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="project_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>	        	
	        	</OriginatesFrom>					
	        </xsl:for-each>

	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='equipment']/doc:element/doc:field[@name='value']">
	        	<GeneratedBy>	        
		        	<xsl:variable name="generatedby_id">
	             		<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
	             	</xsl:variable>
             		
             		<xsl:choose>
             		<xsl:when test="$generatedby_id!=''">
 					<xsl:call-template name="equipment">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="equipment_id" select="$generatedby_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="equipment">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="equipment_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>	        	
	        	</GeneratedBy>					
	        </xsl:for-each>

	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='conference']/doc:element/doc:field[@name='value']">
				<PresentedAt>
		        	<xsl:variable name="dc_relation_conference_id">
	             		<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
	             	</xsl:variable>
             		
             		<xsl:choose>
             		<xsl:when test="$dc_relation_conference_id!=''">
 					<xsl:call-template name="events">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="event_id" select="$dc_relation_conference_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="events">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="event_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>
	       		</PresentedAt>				 	        
	       	</xsl:for-each>

	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='references']/doc:element/doc:element[@name='authority']">
	        	<References>	        
 					<xsl:call-template name="publication">
						<xsl:with-param name="selector" select="." />
					</xsl:call-template>
	        	</References>		
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='publication']/doc:element/doc:element[@name='authority']">
	        	<References>	        
 					<xsl:call-template name="publication">
						<xsl:with-param name="selector" select="." />
					</xsl:call-template>
	        	</References>		
	        </xsl:for-each>
	        	        	       	
	        <xsl:for-each select="doc:element[@name='item']/doc:element[@name='grantfulltext']/doc:element/doc:field[@name='value']">
	        	<ns4:Access xmlns:ns4="http://purl.org/coar/access_right">
	        		<xsl:variable name="accessright">
								<xsl:choose>
									<xsl:when test="contains(., 'open')">
										<xsl:text>http://purl.org/coar/access_right/c_abf2</xsl:text>
									</xsl:when>
									<xsl:when test="contains(., 'restricted')">
										<xsl:text>http://purl.org/coar/access_right/c_16ec</xsl:text>
									</xsl:when>
									<xsl:when test="contains(., 'embargo')">
						
											<xsl:text>http://purl.org/coar/access_right/c_f1cf/</xsl:text>
											<xsl:value-of select="substring(., 9, 4)" />
											<xsl:text>-</xsl:text>
											<xsl:value-of select="substring(., 13, 2)" />
											<xsl:text>-</xsl:text>
											<xsl:value-of select="substring(., 15, 2)" />
						
									</xsl:when>
									<xsl:when test="contains(., 'reserved')">
										<xsl:text>http://purl.org/coar/access_right/c_16ec</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>http://purl.org/coar/access_right/c_14cb</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
					</xsl:variable>
	        		<xsl:variable name="accessrightdate">
							<xsl:call-template name="oai_dateembargoed">
	        					<xsl:with-param name="rights" select="$accessright"/>
	        				</xsl:call-template>	             			
             		</xsl:variable>
             		<xsl:if test="$accessrightdate!=''">
		        		<xsl:attribute name="endDate"><xsl:value-of select="$accessrightdate" /></xsl:attribute>
	        		</xsl:if>
	        		<xsl:call-template name="oai_accessrights">
	        				<xsl:with-param name="rights" select="$accessright"/>
	        		</xsl:call-template>
	        	</ns4:Access>
	        </xsl:for-each>
        </Product>
        </xsl:for-each>
	</xsl:template>
	
	<!--	
    	patent: Template that handle publication using a patent item
    -->
	<xsl:template name="patent">
		<xsl:param name="selector" />
							
		<xsl:for-each select="$selector">
       	<xsl:variable name="item_prop_id">
            <xsl:value-of select="doc:element[@name='others']/doc:field[@name='handle']" />
        </xsl:variable>
        
        <Patent id="{$item_prop_id}">

           <xsl:for-each select="doc:element[@name='item']/doc:element[@name='openairecristype']/doc:element/doc:field[@name='value']">
	            <Type xmlns:oai_cerif="https://www.openaire.eu/cerif-profile/vocab/COAR_Patent_Types"><xsl:value-of select="." /></Type>
            </xsl:for-each>
                        
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='title']/doc:element/doc:field[@name='value']">
                <Title xml:lang="en"><xsl:value-of select="." /></Title>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='date']/doc:element[@name='issued']/doc:element/doc:field[@name='value']">
            	<xsl:if test=". != ''">
                	<RegistrationDate><xsl:value-of select="." /></RegistrationDate>
                </xsl:if>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dcterms']/doc:element[@name='dateAccepted']/doc:element/doc:field[@name='value']">
            	<xsl:if test=". != ''">
                	<ApprovalDate><xsl:value-of select="." /></ApprovalDate>
				</xsl:if>	               	
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='publisher']/doc:element/doc:field[@name='value']">
            	<Issuer>
	             	<xsl:variable name="dc_publisher_id">
	             		<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
	             	</xsl:variable>
           			<DisplayName><xsl:value-of select="." /></DisplayName>
					<xsl:call-template name="ou">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="ou_id" select="$dc_publisher_id" />
					</xsl:call-template>
				</Issuer>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='identifier']/doc:element[@name='patentno']/doc:element/doc:field[@name='value']">
                <PatentNumber><xsl:value-of select="." /></PatentNumber>
            </xsl:for-each>
            
            <xsl:if test="doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='author']/doc:element/doc:field[@name='value']!=''">
            <!-- Inventors [START] -->
            <Inventors>
            <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='contributor']/doc:element[@name='author']/doc:element">
             	<xsl:variable name="dc_contributor_author_id">
             		<xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
            	    <Inventor>
            	    	<DisplayName><xsl:value-of select="./doc:field[@name='value']" /></DisplayName>
            	    	<xsl:for-each select="./doc:element[@name='authority']">           	    	
							<xsl:call-template name="person">
								<xsl:with-param name="selector" select="." />
								<xsl:with-param name="person_id" select="$dc_contributor_author_id" />
							</xsl:call-template>
						</xsl:for-each>						
					</Inventor>
            </xsl:for-each>
            </Inventors>
            <!-- Inventors [END] -->
            </xsl:if>
                     
			<xsl:if test="doc:element[@name='dcterms']/doc:element[@name='rightsHolder']/doc:element/doc:field[@name='value']!=''">                        
            <!-- Holders [START] -->
            <Holders>
            <xsl:for-each select="doc:element[@name='dcterms']/doc:element[@name='rightsHolder']/doc:element/doc:field[@name='value']">
             	<xsl:variable name="dc_holder_id">
             		<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
             	</xsl:variable>
           	    	<Holder>
						<DisplayName><xsl:value-of select="." /></DisplayName>           	    	
						<xsl:call-template name="ou">
							<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
							<xsl:with-param name="ou_id" select="$dc_holder_id" />
						</xsl:call-template>
					</Holder>           		
            </xsl:for-each>
            </Holders>
            <!-- Holders [END] -->
            </xsl:if>
	        
	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='description']/doc:element[@name='abstract']/doc:element/doc:field[@name='value']">
	        	<Abstract xml:lang="en"><xsl:value-of select="." /></Abstract>
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='subject']/doc:element/doc:field[@name='value']">
	        	<Keyword xml:lang="en"><xsl:value-of select="." /></Keyword>
	        </xsl:for-each>

	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='relation']/doc:element/doc:field[@name='value']">
	        	<OriginatesFrom>	        
		        	<xsl:variable name="project_id">
	             		<xsl:value-of select="../doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
	             	</xsl:variable>
             		<!-- <DisplayName><xsl:value-of select="." /></DisplayName> -->
             		<xsl:choose>
             		<xsl:when test="$project_id!=''">
 					<xsl:call-template name="project">
						<xsl:with-param name="selector" select="../doc:element[@name='authority']" />
						<xsl:with-param name="project_id" select="$project_id" />
					</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
 					<xsl:call-template name="project">
						<xsl:with-param name="selector" select="." />
						<xsl:with-param name="project_id" select="''" />
					</xsl:call-template>					
					</xsl:otherwise>
					</xsl:choose>
	        	</OriginatesFrom>					
	        </xsl:for-each>
	        
	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='patent']/doc:element/doc:element[@name='authority']">
	        	<Predecessor>	        
 					<xsl:call-template name="patent">
						<xsl:with-param name="selector" select="." />
					</xsl:call-template>
	        	</Predecessor>		
	        </xsl:for-each>

	        <xsl:for-each select="doc:element[@name='dc']/doc:element[@name='relation']/doc:element[@name='references']/doc:element/doc:element[@name='authority']">
	        	<References>	        
 					<xsl:call-template name="publication">
						<xsl:with-param name="selector" select="." />
					</xsl:call-template>
	        	</References>		
	        </xsl:for-each>	        
        </Patent>
        </xsl:for-each>
	</xsl:template>
	
    <!--	
    	funding: Template that handle Funding.
    -->
	<xsl:template name="funding">
		<xsl:param name="selector" />
		<xsl:param name="funding_id" />

      <xsl:choose>
        <xsl:when test="$funding_id!=''">            
          <xsl:for-each select="$selector">
          <Funding id="Fundings/{$funding_id}">
                    
            <xsl:for-each select="doc:element[@name='crisfunding']/doc:element[@name='fundingoatype']/doc:element/doc:element/doc:field[@name='value']">
              <Type xmlns="https://www.openaire.eu/cerif-profile/vocab/OpenAIRE_Funding_Types"><xsl:value-of select="." /></Type>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='crisfunding']/doc:element[@name='fundingcfAcro']/doc:element/doc:element/doc:field[@name='value']">
              <Acronym><xsl:value-of select="." /></Acronym>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='crisfunding']/doc:element[@name='fundingname']/doc:element/doc:element/doc:field[@name='value']">
              <Name xml:lang="es"><xsl:value-of select="." /></Name>
            </xsl:for-each>
            
            <xsl:variable name="currency_funding"><xsl:value-of select="doc:element[@name='crisfunding']/doc:element[@name='fundingcfCurrencyCode']/doc:element/doc:element/doc:field[@name='value']" /></xsl:variable>
            <xsl:variable name="amount_funding"><xsl:value-of select="doc:element[@name='crisfunding']/doc:element[@name='fundingcfFundingAmount']/doc:element/doc:element/doc:field[@name='value']" /></xsl:variable>
            <xsl:if test="($amount_funding!='') and ($amount_funding castable as xs:integer)">
                <Amount currency="{$currency_funding}"><xsl:value-of select="xs:integer($amount_funding)" /></Amount>
            </xsl:if>	
              
            <xsl:for-each select="doc:element[@name='crisfunding']/doc:element[@name='fundingpeCodigo']/doc:element/doc:element/doc:field[@name='value']">
              <Identifier type="https://w3id.org/cerif/vocab/IdentifierTypes#AwardNumber"><xsl:value-of select="." /></Identifier>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='crisfunding']/doc:element[@name='fundingcfFundingDescription']/doc:element/doc:element/doc:field[@name='value']">
              <Description xml:lang="es"><xsl:value-of select="." /></Description>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='crisfunding']/doc:element[@name='fundingpeClasificacionOCDE']/doc:element/doc:element/doc:field[@name='value']">
              <xsl:if test="string(.) != '---'">
                <Subject xml:lang="es"><xsl:value-of select="." /></Subject>
              </xsl:if>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='crisfunding']/doc:element[@name='fundingcfFundingKeywords']/doc:element/doc:element/doc:field[@name='value']">
              <Keyword xml:lang="es"><xsl:value-of select="." /></Keyword>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='crisfunding']/doc:element[@name='fundingstream']/doc:element/doc:element/doc:field[@name='value']">
              <Keyword xml:lang="es"><xsl:value-of select="." /></Keyword>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='crisfunding']/doc:element[@name='fundingpesector']/doc:element/doc:element/doc:field[@name='value']">
              <Keyword xml:lang="es">Sector <xsl:value-of select="." /></Keyword>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='crisfunding']/doc:element[@name='fundingpeOuFunder']/doc:element/doc:element">
              <xsl:variable name="funder_id">
                <xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
              </xsl:variable>
              <Funder>
                <DisplayName><xsl:value-of select="./doc:field[@name='value']/text()" /></DisplayName>
                <xsl:call-template name="ou">
                  <xsl:with-param name="selector" select="./doc:element[@name='authority']" />
                  <xsl:with-param name="ou_id" select="$funder_id" />
                </xsl:call-template>
              </Funder>
            </xsl:for-each>
            
            <xsl:for-each select="doc:element[@name='crisfunding']/doc:element[@name='fundingpePartOfFunding']/doc:element/doc:element">
              <xsl:variable name="part_of_funding_id">
                <xsl:value-of select="./doc:element[@name='authority']/doc:element[@name='others']/doc:field[@name='handle']/text()" />
              </xsl:variable>
              <PartOf>
                <DisplayName><xsl:value-of select="./doc:field[@name='value']/text()" /></DisplayName>
                <xsl:call-template name="funding">
                  <xsl:with-param name="selector" select="./doc:element[@name='authority']" />
                  <xsl:with-param name="funding_id" select="$part_of_funding_id" />
                </xsl:call-template>
              </PartOf>
            </xsl:for-each>
            
            <xsl:variable name="duration_funding_start"><xsl:value-of select="doc:element[@name='crisfunding']/doc:element[@name='fundingcfFundingStartDate']/doc:element/doc:element/doc:field[@name='value']" /></xsl:variable>
            <xsl:variable name="duration_funding_end"><xsl:value-of select="doc:element[@name='crisfunding']/doc:element[@name='fundingcfFundingEndDate']/doc:element/doc:element/doc:field[@name='value']" /></xsl:variable>
            <xsl:if test="($duration_funding_start!='')">
              <Duration>
                <xsl:attribute name="startDate">
                  <xsl:call-template name="formatdate">
                    <xsl:with-param name="datestr" select="$duration_funding_start" />
                  </xsl:call-template>
                </xsl:attribute>
                <xsl:if test="($duration_funding_end!='')">
                  <xsl:attribute name="endDate">
                    <xsl:call-template name="formatdate">
                      <xsl:with-param name="datestr" select="$duration_funding_end" />
                    </xsl:call-template>
                  </xsl:attribute>
                </xsl:if>	
              </Duration>
            </xsl:if>	
              
            <OAMandate mandated="true" uri="https://portal.concytec.gob.pe/images/stories/images2013/portal/areas-institucion/dsic/ley-30035.pdf" />

          </Funding>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <Funding>
            <xsl:for-each select="$selector">
              <Name xml:lang="es"><xsl:value-of select="." /></Name>
            </xsl:for-each>
          </Funding>
        </xsl:otherwise>
      </xsl:choose>        
	</xsl:template>
	
    <xsl:template match="/">

        <!-- item -->
        <xsl:if test="doc:metadata/doc:element[@name='others']/doc:field[@name='type']/text()='cfitem'">
        	<!-- check type (is a publication or a product or ...) -->
        	<xsl:call-template name="item_chooser">
				<xsl:with-param name="selector" select="." />
			</xsl:call-template>
        </xsl:if>
        
        <!-- ou -->
        <xsl:if test="doc:metadata/doc:element[@name='others']/doc:field[@name='type']/text()='ou'">
	        <xsl:variable name="orgunit_id">
	 			<xsl:value-of select="doc:metadata/doc:element[@name='others']/doc:field[@name='handle']/text()" />
		    </xsl:variable>
        	<xsl:call-template name="ou">
		    	<xsl:with-param name="selector" select="doc:metadata" />
		        <xsl:with-param name="ou_id" select="$orgunit_id" />
		   	</xsl:call-template>
        </xsl:if>
        
        <!-- rp -->
        <xsl:if test="doc:metadata/doc:element[@name='others']/doc:field[@name='type']/text()='rp'">
	        <xsl:variable name="rp_id">
            	<xsl:value-of select="doc:metadata/doc:element[@name='others']/doc:field[@name='handle']/text()" />
            </xsl:variable>
			<xsl:call-template name="person">
				<xsl:with-param name="selector" select="doc:metadata" />
				<xsl:with-param name="person_id" select="$rp_id" />
			</xsl:call-template>
        </xsl:if>
                
        <!-- project -->
        <xsl:if test="doc:metadata/doc:element[@name='others']/doc:field[@name='type']/text()='project'">
	        <xsl:variable name="project_id">
            	<xsl:value-of select="doc:metadata/doc:element[@name='others']/doc:field[@name='handle']/text()" />
            </xsl:variable>
			<xsl:call-template name="project">
				<xsl:with-param name="selector" select="doc:metadata" />
				<xsl:with-param name="project_id" select="$project_id" />
			</xsl:call-template>
        </xsl:if>
        
        <!-- events -->
        <xsl:if test="doc:metadata/doc:element[@name='others']/doc:field[@name='type']/text()='events'">
	        <xsl:variable name="events_id">
            	<xsl:value-of select="doc:metadata/doc:element[@name='others']/doc:field[@name='handle']/text()" />
            </xsl:variable>
			<xsl:call-template name="events">
				<xsl:with-param name="selector" select="doc:metadata" />
				<xsl:with-param name="event_id" select="$events_id" />
			</xsl:call-template>
        </xsl:if>
        
        <!-- journals -->
        <xsl:if test="doc:metadata/doc:element[@name='others']/doc:field[@name='type']/text()='journals'">
        	<xsl:variable name="journals_id">
            	<xsl:value-of select="doc:metadata/doc:element[@name='others']/doc:field[@name='handle']/text()" />
            </xsl:variable>
			<xsl:call-template name="journal">
				<xsl:with-param name="selector" select="doc:metadata" />
				<xsl:with-param name="journal_id" select="$journals_id" />
			</xsl:call-template>
        </xsl:if>
        
        <!-- equipment -->
        <xsl:if test="doc:metadata/doc:element[@name='others']/doc:field[@name='type']/text()='equipment'">
	        <xsl:variable name="equipment_id">
            	<xsl:value-of select="doc:metadata/doc:element[@name='others']/doc:field[@name='handle']/text()" />
            </xsl:variable>
			<xsl:call-template name="equipment">
				<xsl:with-param name="selector" select="doc:metadata" />
				<xsl:with-param name="equipment_id" select="$equipment_id" />
			</xsl:call-template>
        </xsl:if>
        
        <!-- funding -->
        <xsl:if test="doc:metadata/doc:element[@name='others']/doc:field[@name='type']/text()='funding'">
	        <xsl:variable name="funding_id">
            	<xsl:value-of select="doc:metadata/doc:element[@name='others']/doc:field[@name='handle']/text()" />
            </xsl:variable>
			<xsl:call-template name="funding">
				<xsl:with-param name="selector" select="doc:metadata" />
				<xsl:with-param name="funding_id" select="$funding_id" />
			</xsl:call-template>
        </xsl:if>
        
    </xsl:template>
	
</xsl:stylesheet>
