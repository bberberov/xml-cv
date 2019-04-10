<?xml version='1.0' encoding='UTF-8'?>
<!--
xml-cv v0.1.0 | Adapting transform
Copyright © 2019 Boian Berberov

Released under the terms of the
European Union Public License version 1.2 only.

License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-11-12

SPDX-License-Identifier: EUPL-1.2
-->
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:date="http://exslt.org/dates-and-times"
	xmlns:math="http://exslt.org/math"
	extension-element-prefixes="date math"
	version='1.0'>
	<xsl:import href="common.xsl"/>
	<xsl:output method='xml' indent='yes' encoding='UTF-8' />
	<xsl:param name='years'>10</xsl:param>

	<xsl:template match='data/exp'>
		<xsl:if test='math:abs( date:year() - date:year(./to) ) &lt; number($years)' >
			<xsl:call-template name='identity'/>
		</xsl:if>
	</xsl:template>

	<xsl:template match='data/edu/org/pos/from|data/edu/org/pos/to'>
		<xsl:if test='math:abs( date:year() - date:year(.) ) &lt; number($years)' >
			<xsl:call-template name='identity'/>
		</xsl:if>
	</xsl:template>

	<xsl:template match='@*|node()'>
		<xsl:call-template name='identity'/>
	</xsl:template>
</xsl:stylesheet>
