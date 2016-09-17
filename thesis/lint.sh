#!/usr/bin/env bash

REPLACE_RULES=$(cat <<'END_HEREDOC'
s/middleware/software/g;
s/synchrotron/machine/g;
s/programmatically/grammatically/g;
s/ATKCore/Thing/g;
s/API/interface/g;
s/ATKWidget/Thing/g;
s/JDraw/Thing/g;
s/runtime/run time/g;
s/taurus/Taurus/g;
s/frontend/front end/g;
s/transpilers/compilers/g;
s/npm/manager/g;
s/Javascript/language/g;
s/adaptivity/usability/g;
s/linter/checker/g;
s/Cordova/Thing/g;
s/synoptic/control/g;
s/Canone/Thing/g;
s/customizable/configurable/g;
s/Httpd/Thing/g;
s/\@Fig/Figure/g;
s/unmaintained/abandoned/g;
s/unmaintainable/ugly/g;
s/templating/styling/g;
s/backend/back end/g;
s/jQuery/Thing/g;
s/Dojo/Thing/g;
s/RESTful/web/g;
s/servlet/thing/g;
s/Restlet/Thing/g;
s/GUI/interface/g;
s/mTango/Thing/g;
s/mTangoREST/Thing/g;
s/jsTangORB/Thing/g;
s/mTangoUI/Thing/g;
s/JBoss/Thing/g;
s/optimizations/upgrades/g;
s/languageMVC/Thing/g;
s/declaratively/instantly/g;
s/mtango:attr/Thing/g;
s/webpage/web page/g;
END_HEREDOC
)

sed '/^TODO:/d' "$1" \
  | sed "$REPLACE_RULES" \
  | pandoc --to html --from markdown-footnotes-inline_notes-citations \
  | lynx -stdin -force_html -dump \
  | languagetool --language en-US --disable WHITESPACE_RULE
