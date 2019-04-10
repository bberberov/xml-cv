# xml-cv v0.1.0
# Copyright © 2018–2019 Boian Berberov
#
# Released under the terms of the
# European Union Public License version 1.2 only.
#
# License text: https://joinup.ec.europa.eu/collection/eupl/eupl-text-11-12
#
# SPDX-License-Identifier: EUPL-1.2

.PHONY: step-localize step-flatten step-adapt step-render
.PHONY: fodt md html linkedin terms all clean

LANG:=en-US
YEARS:=10
INPUT_DIR:=in
OUTPUT_DIR:=out

XSLT_PARAMS=--stringparam lang ${LANG}
SOURCES=$(notdir $(wildcard $(INPUT_DIR)/*.xml))

#
# 1. Localization Step
#
L10N_DIR=$(OUTPUT_DIR)/localized
L10N_FILES=$(addprefix $(L10N_DIR)/, $(SOURCES))

$(L10N_DIR):
	mkdir -p $@

# XSLT_PARAMS: lang
$(L10N_DIR)/%.xml:	$(INPUT_DIR)/%.xml transform/localize_xml-lang.xsl | $(L10N_DIR)
	xsltproc $(XSLT_PARAMS) transform/localize_xml-lang.xsl $< \
	| xmllint --format - \
	> $@

step-localize:	$(L10N_FILES)

#
# 2. Flattening
#
FLAT_DIR=$(OUTPUT_DIR)/flattened
FLAT_FILES=$(addprefix $(FLAT_DIR)/, $(SOURCES))

$(FLAT_DIR):
	mkdir -p $@

# Resolving all xlink:href attributes and replicating content
$(FLAT_DIR)/%.xml:	$(L10N_DIR)/%.xml transform/flatten_xlink-href.xsl | $(FLAT_DIR)
	xsltproc transform/flatten_xlink-href.xsl $< \
	| xmllint --format - \
	> $@

step-flatten:	$(FLAT_FILES)

#
# 3. Content adaptation
#
ADAPT_DIR=$(OUTPUT_DIR)/adapted
ADAPTED_SUFFIX=.adapted
GENERIC_SUFFIX=.generic
ADAPTED_NAMES=$(addsuffix $(ADAPTED_SUFFIX).xml, $(basename $(SOURCES)))
GENERIC_NAMES=$(addsuffix $(GENERIC_SUFFIX).xml, $(basename $(SOURCES)))
ADAPT_NAMES=$(ADAPTED_NAMES) $(GENERIC_NAMES)
ADAPTED_FILES=$(addprefix $(ADAPT_DIR)/, $(ADAPTED_NAMES))
GENERIC_FILES=$(addprefix $(ADAPT_DIR)/, $(GENERIC_NAMES))
ADAPT_FILES=$(ADAPTED_FILES) $(GENERIC_FILES)

$(ADAPT_DIR):
	mkdir -p $@

# XSLT_PARAMS: years
$(ADAPT_DIR)/%$(ADAPTED_SUFFIX).xml:	$(FLAT_DIR)/%.xml transform/adapt_adapted.xsl | $(ADAPT_DIR)
	xsltproc $(XSLT_PARAMS) transform/adapt_adapted.xsl $< \
	| xmllint --format - \
	> $@

$(ADAPT_DIR)/%$(GENERIC_SUFFIX).xml:	$(FLAT_DIR)/%.xml transform/adapt_generic.xsl | $(ADAPT_DIR)
	xsltproc transform/adapt_generic.xsl $< \
	| xmllint --format - \
	> $@

step-adapt:	$(ADAPT_FILES)

# 
# 4. Rendering
#
RENDER_DIR=$(OUTPUT_DIR)/final
FODT_FILES=$(addprefix $(RENDER_DIR)/, $(addsuffix .fodt, $(basename $(ADAPT_NAMES))))
HTML_FILES=$(addprefix $(RENDER_DIR)/, $(addsuffix .html, $(basename $(ADAPT_NAMES))))
MD_FILES=$(addprefix $(RENDER_DIR)/, $(addsuffix .md, $(basename $(ADAPT_NAMES))))
LINKEDIN_FILES=$(addprefix $(RENDER_DIR)/, $(addsuffix .linkedin.html, $(basename $(ADAPT_NAMES))))
TERMS_FILES=$(addprefix $(RENDER_DIR)/, $(addsuffix .terms.txt, $(basename $(ADAPT_NAMES))))

$(RENDER_DIR):
	mkdir -p $@

# XSLT_PARAMS: lang
$(RENDER_DIR)/%.fodt:	$(ADAPT_DIR)/%.xml transform/render_fodt.xsl style/fodt_document-styles.xml | $(RENDER_DIR)
	xsltproc $(XSLT_PARAMS) transform/render_fodt.xsl $< \
	| xmllint --format - \
	> $@

# XSLT_PARAMS: lang
$(RENDER_DIR)/%.html:	$(ADAPT_DIR)/%.xml transform/render_html.xsl style/html_style.xml | $(RENDER_DIR)
	xsltproc $(XSLT_PARAMS) transform/render_html.xsl $< \
	> $@

# XSLT_PARAMS: lang
$(RENDER_DIR)/%.md:	$(ADAPT_DIR)/%.xml transform/render_md.xsl | $(RENDER_DIR)
	xsltproc $(XSLT_PARAMS) transform/render_md.xsl $< \
	> $@

$(RENDER_DIR)/%.linkedin.html:	$(ADAPT_DIR)/%.xml transform/render_linkedin.xsl style/linkedin_style.xml | $(RENDER_DIR)
	xsltproc transform/render_linkedin.xsl $< \
	> $@

$(RENDER_DIR)/%.terms.txt:	$(ADAPT_DIR)/%.xml transform/render_term-extract.xsl | $(RENDER_DIR)
	xsltproc transform/render_term-extract.xsl $< \
	| sort \
	| uniq -c \
	| sort -k 1nr,2f \
	> $@

fodt:	$(FODT_FILES)
html:	$(HTML_FILES)
md:	$(MD_FILES)
linkedin:	$(LINKEDIN_FILES)
terms:	$(TERMS_FILES)

all step-render:	fodt html md linkedin terms

clean:
	rm -rf $(OUTPUT_DIR)
