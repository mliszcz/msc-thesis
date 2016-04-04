FLAGS=--number-sections \
			--table-of-contents \
			--chapters \
			--standalone \
			--filter pandoc-citeproc \
			--tab-stop=2

OUTDIR=build
OUTFILE=$(OUTDIR)/msc-thesis-michal-liszcz.pdf
REFFILE=$(OUTDIR)/references.bib

HEADER=header.yaml
CHAPTERS=$(wildcard chapters/*.md)
REFERENCES=$(wildcard references/*)

all: $(OUTFILE)

$(OUTFILE): $(HEADER) $(CHAPTERS) $(REFFILE) $(OUTDIR)
	pandoc $(FLAGS) \
		-o $@ \
		$(HEADER) $(CHAPTERS)

$(REFFILE): $(OUTDIR)
	cat $(REFERENCES) > $@

$(OUTDIR):
	mkdir $@

clean:
	rm -f $(OUTDIR)/*
