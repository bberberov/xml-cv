<?xml version='1.0' encoding='UTF-8'?>
<!--
xml-cv v0.1.0 | Common templates
Copyright © 2018–2019, 2021, 2024 Boian Berberov

Released under the terms of the
European Union Public License version 1.2 only.

License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-11-12

SPDX-License-Identifier: EUPL-1.2
-->
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:date="http://exslt.org/dates-and-times"
	extension-element-prefixes="date"
	version='1.0'>

	<xsl:template name='skip'>
		<xsl:apply-templates select='@*|node()'/>
	</xsl:template>

	<xsl:template name='identity'>
		<xsl:copy>
			<xsl:apply-templates select='@*|node()'/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name='identity-copy-attr'>
		<xsl:copy>
			<xsl:copy-of select='@*'/>
			<xsl:apply-templates select='node()'/>
		</xsl:copy>
	</xsl:template>

	<xsl:template name='colon-space'><xsl:text>:&#8194;</xsl:text></xsl:template><!-- EM space -->

	<xsl:template name='comma-list'>
		<xsl:apply-templates/>
		<xsl:if test='position() != last()'><xsl:text>, </xsl:text></xsl:if>
	</xsl:template>

	<!-- FROM - TO -->
	<xsl:template match='from|to' mode='full'>
		<xsl:variable name='month' select = 'date:month-abbreviation(.)' />
		<xsl:if test='$month!=""'>
			<xsl:value-of select='$month' /><xsl:text>. </xsl:text>
		</xsl:if>
		<xsl:value-of select='date:year(.)' />
	</xsl:template>

	<xsl:template match='from|to' mode='year'>
		<xsl:value-of select='date:year(.)' />
	</xsl:template>

	<!-- from and to text formatting -->
	<xsl:template name='entity-from-to'>
		<xsl:if test='./from'>
			<xsl:apply-templates select='./from' mode='full'/>
			<xsl:text> &#8211; </xsl:text><!-- EN dash -->
		</xsl:if>
		<xsl:choose>
			<xsl:when test='./to'>
				<xsl:apply-templates select='./to' mode='full'/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Present</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='pos-from-to'>
		<xsl:if test='./from'>
			<xsl:apply-templates select='./from' mode='year'/>
			<xsl:text> &#8211; </xsl:text><!-- EN dash -->
		</xsl:if>
		<xsl:choose>
			<xsl:when test='./to'>
				<xsl:apply-templates select='./to' mode='year'/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Present</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Education -->
	<xsl:template name='edu-degree-ms'>
		<xsl:text>Masters of Science</xsl:text>
	</xsl:template>

	<xsl:template name='edu-degree-bs'>
		<xsl:text>Bachelors of Science</xsl:text>
	</xsl:template>

	<xsl:template match='edu/degree/ms'>
		<xsl:call-template name='edu-degree-ms' />
		<xsl:text> </xsl:text>
		<xsl:value-of select='.' />
	</xsl:template>

	<xsl:template match='edu/degree/ms' mode='title'>
		<xsl:call-template name='edu-degree-ms' />
	</xsl:template>

	<xsl:template match='edu/degree/bs'>
		<xsl:call-template name='edu-degree-bs' />
		<xsl:text> </xsl:text>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match='edu/degree/bs' mode='title'>
		<xsl:call-template name='edu-degree-bs' />
	</xsl:template>

	<xsl:template match='edu/degree/*[not(self::minor)]' mode='major'>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match='edu/degree/minor'>
		<xsl:text>minor in </xsl:text><xsl:value-of select='.' />
	</xsl:template>

	<!-- `entity` text formatting -->
	<xsl:template match='entity'>
		<xsl:if test='./division'>
			<xsl:if test='./subdivision'>
				<xsl:value-of select='./subdivision' /><xsl:text>, </xsl:text>
			</xsl:if>
			<xsl:value-of select='./division' /><xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:apply-templates select='./name'/>
		<xsl:if test='./location'>
			<xsl:text>; </xsl:text><xsl:apply-templates select='./location'/>
		</xsl:if>
	</xsl:template>

	<xsl:template match='entity/location'>
		<xsl:value-of select='./city' /><xsl:text>, </xsl:text><xsl:value-of select='./state' />
		<xsl:if test='./country'>
			<xsl:text>, </xsl:text><xsl:value-of select='./country' />
		</xsl:if>
	</xsl:template>

	<!-- Organization Position text formatting -->
	<xsl:template match='pos' mode='collapsed'>
		<xsl:value-of select='./name' />
		<xsl:if test='to'>
			<xsl:text> (</xsl:text><xsl:call-template name='pos-from-to' /><xsl:text>)</xsl:text>
		</xsl:if>
		<xsl:if test='position() != last()'><xsl:text>, </xsl:text></xsl:if>
	</xsl:template>

	<!-- Person's Name -->
	<xsl:template match='/cv/data/name'>
		<xsl:value-of select='./given' /><xsl:text> </xsl:text><xsl:value-of select='./surname' />
	</xsl:template>
</xsl:stylesheet>
