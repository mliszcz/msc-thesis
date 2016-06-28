# Solution Overview { #sec:solution-overview }

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

## Design Goals

Apart from general goals formulated in [Introduction], a set of design goals
has been established before TangoJS development has started. These goals aim to
meet the challenges where existing solutions have failed. The goals are mostly
related to technological aspects of implementation.

**Use the latest web standards.**
The Web started to evolve faster and faster in recent years. A lot of
applications has been migrated to the browser. This includes both desktop
mobile applications. The developers are willing to write their software using
web technologies because they can be more productive and target a wider group
of potential users. This forces standardization bodies, like W3C, and browser
vendors to speed up their development cycle. The new standard of ECMAScript
is released once a year. Even before official release it is supported by
browsers. The same applies to HTML5 standard and CSS Level 3 (and above)
modules. These technologies are attractive to developers because they have to
write less code, which is also cleaner and more maintainable. They can put more
focus on their business goals and deliver the high quality project on time.
The developer will then more likely select a framework that is being kept
up-to-date with latest web standards. 

**Make it extensible.**
Today's libraries are easy to extend when necessary. Developers often chose a
modular, pluggable architecture for their frameworks and libraries. This brings
significant benefits for both library authors and users. A modular project is
easier to maintain, especially when it becomes larger than a few files of a
proof of concept. Dividing library into modules can bring better separation
of concerns, at higher level of abstraction. Also, library users can benefit
from a pluggable project. They can include only required parts in their projects.
This allow for reducing the dependencies, which is a crucial aspect of web
development. When a single module does not meet their requirements, they can
develop their own, and use it like a plugin. In case of TangoJS, this may be
developing a *Connector* for new backend server or creating a new widget that
will integrate neatly with the rest of *TangoJS Web Components* module.

**Learn from the best.**
Some of existing web-based TANGO solutions provide configurable widgets that
may be used as a building blocks for larger graphical client applications,
like *synoptic panels*. The leading solution for desktop TANGO clients, the
Taurus framework, offers a broad collection of widgets. These widgets may
be used programmatically or may be interactively put on panels via a simple
drag-and-drop. The goal in TangoJS development was to deliver a set of
widgets most commonly used in Taurus, like *label*, *line edit* or *trend*.
The widgets shall be accessible programmatically from Javascript,
declaratively from a HTML page and interactively, using a dedicated application
for rapid GUI development. In all ways, the user should be able to tweak the
widget's appearance, e.g. hiding some optional parts. It should be also
possible to change some parameters related to the internal details, e.g.
polling period.

**Reuse what works well.**
In the software development field it is crucial to avoid *reinventing the
wheel*. The evaluation of existing solutions showed that there are usually at
least two layers - the backend and the frontend. The frontend part directly
impacts user experience. The backend is never exposed to the end user nor
to the GUI application developer. Instead, the frontend layer is responsible
for interactions with the backend. The most complete solution for TANGO and
browser integration is mTango. The mTango does it's job well on the server side.
However, it's frontend part has some drawbacks, which are, due to the design
decisions, impossible to overcome withour rewriting it from a scratch.
**TangoJS will use *mTango* as a default backend**, leaving developers option
to easily replace it with another backend of their choice.

**Be future-proof.**
When starting a new software project, one should focus not only on current
requirements, but think about project's future. It is important that project
should age slowly. When unmaintained or unpoplar third party solutions are
incorporated, it may soon turn out that project uses deprecated software.
It may be impossible to remove these dependencies later and the project has
to be abandoned. The goal in TangoJS development is to **not include any third
party code** and use **latest web standards**, like HTML5, CSS Level 3
modules or ECMAScript 2015/16. The standard solutions rarely become deprecated.
Instead they evolve gradually, which makes easy to keep the project up-to-date.

**Keep it simple to start with.**
One of project goals was to minimize learning curve. TangoJS Core API brings
familiar TANGO abstractions, like *DeviceProxy* to the browser ecosystem.
The widget collection has been inspired by the Taurus framework - the leading
solution for building TANGO clients in Python/Qt. It was designed with ease of
use and ease of deployment in mind. Only basic knowledge of web-development
and Node.js [@tools-nodejs] is required to get started.

**Consider security aspects.**
Each application, especially one that performs network communication, has to
secure sensible data and prevent unwanted access. In case of TangoJS this is
the job for the *Connector* and corresponding backend server. For instance,
mTango server may use roles defined in servlet container. It also integrates
with TangoAccessControl. The authentication in the server is performed using
HTTP Basic Auth, which is simple and secure way of providing user credentials.
The link between the *Connector* and the server may be secured by using
**encrypted HTTPS protocol**. This has not impact on development and should
be handled during deployment.

## Design Decisions

Also, some more technical design decisions have been mage regarding the
language of choice and development platform.

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

The architecture of TangoJS is layered, where next layer builds on the previous
one. Application developer will interact mostly with the topmost layer, the
*TangoJS WebComponents* module. When programmatic access to TANGO API is
required, one may use *TangoJS Core*. *TangoJS Connector* implementations are
used only by the core layer and are not exposed directly to the developer. The
backend server is not a part of TangoJS. Any backend may be used to access
TANGO infrastructure, provided that a dedicated *Conenctor* is available.
TangoJS ships with two default connectors: an in-memory *mock connector* and
a **mTango connector** which allows to use mTango as a backend for TangoJS.
The architectural diagram is depicted at [@Fig:03-tangojs-architecture-simple].
Below a brief overview of each layer is given.

![TangoJS high-level architecture overview.](
  figures/uml/03-tangojs-architecture-simple.tex){
  #fig:03-tangojs-architecture-simple width=90% }

**TANGO Infrastructure.**
The whole TangoJS stack sits on top of existing TANGO
infrastructure. Since CORBA requires access to the complete TCP/IP stack, TANGO
cannot be accessed directly from the web browser. Some kind of middleman
software is required here. TangoJS addresses this issue by introducing the
*Connector* concept.

**TangoJS Connector.**
A Connector is a bridge between TANGO and TangoJS. Most of the
time there are two separate components in this layer: a serer-side part and
a client-side part. TangoJS specifies only the interface of the client-side
part. How the client communicates with the server is an implementation detail.
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

More detailed view on TangoJS architecture is shown at
[@Fig:03-tangojs-architecture]. The topmost module, *TangoJS WebComponents*,
offers a set of widgets and an API for creating own widgets. All this is
avaliable for the application code. Application developer also have access
to *TangoJS Core API*, when direct access to raw TANGO proxies is required.
This API forwards all calls (after some preprocessing) to the *Connector* layer,
which is then responsible for making the requests to the backend and collecting
the responses. 

![TangoJS component-level architecture.](
  figures/uml/03-tangojs-architecture.tex){
  #fig:03-tangojs-architecture width=90% }

Any kind of web application can build upon layers described above. As a proof
of concept, **a synoptic panel application has been developed**. This
application is described later in this chapter. Each TangoJS layer is covered
in details in the following sections.

## TangoJS Core - the TANGO API for browsers

The main part of the TangoJS, the *TangoJS Core*, is a library for programmatic
access to TANGO APIs. This library __gives user access to concepts like
*DeviceProxy*__, a client side representation of a *device server*, typically
used in client applications in TANGO world. This module also **contains all
structures, enums, typedefs and interfaces defined by the TANGO IDL**.

**General assumptions.**
The goal of this layer is to provide a well-defined, convenient set of
classes that hide the lower layers of the TangoJS stack, like *Connector* or
backend. This is a object-oriented API, similar to jTango, the standard TANGO
Java API. This makes the TANGO developers immediately familiar with it. The
API is nonblocking, due to the asynchronous nature of Javascript. It
extensively uses *Promises*, which means that every method call returns
immediately a standard *Promise* object. This promise may be later resolved
to a value or may be rejected in error case. Use of promises may save the user
from the situations like *calback hell*[^03-callback-hell].

[^03-callback-hell]: <http://callbackhell.com/>

**Module structure.**
The *TangoJS Core* **is distributed as an UMD module** [^03-umd-module]. This
makes it easy to load it in diffrent environments, like Node.js or web browser.
When loaded in browser, it is attached to the global object `tangojs.core`. The
module is internally divided into two packages: the `api` and `tango`. The
`api` package contains TANGO proxies as well as information classes for
*Device*, *Attribute* and *Command* entities. The `tango` package has been
generated from the TANGO IDL and provides common TANGO data types.
Event-related APIs are not available, since **events are not currently
supported**.

[^03-umd-module]: <https://github.com/umdjs/umd>

![*TangoJS Core* package class diagram.](
  figures/uml/03-tangojs-internal-core.tex){
  #fig:03-tangojs-internal-core width=100% }

## TangoJS Connector - pluggable backends

The *Connector* concept allows the TangoJS to support multiple backends. A
*Connector* is an implementation of the *Connector* interface from the *TangoJS
Core* module. The dependencies between the core and the connector are depicted
on [@Fig:03-tangojs-internal-connector].

![Dependency between the *TangoJS Core* and the *Connector*.](
  figures/uml/03-tangojs-internal-connector.tex){
  #fig:03-tangojs-internal-connector width=60% }

A concrete **connector implementation has to be plugged into TangoJS**, before
it may be used. This process is shown at [@Lst:03-connector-setup].
There is always only one connector active. The upper layer, which is *TangoJS
Core*, forwards most calls to this connector and awaits for the results. Since
the core knows nothing about the backend used, it cannot perform any caching
or optimizations. This has to be handled at a connector level.

```{#lst:03-connector-setup .javascript}
// this has to be done before using the TangoJS:
const connector = new CustomConnectorImpl( /* configuration */ )
tangojs.core.setConnector(connector)

// now TangoJS will work using this connector
const deviceProxy = new tangojs.core.api.DeviceProxy('sys/tg_test/1')
```
Listing: Connector setup process.

**mTango connector.**
The mTango has been choosen as a default backend for TangoJS. A connector for
the *mTangoREST server* is a simple client that consumes RESTful API exposed by
the mTango server. In most cases TangoJS will be deployed on a diffrent server
than the mTango. *TangoJS mTango Connector* supports this setup, with proper
**implementation of CORS protocol**. The mTango's servlet container has to be
configured for CORS support. Most containers provide suitable servlet filter
that may be included in the filter chain.
mTango also supports user authorization. Since this is handled completely by
the server, there is no concept of user in TangoJS APIs. The only part aware
of this is the connector. User credentials have to be passed upon connector
instantiation. It's the application developer responsibility to secure these
credentials and re-instantiate connector when user identity changes.

**In-memory mock connector.**
TangoJS ships with a mocked connector implementation, which mimics real TANGO
infrastructure with in-memory hierarchy of objects. There is no network
communication performed. This approach is useful for e.g. automated testing
the upper layers. This connector is flexible and may be configured with a list
of *device* objects, where each device exposes some attributes and commands.

## TangoJS WebComponents - HTML widget toolkit {#sec:solution-tangojs-webcomponents}

The most important part of TangoJS, from end user's perspective, is the widget
toolkit. This module sits on top of core layer in TangoJS stack. It contains
a set of customizable widgets and provides utilities for easily building own
widgets. 

**Module structure.**
This module is designed for in browser use only. The widgets are packed as a
separate HTML files and may be included on demand. The module also exports the
`tangojs.web` package, which contains mixins and utility functions useful for
creating non-standard widgets. This is covered in details in
[@Sec:widget-development].

**Widget concept.**
A widget is a self-contained piece of UI, that may be used on its own and
requires zero configuration. The widget is a graphical representation of a
*model*. A model is an abstraction that may be a *device*, a device's
*attribute* or a *command*. Two examples are a device status indicator widget
and a edit field for a value of an attribute. Some widgets, e.g. a trend
widget, may be bound to a multiple models. A widget may only interact with
it's corresponding models. It is isolated from the rest of the TANGO
environment and independent from the application that it is embedded in.
To acheive these goals, TangoJS widget toolkit module has been developed
using the latest set of W3C standards, including *Custom Elements*, *HTML
Imports*, *HTML Templates* and *Shadow DOM*. These standards together are
called *Web Components*. From the developer point of view, this widgets
behave like native web controls, e.g. *input* or *button*.

**Using TangoJS widgets.**
The developer should be able to include desired widgets in his application.
He may then optionally configure these widgets to match his requirements.
The widgets may be instantiated and configured in two ways. The first way
is via standard DOM manipulation APIs available in Javascript, like the
`document.createElement` function. This is shown at
[@Lst:03-widget-instantiation-js]. Apart from imperative access, there is
also a way to create widgets declaratively, by simply putting desired tag
in HTML markup. This is shown at [@Lst:03-widget-instantiation-html].

```{ #lst:03-widget-instantiation-js .javascript }
const lineEdit = document.createElement('tangojs-line-edit')

lineEdit.setAttribute('model', 'sys/tg_test/1/long_scalar_w')
lineEdit.pollPeriod = 1000 // attributes have reflected properties
lineEdit.showName = true
lineEdit.showQuality = true
```
Listing: Imperative widget instantiation from Javascript code.

```{ #lst:03-widget-instantiation-html .html }
<tangojs-trend
  model="sys/tg_test/1/long_scalar_w,sys/tg_test/1/double_scalar"
  poll-period="1000"
  data-limit="20">
</tangojs-trend>
```
Listing: Declarative widget instantiation from HTML markup.

**Available widgets.**
The *TangoJS Web Components* is highly influenced by the Taurus library. The
initial goal was to bring the most commonly used widgets to the browser. The
widgets offer layout and appearance similar to their counterparts from Taurus.
The avaliable widgets are depicted at [@Fig:03-tangojs-widgets-all].
Below, each widget is provided with a short description:

\begin{figure}
  \centering
  \begin{subfigure}[b]{0.80\textwidth}
    \includegraphics[width=\textwidth]{figures/images/03-tangojs-widgets-label}
    \caption{\texttt{tangojs-label}}
  \end{subfigure}
  \quad
  \par\bigskip\par\bigskip
  \begin{subfigure}[b]{0.80\textwidth}
    \includegraphics[width=\textwidth]{figures/images/03-tangojs-widgets-line-edit-bool}
    \caption{\texttt{tangojs-line-edit}}
  \end{subfigure}
  \quad
  \par\bigskip\par\bigskip
  \begin{subfigure}[b]{0.80\textwidth}
    \includegraphics[width=\textwidth]{figures/images/03-tangojs-widgets-state-led}
    \caption{\texttt{tangojs-state-led}}
  \end{subfigure}
  \quad
  \par\bigskip\par\bigskip
  \begin{subfigure}[b]{0.80\textwidth}
    \includegraphics[width=\textwidth]{figures/images/03-tangojs-widgets-command-button}
    \caption{\texttt{tangojs-command-button}}
  \end{subfigure}
  \quad
  \par\bigskip\par\bigskip
  \begin{subfigure}[b]{0.30\textwidth}
    \includegraphics[width=\textwidth]{figures/images/03-tangojs-widgets-device-tree}
    \caption{\texttt{tangojs-device-tree}}
  \end{subfigure}
  \quad
  \begin{subfigure}[b]{0.50\textwidth}
    \includegraphics[width=\textwidth]{figures/images/03-tangojs-widgets-trend}
    \caption{\texttt{tangojs-trend}}
  \end{subfigure}
  \quad
  \par\bigskip\par\bigskip
  \begin{subfigure}[b]{0.80\textwidth}
    \includegraphics[width=\textwidth]{figures/images/03-tangojs-widgets-form}
    \caption{\texttt{tangojs-form}}
  \end{subfigure}
  \caption{TangoJS widgets.}
  \label{fig:03-tangojs-widgets-all}
\end{figure}

* `tangojs-label` - displays name, value, unit and status of a *read-only*
  attribute;
* `tangojs-line-edit` - displays name, value, unit, status and edit box of a
  *writable* attribute. Depending on attribute type, the edit box may be a
  text field, a spinner or a checkbox;
* `tangojs-state-led` - displays name, state and status of a device;
* `tangojs-command-button` - when pressed, executes a command. Fires a DOM
  event when result becomes available;
* `tangojs-device-tree` - displays all devices defined in TANGO database. This
  is the only widget that is not bind to any model;
* `tangojs-trend` - displays values of multiple attributes in time domain;
* `tangojs-form` - displays a group of widgets for multiple models. Best
  matching widget is choosen for each model;

## TangoJS Panel - synoptic panel application

It is not always necessary to build a dedicated GUI application for given set
of hardware components. There are tools like Taurus, which supports creating
GUIs interactively, by placing widgets on a panels. This process may be
performed by the hardware operator, to **adapt the GUI to the current
requirements** and **display only relevant information**. TangoJS also supports
this scenario, through a web application called *TangoJS Panel*. This
application also shows that TangoJS may be successfuly used for building
complete and non-trivial web applications.

*TangoJS Panel* is a framework-less solution, that also uses *Web Components*
technology to separate it's UI parts. This approach gives the full control over
the DOM and allows for some optimizations. The application is presented at [].

\begin{figure}
  \centering
  \begin{subfigure}[b]{\textwidth}
    \includegraphics[width=\textwidth]{figures/images/03-tangojs-panel-01-fixed}
    \caption{Dashboard with widgets.}
  \end{subfigure}
  \quad
  \par\bigskip\par\bigskip
  \begin{subfigure}[b]{\textwidth}
    \includegraphics[width=\textwidth]{figures/images/03-tangojs-panel-02}
    \caption{\textit{New widget} dialog window.}
  \end{subfigure}
  \caption{\textit{TangoJS Panel} application.}
  \label{fig:03-tangojs-panel}
\end{figure}
