FLAGS= --standalone

PDF_FLAGS= --to=beamer
HTML_FLAGS= --to=revealjs

OUTDIR=build

pdf: $(patsubst %.md, %.pdf, $(wildcard *.md))
html: $(patsubst %.md, %.html, $(wildcard *.md))

%.pdf: %.md $(OUTDIR)
	pandoc $(FLAGS) $(PDF_FLAGS) -o $(OUTDIR)/$@ $<

%.html: %.md $(OUTDIR)
	pandoc $(FLAGS) $(HTML_FLAGS) -o $(OUTDIR)/$@ $<

$(OUTDIR):
	mkdir $@

clean:
	rm -f $(OUTDIR)/*
