<?xml version='1.0' encoding='UTF-8'?>
<!--
xml-cv v0.1.0 | XLink resolving transform
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
	<xsl:output method='xml' indent='yes' encoding='UTF-8' />
	
	<xsl:template match='/cv/meta' />

	<xsl:template match='@id' />

	<xsl:template match='*[@xlink:href]'>
		<xsl:apply-templates select='//*[@id=substring(current()/@xlink:href, 2)]' />
	</xsl:template>

	<xsl:template match='@*|node()'>
		<xsl:call-template name='identity'/>
	</xsl:template>
</xsl:stylesheet>
