<?xml version='1.0' encoding='UTF-8'?>
<!--
xml-cv v0.1.0 | XLink resolving transform
Copyright © 2018–2019, 2021 Boian Berberov

Released under the terms of the
European Union Public License version 1.2 only.

License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-11-12

SPDX-License-Identifier: EUPL-1.2
-->
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:xlink='http://www.w3.org/1999/xlink'
	version='1.0'>
	<xsl:import href="common.xsl"/>
	<xsl:output method='xml' indent='no' encoding='UTF-8'/>

	<!-- Remove refs section -->
	<xsl:template match='/cv/refs'/>

	<!-- Resolve and flatten references -->
	<xsl:template match='*[@xlink:href]'>
		<xsl:apply-templates select='//*[@id=substring(current()/@xlink:href, 2)]'/>
	</xsl:template>

	<!-- Clear IDs in replaced elements -->
	<xsl:template match='@id'/>

	<!-- Fill in To with today's date when empty and From exists -->
<!--	<xsl:template match='edu|exp'>
		<xsl:copy>
			<xsl:apply-templates/>
			<xsl:if test='./from and not(./to)'>
				<to><xsl:call-template name='date-now'/></to>
			</xsl:if>
		</xsl:copy>
	</xsl:template>-->

	<!-- Space Normalization -->
	<xsl:template match='summary/text()'>
		<xsl:if test='preceding-sibling::node()[position()=1]'>
			<xsl:text> </xsl:text>
		</xsl:if>
		<xsl:value-of select='normalize-space(.)'/>
		<xsl:if test='following-sibling::node()[position()=1]'>
			<xsl:text> </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match='@*|node()'>
		<xsl:call-template name='identity'/>
	</xsl:template>
</xsl:stylesheet>
