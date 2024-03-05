<?xml version='1.0' encoding='UTF-8'?>
<!--
xml-cv v0.1.0 | Markdown rendering transform
Copyright © 2018–2019, 2021 Boian Berberov

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
	<xsl:param name='lang'/>

	<!-- Common -->

		<!-- Term -->
	<xsl:template match='term'>
		<xsl:text>_</xsl:text>
			<xsl:apply-templates/>
		<xsl:text>_</xsl:text>
	</xsl:template>

		<!-- Lists -->
	<xsl:template name='list'>
		<xsl:param name="bullet">
			<xsl:call-template name='bullet1'/>
		</xsl:param>
		<xsl:choose>
			<xsl:when test='./*[name()=name(current())]'>
				<xsl:value-of select='$bullet' />
				<xsl:apply-templates select='./title'/>
				<xsl:text>&#10;</xsl:text>
				<xsl:apply-templates select='./*[name()=name(current())]'>
					<xsl:with-param name="bullet">
						<xsl:call-template name='indent' />
						<xsl:value-of select='$bullet' />
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select='./item' mode='list'>
					<xsl:with-param name="bullet">
						<xsl:call-template name='indent' />
						<xsl:value-of select='$bullet' />
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test='./title'>
				<xsl:value-of select='$bullet' />
					<xsl:apply-templates select='./title' />
					<xsl:call-template name='colon-space' />
					<xsl:apply-templates select='./item' mode='collapsed' />
				<xsl:text>&#10;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select='./item' mode='list'>
					<xsl:with-param name="bullet">
						<xsl:value-of select='$bullet' />
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='list-item'>
		<xsl:param name="bullet">
			<xsl:call-template name='bullet1'/>
		</xsl:param>
		<xsl:value-of select='$bullet' />
			<xsl:apply-templates />
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match='item' mode='list'>
		<xsl:param name="bullet">
			<xsl:call-template name='bullet1'/>
		</xsl:param>
		<xsl:call-template name='list-item'>
			<xsl:with-param name="bullet">
				<xsl:value-of select='$bullet' />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match='item' mode='collapsed'>
		<xsl:call-template name='comma-list' />
	</xsl:template>

	<xsl:template name='bullet1'>
		<xsl:text>-&#9;</xsl:text>
	</xsl:template>

	<xsl:template name='indent'>
		<xsl:text>&#9;</xsl:text>
	</xsl:template>
	
		<!-- Header -->
	<xsl:template name='header-contact'>
		<xsl:text>&#9733;</xsl:text>
		<xsl:text> </xsl:text>
		<xsl:value-of select='/cv/data/url[@type="homepage"]' />
		<xsl:text>&#8195;</xsl:text>
		<xsl:text>&#9993;</xsl:text>
		<xsl:text> </xsl:text>
		<xsl:value-of select='/cv/data/email[@type="home"]' />
		<xsl:text>&#8195;</xsl:text>
		<xsl:text>&#9742;</xsl:text>
		<xsl:text> </xsl:text>
		<xsl:value-of select='/cv/data/phone[@type="home"]' />
	</xsl:template>

		<!-- Entity Line -->
	<xsl:template name='entity-line'>
		<xsl:apply-templates select='./entity'/>
		<xsl:text>&#8195;</xsl:text>
		<xsl:call-template name='entity-from-to' />
	</xsl:template>

		<!-- org, pos, activity -->
	<!-- 'pos' mode='collapsed' in common.xml -->

	<xsl:template match='org' mode='collapsed'>
		<xsl:param name="bullet">
			<xsl:call-template name='bullet1'/>
		</xsl:param>
		<xsl:value-of select='$bullet' />
		<xsl:apply-templates select='./name'/>
		<xsl:if test='./pos'>
			<xsl:call-template name='colon-space' />
			<xsl:apply-templates select='./pos' mode='collapsed'/>
		</xsl:if>
		<xsl:text>&#10;</xsl:text>
		<xsl:if test='./activity | ./pos/activity'>
			<xsl:apply-templates select='./activity | ./pos/activity'>
				<xsl:with-param name="bullet">
					<xsl:call-template name='indent' />
					<xsl:value-of select='$bullet' />
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match='org' mode='list'>
		<xsl:param name="bullet">
			<xsl:call-template name='bullet1'/>
		</xsl:param>
		<xsl:value-of select='$bullet' />
		<xsl:apply-templates select='./name'/>
		<xsl:text>&#10;</xsl:text>
		<xsl:if test='./org'>
			<xsl:apply-templates select='./org' mode='list'>
				<xsl:with-param name="bullet">
					<xsl:call-template name='indent' />
					<xsl:value-of select='$bullet' />
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test='./pos'>
			<xsl:apply-templates select='./pos' mode='list'>
				<xsl:with-param name="bullet">
					<xsl:call-template name='indent' />
					<xsl:value-of select='$bullet' />
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
		<xsl:if test='./activity'>
			<xsl:apply-templates select='./activity'>
				<xsl:with-param name="bullet">
					<xsl:call-template name='indent' />
					<xsl:value-of select='$bullet' />
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match='pos' mode='list'>
		<xsl:param name="bullet">
			<xsl:call-template name='bullet1'/>
		</xsl:param>
		<xsl:value-of select='$bullet' />
		<xsl:apply-templates select='./name'/>
		<xsl:if test='to'>
			<xsl:text> (</xsl:text>
			<xsl:call-template name='pos-from-to' />
			<xsl:text>)</xsl:text>
		</xsl:if>
		<xsl:text>&#10;</xsl:text>
		<xsl:if test='./activity'>
			<xsl:apply-templates select='./activity'>
				<xsl:with-param name="bullet">
					<xsl:call-template name='indent' />
					<xsl:value-of select='$bullet' />
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsl:template match='org/activity | pos/activity'>
		<xsl:param name="bullet">
			<xsl:call-template name='bullet1'/>
		</xsl:param>
		<xsl:call-template name='list-item'>
			<xsl:with-param name="bullet">
				<xsl:value-of select='$bullet' />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Top Element -->
	<xsl:template match='/cv'>
		<xsl:text>#&#9;</xsl:text><xsl:apply-templates select='/cv/data/name'/><xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:call-template name='header-contact' /><xsl:text>&#10;</xsl:text>
		<xsl:text>___&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select='/cv/data'/>
	</xsl:template>

	<xsl:template match='/cv/data'>
		<xsl:if test='$lang = "en-CA"'>
			<xsl:text>##&#9;Summary of Qualifications&#10;</xsl:text>
			<xsl:text>&#10;</xsl:text>
			<xsl:call-template name='bullet1'/><xsl:text>Item&#10;</xsl:text>
			<xsl:text>&#10;</xsl:text>
			<xsl:text>###&#9;Strengths&#10;</xsl:text>
			<xsl:apply-templates select='/cv/data/strengths'/>
		</xsl:if>

		<xsl:text>##&#9;Education&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select='/cv/data/edu'>
			<xsl:sort select='to' order='descending' />
		</xsl:apply-templates><xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>##&#9;Experience&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select='/cv/data/exp'>
			<xsl:sort select='to' order='descending' />
		</xsl:apply-templates><xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>##&#9;Skills Summary&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select='/cv/data/skills'/><xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>##&#9;Professional Memberships / Activities&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select='/cv/data/org'/><xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:text>##&#9;References&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select='/cv/data/noref'/><xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match='data/strengths'>
		<xsl:call-template name='list'/>
	</xsl:template>

	<!-- Education -->
	<xsl:template match='/cv/data/edu'>
		<xsl:text>###&#9;</xsl:text><xsl:apply-templates select='./degree'/><xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:call-template name='entity-line' /><xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>

		<xsl:if test='./courses|./projects|./org'>
			<xsl:apply-templates select='./courses'/>
			<xsl:if test='./projects'>
				<xsl:call-template name='bullet1'/>
				<xsl:text>__</xsl:text>
					<xsl:text>Projects</xsl:text>
				<xsl:text>__</xsl:text>
				<xsl:text>&#10;</xsl:text>
				<xsl:apply-templates select='./projects'>
					<xsl:with-param name="bullet">
						<xsl:call-template name='indent'/>
						<xsl:call-template name='bullet1'/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
			<xsl:if test='./org'>
				<xsl:call-template name='bullet1'/>
				<xsl:text>__</xsl:text>
					<xsl:text>Activities</xsl:text>
				<xsl:text>__</xsl:text>
				<xsl:text>&#10;</xsl:text>
				<xsl:apply-templates select='./org' mode='collapsed'>
					<xsl:with-param name="bullet">
						<xsl:call-template name='indent'/>
						<xsl:call-template name='bullet1'/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match='edu/degree'>
		<xsl:choose>
			<xsl:when test='../degree/minor' >
				<xsl:apply-templates select='./*[not(self::minor)]'/>
				<xsl:for-each select='./minor'>
					<xsl:text>, minor in </xsl:text><xsl:value-of select='.' />
				</xsl:for-each>
				<xsl:if test='position() != last()'><xsl:text>;&lt;br /&gt;</xsl:text></xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select='./*'/>
				<xsl:if test='position() != last()'><xsl:text>,&lt;br /&gt;</xsl:text></xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match='edu//courses | edu//projects'>
		<xsl:param name="bullet">
			<xsl:call-template name='bullet1'/>
		</xsl:param>
		<xsl:call-template name='list'>
			<xsl:with-param name="bullet">
				<xsl:value-of select='$bullet'/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match='edu//courses/title | edu//org/name'>
		<xsl:text>__</xsl:text>
			<xsl:apply-templates />
		<xsl:text>__</xsl:text>
	</xsl:template>

	<xsl:template match='edu//projects/title'>
		<xsl:text>_</xsl:text>
			<xsl:apply-templates />
		<xsl:text>_</xsl:text>
	</xsl:template>

	<!-- Experience -->
	<xsl:template match='/cv/data/exp'>
		<xsl:text>###&#9;</xsl:text><xsl:value-of select='./title' /><xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>

		<xsl:call-template name='entity-line' /><xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:apply-templates select='./details[@type="achievement"]'/>
		<xsl:apply-templates select='./details[@type="duty"]'/>
		<xsl:text>&#10;</xsl:text>
	</xsl:template>

	<xsl:template match='exp//details'>
		<xsl:call-template name='list' />
	</xsl:template>

	<!-- Skills -->
	<xsl:template match='data//skills'>
		<xsl:param name="bullet">
			<xsl:call-template name='bullet1'/>
		</xsl:param>
		<xsl:call-template name='list'>
			<xsl:with-param name="bullet">
				<xsl:value-of select='$bullet'/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match='data//skills/title'>
		<xsl:text>__</xsl:text>
			<xsl:apply-templates />
		<xsl:text>__</xsl:text>
	</xsl:template>

	<!-- Org -->
	<xsl:template match='/cv/data/org'>
		<xsl:text>###&#9;</xsl:text><xsl:apply-templates select='./name'/><xsl:text>&#10;</xsl:text>
		<xsl:text>&#10;</xsl:text>
		<xsl:if test='./org'>
			<xsl:apply-templates select='./org' mode='list'/>
		</xsl:if>
		<xsl:if test='./pos'>
			<xsl:apply-templates select='./pos' mode='list'/>
		</xsl:if>
		<xsl:if test='./activity'>
			<xsl:apply-templates select='./activity' mode='list'/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
