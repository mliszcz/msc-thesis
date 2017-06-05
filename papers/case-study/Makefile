FLAGS= \
	--verbose \
	--number-sections \
	--standalone \
	--latex-engine=pdflatex \
	--template=template.tex \
	--filter pandoc-crossref \
	--filter pandoc-citeproc \
	--tab-stop=2

BUILDDIR=build

%.tex: %.md $(BUILDDIR)
	pandoc $(FLAGS) -o $(BUILDDIR)/$@ $<

%.pdf: %.tex $(BUILDDIR)
	pushd $(BUILDDIR) && latexmk -pdf $< && popd

$(BUILDDIR):
	mkdir $@
	cp -r cai-style $@/
	ln -s cai-style/my10.clo $@/

all: tangojs-case-study.pdf

clean:
	rm -rf $(BUILDDIR)
