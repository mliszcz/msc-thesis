# Installation

## Latex

```
sudo apt-get install texlive
```

## Pandoc

```
cabal install pandoc pandoc-citeproc pandoc-crossref
```

## Plantuml

* <http://plantuml.com/download.html>

### PDF output

Working setup:
* plantuml-8042
* batik-1.7.1
* fop-2.1

*batik-1.8 won't work, org.apache.batik.dom.svg.SVGDOMImplementation is missing*

* <http://plantuml.com/pdf.html>
* <http://ftp.piotrkosoft.net/pub/mirrors/ftp.apache.org/xmlgraphics/batik/binaries/>
* <http://ftp.piotrkosoft.net/pub/mirrors/ftp.apache.org/xmlgraphics/fop/binaries/>

```bash
#!/usr/bin/env bash

PUPATH=~/.local/lib/plantuml

java -cp "$PUPATH/*:$PUPATH/batik-1.7.1/*:$PUPATH/batik-1.7.1/lib/*:$PUPATH/fop-2.1/build/*:$PUPATH/fop-2.1/lib/*" net.sourceforge.plantuml.Run "$@"
```
