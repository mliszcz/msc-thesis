FLAGS= \
	--verbose \
	--number-sections \
	--standalone \
	--listings \
	--latex-engine=pdflatex \
	--template=template.tex \
	--filter pandoc-crossref \
	--filter pandoc-citeproc \
	--tab-stop=2

UML_OUTDIR=figures/uml
UML_SRCDIR=figures/uml-source
UML_DIAGRAMS= $(patsubst \
	$(UML_SRCDIR)/%.pu, \
	$(UML_OUTDIR)/%.tex, \
	$(wildcard $(UML_SRCDIR)/*.pu))

BUILDDIR=build

%.tex: %.md $(BUILDDIR)
	pandoc $(FLAGS) -o $(BUILDDIR)/$@ $<

%.pdf: %.tex $(BUILDDIR)
	pushd $(BUILDDIR) && latexmk -pdf $< && popd

$(BUILDDIR):
	mkdir $@
	cp -r cai-style $@/
	ln -s cai-style/my10.clo $@/

$(UML_OUTDIR)/%.tex: $(UML_OUTDIR)/%.latex
	mv $< $@

$(UML_OUTDIR)/%.latex : $(UML_SRCDIR)/%.pu
	plantuml -o $(PWD)/$(UML_OUTDIR) -tlatex:nopreamble -nbthread 4 $<

all: tangojs-case-study.pdf

plantuml: $(UML_DIAGRAMS)

clean:
	rm -rf $(BUILDDIR)
	rm -rf $(UML_OUTDIR)/*
