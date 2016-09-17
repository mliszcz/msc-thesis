#!/usr/bin/env bash

REPLACE_RULES=$(cat <<'END_HEREDOC'
s/middleware/software/g;
s/synchrotron/machine/g;
s/programmatically/grammatically/g;
s/ATKCore/thing/g;
s/API/interface/g;
s/ATKWidget/thing/g;
s/JDraw/thing/g;
s/runtime/run time/g;
s/taurus/Taurus/g;
s/frontend/front end/g;
s/transpilers/compilers/g;
s/npm/manager/g;
s/Javascript/language/g;
s/adaptivity/usability/g;
s/linter/checker/g;
s/Cordova/thing/g;
s/synoptic/control/g;
END_HEREDOC
)

sed '/^TODO:/d' "$1" \
  | sed "$REPLACE_RULES" \
  | pandoc --to html --from markdown-footnotes-inline_notes-citations \
  | lynx -stdin -force_html -dump \
  | languagetool --language en-US --disable WHITESPACE_RULE
