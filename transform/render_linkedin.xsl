<?xml version='1.0' encoding='UTF-8'?>
<!--
xml-cv v0.1.0 | LinkedIn helper (HTML) rendering transform
Copyright © 2019, 2021 Boian Berberov

Released under the terms of the
European Union Public License version 1.2 only.

License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-11-12

SPDX-License-Identifier: EUPL-1.2
-->
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	version='1.0'>
	<xsl:import href="common.xsl"/>
	<xsl:output method='html' indent='yes' encoding='UTF-8'/>

	<!-- Common -->

		<!-- Term -->
	<xsl:template match='term'>
		<xsl:apply-templates/>
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
				<br />
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
				<br />
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
		<br />
	</xsl:template>

	<xsl:template match='item' mode='list'>
		<xsl:param name="bullet">
			<xsl:call-template name='bullet1'/>
		</xsl:param>
		<xsl:call-template name='list-item'>
			<xsl:with-param name="bullet"><xsl:value-of select='$bullet' /></xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match='item' mode='collapsed'>
		<xsl:call-template name='comma-list' />
	</xsl:template>

	<xsl:template name='bullet1'>
		<xsl:text>&#9632;</xsl:text>
		<xsl:text>&#8194;</xsl:text>
	</xsl:template>

	<xsl:template name='bullet2'>
		<xsl:text>&#9745;</xsl:text>
		<xsl:text>&#8194;</xsl:text>
	</xsl:template>

	<xsl:template name='bullet3'>
		<xsl:text>&#128100;</xsl:text>
		<xsl:text>&#8194;</xsl:text>
	</xsl:template>

	<xsl:template name='indent'>
		<xsl:text>&#8195;</xsl:text>
		<xsl:text>&#8195;</xsl:text>
	</xsl:template>
	
		<!-- Header -->
	<xsl:template name='header-contact'>
		<span>
			<xsl:text>&#9733;</xsl:text>
		</span>
		<xsl:text> </xsl:text>
		<xsl:value-of select='/cv/data/url[@type="homepage"]' />
		<xsl:text>&#8195;</xsl:text>
		<span>
			<xsl:text>&#9993;</xsl:text>
		</span>
		<xsl:text> </xsl:text>
		<xsl:value-of select='/cv/data/email[@type="home"]' />
		<xsl:text>&#8195;</xsl:text>
		<xsl:text>&#9742;</xsl:text>
		<xsl:text> </xsl:text>
		<xsl:value-of select='/cv/data/phone[@type="home"]' />
	</xsl:template>

		<!-- Entity Line -->
	<xsl:template name='entity-line'>
		<p>
			<xsl:apply-templates select='./entity'/>
			<xsl:text>&#8195;</xsl:text>
			<xsl:call-template name='from-to' />
		</p>
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
		<br />
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
		<br />
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
		<br />
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
		<html>
			<head>
				<meta charset='utf-8' />
				<title>LinkedIn profile data: <xsl:apply-templates select='/cv/data/name'/></title>
				<xsl:copy-of select='document("../style/linkedin_style.xml")' />
			</head>

			<!-- Document -->
			<body>
				<h1>LinkedIn profile data</h1>
				<h2>
					<xsl:apply-templates select='/cv/data/name'/>
				</h2>
				<p>
					<xsl:call-template name='header-contact' />
				</p>
				<xsl:apply-templates select='/cv/data'/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match='/cv/data'>
		<h2>
			<xsl:text>Experience</xsl:text>
		</h2>
		<xsl:apply-templates select='/cv/data/exp'>
			<xsl:sort select='to' order='descending' />
		</xsl:apply-templates>

		<h2>
			<xsl:text>Education</xsl:text>
		</h2>
		<xsl:apply-templates select='/cv/data/edu'>
			<xsl:sort select='to' order='descending' />
		</xsl:apply-templates>

		<h2>
			<xsl:text>Skills &amp; Endorsements</xsl:text>
		</h2>
		<xsl:apply-templates select='/cv/data/skills'/>

		<h2>
			<xsl:text>Accomplishments</xsl:text>
		</h2>
		<h3>
			<xsl:text>Organizations</xsl:text>
		</h3>
		<xsl:apply-templates select='/cv/data/org'/>
	</xsl:template>

	<!-- Education -->
	<xsl:template match='/cv/data/edu'>
		<xsl:for-each select='./degree'>
			<table>
				<tr>
					<th>School:</th>
					<td><xsl:apply-templates select='../entity/name'/></td>
				</tr>
				<tr>
					<th>Degree:</th>
					<td><xsl:apply-templates select='./*[not(self::minor)]' mode='title'/></td>
				</tr>
				<tr>
					<th>Field of study:</th>
					<td><xsl:value-of select='./*[not(self::minor)]' mode='major' /></td>
				</tr>
				<tr>
					<th>From Year:</th>
					<td><xsl:apply-templates select='../from' mode='year' /></td>
				</tr>
				<tr>
					<th>To Year:</th>
					<td><xsl:apply-templates select='../to' mode='year' /></td>
				</tr>
				<tr>
					<th>Grade:</th>
					<td></td>
				</tr>
				<tr>
					<th>Activities and societies:</th>
					<td></td>
				</tr>
				<tr>
					<th>Description:</th>
					<td>
						<xsl:for-each select='./minor'>
							<xsl:apply-templates select='.'/>
							<xsl:choose>
								<xsl:when test='position() != last()'><xsl:text>, </xsl:text></xsl:when>
								<xsl:otherwise><br /></xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						<xsl:choose>
							<xsl:when test='position()=1'>
								<xsl:if test='../projects'>
									<br /><xsl:text>Projects</xsl:text><br />
									<xsl:apply-templates select='../projects'/>
								</xsl:if>
								<xsl:if test='../org'>
									<br /><xsl:text>Activities</xsl:text><br />
									<xsl:apply-templates select='../org' mode='collapsed'/>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>Second degree</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</td>
				</tr>
			</table>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match='edu/projects'>
		<xsl:param name="bullet">
			<xsl:call-template name='bullet1'/>
		</xsl:param>
		<xsl:call-template name='list'>
			<xsl:with-param name="bullet">
				<xsl:value-of select='$bullet'/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Experience -->
	<xsl:template match='/cv/data/exp'>
		<table>
			<tr>
				<th>Title</th>
				<td><xsl:value-of select='./title' /></td>
			</tr>
			<tr>
				<th>Company</th>
				<td><xsl:value-of select='./entity/name' /></td>
			</tr>
			<tr>
				<th>Location</th>
				<td><xsl:apply-templates select='./entity/location' /></td>
			</tr>
			<tr>
				<th>Start Date</th>
				<td><xsl:apply-templates select='./from' mode='full' /></td>
			</tr>
			<tr>
				<th>End Date</th>
				<td><xsl:apply-templates select='./to' mode='full' /></td>
			</tr>
			<tr>
				<th>Description</th>
				<td>
					<xsl:apply-templates select='./details[@type="achievement"]'/>
					<xsl:apply-templates select='./details[@type="duty"]'/>
				</td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match='exp/details[@type="achievement"]'>
		<xsl:param name="bullet">
			<xsl:call-template name='bullet2'/>
		</xsl:param>
		<xsl:call-template name='list'>
			<xsl:with-param name="bullet">
				<xsl:value-of select='$bullet'/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match='exp/details[@type="duty"]'>
		<xsl:param name="bullet">
			<xsl:call-template name='bullet1'/>
		</xsl:param>
		<xsl:call-template name='list'>
			<xsl:with-param name="bullet">
				<xsl:value-of select='$bullet'/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Skills -->
	<xsl:template match='data//skills'>
		<xsl:call-template name='skip'/>
	</xsl:template>

	<xsl:template match='data//skills/title' />

	<xsl:template match='data//skills/item'>
		<div class='box'>
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<!-- Org -->
	<xsl:template match='/cv/data/org'>
		<table>
			<tr>
				<th>Name</th>
				<td><xsl:value-of select='./name'/></td>
			</tr>
			<xsl:if test='.//pos'>
				<tr>
					<th>Position held</th>
					<td><xsl:apply-templates select='.//pos' mode='collapsed' /></td>
				</tr>
			</xsl:if>
			<tr>
				<th>Description</th>
				<td>
					<xsl:if test='./org'>
						<xsl:apply-templates select='./org' mode='list'>
							<xsl:value-of select='$bullet' />
						</xsl:apply-templates>
					</xsl:if>
					<xsl:if test='./pos'>
						<xsl:apply-templates select='./pos' mode='list'>
							<xsl:value-of select='$bullet' />
						</xsl:apply-templates>
					</xsl:if>
					<xsl:if test='./activity'>
						<xsl:apply-templates select='./activity' mode='list'>
							<xsl:value-of select='$bullet' />
						</xsl:apply-templates>
					</xsl:if>
				</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>
