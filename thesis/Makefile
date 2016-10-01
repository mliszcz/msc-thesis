FLAGS=--number-sections \
			--table-of-contents \
			--chapters \
			--standalone \
			--filter pandoc-crossref \
			--filter pandoc-citeproc \
			--tab-stop=2

OUTDIR=build
PROJECT=msc-thesis-michal-liszcz
OUTFILE=$(OUTDIR)/$(PROJECT).pdf
REFFILE=$(OUTDIR)/references.bib

HEADER=header.yaml
CHAPTERS=$(wildcard chapters/*.md)
REFERENCES=$(wildcard references/*)

UML_OUTDIR=figures/uml
UML_SRCDIR=figures/uml-source
UML_DIAGRAMS= $(patsubst \
	$(UML_SRCDIR)/%.pu, \
	$(UML_OUTDIR)/%.tex, \
	$(wildcard $(UML_SRCDIR)/*.pu))

all: $(OUTFILE)

plantuml: $(UML_DIAGRAMS)

clean:
	rm -f $(OUTDIR)/*
	rm -rf $(UML_OUTDIR)/*

# $(OUTFILE): $(HEADER) $(CHAPTERS) $(REFFILE) $(UML_DIAGRAMS) | $(OUTDIR)
#     pandoc $(FLAGS) \
#         -o $@ \
#         $(HEADER) $(CHAPTERS)

# due to the use of glossaries, unsupported by pandoc,
# pandoc generates only .tex file (with included citations)
# this file is then compiled using standard latex tools

$(OUTDIR)/$(PROJECT).tex: $(HEADER) $(CHAPTERS) $(REFFILE) $(UML_DIAGRAMS) | $(OUTDIR)
	pandoc $(FLAGS) \
		-o $@ \
		$(HEADER) $(CHAPTERS)
	sed -i -r 's/(\s+[a-zA-Z0-9])\s+/\1~/g' $@

$(OUTDIR)/$(PROJECT).pdf: $(OUTDIR)/$(PROJECT).tex
	cd $(OUTDIR); ln -sf ../documentclass
	cd $(OUTDIR); ln -sf ../figures
	cd $(OUTDIR); pdflatex --interaction=batchmode $(PROJECT)
	# cd $(OUTDIR); bibtex $(PROJECT)
	cd $(OUTDIR); makeglossaries -q $(PROJECT)
	cd $(OUTDIR); pdflatex --interaction=batchmode $(PROJECT)
	cd $(OUTDIR); makeglossaries -q $(PROJECT) # rerun for correct page numbering
	cd $(OUTDIR); pdflatex --interaction=batchmode $(PROJECT)
	cd $(OUTDIR); rm documentclass
	cd $(OUTDIR); rm figures

$(REFFILE): $(REFERENCES) | $(OUTDIR)
	cat $^ > $@

$(OUTDIR):
	mkdir $@

$(UML_OUTDIR)/%.tex: $(UML_OUTDIR)/%.latex
	mv $< $@

$(UML_OUTDIR)/%.latex : $(UML_SRCDIR)/%.pu
	plantuml -o $(PWD)/$(UML_OUTDIR) -tlatex:nopreamble -nbthread 4 $<

.PHONY: all clean plantuml
