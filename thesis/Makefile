FLAGS=--number-sections \
			--table-of-contents \
			--chapters \
			--standalone \
			--filter pandoc-citeproc

OUTDIR=build
OUTFILE=msc-thesis-michal-liszcz.pdf

all: header.yaml $(OUTDIR)
	pandoc $(FLAGS) \
	-o $(OUTDIR)/$(OUTFILE) \
	$< $(wildcard chapters/*.md)

$(OUTDIR):
	mkdir $@

clean:
	rm -f $(OUTDIR)/*
