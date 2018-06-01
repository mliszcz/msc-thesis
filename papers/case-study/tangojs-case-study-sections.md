---
title: A case study of a web-based control panel built with TangoJS
title-short: TangoJS Case Study
author: Michał \\surname{Liszcz}, Włodzimierz \\surname{Funika}
author-short: M. Liszcz, W. Funika
affiliation: AGH UST
keywords: SCADA, web, browser, Javascript, Tango, HTML, CORBA, REST
mathclass: AB-XYZ
bibliography:
  - ../../thesis/build/references.bib
  - references.bib
link-citations: true
csl: ../../thesis/documentclass/ieee.csl
listings: true
codeBlockCaptions: true
header-includes:
  - \usepackage{graphicx}
  - \usepackage{tikz}
  - \usepackage{standalone}
  - \usepackage{mathrsfs}
  - \usepackage{amssymb}
  - \usepackage{empheq}
  - \usepackage{braket}
  - \usepackage{empheq}
  - \usepackage{float}
  - \usepackage{color}
  - \usepackage{listings}
  - \usepackage{gensymb}
  - \usepackage{caption}
  - >
    \lstset{ language=C
    , basicstyle=\fontsize{10}{12}\fontencoding{T1}\ttfamily
    , keepspaces=true
    , showspaces=false
    , showstringspaces=false
    , breaklines=true
    , frame=tb
    }



abstract: >
  Scientific and industrial hardware installations are becoming more and more
  complex and require sophisticated methods of control. To address these needs,
  Tango Controls system has been developed. As Tango is a CORBA-based software,
  the developers cannot build control applications using web technologies.
  Recently the TangoJS project has been developed as an attempt to integrate
  Tango with web browsers. This paper describes the TangoJS' design and
  architecture, evaluates TangoJS against existing solutions,
  presents a case study of building an interactive control-panel application
  and discusses possible production-grade deployment scenarios for TangoJS
  applications.

---

# Introduction

Conducting an experiment in a scientific facility requires orchestration of
multiple hardware components, like motors, pumps and power-supplies.
Hardware operators and control system engineers use various software systems
for controlling all the connected devices and ensuring that the whole
infrastructure provides uninterruptible services to its users.

Many systems aiming to facilitate hardware control and maintenance
have been developed [@daneels1999selection]. A common name for these systems is
SCADA, which stands for *Supervisory Control And Data Acquisition*
[@daneels1999scada; @boyer2009].
One of such SCADA systems, the Tango Controls, is extensively used in the National
Synchrotron Radiation Centre
Solaris in Krakow, Poland [@szota2017ontology] as well as in other scientific
facilities.

Tango [@gotz1999tango] is a generic framework for building SCADA systems.
Each piece of hardware is represented as a *device server*, an abstract
object that can be accessed from client applications over the network.
Tango uses OOP paradigm for its data model and characterizes devices with
*attributes* (parameters of the hardware), *commands* (actions the hardware
can perform) and *properties* of the device servers. Tango
supports creating client applications in *Java*, *Python* and *C++*
languages. Tango's middleware layer is built on top of
CORBA [@www-corba; @www-corba-spec; @natan1995] and ZeroMQ [@www-zeromq].
A central MySQL database [@tools-mysql] is used to store all registered devices
and their configuration. An overview of Tango architecture is depicted in
[@Fig:01-tango-architecture].

![Tango Control System architecture overview.](
  ../figures/uml/01-tango-architecture.tex){
  #fig:01-tango-architecture width=80% }

During the years of development, Tango has been widely adopted in both science
and automation industry. Constantly growing community contribute
a lot of tools and utilities related to the Tango project.
The core Tango is a free and open source software, released under GPLv3
license.

\ \

## Web-based control applications

Whereas it is easy to create a desktop client application, the _web-based
approach to Tango GUI development is still an unexplored area_.
Over the years there were a few attempts to create a framework for development
of web-based Tango applications. Most of proposed solutions have been abandoned
due to e.g. limited extensibility, obsolete dependencies or low interactivity
options. The TangoJS project [@liszcz-msc-thesis-tangojs] aims to
address these problems by being a modular, framework-less system that provides
users with interactive widgets for visualization of the status of the hardware.

This paper is aimed to demonstrate how various web technologies can be tied
together to create a generic, graphical application capable of controling Tango
device
servers. The presented approach is build on the TangoJS project
and uses modern
architectural patterns to reliably manage the data flow between a set of
loosely connected UI components that are isolated and independent of each other.

The paper is organized as follows:
Section 2 shows the state of the art of web-based UI development for Tango;
Section 3 gives an overview of the TangoJS system and its core concepts;
Section 4 presents a case study of an application built with TangoJS;
Section 5 discusses the possible deployment strategies for TangoJS-based
applications.
Section 6 concludes the paper and outlines possible directions of further
development.

\ \

# Related work

The use of Web frontend technologies for GUI development for both mobile and
desktop is gaining more and more popularity. Compared with the traditional
approach of writing a native, dedicated application for each platform, it
brings many benefits, wide choice of tools and libraries, simplified deployment
process or portability thanks to the projects like Electron [@www-electron] or
Apache Cordova [@www-cordova].

The first project using a web browser as a runtime for Tango applications
was Canone (2005) [@pelkocanone07; @www-canone].
Canone allows to compose a GUI from multipe widgets representing various
devices
and properties of these devices. The user can put widgets on a webpage layout.
[@Fig:202-canone-gui] presents an example application built with Canone.
Due to the Tango's requirements in regard to the network access, a clear
separation into the backend and the frontend parts is applied in Canone's
architecture. The backend part, called *socket server*, is a Python application
acting as a proxy between Tango device servers and the frontend part. The
frontend is written mostly in PHP but Canone's widgets also use AJAX in a
limited way to provide users with basic interaction options.

![Canone Web Interface. (source [@www-canone])](
  ../figures/images/02-canone-tutorial4.png){
  #fig:202-canone-gui width=80% }

GoTan (2012) [@gotan2012] is a project consisting of two modules, a server
and a client. The server is a Groovy application that communicates directly
with the Tango device servers. The GoTan server exposes a well documented RESTful
API, which clients can use to access the devices. While the default client
is also implemented in Groovy and cannot be easily ported to a browser
enviroment, alternative client implementations are possible thanks to an HTTP-based
API. GoTan does not provide any frontend library to facilitate building the user
interfaces for client applications.

Taurus Web (2013) [@taurusweb2013] project aims to bring Taurus'
functionality to the web environment. Like the competing projects, Taurus Web
is also divided into a server and a client parts. The server part is written in
Python and exposes Tango devices over the WebSocket protocol.
The client part offers the developers access the Tango devices using an API.
There are no generic widgets available and dedicated UI components need to be
implemented by the developers aiming to use Taurus Web.

mTango [@mtango2016] is a two-tier client/server system that provides developers
with a complete set of tools for building interactive, web-based and mobile
Tango client applications.
The server part, the mTangoREST server, is a Java application that can run
within a dedicated or an embedded servlet container. The server is responsible for
communicating with the Tango infrastructure. Tango devices are exposed to the
clients using a
well-defined HTTP-based API. mTango provides two client implementations for
accessing this
API, a Java client for desktop applications and a Javascript client for web
applications. The web-based client library offers both a set of low-level
functions for
communicating with the devices and a collection of high-level widgets. The widgets
can represent attributes and properties of arbitrary devices.
Widgets are implemented using the JavascriptMVC
framework (as of mTango rc0.3). This allows to compose the UI declaratively,
using HTML-like tags. For instance,
`<mtango:plot>` tag can be used to create a time-domain plot of device attributes.

Each of these projects has its unique properties, advantages and drawbacks,
discussed in greater details in ([@liszcz-msc-thesis-tangojs]).
Most of the projects however were abandoned at the proof-of-concept stage and
only a single one is actively maintained these days.

\ \

# Introduction to the concept of TangoJS

Each of the discussed projects has its unique properties, advantages and drawbacks.
However, all the projects that allow to access Tango devices from web applications
share some common properties:

* a two-tier architecture is used, where a server communicates with Tango and
  a client runs within a web browser
  (this is
  mainly because Tango, as a CORBA-based technology, requires access to the
  TCP/IP stack, which is not the case for the web browsers),
* the client communicates with the server via either HTTP or WebSocket protocol,
* the client offers a collection of widgets to facilitate GUI development process
  and provide consistent end-user experience.

From all the discussed solutions, mTango is the only one that is actively developed.
mTango's frontend part has a steep learning curve due to a dependency
on a third party-framework, the JavascriptMVC. A complex setup and a set of
tools (including an SDK and a few CLI utilities) is required to create even a
simple project.

To address this, the TangoJS,
a modular web frontend library for Tango has been developed
[@liszcz-msc-thesis-tangojs].
TangoJS focuses only on the frontend part to provide all the building blocks
required for rapid development of client applications.
TangoJS can use mTango as its backend.

TangoJS uses *well-proven concepts*, as its widgets has been inspired by
the widgets available in the Taurus framework, the leading and the most mature
solution for building graphical control applications on desktop platforms.

TangoJS has been designed to be a modular ecosystem - the users include only
these modules they need and configure everything according to their project
requirements. There are three separate layers, as shown in
[@Fig:03-tangojs-architecture].

![TangoJS multi-tier architecture.](
  ../figures/uml/03-tangojs-architecture-simple.tex){
  #fig:03-tangojs-architecture width=100% }

Each of TangoJS' layers has a strict set of responsibilities. The lower layers
provide services to the upper layers, as each is buildt on previous one. The top
layer is the *TangoJS Web Components* module, which is a collection of widgets
ready to be included in client applications. The widgets use APIs exposed by the
*TangoJS Core* layer, which talks to the *TangoJS Connector* layer in order to
access the *backend server*. The backend implementation is out of TangoJS'
scope, as it uses mTango as a reference backend server implementation. More
detailed descriptions of TangoJS modules are provided in further paragraphs.

**TangoJS Core**. \quad
It is a library for programmatic access to Tango APIs.
The goal of this layer is to provide a well-defined, convenient set of
abstractions that hide the lower layers of the TangoJS stack.
The Core module *gives the user access to the concepts like DeviceProxy*,
a client side representation of a device server. This module also *contains
all the structures, enums, typedefs and interfaces*, as specified by the
Tango IDL [^ftn-idl].

[^ftn-idl]: *Interface Description Language*, which defines abstract objects
  in a language-agnostic way.

**TangoJS Connector**. \quad
The Connector concept allows the TangoJS to support multiple backends. A
Connector is an implementation of the `tangojs.core.Connector` interface.
A concrete *connector implementation has to be plugged into TangoJS*, before
TangoJS can be used. The Core layer forwards most calls to the connector
instance and awaits for the results. The Connector performs operations specific
to the backend server in use, e.g. makes HTTP calls to a RESTful endpoint in
case of mTango on the server. Different connectors can be implemented for
different way of accessing Tango from the browser, e.g. via Websockets.
Connector is also the place where any optimizations (like caching) or security
hardening (like transport over SSL), can be introduced.

**TangoJS Web Components**. \quad
The most important part of TangoJS, from end user's perspective, is the widget
toolkit. This module sits on top of the core layer in TangoJS stack. It contains
a set of customizable widgets suitable for rapid Tango web applications
development. Each widget can represent one or more models. A *model* can be a
Tango device, a device's attribute or a command. For example the Line Edit
widget allows one to change the value of a selected attribute, using a convenient
edit box. Widgets are standalone and independent of each other. Thanks to the
use of *Custom Elements* W3C standard [@www-w3c-custom-elements], the widgets
behave like native web controls, e.g. input or button elements.

**Available widgets**. \quad
The *TangoJS Web Components* is highly influenced by the Taurus library. The
initial goal was to bring the most commonly used widgets to the browser. The
widgets offer a layout and appearance similar to their counterparts from Taurus.
The available widgets are depicted in [@Fig:03-tangojs-widgets-all].
Below, each widget is provided with a short description:

\begin{figure}[!htb]
\centering
  \begin{subfigure}[b]{0.8\textwidth}
  \includegraphics[width=\textwidth,height=\textheight]
    {../figures/images/03-tangojs-widgets-label.png}
  \caption{\texttt{tangojs-label} bound to a scalar attribute.}
  \end{subfigure}

  \bigskip

  \begin{subfigure}[b]{0.8\textwidth}
  \includegraphics[width=\textwidth,height=\textheight]
    {../figures/images/03-tangojs-widgets-line-edit-bool.png}
  \caption{\texttt{tangojs-line-edit} bound to a boolean attribute.}
  \end{subfigure}

  \bigskip

  \begin{subfigure}[b]{0.8\textwidth}
  \includegraphics[width=\textwidth,height=\textheight]
    {../figures/images/03-tangojs-widgets-state-led.png}
  \caption{\texttt{tangojs-state-led} bound to a device instance.}
  \end{subfigure}

  \bigskip

  \begin{subfigure}[b]{0.8\textwidth}
  \includegraphics[width=\textwidth,height=\textheight]
    {../figures/images/03-tangojs-widgets-command-button.png}
  \caption{A set of \texttt{tangojs-command-button}s.}
  \end{subfigure}

  \bigskip

  \begin{subfigure}[b]{0.25\textwidth}
  \includegraphics[width=\textwidth,height=\textheight]
    {../figures/images/03-tangojs-widgets-device-tree.png}
  \caption{\texttt{tangojs-device-tree} with all devices from the database.}
  \end{subfigure}
    ~
  \begin{subfigure}[b]{0.65\textwidth}
  \includegraphics[width=\textwidth,height=\textheight]
    {../figures/images/03-tangojs-widgets-trend.png}
  \caption{\texttt{tangojs-trend} bound to two scalar attributes.}
  \end{subfigure}

  \bigskip

  \begin{subfigure}[b]{0.8\textwidth}
  \includegraphics[width=\textwidth,height=\textheight]
    {../figures/images/03-tangojs-widgets-form.png}
  \caption{\texttt{tangojs-form} bound to three models of different kinds.}
  \end{subfigure}

\caption{TangoJS widgets.}
\label{fig:03-tangojs-widgets-all}{}
\end{figure}

* `tangojs-label` - displays the name, value, unit and status of a *read-only*
  attribute;
* `tangojs-line-edit` - displays the name, value, unit, status and edit box of
  a *writable* attribute. Depending on an attribute type, the edit box may be a
  text field, a spinner or a checkbox;
* `tangojs-state-led` - displays the name and status of a device;
* `tangojs-command-button` - when pressed, executes a command. Fires a DOM
  event when result becomes available;
* `tangojs-device-tree` - displays all devices defined in Tango database. This
  is the only widget that is not bound to any model;
* `tangojs-trend` - displays the values of multiple attributes in the time
  domain;
* `tangojs-form` - displays a group of widgets for multiple models. The best
  matching widget is chosen for each model depending on its type and
  read/read-write mode.

\ \

# A case study of building a control panel application

In the sections that follow we show how to build a dynamic control panel
application. The case study includes a requirements analysis, a review of
development techniques available in TangoJS, an overview of selected aspects of
implementation and a discussion of possible deployment options.

\ \

## Goal setting and requirements analysis

The TangoJS Panel application is inspired by the SarDemo project, which is often
used to demonstrate the abilities of the Sardana toolset [^foot-sardana]
on desktop installations of Tango. A similar application available for TangoJS
will help the project to gain more popularity within the Tango community.
The users should be able to test TangoJS widgets with their own Tango
installations. The TangoJS Panel application needs to be easy to deploy and
should provide a reasonable default configuration (e.g. a web server and user
accounts).

[^foot-sardana]: <http://www.sardana-controls.org/>

A set of functional requirements has been formulated as a guidance for the
development process. The user should be able to:

* users should be able to use the TangoJS Panel application with their own Tango
  installation (and mTango on server side),
* application should display all device servers defined in the database,
* user should be able to create interactive widgets for selected attributes
  of the devices,
* it should be possible to place the widgets on a dashboard, view and move
  them around,
* the user should be able to save and restore the layout of the dashboard.

The web technologies are the best choice for creating any kind of a
dashboard-like layout. TangoJS paired with a lightweight frontend framework
will allow to address the goals formulated above with minimal effort required.
The main view of TangoJS Panel's user
interface is shown in [@Fig:03-tangojs-panel-01]. It is a dashboard where the
user can place multiple widgets representing the attributes and commands of
various devices.
Technical details of implementation and architectural considerations are
described later in the sections that follow.

![TangoJS Panel application's main view.
](../figures/images/03-tangojs-panel-01-fixed.png){#fig:03-tangojs-panel-01 width=85%}

\ \

## TangoJS from developer's perspective

TangoJS framework is targeting software developers as its end users.
Most of the time the developers interact either with the Core module or the Web
Components module. The Connector module is an implementation detail transparent
to the developers and its configuration depends on environment.

TangoJS has been designed to *minimize dependencies on third party code* and to use
the *recent web standards*, like HTML5, CSS Level 3 modules or ECMAScript 2016.
The standard solutions rarely become deprecated. Instead, they evolve
gradually, which makes easy to keep the project up-to-date. These technologies
are already implemented in all modern browsers, thus no transcompilation is
required.

**TangoJS Core**. \quad
One of the TangoJS project goals was to minimize the learning curve. TangoJS
Core API brings familiar Tango abstractions, like *DeviceProxy* to the browser
ecosystem. All these objects are stored in a global `window.tangojs.core.api`
object. For instance, to read/write value from/to an attribute of a device of
choice, one simply instantiates an `AttributeProxy` object and calls the
apropriate method, like shown in [@Lst:03-tangojs-core-read-attr]. Before
performing any communication using TangoJS Core API, the connector has to be
configured, as shown in [@Lst:03-tangojs-connector-configuration]. The mTango
connector, `tangojs.connector.MTangoConnector`, is a Connector implementation
ready to use with mTango on the server side.

```{ #lst:03-tangojs-core-read-attr .javascript
  caption="Accessing attribute's value using TangoJS Core API" }
const { AttributeProxy, AttributeValue } = tangojs.core.api

const attributeProxy = new AttributeProxy('sys/tg_test/1/long_scalar')

const inValue = new tangojs.core.api.AttributeValue({value: 32})
attributeProxy.write(inValue)

attributeProxt.read()
  .then(outVal => console.log(`Value: ${outVal.value}`))
  .catch(error => console.error(`Failure: ${error}`))
```

```{ #lst:03-tangojs-connector-configuration .javascript
  caption="Wiring Connector implementation to TangoJS Core" }
const connector = new MyConnectorImpl(...)
tangojs.core.setConnector(connector)
```


**TangoJS Web Components**. \quad
TangoJS' widget collection has been inspired by the Taurus framework -
the leading solution for building Tango clients in Python/Qt. It was designed
with the ease-of-use and ease-of-deployment in mind.

The developer should be able to include the desired widgets in his/her
application. He/she may then optionally configure these widgets to match
his/her requirements. The widgets can be instantiated and configured in two
ways. The first way is via standard DOM manipulation APIs as shown in
[@Lst:03-widget-instantiation-js]. Apart from the *imperative* access, there is
also a way to create widgets *declaratively*, by simply putting a desired tag
into a HTML markup. This is shown in [@Lst:03-widget-instantiation-html].

```{ #lst:03-widget-instantiation-js .javascript
  caption="Imperative widget instantiation from Javascript code." }
const lineEdit = document.createElement('tangojs-line-edit')

lineEdit.setAttribute('model', 'sys/tg_test/1/long_scalar_w')
lineEdit.pollPeriod = 1000
lineEdit.showName = true
lineEdit.showQuality = true

document.body.appendChild(lineEdit)
```

```{ #lst:03-widget-instantiation-html .html
  caption="Declarative widget instantiation from HTML markup." }
<tangojs-trend
  model="sys/tg_test/1/long_scalar_w,sys/tg_test/1/double_scalar"
  poll-period="1000"
  data-limit="20">
</tangojs-trend>
```

All TangoJS widgets which are available in the TangoJS WebComponents module
have their constructor functions attached to the global
`window.tangojs.web.components` object. Each constructor has a static
`capabilities` property, which describes what kind of models (devices,
attributes or commands) the widget can visualize. Apart from the capabilities,
each constructor function exposes the `attributes` property, which describes all
the configurable HTML attributes of a widget. Each HTML attribute is
characterized by its name, data type and default value.

\ \

## Control panel application - software stack

TangoJS can be view as a set of APIs and widgets. To build a real application,
other technologies have to be incorporated. TangoJS provides widgets that
behave like ordinary HTML elements. This allows for seamless integration
of TangoJS with any web framework.
Its up to the developer to decide if he/she creates the application using
Angular [@www-angular; @darwin2013angularjs], React [@www-react] or just
plain DOM APIs.

Among all frontend frameworks the Facebook's React is often chosen by
developers to create web applications of any scale. Although it comes with some
controversial features like the JSX (which, when used, requires
transcompilation), and is heavyweight with all its dependencies, a
stripped-down fork called *Preact* [@www-preact] is availabe. It offers API
compatibility with React, but is much smaller in size [@www-preact-vs-react] and
offers better performance [@www-preact-perf].
Preact contains everything that is required to build highly reactive
applications including stateless (functional) components, and unidirectional
data flow.

React on its own is merely a presentation layer that can be used to create
*views* (as in a classic MVC pattern). For most real-world applications, like the TangoJS Panel, a state, or
a data *model*, needs to be introduced. While it is possible to represent the
state as a bunch of variables scattered accross the codebase, mutating these
variables from different places is error prone, difficult to test and
maintain. To address this problem, Facebook proposed the *Flux architecture*
[@www-flux].
In Flux, application's state is stored in a central place, called *store*. Various
*actions* can change the state, but these changes always happen inside the store
in a well-defined order. The store acts as a *single source of truth* for an
application - the whole application's state is maintained by the store.
Only changes in the store can result in UI updates. There are many
implementations of Flux architecture, all offer some sort of *predictable state
container* that can transform itself under a stream of events. For building TangoJS
Panel we have chosen *Redux* [@www-redux], as it easily integrates with Preact.

\ \

## Control panel application - architecture

The application follows a standard React-Redux architecture. The state (or store)
contains both the domain-specific parts like a list of visible widgets and the
ordinary UI state, like an indication that a dialog window is visible. The read-only
state is passed to the *presentational components* [@www-smart-dumb-components],
which form the application's UI. The components trigger various actions that are
dispatched back to the store.

There are just three *presentational components*, the `Dashboard`, the
`Menu` and the `WidgetSelector`. Each component is paired with a corresponding
*container component* [@www-smart-dumb-components] that maps the global
application's state to component's properties. These container components are
combined into the `Application` component.

The `Dashboard` component is a thin wrapper around the `react-grid-layout`
component[^foot-rgl]. Its purpose is to visualize TangoJS widgets on a grid with
draggable and resizable elements. It is responsive and different layouts can
be used for differens screen sizes.

[^foot-rgl]: <https://github.com/STRML/react-grid-layout>

The `Menu` is a sidebar that contains `tangojs-tree-view` widget and additional
controls for interacting with the device tree. The user can use this tree to
browse all objects stored in the Tango database. When he/she selects a desired
object, he/she can create a widget to visualize this object on the `Dashboard`.

The `WidgetSelector` is a modal window, built with `react-modal`[^foot-rmodal].
It is displayed when the user chooses a device, an attribute or a command from
the device tree browser. `WidgetSelector` uses the capabilities of each possible
TangoJS widget to determine which widget is the most suitable for visualization
of selected objects. When the user selects the desired widget, a dynamic form
with all configurable HTML attributes of this widget is generated using the
`react-jsonschema-form` component[^foot-jsonschema].

[^foot-rmodal]: <https://github.com/reactjs/react-modal>
[^foot-jsonschema]: <https://github.com/mozilla-services/react-jsonschema-form>

![TangoJS Panel application's top-level architecture.
](../figures/uml/03-tangojs-panel-architecture.tex){#fig:03-tangojs-panel-arch width=100%}

The bootstrapping code fetches Tango database's address from the browser's query
string, configures an appropriate TangoJS Connector and initializes the
application inside the HTML document's body. Top level components of TangoJS
Panel application and interactions between these components are presented in
[@Fig:03-tangojs-panel-arch]. These components can be further divided into
smaller units of functionality, like functions or classes.

\ \

## Control panel application - selected aspects of implementation

This section covers the most important aspects of the implementation, including
backend configuration, TangoJS initialization, Preact/Redux-based state
maintenance and dynamic widget discovery. The complete source code of the TangoJS
Panel application is available online[^foot-app-repo].

[^foot-app-repo]: <https://github.com/mliszcz/tangojs-panel>

**mTango configuration**. \quad
TangoJS Panel application uses mTango server to access the Tango infrastructure.
mTango requires some initial configuration to handle requests from TangoJS.

* TangoJS Panel can be deployed in a different domain (*origin*), thus mTango
needs to be configured to accept cross-domain connections. CORS[^foot-cors]
requests can be enabled in most servlet containers using configuration files.
There is no need to change the application's code.

[^foot-cors]: Cross Origin Resource Sharing

* *TangoJS mTango Connector* uses HTTP basic authentication and this
authentication method needs to be supported by the mTango server. Most servlet
containers allow to
configure such an authentication with different backends, e.g. a fixed list of users,
a database or an LDAP directory.

A preconfigured mTango REST server is available in a Docker container
[^foot-mtango-docker]. This container has been created during the TangoJS
development. It may be used with the existing Tango deployment.

[^foot-mtango-docker]: <https://hub.docker.com/r/mliszcz/mtango/>

**Initialization of the TangoJS framework**. \quad
Before TangoJS can be used, a connector needs to be configured. This can be done
immediately after the required objects are loaded. To instantiate mTango Connector
one has to supply the address of the server-side API endpoint and authentication
credentials. This process is shown in [@Lst:03-tangojs-mtango-connector]. To
avoid hardcoding the credentials in the application's code one can display a
pop-up window during the page loading and ask the user for his/her credentials.

```{ #lst:03-tangojs-mtango-connector .html
  caption="Configuring mTango Connector instance." }
<script type="text/javascript">
  (function (tangojs) {
    'use strict'

    const connector = new tangojs.connector.mtango.MTangoConnector(
      'http://172.18.0.5:8080/rest/rc2', // endpoint
      'tango',                           // username
      'secret')                          // password

    tangojs.core.setConnector(connector)

  })(window.tangojs)
</script>
```

TangoJS widget's are loaded asynchronously using HTML Imports [@www-w3c-html-imports]. In some
scenarios it is desirable to postpone application's initialization until all
imports are loaded. If the native HTML Imports feature is available in the
browser, a `DOMContentLoaded` event indicates that all imports have been resolved.
In the cases where the webcomponents.js polyfill[^foot-wc-poly] is being used, one
has to wait for an `HTMLImportsLoaded` event instead. The complete TangoJS Panel
application initialization procedure covering both cases is shown in
[@Lst:03-tangojs-initialization].

[^foot-wc-poly]: <https://www.webcomponents.org/polyfills#html-imports-polyfill>

```{ #lst:03-tangojs-initialization .html
  caption="TangoJS Panel delayed initialization." }
<script>
  (function() {
    'use strict'

    const root = document.getElementById('root')
    const run = () => window.tangojsPanel.bootstrap(root)

    if (HTMLImports && !HTMLImports.useNative) {
      window.addEventListener('HTMLImportsLoaded', run, true)
    } else {
      window.addEventListener('DOMContentLoaded', run, true)
    }
  })()
</script>
```

**State handling and widget rendering**. \quad
In the applications based on the Flux architecture, any changes to the state are
performed in a central *store*. If necessary, these changes can result in view
updates. These assumptions impact on how actions propagate in the TangoJS Panel
application.

The basic use case for the TangoJS Panel is a widget addition. When the user
selects an object from TangoJS Device Tree widget in the application's menu,
an appropriate action is sent to the store. As a result of this action, the store
updates the application's state. This change causes the WidgetSelector component
to be rendered. Later, when the user selects the desired widget to represent
his/her object, another action is sent to the store. This new action causes
widget creation and rendering it on the Dashboard. The whole scenario is shown
in a sequence diagram in [@Fig:03-tangojs-panel-flow].

![Sequence of actions resulting in a widget creation.
](../figures/uml/03-tangojs-panel-flow.tex){#fig:03-tangojs-panel-flow width=100%}

**Discovering available widgets**. \quad
As stated in the TangoJS overview, by convention the constructor functions of all
widgets are attached to the global `window.tangojs.web.components` object.
When the user wants to visualize an object (a device, an attribute or a command),
TangoJS Panel application fetches the description of this object from the Tango
database (e.g. an *AttributeInfo* structure for attributes) and uses this
description to filter suitable widgets. The filtering is done using the
`capabilities` property attached to the constructor function of each widget. When
the user chooses a desired widget to be rendered, the TangoJS Panel application
displays a dynamic form where the user can specify HTML attributes for this widget.
This is done with the help of the `attributes` property of the widget's constructor.
An example code responsible for setting these properties on TangoJS Trend widget is
shown in [@Lst:03-tangojs-widget-props]. The TangoJS Panel application can access
these values using `window.tangojs.web.components['tangojs-trend'].capabilities`
and `window.tangojs.web.components['tangojs-trend'].attributes`.


```{ #lst:03-tangojs-widget-props .html
  caption="Metadata attached to the widget's constructor during widget's registration." }
  window.tangojs.web.util.registerComponent(
    'tangojs-trend',
    TangoJsTrendElement,
    {
      capabilities: {
        attributeModel: true,
        commandModel: false,
        statusModel: false,
        readOnlyModel: true
      },
      attributes: {
        'model': { type: [Array, String] },
        'poll-period': { type: Number },
        'data-limit': { type: Number }
      }
    })
```

\ \

# Deployment strategies for TangoJS applications

An important advantage of the web applications over the desktop applications
is the ease of deployment. End users access the application that is stored on
a remote server. The only requirement on the client side is a web browser.
Developers and administrators can easily push a new version to the server and
users always access the up-to-date application. This is especially important in
the large-scale deployments, like corporate intranets or control rooms in
scientific facilities, where the application has to be delivered to tens of
users.

In the case of the TangoJS Panel application deployment planning a few aspects have
to be considered. The existing Tango installation needs to be accessible from
TangoJS backend server. The backend server should also have access to some sort
of users' directory, like e.g. LDAP. This is needed for authentication and
authorization purposes. mTango can be used on the server side to perform these
tasks. The Panel application communicates with mTango via AJAX calls. Although
mTango is released with an embedded Tomcat servlet container, a separate
container offers greater flexibility and better configuration options.

The frontend part, which is a TangoJS Panel application itself, has to be
stored on an ordinary web server. Since no server-side processing is required,
any server can be used. Possible examples are Apache, nginx or Node.js-based
`http-server` package.

Zipping together a web server, a servlet container and (optionally) a Tango
database with an example device requires using tools for service orchestration.
These tools are discussed later in this section.

\ \

## Containerizing applications

Docker [@www-docker] is a popular tool that provides isolated, reproducible
environments for running applications. Docker uses LXC containers, cgroups and
other Linux kernel features to isolate processes from the host operating system
[@www-containers-anatomy]. A fine-grained management of available resources like
filesystems and networks is possible for Docker *containers*.

Docker instantiates containers from *images*. Image definitions are stored in
plaintext *Dockerfiles*. Dockerfile is a recipe that describes steps required to
build a minimal filesystem required to run the desired application.
An online service, called DockerHub[^foot-docker-hub], can be used to publish
and share Docker images.

[^foot-docker-hub]: <https://hub.docker.com/>

TangoJS offers Docker images with mTango and Tango itself. The images
require zero configuration and are designed for instant TangoJS deployment.
The Tango image[^docker-tangocs] is available in the registry as
`tangocs/tango-cs`. The mTango image[^docker-mtango] is available as
`mliszcz/mtango`.

[^docker-tangocs]: <https://hub.docker.com/r/tangocs/tango-cs/>
[^docker-mtango]: <https://hub.docker.com/r/mliszcz/mtango/>

The TangoJS Panel application is straightforward to install, as the only
requirement is a static web server. Since it is a Node.js project, one can
use npm to pull the dependencies in a production environment and run the
application directly from a git checkout. A simple Node.js-based web server can
be used instead of a full-blown solution like the Apache server.
The Dockerfile (based on the tiny Alpine linux) which can be used to start the
TangoJS Panel application is shown in [@Lst:03-tangojs-alpine-dockerfile].
This Dockerfile can be built and started using the usual `docker build` and
`docker run` commands.

```{ #lst:03-tangojs-alpine-dockerfile .dockerfile
  caption="A Dockerfile with the TangoJS Panel application." }
FROM alpine:edge

RUN  apk add --no-cache git nodejs nodejs-npm \
  && git clone --depth 1 -b master \
    https://github.com/mliszcz/tangojs-panel-obsolete \
    /tangojs-panel \
  && cd /tangojs-panel \
  && npm install \
  && npm prune --production \
  && npm install --no-save http-server \
  && apk del git nodejs-npm

EXPOSE 8080

CMD /tangojs-panel/node_modules/.bin/http-server /tangojs-panel
```

It is possible to try the TangoJS Panel application without an existing Tango
and mTango installation. One can replace the mTango Connector with a mocked
in-memory connector implementation[^foot-tangojs-connector-mock].

[^foot-tangojs-connector-mock]: <https://github.com/tangojs/tangojs-connector-local>

\ \

## Service orchestration

To efficiently manage three (or even four if one separates TangoTest device
from Tango database server) containers, an
orchestration tool is required. The Docker Compose[^foot-docker-compose], a
community project which recently became an official part of Docker, has been
designed to address this problem.

[^foot-docker-compose]: <https://docs.docker.com/compose/>

Docker Compose allows to define containers, dependencies, network links
and mount points using a convenient YAML file.
A Docker Compose file with Tango, MySQL database and mTango has been created
during TangoJS development and is available online[^foot-tango-workspace].
One can add a new entry in the `services` section of `docker-compose.yml` file
in order to  automatically start TangoJS Panel together with other services.
Assuming that TangoJS Panel Dockerfile is named `Dockerfile.tangojs-panel`, the
Docker Compose service could be defined as shown in
[@Lst:03-tangojs-docker-compose]. With such configuration,
mTango service endpoint is going to be available for the TangoJS Panel under the
`mtango.workspace` hostname.
A complete configuration file and other artifacts required to run TangoJS Panel
as a Docker Compose service are available online [^foot-tangojs-resources].

[^foot-tango-workspace]: <https://github.com/mliszcz/tango-workspace>
[^foot-tangojs-resources]: <https://github.com/mliszcz/msc-thesis/papers/case-study/resources>

```{ #lst:03-tangojs-docker-compose .yaml
  caption="TangoJS Panel application configured as a Docker Compose service." }
services:

  # Tango, MySQL and mTango services ...

  panel:
    image: tangojs-panel
    build:
      context: .
      dockerfile: Dockerfile.tangojs-panel
    hostname: panel.workspace
    links:
      - mtango:mtango.workspace
```

When the administrator runs the `docker-compose up` command, an image with
TangoJS Panel application shall be created from the Dockerfile shown in
[@Lst:03-tangojs-alpine-dockerfile].
Other images, like the Tango database, TangoTest device or
mTango server shall be pulled from the Docker registry. TangoJS Panel application
is going be accessible at `http://{container-ip}:8080` address immediately after
the start of all the services.

\ \

# Summary

The TangoJS framework was designed to facilitate the creation of web-based client
applications for Tango Control System.

TangoJS enables building Tango client applications with standard front-end
technologies like HTML, CSS and Javascript. It delivers Tango developers a complete
set of tools and APIs required for this task. There is a minimal set of
dependencies required.

TangoJS is *compliant with the latest web standards*, which makes
it attractive for developers and allows to keep the codebase clean and
maintainable. The *use of the Web Components* [@www-w3c-webcomponents] technology and a
*framework-less architecture* enables *many integration options* between TangoJS
and other frontend libraries. *Modular design* and well-defined interfaces
enable developers to easily swap TangoJS modules, e.g. the backend module.

In this paper we showed how TangoJS can
be used to build a dynamic control panel application, the TangoJS Panel.
It is a synoptic panel suitable for visualization of devices of
any kind. This application enables users and developers new to the TangoJS to
immediately try the framework.
As TangoJS Panel can be configured either to work with an existing Tango
infrastructure or to use an in-memory mocked database, it is suitable for both
demonstrational purposes and production-grade deployments.

TangoJS is a library intended to be used the software developers to create GUI
applications.
Raw DOM APIs are used instead of a third-party web framework. This approach is
preferable for libraries, as lack of dependencies makes it easier for developers
to use and integrate the library with their software stack.

The process of TangoJS Panel development showed that using a web framework for
application
development helps to keep the code maintainable and facilitates the
implementation.
Although the Preact framework was used during this case study, TangoJS can be
easily integrated with any other frontend framework. TangoJS does not enforce
any specific technology stack or development style.

We showed how Docker and Docker Compose can be used to
automate the configuration and deployment of TangoJS-based applications.
Each component of the system was running in its own isolated container.
Such an approach enables to use the same environment for development and
production,
reduces the effort needed to perform the deployments or upgrades
and facilitates the maintenance of application's environment
(including a database).

\ \

## Future work

Various directions for further development are considered for both the TangoJS
Panel application and the TangoJS project itself.
The Panel application can be extended with support for native notifications
[^www-notifications]
and features like configuration menu, authentication form and administrative
accounts.
As for the TangoJS, future work aims to implement a few more genral-purpose
widgets, provide a better and simpler API for creating custom widgets and encance
the discovery mechanism for such widgets.

[^www-notifications]: https://notifications.spec.whatwg.org/

The biggest challenge, however, is to add support for event-based
communication instead of currently implemented device server polling.
The goal is to reduce the amount of network traffic and decrease the delay
between hardware changes and UI updates.
Event-based communication can be implemented using HTML's server-sent events
feature [^www-server-sent-ev]
or by changing the transport protocol from HTTP to WebSocket in order to allow
the server to initiate the transaction.
Both solutions require support on the backend side as well.

[^www-server-sent-ev]: https://html.spec.whatwg.org/multipage/server-sent-events.html#server-sent-events

\ \
