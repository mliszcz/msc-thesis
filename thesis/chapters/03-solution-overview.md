# Solution and Implementation { #sec:solution-overview }

Each of the existing solutions presented in the previous chapter has some
drawbacks. There is no *best choice* that will suit everyone's needs. **To
address these issues and fulfill the goals ~~discussed~~ in [@Sec:introduction],
the TangoJS project has been developed.**

This chapter describes the implemented solution in terms of the formulated
design goals and provides a high level overview of the system architecture,
including all related software layers.

## Introduction to TangoJS

TangoJS allows building TANGO client applications with the standard web
front-end technologies like HTML, CSS and Javascript. It gives TANGO
developers a complete set of tools and APIs required for this task. There is a
minimal set of dependencies is required.

TangoJS has been designed to be a modular ecosystem - one includes only
required modules and configures everything according to the project
requirements. There are three main layers, which are separated and connected
with well-defined interfaces.

* **TangoJS Core** - Javascript API for programmatic interactions with TANGO
  from a web browser, partly generated from TANGO IDL;
* **TangoJS Connector** - interface that abstracts-out communication with TANGO
  infrastructure via pluggable backend servers;
* **TangoJS WebComponents** - an extensible widget toolkit for rapid GUI
  applications development, inspired by Taurus;

All these components are described in detail later in this chapter.

## Design Goals

Apart from the general goals formulated in [@Sec:introduction], a set of design
goals has been established before TangoJS development has started. These goals
aim to meet the challenges where the existing solutions have failed. The goals
are mostly related to the technological aspects of implementation.

**Compliance with the latest web standards.**
The Web started to evolve faster and faster in recent years. A lot of
applications has been migrated to the browser. This includes both desktop
mobile applications. The developers are willing to write their software using
web technologies because they can be more productive and target a wider group
of potential users. This forces standardization bodies, like W3C, and browser
vendors to speed up their development cycle. The new standard of ECMAScript
is released once a year and quickly becomes supported by major web browsers.
The HTML standard and CSS modules are also constantly evolving, including more
and more features.
These technologies are attractive to developers because they have to
write less code, which is also cleaner and more maintainable. They can put more
focus on their business goals and deliver a high quality project on time.
The developer will more likely select a framework that is being kept
up-to-date with the latest web standards.

**Extensibility.**
Today's libraries are easy to extend when necessary. Developers often choose a
modular, pluggable architecture for their frameworks and libraries. This brings
significant benefits for both library authors and users. A modular project is
easier to maintain, especially when it becomes larger than a few files of a
proof of concept. Dividing the library into modules can bring better separation
of concerns, at a higher level of abstraction. Also, library users can benefit
from a pluggable project. They can include only required parts in their
projects. This allow for reducing the dependencies, which is a crucial aspect
of web development. When a single module does not meet their requirements, they
can develop their own one, and use it like a plugin. In case of TangoJS, this
may be developing a *Connector* for a new backend server or creating a new
widget that will integrate neatly with the rest of *TangoJS Web Components*
modules.

**Using well-proven concepts.**
Some of the existing web-based TANGO solutions provide configurable widgets
that can be used as building blocks for larger graphical client applications,
like *synoptic panels*. The leading solution for desktop TANGO clients, the
Taurus framework, offers a broad collection of widgets. These widgets can
be used programmatically or can interactively be put on panels via a simple
drag-and-drop. The goal in TangoJS development was to deliver a set of
widgets most commonly used in Taurus, like *label* (which visualizes single
attribute), *line edit* (which is a writable label) or
*trend* (which visualizes a set of attributes in time domain).
The widgets shall be accessible programmatically from within Javascript,
declaratively from an HTML page and interactively, using a dedicated application
for rapid GUI development. In all ways, the user should be able to tweak the
widget's appearance, e.g. hiding some optional parts. It should also be
possible to change some parameters related to the internal details, e.g.
polling period.

**Reuse of what works well.**
In the software development it is crucial to avoid *reinventing the
wheel*. The evaluation of the existing solutions shows that there are usually
at least two layers - the backend and the frontend. The frontend part directly
impacts user experience. The backend is never exposed to the end user nor
to the GUI application developer. Instead, it is the frontend layer that is
responsible for interactions with the backend. The most complete solution for
TANGO and browser integration is mTango. The mTango does its job very well on
the server side. However, its frontend part has some drawbacks, which are, due
to the design decisions, impossible to be overcome without rewriting it from a
scratch. **TangoJS will use *mTango* as a default backend**, leaving developers
the option to easily replace it with another backend of their choice.

**Being future-proof.**
When starting a new software project, one should focus not only on the current
requirements, but think about the project's future. It is important to ensure
that project ages slowly. When unmaintained or unpopular third party solutions
are incorporated, it may soon turn out that the project uses deprecated
software. It may be impossible to remove these dependencies later and the
project will be destined to be abandoned. The goal in TangoJS development is
to **minimize dependencies on third party code** and use the **latest web
standards**, like HTML5, CSS Level 3 modules or ECMAScript 2016. The standard
solutions rarely become deprecated. Instead, they evolve gradually, which makes
easy to keep the project up-to-date.

**Keeping it simple to start with.**
One of project goals was to minimize the learning curve. TangoJS Core API
brings familiar TANGO abstractions, like *DeviceProxy* to the browser
ecosystem. The widget collection has been inspired by the Taurus framework -
the leading solution for building TANGO clients in Python/Qt. It was designed
with the ease of use and ease of deployment in mind. Only basic knowledge of
web-development and Node.js [@tools-nodejs] is required to get started.

**Considering of security aspects.**
Each application, especially one that involves network communication, has to
secure sensible data and prevent from unwanted access. In case of TangoJS this
is the job for the *Connector* and corresponding backend server. For instance,
mTango server may use the roles defined in the servlet container. It also
integrates with TangoAccessControl. The authentication in the server is
performed using HTTP Basic Auth, which is a simple and secure way of providing
user credentials. The link between the *Connector* and the server may be
secured by using **encrypted HTTPS protocol**. This has not impact on
development and should be handled during deployment.

## Design Decisions

Also, some more technical design decisions have been made regarding the
language of choice and development platform.

**Choice of the best language.**
Since TangoJS aims to allow for building TANGO clients that run in web
browsers, it immediately becomes obvious that the whole thing is going to be
built with Javascript (and with HTML, when it comes to the presentation layer).
Javascript is the core language of the Web. Nowadays there are tons of
languages that can be compiled to Javascript, but we have chosen pure
Javascript to power TangoJS. Although each language offers its unique features,
they come with the cost of introducing additional buildstep for the compilation
phase, maintaining sourcemaps, etc. Of course, every web project today requires
a dedicated build process - at least for concatenating and minifying the code.
However, this may not be true in the near future, due to the emerging support
for HTTP/2, which is fully multiplexed and can handle parallel transfers over
single a TCP connection.

TangoJS has been written using the latest standard of Javascript language,
called ECMAScript 2015. It brings a lot of new features and goodness known
from e.g. CoffeeScript. It also works in all modern browsers without a need for
transcompilation to ECMAScript 5. The ECMAScript 2015 and its role in TangoJS
is discussed in [@Sec:results] and [@Sec:selected-aspects-of-implementation].

**Select a popular platform.**
Node.js has been chosen as both the development and target platform for
TangoJS. In recent days it has become most the popular solution for building
Javascript applications, both on the server and client side. It is not just an
ordinary Javascript runtime, but a whole ecosystem, with dependency management,
application packaging, support for complex build processes and development
workflows. All components are available in the npm Registry [@tools-npmjs] -
the *de-facto standard* in distributing Javascript dependencies, not only for
Node.js, but also for web browsers.

## Architecture of TangoJS

The architecture of TangoJS is layered, where a next layer builds on the
previous one. Application developer will interact mostly with the topmost
layer, the *TangoJS WebComponents* module. When programmatic access to
TANGO API is required, one can use *TangoJS Core*. *TangoJS Connector*
implementations are used only by the core layer and are not exposed directly
to the developer. The backend server is not part of TangoJS. Any backend may
be used to access TANGO infrastructure, provided that a dedicated *Connector*
is available. Currently there are two connectors to choose from: an in-memory
*mock connector* and a **mTango connector** which allows to use mTango as a
backend for TangoJS. The architecture of TangoJS is depicted in
[@Fig:03-tangojs-architecture-simple]. Below we briefly discuss each layer.

![An overview of TangoJS high-level architecture.](
  figures/uml/03-tangojs-architecture-simple.tex){
  #fig:03-tangojs-architecture-simple width=90% }

**TANGO Infrastructure.**
The whole TangoJS stack sits on top of the existing TANGO infrastructure. Since
CORBA requires access to the complete TCP/IP stack, TANGO cannot be accessed
directly from the web browser. Some sort of proxy software is required
here. TangoJS addresses this issue by introducing the *Connector* concept.

**TangoJS Connector.**
A Connector is a bridge between TANGO and TangoJS. Most of the
time there are two separate components in this layer: a server-side part and
a client-side part. TangoJS specifies only the interface of the client-side
part. How the client communicates with the server is an implementation detail
and depends on used backend.

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

![TangoJS component-level architecture.](
  figures/uml/03-tangojs-architecture.tex){
  #fig:03-tangojs-architecture width=80% }

A more detailed view on TangoJS architecture is shown in
[@Fig:03-tangojs-architecture]. The topmost module, *TangoJS WebComponents*,
offers a set of widgets and an API for creating own widgets. Application
developer also have access to *TangoJS Core API*, when direct access to raw
TANGO proxies is required. This API forwards all actions to the *Connector*
layer, which is then responsible for making the requests to the backend and
collecting the responses.

Any kind of web application can build upon the layers described above. As a
proof of concept, **a synoptic panel application has been developed**. This
application is described later in this chapter. The TangoJS layers are covered
in details in the following sections.

## TangoJS Core - the TANGO API for browsers

The main part of the TangoJS, the *TangoJS Core*, is a library for programmatic
access to TANGO APIs. This library __gives the user access to concepts like
*DeviceProxy*__, a client side representation of a *device server*, typically
used in client applications in TANGO world. This module also **contains all the
structures, enums, typedefs and interfaces defined by the TANGO IDL**.

**General assumptions.**
The goal of this layer is to provide a well-defined, convenient set of
classes that hide the lower layers of the TangoJS stack, like *Connector* or
the backend. This is an object-oriented API, similar to jTango, the standard
TANGO Java API. This makes the TANGO developers immediately familiar with it.
The API is nonblocking, due to the asynchronous nature of Javascript. It
extensively uses *Promises*, which means that each method call returns
immediately a standard *Promise* object. This promise may be later resolved
to a value or may be rejected in error case. The use of promises may save the
user from the situations like *calback hell*.

![Class diagram of *TangoJS Core* package.](
  figures/uml/03-tangojs-internal-core.tex){
  #fig:03-tangojs-internal-core width=100% }

**Module structure.**
The *TangoJS Core* **is distributed as an UMD module** [@www-umd]. This
makes it easy to load it in different environments, like Node.js or web browser.
When loaded in the browser, it is attached to the global object `tangojs.core`.
The module is internally divided into two packages: the `api` and `tango`. The
`api` package contains TANGO proxies as well as information classes for
*Device*, *Attribute* and *Command* entities. The `tango` package has been
generated from the TANGO IDL and provides the common TANGO data types.
Event-related APIs are unavailable, since **events are not currently
supported**. A class diagram of this module is presented in
[@Fig:03-tangojs-internal-core].

## TangoJS Connector - pluggable backends

The *Connector* concept allows the TangoJS to support multiple backends. A
*Connector* is an implementation of the *Connector* interface from the *TangoJS
Core* module. The dependencies between the core and the connector are depicted
in [@Fig:03-tangojs-internal-connector].

![Dependency between the *TangoJS Core* and the *Connector*.](
  figures/uml/03-tangojs-internal-connector.tex){
  #fig:03-tangojs-internal-connector width=60% }

A concrete **connector implementation has to be plugged into TangoJS**, before
it may be used. This process is shown on [@Lst:03-connector-setup].
There is always only one connector active. The upper layer, which is *TangoJS
Core*, forwards most calls to this connector and awaits for the results. Since
the core knows nothing about the backend used, it cannot perform any caching
or optimizations. This has to be handled at the connector level.

```{#lst:03-connector-setup .javascript}
// following to be done before using the TangoJS:
const connector = new CustomConnectorImpl( /* configuration */ )
tangojs.core.setConnector(connector)

// now TangoJS will work using this connector
const deviceProxy = new tangojs.core.api.DeviceProxy('sys/tg_test/1')
```
Listing: Connector setup process.

**mTango connector.**
The mTango has been chosen as a default backend for TangoJS. The connector for
the *mTangoREST server* is a simple client that consumes RESTful API exposed by
the mTango server. In most cases TangoJS will be deployed on a different server
than the mTango. *TangoJS mTango Connector* supports this setup, with proper
**implementation of CORS protocol**. The mTango's servlet container has to be
configured for CORS support. Most containers provide a suitable servlet filter
that can be included in the filter chain.
mTango also supports user authorization. Since this is handled completely by
the server, there is no concept of user in TangoJS APIs. The only part aware
of user authority is the connector. User credentials have to be passed upon the
connector instantiation. It's the application developer responsibility to
secure these credentials and re-instantiate the connector when the user's
identity changes.

**In-memory mock connector.**
TangoJS also offers a mocked connector implementation, which mimics a real
TANGO infrastructure with in-memory hierarchy of objects. There is no network
communication performed. This approach is useful for e.g. automated testing
the upper layers. This connector is flexible and can be configured with a list
of *device* objects, where each device exposes some attributes and commands.

![Reading value of an attribute using TangoJS Core API.](
  figures/uml/03-tangojs-sequence-read.tex){
  #fig:03-tangojs-sequence-read width=90% }

## TangoJS WebComponents - HTML widget toolkit {#sec:solution-tangojs-webcomponents}

The most important part of TangoJS, from end user's perspective, is the widget
toolkit. This module sits on top of the core layer in TangoJS stack. It contains
a set of customizable widgets and provides utilities to easily build own
widgets.

**Module structure.**
This module is designed for in-browser use only. The widgets are packed as
separate HTML files and can be included on demand. The module also exports the
`tangojs.web` package, which contains mixins and utility functions useful for
creating non-standard widgets. This is covered in details in
[@Sec:widget-development].

**Widget concept.**
A widget is a self-contained piece of UI, that may be used on its own and
requires zero configuration. The widget is a graphical representation of a
*model*. A model is an abstraction that may be a *device*, a device's
*attribute* or a *command*. Two examples are a device status indicator widget
and an edit field for a value of an attribute. Some widgets, e.g. a trend
widget, can be bound to a multiple models. A widget may only interact with
its corresponding models. It is isolated from the rest of the TANGO
environment and independent from the application that it is embedded in.
To achieve these goals, TangoJS widget toolkit module has been developed
using the latest set of W3C standards, including *Custom Elements*, *HTML
Imports*, *HTML Templates* and *Shadow DOM*. These standards together are
called *Web Components*. From the developer point of view, these widgets
behave like native web controls, e.g. *input* or *button*.

**Using TangoJS widgets.**
The developer should be able to include the desired widgets in his/her
application. He/she may then optionally configure these widgets to match
his/her requirements. The widgets can be instantiated and configured in two
ways. The first way is via standard DOM manipulation APIs available in
Javascript, like the `document.createElement` function. This is shown in
[@Lst:03-widget-instantiation-js]. Apart from the imperative access, there is
also a way to create widgets declaratively, by simply putting desired tag
in HTML markup. This is shown in [@Lst:03-widget-instantiation-html].

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
widgets offer a layout and appearance similar to their counterparts from Taurus.
The available widgets are depicted in [@Fig:03-tangojs-widgets-all].
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
  *writable* attribute. Depending on an attribute type, the edit box may be a
  text field, a spinner or a checkbox;
* `tangojs-state-led` - displays name, state and status of a device;
* `tangojs-command-button` - when pressed, executes a command. Fires a DOM
  event when result becomes available;
* `tangojs-device-tree` - displays all devices defined in TANGO database. This
  is the only widget that is not bound to any model;
* `tangojs-trend` - displays the values of multiple attributes in the time
  domain;
* `tangojs-form` - displays a group of widgets for multiple models. The best
  matching widget is chosen for each model depending on its type and
  read/read-write mode.

**Widget's lifecycle.**
Behavior of most widgets is similar. Each one represents the status of a
*device server* or a value of *device server*'s attribute.
Upon initialization the widget is
configured according to the HTML attributes specified, e.g. the `model`
attribute. Then, with help of lower TangoJS layers, the widget starts polling
the *device server*. Widget updates its interface periodically, using the latest
data received from the *device server*, e.g. `tangojs-trend` draws a new point
on plot. Most attributes of a widget may be changed dynamically, after the
widget has been created. Change of some attributes, like mentioned `model` or
`poll-period` leads to widget's reinitialization. During reinitialization,
polling loop is usually restarted.

Apart from constantly updating its layout, a widget also handles user's input.
`tangojs-line-edit`, for instance, reads value entered by used, converts it
to a TANGO data type and sends it to the *device server*. This is performed
independently of layout updates.

All widgets are custom HTML elements. As such, their lifecycle is controlled
by callbacks defined in *Custom Elements* specification. Widget initialization
is handled in `createdCallback`. Reinitialization due to attribute change is
performed in `attributeChangedCallback`. A sequence diagram with widget's
lifecycle is presented in [@Fig:03-tangojs-sequence-widget-lifecycle]. Widgets
and *Custom Elements* are covered more deeply in [@Sec:widget-development] and
[@Sec:selected-aspects-of-implementation].

![Widget's lifecycle. Interactions with *TangoJS Core* has been simplified.](
  figures/uml/03-tangojs-sequence-widget-lifecycle.tex){
  #fig:03-tangojs-sequence-widget-lifecycle width=90% }

## Interworking between TangoJS layers

TangoJS modules are separated and have different responsibilities. However,
even simple use cases like reading device's state or setting an attribute,
require interactions between all the layers.

When it comes to the programmable access, application developer typically
interacts with the `TangoJS Core` layer. All actions are passed down through
the TangoJS stack until they reach the *Connector* layer, where any network
communication occurs. In the connector, a promise of result is always
returned. It is later resolved to a concrete value. A scenario with reading
a single attribute is presented in [@Fig:03-tangojs-sequence-read]. Other use
cases, like writing value to an attribute, reading device's state or invoking
a command follow similar pattern.

More complex scenarios are often implemented in widgets. Widgets are
usually bound to TANGO models. Upon initialization or reinitialization
widget has to fetch its configuration from the device and then periodically
poll the device to update its value. Some widgets, like
`tangojs-trend` or `tangojs-form` offers support for multiple models, which
makes actions flow even more complex.

## TangoJS Panel - synoptic panel application

It is not always necessary to build a dedicated GUI application for a given set
of hardware components. There are tools like Taurus, which support creating
GUIs interactively, by placing widgets on a panel. This process can be
performed by the hardware operator, to **adapt the GUI to the current
requirements** and **display only relevant information**. TangoJS also supports
this scenario, through a web application called *TangoJS Panel*. Because of its
complexity, it proves that TangoJS can be successfully used for building
complete and non-trivial web applications.

*TangoJS Panel* is a framework-less solution that also uses *Web Components*
technology to separate its UI parts. This approach gives the developer full
control over the DOM and allows for some optimizations related UI updating.
The application is presented in [@Fig:03-tangojs-panel].

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
