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
  - \newcommand*\listfigurename{}
  - \newcommand*\listtablename{}
  - \newcommand{\passthrough}[1]{#1}
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

Tango [@gotz1999tango] is a generic framework for building SCADA systems.
Each piece of hardware is represented as a *device server*, an abstract
object that can be accessed from the client applications over the network.
Tango uses OOP paradigm for its data model and characterizes devices with
*attributes* (parameters of the hardware), *commands* (actions the hardware
can perform) and *properties* of the device servers. Tango
supports creating client applications in *Java*, *Python* and *C++*
languages. Tango's middleware layer is built on top of
CORBA [@www-corba; @www-corba-spec; @natan1995] and ZeroMQ [@www-zeromq].
A central MySQL database [@tools-mysql] is used to store all registered devices
and their configuration. An overview of Tango architecture is depicted in
[@Fig:01-tango-architecture].

![TANGO Control System architecture overview. TODO color](
  ../../../thesis/figures/uml/01-tango-architecture.tex){
  #fig:01-tango-architecture width=80% }

During the years of development, Tango has been widely adopted in both science
and automation industry. Constantly growing community contribute
a lot of tools and utilities related to the Tango project.
The core Tango is a free and open source software, released under GPLv3
license.

# Web-based control applications

The use of Web frontend technologies for GUI development for both mobile and
desktop is gaining more and more popularity. Compared with the traditional
approach of writing a native, dedicated application for each platform, it
brings many benefits, wide choice of tools and libraries, simplified deployment
process or portability thanks to the projects like Electron [@www-electron] or
Apache Cordova [@www-cordova].

Whereas it is easy to create a desktop client application, the _web-based
approach to TANGO GUI development is still an unexplored area_. This is
mainly because TANGO, as a CORBA-based technology, requires access to the
TCP/IP stack, which is not the case for the web browsers.

This work demonstrates how various web technologies can be tied together to
create a generic, graphical application capable of controling TANGO device
servers. Presented approach builds on the TangoJS project
[@liszcz-msc-thesis-tangojs] and uses modern
architectural patterns to reliably manage the data flow between a set of
loosely coupled components.

## Related work

Over the years there were a few attempts to propose a framework for creation of
web-based Tango applications.
Each of these projects has it's unique properties, advantages and drawbacks,
discussed in greater details in ([@liszcz-msc-thesis-tangojs]).
Most of the projects however were abandoned at the proof-of-concept stage and
only one is actively maintained these days.

The first project using a web browser as a runtime for Tango applications
was Canone (2005) [@pelkocanone07; @www-canone].
It allows one to compose GUI from multipe widgets representing various devices
and properties of these devices. The user can put widgets on a webpage layout.
[@Fig:202-canone-gui] presents example application built with Canone.
Due to the Tango's requirements in regard to the network access, a clear
separation into the backend and the frontend parts is visible in Canone's
architecture. The backend part, called *socket server* is a Python application,
acting as a proxy between Tango device servers and the frontend part, written
in mostly in PHP. Canone's widgets also use AJAX in a limited way to provide
users with basic interaction options.

![Canone Web Interface. (source [@www-canone])](
  ../figures/images/02-canone-tutorial4.png){
  #fig:02-canone-gui width=60% }

GoTan (2012) [@gotan2012] is a project consisting of two modules, a server
and a client. The server is a Groovy application that communicates directly
with Tango device servers. The GoTan server exposes a well documented RESTful
API, which clients can use to access the devices. While the reference client
is also implemented in Groovy and cannot be easily ported to a browser
enviroment, alternative client implementations are possible using HTTP-based
API. GoTan does not provide any frontend layer to facilitate bulding of user
interfaces for client applications.

Taurus Web (2013) [@taurusweb2013] project aims to bring Taurus'
functionality to the web environment. Like competiting projects, Taurus Web
is also divided into backend and frontend parts. The backend part is a
WebSocket server implementd in Python. The server exposes Tango devices to the
frontend part. The frontend is a library that acts as a client for the server.
There are no customizable widgets and dedicated UI components need to be
implemented by the developers using Taurus Web.

// TODO read this and double check
mTango [@mtango2016] is a two-tier system providing developers with complete set
of tools to build interactive, web-based and mobile Tango client applications.
The server part, the mTangoREST server is a Java application that can run on a
dedicated or embedded servlet container. The server is responsible for
communicating with the Tango infrastructure and exposes the devices via a
well-defined HTTP-based API. There are two client implementations consuming this
API, a Java client for desktop applications and a Javascript client for web
applications. The web-based client is both a library for programmatic access to
Tango devices and a set of widgets that can represent attributes or properties
of these devices. The frontend client is implemented using the JavascriptMVC
framework (as of mTango rc0.3). This allows one to use the widgets like HTML tags. For instance,
`<mtango:plot>` can be used to visualize changes in attribute over time.

## TangoJS introduction

All attempts to create software that exposes Tango devices to web applications
share some common properties:

* a two-tier architecture is used, where the server communicates with Tango and
  client runs within a web browser,
* a client communicates with a server via either HTTP or WebSocket
* the client offers a collection of widgets to facilitate development process
  and provide consistent end-user experience

From all discussed solutions, mTango is the only one that is actively developed.
mTango's frontend part has a steep learning curve due to a dependency
on a third party-framework, the JavascriptMVC. To address this, the TangoJS,
a modular web frontend library for Tango has been presented
in [@liszcz-msc-thesis-tangojs].
TangoJS focuses only on the frontend part to provide all building blocks
required for rapid client application development.
TangoJS can use mTango as it's backend.

TangoJS uses *well-proven concepts*, as TangoJS' widgets has been inspired by
the widgets available in the Taurus framework, the leading and the most mature
solution for building graphical control applications on desktop platforms.

TangoJS has been designed to be a modular ecosystem - one includes only the
modules one needs and configures everything according to the project
requirements. There are three separate layers, as shown in
[@Fig:03-tangojs-architecture].

![TangoJS layered architecture on existing Tango infrastructure.](
  ../figures/uml/03-tangojs-architecture-simple.tex){
  #fig:03-tangojs-architecture width=100% }

Each of TangoJS' layers has a strict set of responsibilities. The lower layers
provide services to the upper layers, as each builds on previous one. The top
layer is the *TangoJS Web Components* module, which is a collection of widgets
ready to be included in client applications. The widgets use APIs exposed by the
*TangoJS Core* layer, which talks to the *TangoJS Connector* layer in order to
access the *backend server*. The backend implementation is out of TangoJS'
scope, as it uses mTango as a reference backend server implementation. More
detailed descriptions of TangoJS modules are provided in following paragraphs.

**TangoJS Core**. \quad
It is a library for programmatic access to Tango APIs.
The goal of this layer is to provide a well-defined, convenient set of
abstractions that hide the lower layers of the TangoJS stack.
The Core module *gives the user access to the concepts like DeviceProxy*,
a client side representation of a device server. This module also *contains
all the structures, enums, typedefs and interfaces*, as specified by the
TANGO IDL [^ftn-idl].

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
development. Each widget can represent one or more models. A model can be a
Tango device, a device's attribute or a command. For example the Line Edit
widget allows one to change the value of a selected attribute, using a convenient
edit box. Widgets are standalone and independent of each other. Thanks to the
use of *Custom Elements* [@www-w3c-custom-elements] W3C standard, the widgets
behave like native web controls, e.g. input or button elements.

**Available widgets**. \quad
The *TangoJS Web Components* is highly influenced by the Taurus library. The
initial goal was to bring the most commonly used widgets to the browser. The
widgets offer a layout and appearance similar to their counterparts from Taurus.
The available widgets are depicted in [@Fig:03-tangojs-widgets-all].
Below, each widget is provided with a short description:

<div id="fig:03-tangojs-widgets-all">
![\texttt{tangojs-label} bound to a scalar attribute.
](../figures/images/03-tangojs-widgets-label.png){#fig:cfa width=80%}
\par\bigskip
![\texttt{tangojs-line-edit} bound to a boolean attribute.
](../figures/images/03-tangojs-widgets-line-edit-bool.png){#fig:cfb width=80%}
\par\bigskip
![\texttt{tangojs-state-led} bound to a device instance.
](../figures/images/03-tangojs-widgets-state-led.png){#fig:cfc width=80%}
\par\bigskip
![A set of \texttt{tangojs-command-button}s.
](../figures/images/03-tangojs-widgets-command-button.png){#fig:cfc1 width=80%}
\par\bigskip
![\texttt{tangojs-device-tree} with all devices from the database.
](../figures/images/03-tangojs-widgets-device-tree.png){#fig:cfd1 width=30%}
\quad
![\texttt{tangojs-trend} bound to two scalar attributes.
](../figures/images/03-tangojs-widgets-trend.png){#fig:cfd2 width=50%}
\par\bigskip
![\texttt{tangojs-form} bound to three models of different kinds.
](../figures/images/03-tangojs-widgets-form.png){#fig:cfc2 width=80%}

TangoJS widgets.
</div>

* `tangojs-label` - displays the name, value, unit and status of a *read-only*
  attribute;
* `tangojs-line-edit` - displays the name, value, unit, status and edit box of
  a *writable* attribute. Depending on an attribute type, the edit box may be a
  text field, a spinner or a checkbox;
* `tangojs-state-led` - displays the name, state and status of a device;
* `tangojs-command-button` - when pressed, executes a command. Fires a DOM
  event when result becomes available;
* `tangojs-device-tree` - displays all devices defined in TANGO database. This
  is the only widget that is not bound to any model;
* `tangojs-trend` - displays the values of multiple attributes in the time
  domain;
* `tangojs-form` - displays a group of widgets for multiple models. The best
  matching widget is chosen for each model depending on its type and
  read/read-write mode.

# A case study of building a control panel app

In the following sections we show how to build a dynamic control panel
application. The case study includes requirements analysis, review of
development techniques available in TangoJS, overview of selected aspects of
implementation and discussion of possible deployment options.

## Goal setting and requirements analysis

The TangoJS Panel application is inspired by the SarDemo project, which is often
used to demonstrate the abilities of the Sardana toolset [^foot-sardana]
on desktop installations of Tango. A similar application available for TangoJS
will help this project gain more popularity within the Tango community.
The users should be able to test TangoJS widgets with their own Tango
installations. The TangoJS Panel application needs to be easy to deploy and
should require zero configuration.

[^foot-sardana]: <http://www.sardana-controls.org/>

A set of functional requirements has been formulated as a guidance for
development process. The user should be able to:

* user shoul be able to use the TangoJS Panel application with his own Tango
  installation (and mTango on server side),
* application should display all device servers defined in the database,
* user should be able to create interactive widgets for selected attributes
  of the devices,
* it should be possible to place the widgets on a dashboardview and move
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
](../figures/images/03-tangojs-panel-01-fixed.png){#fig:03-tangojs-panel-01 width=50%}

## TangoJS from developer's perspective

TangoJS framework it targeting software developers as its end users.
Most of the time the developers interact either with the Core module or the Web
Components module. The Connector module is an implementation detail transparent
to the developers and its configuration depends on environment.

TangoJS has been designed to *minimize dependencies on third party code* and use
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
apropriate method, like shown on [@Lst:03-tangojs-core-read-attr]. Before
performing any communication using TangoJS Core API, the connector has to be
configured, as shown on [@Lst:03-tangojs-connector-configuration]. The mTango
connector, `tangojs.connector.MTangoConnector`, is a Connector implementation
ready to use with mTango on the server side.

```{ #lst:03-tangojs-core-read-attr .javascript }
const { AttributeProxy, AttributeValue } = tangojs.core.api

const attributeProxy = new AttributeProxy('sys/tg_test/1/long_scalar')

const inValue = new tangojs.core.api.AttributeValue({value: 32})
attributeProxy.write(inValue)

attributeProxt.read()
  .then(outVal => console.log(`Value: ${outVal.value}`))
  .catch(error => console.error(`Failure: ${error}`))
```
Listing: Accessing attribute's value using TangoJS Core API.

```{ #lst:03-tangojs-connector-configuration .javascript }
const connector = new MyConnectorImpl(...)
tangojs.core.setConnector(connector)
```

Listing: Wiring Connector implementation to TangoJS Core.

**TangoJS Web Components**. \quad
TangoJS' widget collection has been inspired by the Taurus framework -
the leading solution for building TANGO clients in Python/Qt. It was designed
with the ease-of-use and ease-of-deployment in mind.

The developer should be able to include the desired widgets in his/her
application. He/she may then optionally configure these widgets to match
his/her requirements. The widgets can be instantiated and configured in two
ways. The first way is via standard DOM manipulation APIs as shown in
[@Lst:03-widget-instantiation-js]. Apart from the *imperative* access, there is
also a way to create widgets *declaratively*, by simply putting a desired tag
in a HTML markup. This is shown in [@Lst:03-widget-instantiation-html].

```{ #lst:03-widget-instantiation-js .javascript }
const lineEdit = document.createElement('tangojs-line-edit')

lineEdit.setAttribute('model', 'sys/tg_test/1/long_scalar_w')
lineEdit.pollPeriod = 1000
lineEdit.showName = true
lineEdit.showQuality = true

document.body.appendChild(lineEdit)
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

All TangoJS widgets which are available in the TangoJS WebComponents module
have their constructor functions attached to the global
`window.tangojs.web.components` object. Each constructor has a static
`capabilities` property, which describes what kind of models (devices,
attributes or commands) the widget can visualize. Apart from the capabilities,
each constructor function exposes the `attributes` property, which describes all
the configurable HTML attributes of a widget. Each HTML attribute is
characterized by its name, data type and default value.

## Control panel application - software stack

TangoJS is just a set of APIs and widgets. To build a real application,
other technologies have to be incorporated. TangoJS provides widgets that
behave like ordinary HTML elements. This allows for seamless integration
of TangoJS with any web framework.
It's up to the developer to decide if he/she creates the application using
Angular [@www-angular; @darwin2013angularjs], React [@www-react] or just
plain DOM APIs.

Among all frontend frameworks the Facebook's React is often chosen by
developers to create web applications of any scale. Although it comes with some
controversial features like the JSX (which, when used, requires
transcompilation), and is heavyweight with all its dependencies, a
stripped-down fork called *Preact* [@www-preact] is availabe. It offers API
compatibility with React, but is much smaller in size [@www-preact-vs-react] and
offers better performance [@www-preact-perf].
Preact contains everything what is required to build highly reactive
applications including stateless (functional) components, and unidirectional
data flow.

React on its own is merely a presentation layer, that can be used to create
*views* (as in classic MVC pattern). For most real-world applications, like the TangoJS Panel, a state, or
a data *model*, needs to be introduced. While it is possible to represent the
state as a bunch of variables scattered accross the codebase, mutating these
variables from different places is error prone, hard to test and hard to
maintain. To address this problem, Facebook proposed the *Flux architecture*
[@www-flux].
In Flux, the state is stored in a central place, called *store*. Various
*actions* can change the state, but these changes always happen inside the store
in a well-defined order. The store acts as a *single source of truth* for an
application - whole application's state is maintained by the store.
Only changes in the store can result in UI updates. There are many
implementations of Flux architecture, all offer some sort of *predictable state
container* that can transform itself under a stream of events. For building TangoJS
Panel we have chosen *Redux* [@www-redux], as it easily integrates with Preact.

## Control panel application - architecture

The application follows a standard React-Redux architecture. The state (or store)
contains both the domain-specific parts like list of visible widgets and the
ordinary UI state, like indication that a modal window is visible. The read-only
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
Panel application and interactions between the are presented in
[@Fig:03-tangojs-panel-arch]. These components can be further divided into
smaller units of functionality, like functions or classes.

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
There is no need to change application's code.

[^foot-cors]: Cross Origin Resource Sharing

* *TangoJS mTango Connector* uses HTTP basic authentication and this
authentication method needs to be supported by the mTango server. Most servlet
containers allow one to
configure such authentication with differen backends, e.g. a fixed list of users,
a database or a LDAP directory.

A preconfigured mTango REST server is available in a Docker container
[^foot-mtango-docker]. This container has been created during the TangoJS
development. It may be used with the existing Tango deployment.

[^foot-mtango-docker]: <https://hub.docker.com/r/mliszcz/mtango/>

**Initialization of the TangoJS framework**. \quad
Before TangoJS can be used, a connector needs to be configured. This can be done
immediately after the required objects are loaded. To instantiate mTango Connector
one has to supply the address of the server-side API endpoint and authentication
credentials. This process is shown on [@Lst:03-tangojs-mtango-connector]. To
avoid hardcoding the credentials in the application's code one can display a
pop-up window during page loading and ask user for his/her credentials.

```{ #lst:03-tangojs-mtango-connector .html }
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
Listing: Configuring mTango Connector instance.

TangoJS widget's are loaded asynchronously using HTML Imports [@www-w3c-html-imports]. In some
scenarios it is desirable to postpone application's initialization until all
imports are loaded. If the native HTML Imports feature is available in the
browser, a `DOMContentLoaded` event indicates that all imports have been resolved.
In cases where the webcomponents.js polyfill[^foot-wc-poly] is being used, one
has to wait for a `HTMLImportsLoaded` event instead. The complete TangoJS Panel
application initialization procedure covering both cases is shown in
[@Lst:03-tangojs-initialization].

[^foot-wc-poly]: <https://www.webcomponents.org/polyfills#html-imports-polyfill>

```{ #lst:03-tangojs-initialization .html }
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
Listing: TangoJS Panel delayed initialization.

**State handling and widget rendering**. \quad
In applications based on Flux architecture, any changes to the state are
performed in a central *store*. If necessary, these changes can result in view
updates. These assumptions impact on how actions propagate in the TangoJS Panel
application.

The basic use case for the TangoJS Panel is a widget addition. When the user
selects an object from TangoJS Device Tree widget in the application's menu,
an apropriate action is sent to the store. As a result of this action, store
updates the application's state. This change causes the WidgetSelector component
to be rendered. Later, when the user selects the desired widget to represent
his/her object, another action is sent to the store. This new action causes
widget creation and rendering it on the Dashboard. The whole scenario is shown
in a sequence chart in [@Fig:03-tangojs-panel-flow].

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
This is done with the help of the `attributes` property of widget's constructor.
The example code responsible for setting these properties on TangoJS Trend widget is
shown in [@Lst:03-tangojs-widget-props]. TangoJS Panel application can access
these values using `window.tangojs.web.components['tangojs-trend'].capabilities`
and `window.tangojs.web.components['tangojs-trend'].attributes`.


```{ #lst:03-tangojs-widget-props .html }
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
Listing: Metadata attached to the widget's constructor during widget's registration.

# Deployment strategies for TangoJS applications

An important advantage of the web applications over the desktop applications
is the ease of deployment. End users access the application that is stored on
a remote server. The only requirement on the client side is a web browser.
Developers and administrators can easily push a new version to the server and
users always access the up-to-date application. This is especially important in
the large-scale deployments, like corporate intranets or control rooms in
scientific facilities, where the application has to be delivered to tenths of
users.

In case of the TangoJS Panel application deployment planning a few aspects have
to be considered. The existing Tango installation needs to be accessible from
TangoJS backend server. The backend server should also have access to some sort
of users' directory, like e.g. LDAP. This is needed for authentication and
authorization purposes. mTango can be used on the server side to perform these
tasks. The Panel application communicates with mTango via AJAX calls. Although
mTango is released with an embedded Tomcat servlet container, a separate
container offers greater flexibility and better configuration options.

The frontend part, which is a TangoJS Panel application itself, has to be
stored in a ordinary web server. Since no server-side processing is required,
any server can be used. Possible examples are Apache, nginx or Node.js-based
`http-server` package.

Zipping together a web server, a servlet container and (optionally) a Tango
database with an example device requires using tools for service orchestration.
These tools are discussed later in this section.

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

TangoJS project offers Docker images with mTango and Tango itself. The images
require zero configuration and are designed for instant TangoJS deployment.
The Tango image[^docker-tangocs] is available in the registry as
`tangocs/tango-cs`. The mTango image[^docker-mtango] is available as
`mliszcz/mtango`.

[^docker-tangocs]: <https://hub.docker.com/r/tangocs/tango-cs/>
[^docker-mtango]: <https://hub.docker.com/r/mliszcz/mtango/>

TangoJS Panel application is straightforward to install, as the only
requirement is a static web server. Since it is a Node.js project, one can
use npm to pull the dependencies in a production environment and run the
application directly from a git checkout. A simple Node.js-based web server can
be used instead a full-blown solution like the Apache server.
The Dockerfile (based on the tiny Alpine linux) which can be used to start the
TangoJS Panel application is shown on [@Lst:03-tangojs-alpine-dockerfile].
This Dockerfile can be built and started using the usual `docker build` and
`docker run` commands.

```{ #lst:03-tangojs-alpine-dockerfile .dockerfile }
FROM alpine:edge

RUN  apk add --no-cache git nodejs nodejs-npm \
  && git clone --depth 1 -b master https://github.com/mliszcz/tangojs-panel-obsolete /tangojs-panel \
  && cd /tangojs-panel \
  && npm install \
  && npm prune --production \
  && npm install --no-save http-server \
  && apk del git nodejs-npm

EXPOSE 8080

CMD /tangojs-panel/node_modules/.bin/http-server /tangojs-panel
```
Listing: A Dockerfile with the TangoJS Panel application.

It is possible to try the TangoJS Panel application without an existing Tango
and mTango installation. One can replace the mTango Connector with a mocked
in-memory connector implementation[^foot-tangojs-connector-mock].

[^foot-tangojs-connector-mock]: <https://github.com/tangojs/tangojs-connector-local>

## Service orchestration

To efficiently manage three (or even four if one separates TangoTest device
from Tango database server) containers described in the previous section, an
orchestration tool is required. The Docker Compose[^foot-docker-compose], a
community project which recently became an official part of Docker, has been
designed to address this problem.

[^foot-docker-compose]: <https://docs.docker.com/compose/>

Docker Compose allows to define containers, dependencies, network links
and mount points using a convenient YAML file.
This file together with all other artifacts required to run the TangoJS Panel
application together with a minimal Tango installation are available at TODO [].
A Docker Compose file with Tango, MySQL database and mTango has been created
during TangoJS development and is available online[^foot-tango-workspace].
One can add a new entry in the `services` section of `docker-compose.yml` file
in order to  automatically start TangoJS Panel together with other services.
Assuming that TangoJS Panel Dockerfile is named `Dockerfile.tangojs-panel`, the
Docker Compose service could be defined as shown on
[@Lst:03-tangojs-docker-compose]. mTango service will be available for TangoJS
Panel under the `mtango.workspace` hostname.

[^foot-tango-workspace]: <https://github.com/mliszcz/tango-workspace>

```{ #lst:03-tangojs-docker-compose .yaml }
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
Listing: TangoJS Panel application configured as a Docker Compose service.

When the administrator runs the `docker-compose up` command, an image with
TangoJS Panel application will be created from the Dockerfile shown on
[@Lst:03-tangojs-alpine-dockerfile].
Other images, like the Tango database, TangoTest device or
mTango server will be pulled from the Docker registry. TangoJS Panel application
will be available at `http://{container-ip}:8080` address immediately after
start of all the services.

# Summary

TangoJS allows building Tango client applications with standard front-end
technologies like HTML, CSS and Javascript. It gives Tango developers a complete
set of tools and APIs required for this task. There is a minimal set of
dependencies required.

TangoJS is *compliant with the latest web standards*, which makes
it attractive for developers and allows to keep the codebase clean and
maintainable. *Use of Web Components* [@www-w3c-webcomponents] technology and
*framework-less architecture* enables *many integration options* between TangoJS
and other frontend libraries. *Modular design* and well-defined interfaces
allow developers to easily swap TangoJS modules, e.g. the backend module.

TODO: jakie rozwiazania sie sprawdzily, jakie nie, itp

TangoJS framework was designed to facilitate the creation of web-based client
applications for Tango Control System. In this paper we showed how TangoJS can
be used to build a dynamic control panel, the TangoJS Panel application.
It is a fully functional synoptic panel suitable for visualization of devices of
any kind. This application allows users and developers new to the TangoJS
immediately try the framework.

Although the Preact framework was used during this case study, TangoJS can be
easily integrated with any other frontend framework. TangoJS does not enforce
any specific technology stack or development style.

As TangoJS Panel can be configured to either work with an existing Tango
infrastructure or use an in-memory mocked database, it is suitable for both
demonstrational purposes and production grade deployments. We showed how Docker
and Docker Compose can be used to automate the configuration and deployment in
both cases.

# References

<div id="refs"></div>

