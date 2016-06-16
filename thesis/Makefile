FLAGS=--number-sections \
			--table-of-contents \
			--chapters \
			--standalone \
			--filter pandoc-crossref \
			--filter pandoc-citeproc \
			--tab-stop=2

OUTDIR=build
OUTFILE=$(OUTDIR)/msc-thesis-michal-liszcz.pdf
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

$(OUTFILE): $(HEADER) $(CHAPTERS) $(REFFILE) $(UML_DIAGRAMS) | $(OUTDIR)
	pandoc $(FLAGS) \
		-o $@ \
		$(HEADER) $(CHAPTERS)

$(REFFILE): $(REFERENCES) | $(OUTDIR)
	cat $^ > $@

$(OUTDIR):
	mkdir $@

$(UML_OUTDIR)/%.tex: $(UML_OUTDIR)/%.latex
	mv $< $@

$(UML_OUTDIR)/%.latex : $(UML_SRCDIR)/%.pu
	plantuml -o $(PWD)/$(UML_OUTDIR) -tlatex:nopreamble -nbthread 4 $<

.PHONY: all clean plantuml
