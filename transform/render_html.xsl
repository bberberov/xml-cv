<?xml version='1.0' encoding='UTF-8'?>
<!--
xml-cv v0.1.0 | Plain HTML rendering transform
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
	<xsl:output method='html' indent='no' encoding='UTF-8'/>
	<xsl:param name='lang'/>

	<!-- Common -->

		<!-- Term -->
	<xsl:template match='term'>
		<em><xsl:apply-templates/></em>
	</xsl:template>

		<!-- Lists -->
	<xsl:template name='list'>
		<xsl:choose>
			<!-- Outline -->
			<xsl:when test='*[name()=name( current() )]'>
				<li>
					<p>
						<xsl:apply-templates select='./title | ./name'/>
					</p>
					<ul>
						<xsl:apply-templates select='./item | ./*[name()=name( current() )]' mode='list'/>
					</ul>
				</li>
			</xsl:when>
			<!-- Named List -->
			<xsl:when test='./title | ./name'>
				<xsl:choose>
					<xsl:when test='@list = "true"'>
						<li>
							<p>
								<xsl:apply-templates select='./title | ./name'/>
							</p>
							<ul>
								<xsl:apply-templates select='item' mode='list'/>
							</ul>
						</li>
					</xsl:when>
					<xsl:otherwise>
						<li>
							<p>
								<xsl:apply-templates select='./title | ./name'/>
								<xsl:call-template name='colon-space'/>
								<xsl:apply-templates select='./item' mode='collapsed'/>
							</p>
						</li>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<!-- Plain List -->
			<xsl:otherwise>
				<xsl:apply-templates select='./item' mode='list'/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='list-item'>
		<li>
			<p>
				<xsl:apply-templates/>
			</p>
		</li>
	</xsl:template>

	<xsl:template match='item' mode='list'>
		<xsl:call-template name='list-item'/>
	</xsl:template>

	<xsl:template match='item' mode='collapsed'>
		<xsl:call-template name='comma-list'/>
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
		<div class='entity-line'>
			<xsl:apply-templates select='./entity'/>
			<span style='float: right;'>
				<xsl:call-template name='entity-from-to' />
			</span>
		</div>
	</xsl:template>

		<!-- org, pos, activity -->
	<!-- 'pos' mode='collapsed' in common.xml -->

	<xsl:template match='org' mode='collapsed'>
		<li>
			<p>
				<xsl:apply-templates select='./name'/>
				<xsl:if test='./pos'>
					<xsl:call-template name='colon-space' />
					<xsl:apply-templates select='./pos' mode='collapsed'/>
				</xsl:if>
			</p>
			<xsl:if test='./activity | ./pos/activity'>
				<ul>
					<xsl:apply-templates select='./activity | ./pos/activity'/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match='org' mode='list'>
		<li>
			<p>
				<xsl:apply-templates select='./name'/>
			</p>
			<xsl:if test='./pos'>
				<ul>
					<xsl:apply-templates select='./pos' mode='list'/>
				</ul>
			</xsl:if>
			<xsl:if test='./activity'>
				<ul>
					<xsl:apply-templates select='./activity'/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match='pos' mode='list'>
		<li>
			<p>
				<xsl:apply-templates select='./name'/>
				<xsl:if test='to'>
					<span style='float: right;'>
						<xsl:call-template name='pos-from-to' />
					</span>
				</xsl:if>
			</p>
			<xsl:if test='./activity'>
				<ul>
					<xsl:apply-templates select='./activity'/>
				</ul>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match='org/activity | pos/activity'>
		<xsl:call-template name='list-item' />
	</xsl:template>

	<!-- Top Element -->
	<xsl:template match='/cv'>
		<html>
			<head>
				<meta charset='utf-8' />
				<title>Resume: <xsl:apply-templates select='/cv/data/name'/></title>
				<xsl:copy-of select='document("../style/html_style.xml")' />
			</head>

			<!-- Document -->
			<body>
				<header>
					<h1><xsl:apply-templates select='/cv/data/name'/></h1>
					<div class='header-contact'>
					<xsl:call-template name='header-contact' />
					</div>
				</header>
				<xsl:apply-templates select='/cv/data'/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match='/cv/data'>
		<xsl:if test='$lang = "en-CA"'>
			<h1>
				<xsl:text>Summary of Qualifications</xsl:text>
			</h1>

			<ul>
				<li>
					<p>Item</p>
				</li>
			</ul>

			<h2>
				<xsl:text>Strengths</xsl:text>
			</h2>
			<div style='columns:4'>
				<ul>
					<xsl:apply-templates select='/cv/data/strengths'/>
				</ul>
			</div>
		</xsl:if>

		<h1>
			<xsl:text>Education</xsl:text>
		</h1>
		<xsl:apply-templates select='/cv/data/edu'>
			<xsl:sort select='to' order='descending' />
		</xsl:apply-templates>

		<h1>
			<xsl:text>Experience</xsl:text>
		</h1>
		<xsl:apply-templates select='/cv/data/exp'>
			<xsl:sort select='to' order='descending' />
		</xsl:apply-templates>

		<h1>
			<xsl:text>Skills Summary</xsl:text>
		</h1>
		<ul>
			<xsl:apply-templates select='/cv/data/skills'/>
		</ul>

		<h1>
			<xsl:text>Professional Memberships / Activities</xsl:text>
		</h1>
		<div style='columns:2'>
			<xsl:apply-templates select='/cv/data/org'/>
		</div>

		<h1>
			<xsl:text>References</xsl:text>
		</h1>
		<p>
			<xsl:apply-templates select='/cv/data/noref'/>
		</p>
	</xsl:template>

	<xsl:template match='data/strengths'>
		<xsl:call-template name='list'/>
	</xsl:template>

	<!-- Education -->
	<xsl:template match='/cv/data/edu'>
		<h2><xsl:apply-templates select='./degree'/></h2>
		<xsl:call-template name='entity-line' />

		<xsl:if test='./courses|./projects|./org'>
			<ul>
				<xsl:apply-templates select='./courses'/>
				<xsl:if test='./projects'>
					<li>
						<p>
							<strong>
								<xsl:text>Projects</xsl:text>
							</strong>
						</p>
						<ul>
							<xsl:apply-templates select='./projects'/>
						</ul>
					</li>
				</xsl:if>
				<xsl:if test='./org'>
					<li>
						<p>
							<strong>
								<xsl:text>Activities</xsl:text>
							</strong>
						</p>
						<ul>
							<xsl:apply-templates select='./org' mode='collapsed'/>
						</ul>
					</li>
				</xsl:if>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match='edu/degree'>
		<xsl:choose>
			<xsl:when test='../degree/minor' >
				<xsl:apply-templates select='./*[not(self::minor)]'/>
				<xsl:for-each select='./minor'>
					<xsl:text>, minor in </xsl:text><xsl:value-of select='.' />
				</xsl:for-each>
				<xsl:if test='position() != last()'><xsl:text>;</xsl:text><br /></xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select='./*'/>
				<xsl:if test='position() != last()'><xsl:text>,</xsl:text><br /></xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match='edu//courses | edu//projects'>
		<xsl:call-template name='list' />
	</xsl:template>

	<xsl:template match='edu//courses/title | edu//org/name'>
		<strong>
			<xsl:apply-templates />
		</strong>
	</xsl:template>

	<xsl:template match='edu//projects/title'>
		<em>
			<xsl:apply-templates />
		</em>
	</xsl:template>

	<!-- Experience -->
	<xsl:template match='/cv/data/exp'>
		<h2><xsl:value-of select='./title' /></h2>
		<xsl:call-template name='entity-line' />

		<ul>
			<xsl:apply-templates select='./details[@type="achievement"]'/>
		</ul>
		<ul>
			<xsl:apply-templates select='./details[@type="duty"]'/>
		</ul>
	</xsl:template>

	<xsl:template match='exp//details'>
		<xsl:call-template name='list' />
	</xsl:template>

	<!-- Skills -->
	<xsl:template match='data//skills'>
		<xsl:call-template name='list' />
	</xsl:template>

	<xsl:template match='data//skills/title'>
		<strong>
			<xsl:apply-templates />
		</strong>
	</xsl:template>

	<!-- Org -->
	<xsl:template match='/cv/data/org'>
		<h2>
			<xsl:apply-templates select='./name'/>
		</h2>
		<xsl:if test='./org'>
			<ul>
				<xsl:apply-templates select='./org' mode='list'/>
			</ul>
		</xsl:if>
		<xsl:if test='./pos'>
			<ul>
				<xsl:apply-templates select='./pos' mode='list'/>
			</ul>
		</xsl:if>
		<xsl:if test='./activity'>
			<ul>
				<xsl:apply-templates select='./activity' mode='list'/>
			</ul>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
