<?xml version='1.0' encoding='UTF-8'?>
<!--
xml-cv v0.1.0 | Plain text term extractor transform
Copyright © 2018–2019 Boian Berberov

Released under the terms of the
European Union Public License version 1.2 only.

License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-11-12

SPDX-License-Identifier: EUPL-1.2
-->
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'>
	<xsl:import href="common.xsl"/>
	<xsl:output method='text' indent='no' encoding='UTF-8'/>

	<xsl:template match='term'>
		<xsl:value-of select='.'/>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match='@*|node()'>
		<xsl:call-template name='skip'/>
	</xsl:template>
</xsl:stylesheet>
