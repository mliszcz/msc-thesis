FLAGS= --standalone --to=beamer

OUTDIR=build

all: $(patsubst %.md, %.pdf, $(wildcard *.md))

%.pdf: %.md $(OUTDIR)
	pandoc $(FLAGS) -o $(OUTDIR)/$@ $<

$(OUTDIR):
	mkdir $@

clean:
	rm -f $(OUTDIR)/*
