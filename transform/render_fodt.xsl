<?xml version='1.0' encoding='UTF-8'?>
<!--
xml-cv v0.1.0 | OpenDocument (FODT) rendering transform
Copyright © 2018–2019, 2021, 2023–2024 Boian Berberov

Released under the terms of the
European Union Public License version 1.2 only.

License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-11-12

SPDX-License-Identifier: EUPL-1.2
-->
<xsl:stylesheet
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:xs='http://www.w3.org/2001/XMLSchema'
	xmlns:xlink='http://www.w3.org/1999/xlink'

	xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
	xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
	xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"

	xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0"
	xmlns:svg="urn:oasis:names:tc:opendocument:xmlns:svg-compatible:1.0"

	xmlns:loext="urn:org:documentfoundation:names:experimental:office:xmlns:loext:1.0"
	version='1.0'>
	<xsl:import href="common.xsl"/>
	<xsl:output method='xml' indent='no' encoding='UTF-8'/>
	<xsl:strip-space elements='summary'/>
	<xsl:param name='lang'/>

	<!--
		Common
	-->

	<!-- Text style -->
	<xsl:template name='strong'>
		<text:span text:style-name="Strong_20_Emphasis"><xsl:apply-templates/></text:span>
	</xsl:template>

	<xsl:template name='em'>
		<text:span text:style-name="Emphasis"><xsl:apply-templates/></text:span>
	</xsl:template>

	<!-- Lists -->
	<xsl:template name='list-single'>
		<xsl:attribute name='text:style-name'>List_20_1</xsl:attribute>
	</xsl:template>

	<xsl:template name='list-start'>
		<xsl:attribute name='text:style-name'>List_20_1_20_Start</xsl:attribute>
	</xsl:template>

	<xsl:template name='list-continue'>
		<xsl:attribute name='text:style-name'>List_20_1_20_Cont.</xsl:attribute>
	</xsl:template>

	<xsl:template name='list-end'>
		<xsl:attribute name='text:style-name'>List_20_1_20_End</xsl:attribute>
	</xsl:template>

	<xsl:template name='list-order-basic'>
		<xsl:choose>
			<xsl:when test='last() = 1'>
				<xsl:call-template name='list-single'/>
			</xsl:when>
			<xsl:when test='position() = 1'>
				<xsl:call-template name='list-start'/>
			</xsl:when>
			<xsl:when test='position() = last()'>
				<xsl:call-template name='list-end'/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name='list-continue'/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='list-order'>
		<xsl:choose>
			<xsl:when test='
				boolean(ancestor-or-self::*[name() = name(current())]/following-sibling::*[name() = name(current())])
				and
				boolean(ancestor-or-self::*[name() = name(current())]/preceding-sibling::*[name() = name(current())])
			'>
				<xsl:call-template name='list-continue'/>
			</xsl:when>
			<xsl:when test='
				boolean(ancestor-or-self::*[name() = name(current())]/following-sibling::*[name() = name(current())])
			'>
				<xsl:choose>
					<xsl:when test='
						position() = 1
						and
						not(boolean(parent::*[name() = name(current())]))
					'>
						<xsl:call-template name='list-start'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name='list-continue'/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test='
				boolean(ancestor-or-self::*[name() = name(current())]/preceding-sibling::*[name() = name(current())])
			'>
				<xsl:choose>
					<xsl:when test='
						position() = last()
						and
						not(boolean(child::*[name() = name(current())]))
					'>
						<xsl:call-template name='list-end'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name='list-continue'/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name='list-order-basic'/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='list-item-order'>
		<xsl:choose>
			<xsl:when test='
				boolean(ancestor::*[name() = name(current()/..)]/following-sibling::*[name() = name(current()/..)])
				and
				boolean(ancestor::*[name() = name(current()/..)]/preceding-sibling::*[name() = name(current()/..)])
			'>
				<xsl:call-template name='list-continue'/>
			</xsl:when>
			<xsl:when test='
				boolean(ancestor::*[name() = name(current()/..)]/following-sibling::*[name() = name(current()/..)])
			'>
				<xsl:choose>
					<xsl:when test='position() = 1'>
						<xsl:call-template name='list-start'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name='list-continue'/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test='
				boolean(ancestor::*[name() = name(current()/..)]/preceding-sibling::*[name() = name(current()/..)])
			'>
				<xsl:choose>
					<xsl:when test='position() = last()'>
						<xsl:call-template name='list-end'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name='list-continue'/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name='list-order-basic'/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name='list'>
		<xsl:choose>
			<!-- Outline -->
			<xsl:when test='*[ name() = name( current() ) ]'>
				<text:list-item>
					<text:p>
						<xsl:call-template name='list-order'/>
						<xsl:apply-templates select='./title | ./name'/>
					</text:p>
					<text:list>
						<xsl:apply-templates select='./item | ./*[ name() = name( current() ) ]'/>
					</text:list>
				</text:list-item>
			</xsl:when>
			<!-- Named List -->
			<xsl:when test='./title | ./name'>
				<text:list-item>
					<text:p>
						<xsl:call-template name='list-order'/>
						<xsl:apply-templates select='./title | ./name'/>
						<xsl:if test='./item'>
							<xsl:choose>
								<xsl:when test='@list = "true"'>
									<text:list>
										<xsl:apply-templates select='./item'/>
									</text:list>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name='colon-space'/>
									<xsl:apply-templates select='./item' mode='collapsed'/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</text:p>
				</text:list-item>
			</xsl:when>
			<!-- Plain List -->
			<xsl:otherwise>
				<xsl:apply-templates select='./item'/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- `item` -->
	<xsl:template match='/cv/data//item'>
		<text:list-item>
			<text:p>
				<xsl:call-template name='list-item-order'/>
				<xsl:apply-templates/>
			</text:p>
		</text:list-item>
	</xsl:template>

	<xsl:template match='/cv/data//item' mode='collapsed'>
		<xsl:call-template name='comma-list'/>
	</xsl:template>

	<!-- Entity Line, with location and URL -->
	<xsl:template name='entity-line'>
		<text:p text:style-name="Small">
			<xsl:choose>
				<xsl:when test='./entity/url'>
					<text:a xlink:type="simple" text:style-name="Internet_20_link">
						<xsl:attribute name='xlink:href'>
							<xsl:value-of select='./entity/url'/>
						</xsl:attribute>
						<xsl:apply-templates select='./entity'/>
					</text:a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select='./entity'/>
				</xsl:otherwise>
			</xsl:choose>
			<text:tab /><xsl:call-template name='entity-from-to'/>
		</text:p>
	</xsl:template>

	<!-- `summary` -->
	<xsl:template match='/cv/data//summary'>
		<text:p text:style-name="Summary">
			<xsl:apply-templates/>
		</text:p>
	</xsl:template>

	<!-- `details` -->
	<xsl:template match='/cv/data//details'>
		<xsl:call-template name='list'/>
	</xsl:template>

	<!-- `title` -->
	<xsl:template match='/cv/data//details/title | /cv/data//skills/title'>
		<xsl:call-template name='strong'/>
	</xsl:template>

	<!-- `name` and `term` -->
	<xsl:template match='/cv/data//details/name | /cv/data//org/name | /cv/data//term'>
		<xsl:call-template name='em'/>
	</xsl:template>

	<!-- `org`, `pos`, `activity` -->
	<!-- `pos mode='collapsed'` in `common.xml` -->

	<xsl:template match='org'>
		<text:list-item>
			<text:p>
				<xsl:call-template name='list-order'/>
				<xsl:apply-templates select='./name'/>
			</text:p>
			<xsl:if test='./org'>
				<text:list>
					<xsl:apply-templates select='./org'/>
				</text:list>
			</xsl:if>
			<xsl:if test='./pos'>
				<text:list>
					<xsl:apply-templates select='./pos'/>
				</text:list>
			</xsl:if>
			<xsl:if test='./activity'>
				<text:list>
					<xsl:apply-templates select='./activity'/>
				</text:list>
			</xsl:if>
		</text:list-item>
	</xsl:template>

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
			<xsl:if test='./org'>
				<text:list>
					<xsl:apply-templates select='./org' mode='collapsed'/>
				</text:list>
			</xsl:if>
			<xsl:if test='./activity | ./pos/activity'>
				<text:list>
					<xsl:apply-templates select='./activity | ./pos/activity'/>
				</text:list>
			</xsl:if>
		</text:list-item>
	</xsl:template>

	<xsl:template match='pos'>
		<text:list-item>
			<text:p>
				<xsl:choose>
					<xsl:when test='
						( boolean(preceding-sibling::name) and position() != last() )
						or
						( boolean(./activity) and position() != last() )
					'>
						<xsl:call-template name='list-continue'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name='list-item-order'/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates select='./name'/>
				<xsl:if test='to'>
					<text:tab /><xsl:call-template name='pos-from-to'/>
				</xsl:if>
			</text:p>
			<xsl:if test='./activity'>
				<text:list>
					<xsl:apply-templates select='./activity'/>
				</text:list>
			</xsl:if>
		</text:list-item>
	</xsl:template>

	<xsl:template match='org/activity'>
		<text:list-item>
			<text:p>
				<!-- FIXME -->
				<xsl:choose>
					<xsl:when test='
						( boolean(preceding-sibling::name) and position() != last() )
					'>
						<xsl:call-template name='list-continue'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name='list-item-order'/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates/>
			</text:p>
		</text:list-item>
	</xsl:template>

	<xsl:template match='org/pos/activity'>
		<text:list-item>
			<text:p>
				<!-- FIXME -->
				<xsl:choose>
					<xsl:when test='
						( boolean(preceding-sibling::name) and position() != last() )
					'>
						<xsl:call-template name='list-continue'/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name='list-item-order'/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:apply-templates/>
			</text:p>
		</text:list-item>
	</xsl:template>

	<!-- Header contact info email -->
	<xsl:template name='contact-email'>
		<xsl:param name='email'>test@test.test</xsl:param>

		<text:span text:style-name="Icon">
			<xsl:text>&#9993;</xsl:text>
		</text:span>
		<xsl:text> </xsl:text>
		<text:a xlink:type="simple" text:style-name="Internet_20_link">
			<xsl:attribute name='xlink:href'>
				<xsl:text>mailto:</xsl:text>
				<xsl:value-of select='$email'/>
			</xsl:attribute>
			<xsl:value-of select='$email'/>
		</text:a>
	</xsl:template>

	<!-- Header contact info phone -->
	<xsl:template name='contact-phone'>
		<xsl:param name='phone'>555-0128</xsl:param>

		<text:span text:style-name="Icon">
			<xsl:text>&#9742;</xsl:text>
		</text:span>
		<xsl:text> </xsl:text>
		<xsl:value-of select='$phone'/>
	</xsl:template>

	<!-- Header contact info URLs -->
	<xsl:template name='contact-link'>
		<xsl:param name='link'>https://test.test/</xsl:param>

		<text:span text:style-name="Icon">
			<xsl:text>&#9733;</xsl:text>
		</text:span>
		<xsl:text> </xsl:text>
		<text:a xlink:type="simple" text:style-name="Internet_20_link">
			<xsl:attribute name='xlink:href'>
				<xsl:value-of select='$link'/>
			</xsl:attribute>
			<xsl:value-of select='$link'/>
		</text:a>
	</xsl:template>

	<!--
		Document generation
	-->

	<!-- Set up the boilerplate and page headers -->
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

			<!-- Import the styles from a separate document -->
			<xsl:copy-of select='document("../style/fodt_document-styles.xml")/*/*' />

			<!-- Page styles, including Header and Footer -->
			<office:master-styles>

				<!-- Header for every page -->
				<style:master-page style:name="Standard" style:page-layout-name="Page">
					<style:header>
						<text:p text:style-name="Header_20_Default">
							<xsl:apply-templates select='/cv/data/name'/>
							<text:tab />
							<xsl:if test='/cv/data/email[@type="home"]'>
								<xsl:call-template name='contact-email'>
									<xsl:with-param name='email'>
										<xsl:value-of select='/cv/data/email[@type="home"]'/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test='/cv/data/phone[@type="home"]'>
								<xsl:text>&#8195;</xsl:text>
								<xsl:call-template name='contact-phone'>
									<xsl:with-param name='phone'>
										<xsl:value-of select='/cv/data/phone[@type="home"]'/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test='/cv/data/url[@type="homepage"]'>
								<xsl:text>&#8195;</xsl:text>
								<xsl:call-template name='contact-link'>
									<xsl:with-param name='link'>
										<xsl:value-of select='/cv/data/url[@type="homepage"]'/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<text:tab />
							<xsl:text>Page </xsl:text><text:page-number text:select-page="current"/>
						</text:p>
					</style:header>
				</style:master-page>

				<!-- First Page Header-->
				<style:master-page style:name="First_20_Page" style:display-name="First Page"
					style:page-layout-name="Front_20_Page" style:next-style-name="Standard">
					<style:header>
						<text:section text:style-name="FP_Header" text:name="First_Page_Header">
							<text:p text:style-name="Header_20_First_20_Page">
								<text:span text:style-name="Name">
									<xsl:apply-templates select='/cv/data/name'/>
								</text:span>
							</text:p>
							<text:p text:style-name="Header_20_First_20_Page">
								<xsl:if test='/cv/data/email[@type="home"]'>
									<xsl:call-template name='contact-email'>
										<xsl:with-param name='email'>
											<xsl:value-of select='/cv/data/email[@type="home"]'/>
										</xsl:with-param>
									</xsl:call-template>
									<text:tab />
								</xsl:if>
								<xsl:if test='/cv/data/phone[@type="home"]'>
									<xsl:call-template name='contact-phone'>
										<xsl:with-param name='phone'>
											<xsl:value-of select='/cv/data/phone[@type="home"]'/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</text:p>
							<xsl:for-each select='/cv/data/url'>
								<text:p text:style-name="Header_20_First_20_Page">
									<xsl:call-template name='contact-link'>
										<xsl:with-param name="link">
											<xsl:value-of select='.'/>
										</xsl:with-param>
									</xsl:call-template>
								</text:p>
							</xsl:for-each>
						</text:section>
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

	<!-- Structure the resume -->
	<xsl:template match='/cv/data'>
		<xsl:if test='./summary'>
			<text:h text:style-name="Heading_20_1">
				<xsl:text>Summary</xsl:text>
			</text:h>
			<xsl:apply-templates select='./summary'/>
		</xsl:if>

		<xsl:if test='./edu'>
			<text:h text:style-name="Heading_20_1">
				<xsl:text>Education</xsl:text>
			</text:h>
			<!-- Unfinished first -->
			<xsl:apply-templates select='/cv/data/edu[not(to)]'>
				<xsl:sort select='from' order='descending'/>
			</xsl:apply-templates>
			<!-- Finished second -->
			<xsl:apply-templates select='/cv/data/edu[to]'>
				<xsl:sort select='to'   order='descending'/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:if test='./exp'>
			<text:h text:style-name="Heading_20_1">
				<xsl:text>Experience</xsl:text>
			</text:h>
			<!-- Unfinished first -->
			<xsl:apply-templates select='/cv/data/exp[not(to)]'>
				<xsl:sort select='from' order='descending'/>
			</xsl:apply-templates>
			<!-- Finished second -->
			<xsl:apply-templates select='/cv/data/exp[to]'>
				<xsl:sort select='to'   order='descending'/>
			</xsl:apply-templates>
		</xsl:if>

		<xsl:if test='./skills'>
			<text:h text:style-name="Heading_20_1">
				<xsl:text>Additional Skills and Technologies</xsl:text>
			</text:h>
			<xsl:apply-templates select='/cv/data/skills'/>
		</xsl:if>

		<xsl:if test='./org'>
			<text:h text:style-name="Heading_20_1">
				<xsl:text>Professional Memberships and Activities</xsl:text>
			</text:h>
			<xsl:apply-templates select='/cv/data/org'/>
		</xsl:if>

		<xsl:if test='./noref'>
			<text:h text:style-name="Heading_20_1">
				<xsl:text>References</xsl:text>
			</text:h>
			<text:p text:style-name="List_20_1">
				<xsl:apply-templates select='/cv/data/noref'/>
			</text:p>
		</xsl:if>
	</xsl:template>

	<!-- Education -->
	<xsl:template match='/cv/data/edu'>
		<text:h text:style-name="Heading_20_2">
			<xsl:apply-templates select='./degree|./training|./certificate'/>
		</text:h>
		<xsl:call-template name='entity-line' />

		<xsl:if test='./details|./org'>
			<text:list text:style-name="List_20_1">
				<xsl:apply-templates select='./details'/>
				<!-- Special handling of `org` -->
				<xsl:if test='./org'>
					<text:list-item>
						<text:p>
							<xsl:choose>
								<xsl:when test='./details'>
									<xsl:call-template name='list-continue'/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name='list-start'/>
								</xsl:otherwise>
							</xsl:choose>
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

	<xsl:template match='/cv/data/edu/degree'>
		<xsl:choose>
			<xsl:when test='./minor' >
				<xsl:apply-templates select='./*[not(self::minor)]'/>
				<xsl:for-each select='./minor'>
					<xsl:text>, minor in </xsl:text><xsl:value-of select='.' />
				</xsl:for-each>
				<xsl:if test='position() != last()'>
					<xsl:text>;</xsl:text>
					<text:line-break />
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select='./*'/>
				<xsl:if test='position() != last()'>
					<xsl:text>,</xsl:text>
					<text:line-break />
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match='/cv/data/edu/training | /cv/data/edu/certificate'>
		<xsl:apply-templates/>
		<xsl:if test='position() != last()'>
			<xsl:text>,</xsl:text>
			<text:line-break />
		</xsl:if>
	</xsl:template>

	<!-- Experience -->
	<xsl:template match='/cv/data/exp'>
		<text:h text:style-name="Heading_20_2">
			<xsl:value-of select='./title'/>
		</text:h>
		<xsl:call-template name='entity-line'/>

		<xsl:apply-templates select='./summary'/>

		<xsl:if test='./details[@type = "achievement"]'>
			<text:list text:style-name="List_20_2">
				<xsl:apply-templates select='./details[@type="achievement"]'/>
			</text:list>
		</xsl:if>

		<xsl:if test='./details[@type != "achievement"] | ./details[not(@type)]'>
			<text:list text:style-name="List_20_1">
				<xsl:apply-templates select='./details[@type != "achievement"] | ./details[ not(@type) ]'/>
			</text:list>
		</xsl:if>
	</xsl:template>

	<!-- Skills -->
	<xsl:template match='/cv/data/skills'>
		<text:list text:style-name="List_20_1">
			<xsl:call-template name='list'/>
		</text:list>
	</xsl:template>

	<!-- Professional Membership or Activity -->
	<xsl:template match='/cv/data/org'>
		<text:list text:style-name="List_20_1">
			<xsl:apply-templates select='.' mode='collapsed'/>
		</text:list>
	</xsl:template>
</xsl:stylesheet>
