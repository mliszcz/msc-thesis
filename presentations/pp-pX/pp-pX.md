---
title: Adaptive Web User Interfaces for TANGO Control System
subtitle: |
  MSc thesis\
  PP PX presentation: status and progress (part 2)
author: |
  Michal Liszcz\
  Supervisor: Wlodzimierz Funika, PhD

date: Mar, 2016

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

* Thesis status
* Development status
* Project roadmap
* KUKDM'16
* Cooperation with the supervisor
* Cooperation with the client

---

# Thesis status (1)

Notation: **<concept/progress>**

1. Introduction
    1. TANGO Control System **(100% / 0%)**
    1. Web applications **(100% / 0%)**
    1. Adaptive UIs **(100% / 0%)**
    1. Aims and goals **(100% / 0%)**
    1. Objectives **(100% / 0%)**

---

# Thesis status (2)

Notation: **<concept/progress>**

2. State of the Art
    1. mTango **(100% / 0%)**
    1. Taurus Web **(100% / 0%)**
    1. Tango REST **(100% / 0%)**
    1. Summary **(100% / 0%)**

---

# Thesis status (3)

Notation: **<concept/progress>**

3. Solution Overview
    1. Architecture **(100% / 0%)**
    1. TANGO API for browsers **(100% / 0%)**
    1. Pluggable backends **(100% / 0%)**
    1. TANGO widget toolkit **(100% / 0%)**
    1. Synoptic panel application (80% / 0%)**

---

# Thesis status (4)

Notation: **<concept/progress>**

4. Selected Aspects of Implementation
    1. CORBA IDL to Javascript translation **(100% / 0%)**
    1. Web components **(100% / 0%)**
    1. ECMAScript 2015 **(100% / 0%)**
    1. HTML5 and CSS3 **(100% / 0%)**
    1. Other technologies **(100% / 0%)**
    1. Limitations and browser support **(100% / 0%)**

---

# Thesis status (5)

Notation: **<concept/progress>**

5. Results
    1. UI-metrics **(100% / 0%)**
    1. Usability evaluation **(100% / 0%)**
    1. Performance tests **(100% / 0%)**
    1. Deployment at SOLARIS **(100% / 0%)**

---

# Thesis status (6)

Notation: **<concept/progress>**

6. Conclusions
    1. Goals review **(100% / 0%)**
    1. Future work **(100% / 0%)**

---

# Implementation status

* *idl2js* - **done**,
* *tangojs-core* - **done**,
* *tangojs-connector-local* - **done**,
* *tangojs-web-components* - **done**,
* *tangojs-panel* - **WIP** (est. 2 weeks),
* *tangojs-connector-mtango* - **not started** (est. 1 week).

---

# Project roadmap

* end of March:
    * *tangojs-panel* delivery,
    * **deadline** for thesis 2nd Chapter,
* 1st/2nd week of April:
    * integration with mTango,
    * working prototype,
* end of April:
    * deadline for thesis 1st Chapter
* May:
    * Chapters 3 and 4
* June:
    * Chapters 5 and 6
* July, August, September:
    * *unexpected*

---

# KUKDM'16

* unexpected,
* blocking issue (since ~15.02),
* abstract submitted,
* poster prepared.

---

# Cooperation with the supervisor

**Wlodzimierz Funika, PhD**

* frequent email exchange,  
  (in past few weeks mostly due to KUKDM'16),
* no issues nor impediments.

---

# Cooperation with the client

**NSRC SOLARIS**

* periodic status reports / updates,
* granted access to the repositories (notifications on commit).

---

# Thank you
