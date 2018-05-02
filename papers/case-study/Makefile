FLAGS= \
	--verbose \
	--number-sections \
	--standalone \
	--listings \
	--pdf-engine=pdflatex \
	--filter pandoc-crossref \
	--filter pandoc-citeproc \
	--tab-stop=2

UML_OUTDIR=figures/uml
UML_SRCDIR=figures/uml-source
UML_DIAGRAMS= $(patsubst \
	$(UML_SRCDIR)/%.pu, \
	$(UML_OUTDIR)/%.tex, \
	$(wildcard $(UML_SRCDIR)/*.pu))

# BUILDDIR=build
#
# %.tex: %.md $(BUILDDIR)
#     pandoc $(FLAGS) -o $(BUILDDIR)/$@ $<
#
# %.pdf: %.tex $(BUILDDIR)
#     pushd $(BUILDDIR) && latexmk -pdf $< && popd
#
# $(BUILDDIR):
#     mkdir $@
#     cp -r cai-style $@/
#     ln -s cai-style/my10.clo $@/

$(UML_OUTDIR)/%.tex: $(UML_OUTDIR)/%.latex
	mv $< $@

$(UML_OUTDIR)/%.latex : $(UML_SRCDIR)/%.pu
	plantuml -o $(PWD)/$(UML_OUTDIR) -tlatex:nopreamble -nbthread 4 $<


%.tex: %.md
	pandoc tangojs-case-study.md --to=latex --natbib --no-highlight --tab-stop=2 \
		| sed 's/\\citep/\\cite/g' > tangojs-case-study-sections.tex


%.pdf: %.tex
	latexmk -pdf $<

all: tangojs-case-study.pdf

plantuml: $(UML_DIAGRAMS)

clean:
	latexmk -C
	rm -f *.bbl *.run.xml
	# rm -rf $(BUILDDIR)
	# rm -rf $(UML_OUTDIR)/*

.PHONY: all clean
