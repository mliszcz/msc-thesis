---
title: Adaptive Web User Interfaces for TANGO Control System
subtitle: |
  MSc thesis\
  SEM 2 presentation: TangoJS introduction
author: |
  Michal Liszcz\
  Supervisor: Wlodzimierz Funika, PhD

date: Jun, 2016

documentclass: beamer

header-includes:
  - \newcommand{\columnsbegin}{\begin{columns}}
  - \newcommand{\columnsend}{\end{columns}}
  - \graphicspath{{../beamerthemeAGH/}}
  - \usepackage{{../beamerthemeAGH/beamerthemeAGH}}
  - \usepackage{listings}

include-before:
  - \graphicspath{{./}}
---

# Agenda

* TANGO Controls - introduction
* Motivation and goals
* State of the Art
* Introducing TangoJS
* TangoJS architecture
    * *core* (API)
    * *mtango-connector* (backend client)
    * *web-components* (widget toolkit)
* *Panel* application
* Security considerations
* Other outcomes
* Summary

---

# TANGO Controls - introduction

* A distributed system for controlling *devices*,

* *Device* is an abstract entity that has:
    * attributes - "fields", parameters (read-only or writable),
    * commands - "methods", actions, that may be invoked,

* Implemented on top of CORBA and ZeroMQ,

* Bindings for C++, Java and Python,

* **GUI libraries based on Swing (ATK) and Qt (Taurus)**.

---

# TANGO Controls - architecture (simplified)

![TANGO Controls architecture overview.](images/tango-cs-archi-simple.png){ width=95% }

---

# Motivation and goals

* Web technologies (HTML, JS, CSS) are extensively used for building modern
  UIs:
    * for web browser,
    * for desktop (Electron -> Atom, Min, ...),
    * for mobile (Apache Cordova),

* Benefits:
    * hundreds of frameworks,
    * thousands of libraries and components,
    * fast prototyping,
    * ease of deployment,

* But it is not possible to create native web-based TANGO clients,

* **Goal: Provide an extensible, standard-based solution for building TANGO
  clients for web browsers**.

---

# State of the Art

* Canone - HTML + PHP + Python (for TANGO access)
    * discontinued in 2007, used by nobody

* Taurus Web - TANGO over WebSockets
    * discontinued proof-of-copcept

* a few more proofs-of-concept, works-in-progress and dead projects

---

# State of the Art (continued)

* mTango (<https://bitbucket.org/hzgwpn/mtango>):
    * actively developed since 2013,
    * RESTful gateway to TANGO (Java servlet),
    * Javascript client,
    * collection of UI components,

* However, the frontend have some drawbacks:
    * uses JavascriptMVC (1.5) (SO Q&A query yields 192 results for
    '*javasciptmvc*' and 176k for '*angularjs*'),
    * uses JsonP (instead of CORS requests),
    * requires Java and Rhino runtime (but everyone wants Node.js),
    * provides just basic widgets
    * it is hard to get started

---

# Introducing TangoJS

* *Modular, extensible, framework-agnostic __frontend__ stack for TANGO
  Controls*,

* Uses modern web standards:
    * Web Components,
    * works with(out) any framework,

* Multiple configuration options:
    * supports mTango in backend,
    * works in Node (API) and browsers (API + widgets),

* Built with Node, available in npm:
    * just grab what you need.

---

# TangoJS architecture

\columnsbegin

\column{.3\textwidth}

\begin{figure}[H]
  \centering
  \includegraphics[width=0.7\textwidth]{images/tangojs-stack.png}
  \caption{TangoJS stack.}
\end{figure}

\column{.7\textwidth}

* Allows for building TANGO client apps using any Javascript-based solution,

* Provides complete set of widgets similar inspired by Taurus library,

* Core API uses structures and entities from TANGO IDL,

* May be configured with any backend:
    * ships with mTango connector.

\columnsend

---

# TangoJS architecture - *core*

* Tango API for Javascript,

* Interface similar to jTango (Tango API for Java),

* Enums, constants and structures generated from TANGO IDL:
    * consistent with whole TANGO ecosystem,

* Backend-agnostic:
    * all calls are passed to the underlying
      connector,
    * ongoing work: communicate directly with TANGO,

* Written in ES2015 - maintainable, clean, modular code,

* Each function returns a Promise - no callback madness.

---

# TangoJS architecture - *mtango-connector*

* Client for the mTango RESTful server,

* Uses Fetch API,

* Requires to configure mTango for CORS.

---

# TangoJS architecture - *web-components*

* Inspired by Taurus library,

* Built with *Web Components*:
    * *Custom Elements*, *HTML Imports*, *Shadow DOM*,
    * Each widget is a self contained entity,
    * Widgets may be loaded on demand,

* Available widgets:
    * `tangojs-label`
    * `tangojs-line-edit`
    * `tangojs-command-button`
    * `tangojs-state-led`
    * `tangojs-trend`
    * `tangojs-form`
        * adapts to bound model
    * `tangojs-device-tree`

---

# TangoJS architecture - *web-components* (continued)

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

# *Panel* application

![*TangoJS Panel* - synoptic panel application built with TangoJS](images/tangojs-panel.png)

---

# Security considerations

* Authentication:
    * handled by the connector
    * *mTango-connector* uses HTTP basic auth
    * authentication filter may be configured for e.g. LDAP

* Authorization:
    * handled by TANGO
    * `TangoAccessControl` device

# Other outcomes and artifacts

* Website: <https://tangojs.github.io>

* API documentation

* *getting-started* application template,

* Docker containers
    * TANGO 9
    * mTango rc2

---

# Summary

* Objectives have been achieved,

* Positive feedback from NSRC Solaris team,

* Presented on KUKDM'16.

---

# Thank you
