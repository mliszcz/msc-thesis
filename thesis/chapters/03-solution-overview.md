# Solution Overview

Each of the existing solutions presented in previous chapter has some drawbacks.
There is no *best choice* that will suit everyone's needs. **To address these
issues and fulfill goals discussed in [Introduction] chapter, the TangoJS
project has been developed.**

This chapter describes the implemented solution in terms of formulated design
goals and provides a high level overview of the system architecture, including
all related software layers.

## Introducing TangoJS

TangoJS allows to build TANGO client applications using the standard web
front-end technologies like HTML, CSS and Javascript. It is a comprehensive
solution that gives TANGO developers a complete set of tools and APIs. There
is minimal set of dependencies is required.

TangoJS has been designed to be a modular ecosystem - one includes only
required modules and configures everything according to the project
requirements. There are three main layers, which are separated and connected
using well-defined interfaces. This forms overall TangoJS experience.

* **TangoJS Core** - Javascript API for programmatic interactions with TANGO
  from a web browser, partly generated from TANGO IDL;
* **TangoJS Connector** - interface that abstracts-out communication with TANGO
  infrastructure via pluggable backend servers;
* **TangoJS WebComponents** - an extensible widget toolkit for rapid GUI
  applications development, inspired on Taurus;

All these components are described in detail later in this chapter.

## Design Goals and Design Decisions

Apart from general goals formulated in [Introduction], a set of design goals
has been established before TangoJS development has started. These goals aim to
meet the challenges where existing solutions have failed. The goals are mostly
related to technological aspects of implementation.

**Use the latest web standards.**
TODO.

**Make it extensible.**
TODO.

**Learn from the best.**
TODO.

**Reuse what works well.**
TODO.

**Be future-proof.**
TODO.

**Keep it simple to start with.**
One of project goals was to minimize learning curve. TangoJS Core API brings
familiar TANGO abstractions, like *DeviceProxy* to the browser ecosystem.
The widget collection has been inspired by the Taurus framework - the leading
solution for building TANGO clients in Python/Qt. It was designed with ease of
use and ease of deployment in mind. Only basic knowledge of web-development
and Node.js [@tools-nodejs] is required to get started.

**Choose the best language.**
Since TangoJS amis to allow for building TANGO clients that run in web
browsers, it immediately becomes obvious that the whole thing is build with
Javascript (and with HTML, when it comes to the presentation layer). Javascript
is the core language of the Web. Nowadays there are tons of languages that
can be compiled to Javascript, but pure Javascript has been choosen to power
TangoJS. Although every language offers its unique features, they come with
the cost of introducing additional buildstep for the compilation phase,
maintaining sourcemaps, etc. Of course, every web project today requires a
dedicated build process - at least for concatenating and minifying and code.
However, this may not be true in near future, due to the emerging support for
HTTP/2, which is fully multiplexed and can handle parallell transfers over
single TCP connection.

TangoJS has been written using latest standard of Javascript language, called
ECMAScript 2015. It brings a lot of new features and goodness known from e.g.
CoffeeScript. It also works in all modern browsers without need for
transcompilation to ECMAScript 5. The ECMAScript 2015 and its role in TangoJS
is discussed in the next chapter.

**Select a popular platform.**
Node.js has been choosen as a both development and target platform for TangoJS.
In recent days it has become most popular solution for building Javascript
applications, both on server and client side. It is not just an ordinary
Javascript runtime, but a whole ecosystem, with dependency management,
application packagin, support for complex build processes and development
workflows. All components are available in the npm Registry [@tools-npmjs] -
the *de-facto standard* in distributing Javascript dependencies, not only for
Node.js, but also for web browsers.

## TangoJS architecture

The architecture of TangoJS is layered, where next layer builds on previous
one. The architectural diagram is depicted at [@Fig:03-tangojs-architecture].
Below a brief overview of each layer is given.

![TangoJS high-level architecture overview.](
  figures/uml/03-tangojs-architecture.tex){
  #fig:03-tangojs-architecture width=80% }

**TANGO Infrastructure.**
The whole TangoJS stack sits on top of existing TANGO
infrastructure. Since CORBA requires access to the complete TCP/IP stack, TANGO
cannot be accessed directly from the web browser. Some kind of middleman
software is required here. TangoJS addresses this issue by introducing
Connector concept.

**TangoJS Connector.**
A Connector is a bridge between TANGO and TangoJS. Most of the
time there are two separate components in this layer: a serer-side part and
a client-side part. TangoJS specifies only the interface of the client-side
part. How the client communicates with the server is a implementation detail.
TangoJS ships with a mTango connector, which may be paired with mTango RESTful
server.

**TangoJS Core.**
This is a package that brings all the TANGO datatypes, structures,
enums and interfaces to the Javascript world. It has been partly generated
directly from TANGO IDL. The main goal was to maintain consistency with TANGO
Java API, and provide the same set of abstractions with identical interfaces.
It may be used from both Node.js and web browser.

**TangoJS WebComponents.**
This it the largest part of the TangoJS stack. It is a
collection of standalone widgets, which may be included in any web application.
No third-party framework is required. The library offers widgets similar to
Taurus core widgets, but provides means for developing new components.

Any kind of web application can build upon layers described above. As a proof
of concept, a synoptic panel application, which is described later, has been
developed. Each TangoJS layer is described in details in the following
sections.

## TangoJS Core - the TANGO API for browsers

## TangoJS Connector - pluggable backends

## TangoJS WebComponents - HTML widget toolkit

## TangoJS Panel - synoptic panel application
