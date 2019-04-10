<?xml version='1.0' encoding='UTF-8'?>
<!--
xml-cv v0.1.0 | Localization resolving transform
Copyright © 2018–2019 Boian Berberov

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
	<xsl:output method='xml' indent='yes' encoding='UTF-8'/>
	<xsl:param name='lang'/>

	<xsl:template match='multilang'>
		<xsl:choose>
			<xsl:when test='./*[lang($lang)]'>
				<xsl:for-each select='./*[lang($lang)]'>
					<xsl:call-template name='copy-element'/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select='./*[lang(string(//@xml:lang))]'>
					<xsl:call-template name='copy-element'/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='copy-element'>
		<xsl:copy>
			<xsl:copy-of select='../@*|@*'/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match='@*|node()'>
		<xsl:call-template name='identity'/>
	</xsl:template>
</xsl:stylesheet>
