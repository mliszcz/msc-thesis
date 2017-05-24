FLAGS=--number-sections --standalone --template=template.tex

BUILDDIR=build

%.pdf: %.md $(BUILDDIR)
	pandoc $(FLAGS) -o $(BUILDDIR)/$@ $<

$(BUILDDIR):
	mkdir $@

all: $(patsubst %.md, %.pdf, $(wildcard *.md))

clean:
	rm -rf $(BUILDDIR)
