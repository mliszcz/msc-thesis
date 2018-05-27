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


$(UML_OUTDIR)/%.tex: $(UML_OUTDIR)/%.latex
	mv $< $@

$(UML_OUTDIR)/%.latex : $(UML_SRCDIR)/%.pu
	plantuml -o $(PWD)/$(UML_OUTDIR) -tlatex:nopreamble -nbthread 4 $<

%.tex: %.md
	pandoc $< --to=latex --natbib --no-highlight --tab-stop=2 --listings \
		| sed 's/\\citep/\\cite/g' \
		| sed 's/\\cite{Fig:/\\ref{fig:/g' \
		| sed 's/\\cite{Lst:/\\ref{lst:/g' \
		> $@

%.pdf: %.tex
	latexmk -pdf $<

tangojs-case-study.pdf: tangojs-case-study-sections.tex

all: tangojs-case-study.pdf

plantuml: $(UML_DIAGRAMS)

clean:
	latexmk -C
	rm -f *.bbl *.run.xml
	# rm -rf $(UML_OUTDIR)/*

.PHONY: all clean plantuml
