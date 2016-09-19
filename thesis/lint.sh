#!/usr/bin/env bash

sed '/^TODO:/d' "$1" \
  | pandoc --to html --from markdown-footnotes-inline_notes \
  | sed -ne '/^<p>.*<\/p>$/p' \
  | sed 's/\[[0-9a-zA-Z\@\:\^\_\-]*\]//g' \
  | sed -r 's| ?<span class="citation"></span>||g' \
  | lynx -stdin -force_html -dump \
  | languagetool --language en-US --disable WHITESPACE_RULE
