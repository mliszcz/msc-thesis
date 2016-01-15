---
title: Adaptive Web User Interfaces for TANGO Control System
subtitle: |
  MSc thesis\
  PP P2 presentation: thesis structure
author: |
  Michal Liszcz\
  Supervisor: Wlodzimierz Funika, PhD
date: Jan, 2016

documentclass: beamer

header-includes:
  - \graphicspath{{../beamerthemeAGH/}}
  - \usepackage{{../beamerthemeAGH/beamerthemeAGH}}

include-before:
  - \graphicspath{{./}}

---

# Thesis chapters

The thesis should be divided into following chapters:

1. Introduction
1. State of the art
1. Solution overview
1. Selected aspects of implementation
1. Results
1. Conclusions
1. Acknowledgements

---

# 1. Introduction (1/2)

1. TANGO Control System
     * General introduction
     * Architecture overview
     * GUI Tools and Frameworks
1. Web applications
     * Trends in application development
     * Modern web technologies
1. Adaptive user interfaces
     * Adaptation techniques
1. Aims and goals
1. Objectives

---

# 1. Introduction (2/2)

* Main sections
    1. TANGO Control System
        * general overview, architecture, tooling, ...
    1. Web applications
        * advantages, technologies, trends, ...
    1. User interfaces
        * general trends, UIs role in SCADA systems
    1. Topic formulation / aims
        * what I hope to achieve
    1. Objectives
        * checklist with measurable goals
* 10-15 pages

---

# 2. State of the art

* Evaluate existing solutions. One per section:
    1. mTango
    1. Taurus Web
    1. Tango REST
    1. more stuff here ...
* Show weak and strong points of each solution
* Check what may be reused / integrated
* 7-10 pages

---

# 3. Solution overview

1. Requirements / design goals
1. Proposed solution
1. SW architecture
     * overview of components and dependencies
1. `tangojs` - TANGO API for browsers
1. `tangojs-connectors` - pluggable backends
1. `tangojs-web-components` - TANGO widget toolkit
1. `tangojs-panel` - synoptic panel application for Solaris


* 10-15 pages

---

# 4. Selected aspects of implementation

Noteworthy aspects:

1. CORBA IDL to Javascript translation
1. Web Components - framework-agnostic widgets
1. Benefits of ECMAScript 2015
1. HTML5, CSS3 and beyond
1. Componentization in AngularJS 1.x
1. Other technologies
1. Limitations and browser support


* 10-15 pages

---

# 5. Results
Evaluate solution:

1. UI-metrics
1. Usability evaluation
1. Performance tests (??)
1. Deployment at SOLARIS


* 7-10 pages

---

# 6. Conclusions

1. Goals review
1. Future work:
     * HTIOP (CORBA over HTTP)
     * gRPC (TANGO without CORBA)

* 2-5 pages

---

# Summary

* Chapters:
    1. Introduction [10-15]
    1. State of the art [7-10]
    1. Solution overview [10-15]
    1. Selected aspects of implementation [10-15]
    1. Results [7-10]
    1. Conclusions [2-5]
* 46-70 pages total
* things to remember about:
    * title page, **abstract**, acknowledgements,
      table of contents, table of figures, references ...

---

# Roadmap (1/2)

* ...
* Dec 2015
    * `tangojs-web-components`: development
* Jan 2016
    * `tangojs-panel` mockups; application skeleton
    * writing 2nd chapter (State of the art)
* Feb 2016
    * `tangojs-web-components`: refactoring, charts
    * `tangojs-panel`: implementation (1/2)
    * writing 1st chapter (Introduction)
* Mar 2016
    * `tangojs-panel`: implementation (2/2)
    * writing 3rd chapter (Solution)

---

# Roadmap (2/2)

* Apr 2016
    * writing 3rd chapter (Solution)
    * writing 4th chapter (Implementation aspects)
    * `tangojs-connector-rest`: implementation
* May 2016
    * writing 5th and 6th chapters
    * `tangojs-panel`: testing; minor changes
* Jun 2016
    * safety buffer

---

# Thank you

Your questions?
