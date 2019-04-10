<?xml version='1.0' encoding='UTF-8'?>
<!--
xml-cv v0.1.0 | OpenDocument (FODT) rendering transform
Copyright © 2018–2019 Boian Berberov

Released under the terms of the
European Union Public License version 1.2 only.

License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-11-12

SPDX-License-Identifier: EUPL-1.2
-->
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:xs='http://www.w3.org/2001/XMLSchema'
	
	xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
	xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
	xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"

	xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
	xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"

	xmlns:loext="urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0"
	version='1.0'>
	<xsl:import href="common.xsl"/>
	<xsl:output method='xml' indent='yes' encoding='UTF-8'/>
	<xsl:param name='lang'/>

	<!-- Common -->

		<!-- Term -->
	<xsl:template match='term'>
		<text:span text:style-name="Emphasis">
			<xsl:apply-templates/>
		</text:span>
	</xsl:template>

		<!-- Lists -->
	<xsl:template name='list-order'>
		<xsl:choose>
			<xsl:when test='name(..) = name(.)'>
				<xsl:attribute name='text:style-name'>List_20_1_20_Cont.</xsl:attribute>
			</xsl:when>
			<xsl:when test='name(child::*) = name(.)'>
				<xsl:attribute name='text:style-name'>List_20_1_20_Cont.</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test='last() = 1'>
						<xsl:attribute name='text:style-name'>List_20_1</xsl:attribute>
					</xsl:when>
					<xsl:when test='position() = 1'>
						<xsl:attribute name='text:style-name'>List_20_1_20_Start</xsl:attribute>
					</xsl:when>
					<xsl:when test='position() = last()'>
						<xsl:attribute name='text:style-name'>List_20_1_20_End</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name='text:style-name'>List_20_1_20_Cont.</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='list'>
		<xsl:choose>
			<xsl:when test='./*[name()=name(current())]'>
				<text:list-item>
					<text:p>
						<xsl:call-template name='list-order' />
						<xsl:apply-templates select='./title'/>
					</text:p>
					<text:list>
						<xsl:apply-templates select='./*[name()=name(current())]'/>
						<xsl:apply-templates select='./item' mode='list'/>
					</text:list>
				</text:list-item>
			</xsl:when>
			<xsl:when test='./title'>
				<text:list-item>
					<text:p>
						<xsl:call-template name='list-order' />
						<xsl:apply-templates select='./title' />
						<xsl:call-template name='colon-space' />
						<xsl:apply-templates select='./item' mode='collapsed' />
					</text:p>
				</text:list-item>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select='./item' mode='list' />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='list-item'>
		<text:list-item>
			<text:p>
				<xsl:call-template name='list-order' />
				<xsl:apply-templates />
			</text:p>
		</text:list-item>
	</xsl:template>

	<xsl:template match='item' mode='list'>
		<xsl:call-template name='list-item' />
	</xsl:template>

	<xsl:template match='item' mode='collapsed'>
		<xsl:call-template name='comma-list' />
	</xsl:template>

		<!-- Header -->
	<xsl:template name='header-contact'>
		<text:span text:style-name="Icon">
			<xsl:text>&#9733;</xsl:text>
		</text:span>
		<xsl:text> </xsl:text>
		<xsl:value-of select='/cv/data/url[@type="homepage"]' />
		<xsl:text>&#8195;</xsl:text>
		<text:span text:style-name="Icon">
			<xsl:text>&#9993;</xsl:text>
		</text:span>
		<xsl:text> </xsl:text>
		<xsl:value-of select='/cv/data/email[@type="home"]' />
		<xsl:text>&#8195;</xsl:text>
		<xsl:text>&#9742;</xsl:text>
		<xsl:text> </xsl:text>
		<xsl:value-of select='/cv/data/phone[@type="home"]' />
	</xsl:template>

		<!-- Entity Line -->
	<xsl:template name='entity-line'>
		<text:p text:style-name="Small">
			<xsl:apply-templates select='./entity'/>
			<text:tab /><xsl:call-template name='from-to' />
		</text:p>
	</xsl:template>

		<!-- org, pos, activity -->
	<!-- 'pos' mode='collapsed' in common.xml -->

	<xsl:template match='org' mode='collapsed'>
		<text:list-item>
			<text:p>
				<xsl:call-template name='list-order' />
				<xsl:apply-templates select='./name'/>
				<xsl:if test='./pos'>
					<xsl:call-template name='colon-space' />
					<xsl:apply-templates select='./pos' mode='collapsed'/>
				</xsl:if>
			</text:p>
			<xsl:if test='./activity | ./pos/activity'>
				<text:list>
					<xsl:apply-templates select='./activity | ./pos/activity'/>
				</text:list>
			</xsl:if>
		</text:list-item>
	</xsl:template>

	<xsl:template match='org' mode='list'>
		<text:list-item>
			<text:p>
				<xsl:call-template name='list-order' />
				<xsl:apply-templates select='./name'/>
			</text:p>
			<xsl:if test='./org'>
				<text:list>
					<xsl:apply-templates select='./org' mode='list'/>
				</text:list>
			</xsl:if>
			<xsl:if test='./pos'>
				<text:list>
					<xsl:apply-templates select='./pos' mode='list'/>
				</text:list>
			</xsl:if>
			<xsl:if test='./activity'>
				<text:list>
					<xsl:apply-templates select='./activity'/>
				</text:list>
			</xsl:if>
		</text:list-item>
	</xsl:template>

	<xsl:template match='pos' mode='list'>
		<text:list-item>
			<text:p>
				<xsl:call-template name='list-order' />
				<xsl:apply-templates select='./name'/>
				<xsl:if test='to'>
					<text:tab /><xsl:call-template name='from-to' />
				</xsl:if>
			</text:p>
			<xsl:if test='./activity'>
				<text:list>
					<xsl:apply-templates select='./activity'/>
				</text:list>
			</xsl:if>
		</text:list-item>
	</xsl:template>

	<xsl:template match='org/activity | pos/activity'>
		<xsl:call-template name='list-item' />
	</xsl:template>

	<!-- Top Element -->
	<xsl:template match='/cv'>
		<office:document
			xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
			xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
			xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"

			xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
			xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"

			xmlns:loext="urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0"
			office:mimetype="application/vnd.oasis.opendocument.text"
			office:version="1.2">

			<xsl:copy-of select='document("../style/fodt_document-styles.xml")/*/*' />

			<!-- Page styles, including Header and Footer -->
			<office:master-styles>
				<style:master-page style:name="Standard" style:page-layout-name="Page">
					<style:header>
						<text:p text:style-name="Header_20_Default">
							<xsl:apply-templates select='/cv/data/name'/>
							<text:tab />
							<xsl:call-template name='header-contact' />
							<text:tab />
							<xsl:text>Page </xsl:text><text:page-number text:select-page="current"/>
						</text:p>
					</style:header>
				</style:master-page>
				<style:master-page style:name="First_20_Page" style:display-name="First Page" style:page-layout-name="Page" style:next-style-name="Standard">
					<style:header>
						<text:p text:style-name="Header_20_First_20_Page">
							<text:span text:style-name="Name">
								<xsl:apply-templates select='/cv/data/name'/>
							</text:span>
							<text:tab />
							<xsl:call-template name='header-contact' />
						</text:p>
					</style:header>
				</style:master-page>
			</office:master-styles>

			<!-- Document -->
			<office:body><office:text>
				<text:p text:style-name="P1"/>
				<xsl:apply-templates select='/cv/data'/>
			</office:text></office:body>
		</office:document>
	</xsl:template>

	<xsl:template match='/cv/data'>
		<xsl:if test='$lang = "en-CA"'>
			<text:h text:style-name="Heading_20_1">
				<xsl:text>Summary of Qualifications</xsl:text>
			</text:h>

			<text:list text:style-name="List_20_1">
				<text:list-item>
					<text:p>Item</text:p>
				</text:list-item>
			</text:list>

			<text:h text:style-name="Heading_20_2">
				<xsl:text>Strengths</xsl:text>
			</text:h>
			<text:section text:style-name="Columns_4" text:name="Strengths">
				<text:list text:style-name="List_20_1">
					<xsl:apply-templates select='/cv/data/strengths'/>
				</text:list>
			</text:section>
		</xsl:if>

		<text:h text:style-name="Heading_20_1">
			<xsl:text>Education</xsl:text>
		</text:h>
		<xsl:apply-templates select='/cv/data/edu'>
			<xsl:sort select='to' order='descending' />
		</xsl:apply-templates>

		<text:h text:style-name="Heading_20_1">
			<xsl:text>Experience</xsl:text>
		</text:h>
		<xsl:apply-templates select='/cv/data/exp'>
			<xsl:sort select='to' order='descending' />
		</xsl:apply-templates>

		<text:h text:style-name="Heading_20_1">
			<xsl:text>Skills Summary</xsl:text>
		</text:h>
		<text:list text:style-name="List_20_1">
			<xsl:apply-templates select='/cv/data/skills'/>
		</text:list>

		<text:h text:style-name="Heading_20_1">
			<xsl:text>Professional Memberships / Activities</xsl:text>
		</text:h>
		<text:section text:style-name="Columns_2" text:name="Pro_Member_Activ">
			<xsl:apply-templates select='/cv/data/org'/>
		</text:section>

		<text:h text:style-name="Heading_20_1">
			<xsl:text>References</xsl:text>
		</text:h>
		<text:p text:style-name="List_20_1">
			<xsl:apply-templates select='/cv/data/noref'/>
		</text:p>
	</xsl:template>

	<xsl:template match='data/strengths'>
		<xsl:call-template name='list'/>
	</xsl:template>

	<!-- Education -->
	<xsl:template match='/cv/data/edu'>
		<text:h text:style-name="Heading_20_2"><xsl:apply-templates select='./degree'/></text:h>
		<xsl:call-template name='entity-line' />

		<xsl:if test='./courses|./projects|./org'>
			<text:list text:style-name="List_20_1">
				<xsl:apply-templates select='./courses'/>
				<xsl:if test='./projects'>
					<text:list-item>
						<text:p>
							<xsl:call-template name='list-order' />
							<text:span text:style-name="Strong_20_Emphasis">
								<xsl:text>Projects</xsl:text>
							</text:span>
						</text:p>
						<text:list>
							<xsl:apply-templates select='./projects'/>
						</text:list>
					</text:list-item>
				</xsl:if>
				<xsl:if test='./org'>
					<text:list-item>
						<text:p>
							<xsl:call-template name='list-order' />
							<text:span text:style-name="Strong_20_Emphasis">
								<xsl:text>Activities</xsl:text>
							</text:span>
						</text:p>
						<text:list>
							<xsl:apply-templates select='./org' mode='collapsed'/>
						</text:list>
					</text:list-item>
				</xsl:if>
			</text:list>
		</xsl:if>
	</xsl:template>

	<xsl:template match='edu/degree'>
		<xsl:choose>
			<xsl:when test='../degree/minor' >
				<xsl:apply-templates select='./*[not(self::minor)]'/>
				<xsl:for-each select='./minor'>
					<xsl:text>, minor in </xsl:text><xsl:value-of select='.' />
				</xsl:for-each>
				<xsl:if test='position() != last()'><xsl:text>;</xsl:text><text:line-break /></xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select='./*'/>
				<xsl:if test='position() != last()'><xsl:text>,</xsl:text><text:line-break /></xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match='edu//courses | edu//projects'>
		<xsl:call-template name='list' />
	</xsl:template>

	<xsl:template match='edu//courses/title | edu//org/name'>
		<text:span text:style-name="Strong_20_Emphasis">
			<xsl:apply-templates />
		</text:span>
	</xsl:template>

	<xsl:template match='edu//projects/title'>
		<text:span text:style-name="Emphasis">
			<xsl:apply-templates />
		</text:span>
	</xsl:template>

	<!-- Experience -->
	<xsl:template match='/cv/data/exp'>
		<text:h text:style-name="Heading_20_2"><xsl:value-of select='./title' /></text:h>
		<xsl:call-template name='entity-line' />

		<text:list text:style-name="List_20_2">
			<xsl:apply-templates select='./details[@type="achievement"]'/>
		</text:list>
		<text:list text:style-name="List_20_1">
			<xsl:apply-templates select='./details[@type="duty"]'/>
		</text:list>
	</xsl:template>

	<xsl:template match='exp//details'>
		<xsl:call-template name='list' />
	</xsl:template>

	<!-- Skills -->
	<xsl:template match='data//skills'>
		<xsl:call-template name='list' />
	</xsl:template>

	<xsl:template match='data//skills/title'>
		<text:span text:style-name="Strong_20_Emphasis">
			<xsl:apply-templates />
		</text:span>
	</xsl:template>

	<!-- Org -->
	<xsl:template match='/cv/data/org'>
		<text:h text:style-name="Heading_20_2">
			<xsl:apply-templates select='./name'/>
		</text:h>
		<xsl:if test='./org'>
			<text:list text:style-name="List_20_1">
				<xsl:apply-templates select='./org' mode='list'/>
			</text:list>
		</xsl:if>
		<xsl:if test='./pos'>
			<text:list text:style-name="List_20_1">
				<xsl:apply-templates select='./pos' mode='list'/>
			</text:list>
		</xsl:if>
		<xsl:if test='./activity'>
			<text:list text:style-name="List_20_1">
				<xsl:apply-templates select='./activity' mode='list'/>
			</text:list>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
