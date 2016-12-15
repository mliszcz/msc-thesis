---
title: Adaptive Web User Interfaces for TANGO Control System
subtitle: |
  MSc thesis defense
author: |
  Michal Liszcz\
  Supervisor: Wlodzimierz Funika, PhD

date: Dec, 2016

documentclass: beamer

header-includes:
  - \newcommand{\columnsbegin}{\begin{columns}}
  - \newcommand{\columnsend}{\end{columns}}
  - \graphicspath{{../beamerthemeAGH/}}
  - \usepackage{{../beamerthemeAGH/beamerthemeAGH}}
  - \usepackage{listings}
  - \usepackage{caption}
  - \captionsetup[figure]{labelformat=empty}
  - \setbeamercolor{frametitle}{fg=AGHred}
  - \setbeamertemplate{itemize item}{\color{AGHgreen}$\blacktriangleright$}
  - \setbeamertemplate{itemize subitem}{\color{AGHblack}\tiny$\blacktriangleright$}
  - \setbeamercolor{itemize/enumerate subbody}{fg=AGHgreen}

include-before:
  - \graphicspath{{./}}
---

# Presentation plan

* TANGO Controls - introduction
* Motivation and goals
* State of the Art
* TangoJS overview
    * *core* (API)
    * *connector* (backend client)
    * *web-components* (widget toolkit)
* *Panel* application
* Summary

---

# TANGO Controls - introduction

* A software toolkit for controlling hardware in distributed environment,

* Built on top of **CORBA** with bindings for C++, Java and Python,

* *Device* in TANGO is represented as a remote object that has:

    * attributes - *fields*, parameters of the device,
    * commands - *methods*, actions that device can perform,

* **GUI libraries based on Swing (ATK) and Qt (Taurus)**.

---

# TANGO Controls - architecture (simplified)

![](images/01-tango-architecture.png){ width=70% }

---

# TANGO Controls - graphical client application (Taurus)

![](images/01-tango-gui-taurus.png)

---

# Motivation and goals

* Web technologies (HTML, JS, CSS) are extensively used for building modern
  GUI applications:
    * for web browser,
    * for desktop (Github Electron),
    * for mobile (Apache Cordova),

* Benefits:
    * hundreds of frameworks,
    * thousands of libraries and reusable components,
    * fast prototyping,
    * ease of deployment,

* But it is not possible to create native web-based TANGO clients,

* **Goal: Provide an extensible, standard-based solution for building TANGO
  clients for web browsers**.

---

# State-of-the-art

* Canone - PHP and Python on server side:
    * limited interaction options, discontinued in 2007,

* Taurus Web - WebSocket gateway for TANGO:
    * almost no frontend code, discontinued proof-of-concept,

* Tango REST RESTful API for TANGO:
    * server written in Java, no frontend code,

* mTango (<https://bitbucket.org/hzgwpn/mtango>):
    * actively developed since 2013,
    * RESTful gateway to TANGO (Java servlet),
    * Javascript client library,
    * collection of UI components,
    * **drawbacks**: dependency on JavascriptMVC and Rhino, use of JsonP,
    no CORS support, just a few basic widgets, requires high effort to get
    started.

---

# TangoJS introduction

* *Modular, extensible, framework-agnostic __frontend__ stack for TANGO
  Controls*,

* Uses modern web standards: ES2015, Web Components, CSS3,

* Works with (or without) any framework,

* Pluggable backends for communication with TANGO (mTango can be used on
  server side),

* Can run in Node.js (API only) and all major browsers (API + widgets),

* Built with Node.js, available in npm, can be easily integrated into existing
  Node.js projects.

---

# TangoJS architecture and modules

![](images/03-tangojs-architecture.png)

---

# TangoJS overview (1/4) - *core* (API)

* Tango API for Javascript,

* Interface similar to jTango (Tango API for Java),

* Enums, constants and structures generated from TANGO IDL:
    * consistent with whole TANGO ecosystem,

* Backend-agnostic:
    * all calls are passed to the underlying
      connector,

* Written with ES2015 - maintainable, clean design, modular code.

---

# TangoJS overview (2/4) - *connector* (backend client)

* A plugin for accessing TANGO infrastructure,

* Integrates browser with TANGO,

* Default connector uses mTango on server side,

    * client is implemented with Fetch API,

    * requires mTango to be configured with CORS support,

* Possible other implementations (e.g. with WebSocket),

* Responsible for user authentication and authorization.

---

# TangoJS overview (3/4) - *web-components*

* A collection of widgets inspired by Taurus library,

* Built with *Web Components*:
    * *Custom Elements*, *HTML Imports*, *Shadow DOM*,
    * each widget is a self contained entity,
    * widgets may be loaded on demand,

* Available widgets:
    * `tangojs-label`
    * `tangojs-line-edit`
    * `tangojs-command-button`
    * `tangojs-state-led`
    * `tangojs-trend`
    * `tangojs-form`
    * `tangojs-device-tree`

---

# TangoJS overview (4/4) - *web-components* (continued)

* Create components declaratively:

```html
<tangojs-trend
  model="sys/tg_test/1/double_scalar"
  poll-period="1000"
  data-limit="20">
</tangojs-trend>
```

* Or using DOM APIs:

```javascript
const le = document.createElement('tangojs-line-edit')
le.setAttribute('model', 'sys/tg_test/1/long_scalar_w')
le.pollPeriod = 1000 // reflected properties
le.showName = true
```

---

# *TangoJS Panel* - synoptic panel build with TangoJS

![](images/tangojs-panel.png)

---

# Summary

* Objectives have been achieved:
    * TangoJS allows for building *adaptive* web-based client applications,
    * widget's layout may be controlled via media queries and adapted to the
      environment,
    * operator may adapt the UI interactively using the TangoJS Panel application,

* Solution is extensible:
    * new widgets may be added in future,
    * new ways of communication with TANGO may be implemented (requires changes
      only in connector),

* Positive feedback from NSRC Solaris and TANGO community,

* Work presented at KUKDM'16 conference.

---

#

## Thank you!
