---
title: Adaptive Web User Interfaces for TANGO Control System
subtitle: |
  MSc thesis\
  PP P5 presentation: status and progress (part 3 - final)
author: |
  Michal Liszcz\
  Supervisor: Wlodzimierz Funika, PhD

date: May, 2016

documentclass: beamer

header-includes:
  - \newcommand{\columnsbegin}{\begin{columns}}
  - \newcommand{\columnsend}{\end{columns}}
  - \graphicspath{{../beamerthemeAGH/}}
  - \usepackage{{../beamerthemeAGH/beamerthemeAGH}}

include-before:
  - \graphicspath{{./}}
---

# Agenda

* Progress evaluation
* Acheivements (1/2)
* Acheivements (2/2)
* Thesis status
* Updated roadmap
* Why this matters
* Summary

---

# Progress evaluation

* Most objectives have been achieved:
    * Development is *almost* done,
    * TangoJS architecture is implemented according to initial design,
    * Everything has been tested against a real device server (`TangoTest`),
* Still few bugs left in the issue tracker,
* Thesis status is dicsussed later.

---

# Acheivements (1/2)

* 5 main subprojects

    * `tangojs-core`
    * `tangojs-connector-local`
    * `tangojs-connector-mtango`
    * `tangojs-web-components`
    * `tangojs-panel`

* 4 available in NPM

* ~3.5k SLOC (excl. comments, blank lines and generated code)

* few minor repositories

* Docker containers - Tango 9, mTango

* a webpage (<https://tangojs.github.io>)

---

# Acheivements (2/2)

*TODO: wstawic obrazek*

# Thesis status

Just a few pages ... written.

...

Expected delivery date - Sept. 2016.

---

# Updated roadmap

* 21-23 Jun. 2016 - 30th Tango Collaboration meeting (Toulouse, FR):
    * make sure TangoJS is stable enough for a public release preview,
    * Solaris team member will make a presentation,
* end of June, July and August - writing actual thesis:
    * compare existing solutions,
    * describe proposed solution (architecture and technical details),
    * discuss different approaches to building web UIs.
* holidays:
    * deploy TangoJS on a server located at Solaris site.

---

# Why this matters

* TangoJS allows you:

    * to quickly design and build UIs,
    * for any device server,
    * using your web-dev skills,
    * and modern web standards.

* Framework-less solution,

* Suitable for any developer.

---

# Summary

* Objectives have been achieved,

* The solution looks promising,

* More testing is required,

* The thesis has to be written.


---

# Thank you
