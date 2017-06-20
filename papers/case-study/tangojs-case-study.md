---
title: A case study of a web-based control panel built with TangoJS
title-short: TangoJS Case Study
author: Michał \surname{Liszcz}, Włodzimierz \surname{Funika}
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

## Tango Controls

Tango [@gotz1999tango] is a generic framework for building SCADA systems.
Each piece of hardware is represented as a *device server*, an abstract
object that can be accessed from the client applications over the network.
Tango uses OOP paradigm for it's data model and characterizes devices with
*attributes* (parameters of the hardware), *commands* (actions the hardware
can perform) and *properties* of the device servers. Tango
supports creating client applications in *Java*, *Python* and *C++*
languages. Tango's middleware layer is built on top of
CORBA [@www-corba; @www-corba-spec; @natan1995] and ZeroMQ [@www-zeromq].
A central MySQL database [@tools-mysql] is used to store all registered devices
and their configuration. An overview of Tango architecture is depicted in
[@Fig:01-tango-architecture].

![TANGO Control System architecture overview.](
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

## Related work

There were many attempts to create web-based client applications for Tango,
including Canone [@pelkocanone07; @www-canone], GoTan [@gotan2012], Taurus Web
[@taurusweb2013,] and mTango [@mtango2016]. Each of these systems has it's
unique properties, advantages and drawbacks ([@liszcz-msc-thesis-tangojs],
p. 19). These days only mTango is being actively developed, but most of the
development effort is put into the backend part.

In [@liszcz-msc-thesis-tangojs] a modular web frontend library for Tango,
the TangoJS, has been presented. *In this paper we provide an overview of
TangoJS and show how to use it to develop a web-based control panel
application.*

## TangoJS introduction

TangoJS allows building Tango client applications with standard front-end
technologies like HTML, CSS and Javascript. It gives Tango developers a complete
set of tools and APIs required for this task. There is a minimal set of
dependencies required.

TangoJS' design goals address the issues where the existing solutions have
failed. The goals are mostly related to the technological aspects of
implementation. TangoJS is *compliant with the latest web standards*, which makes
it attractive for developers and allows to keep the codebase clean and
maintainable. *Use of Web Components* [@www-w3c-webcomponents] technology and
*framework-less architecture* enables *many integration options* between TangoJS
and other frontend libraries. *Modular design* and well-defined interfaces
allow developers to easily swap TangoJS modules, e.g. the backend module.
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
used to demonstrate the abilities of the Sardata toolset []
on desktop installations of Tango. A similar application available for TangoJS
will help this project gain more popularity within the Tango community.
The users should be able to test TangoJS widgets with their own Tango
installations. The TangoJS Panel application needs to be easy to deploy and
should require zero configuration.

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
described later in the following sections.

![TangoJS Panel application's main view.
](../figures/images/03-tangojs-panel-01-fixed.png){#fig:03-tangojs-panel-01 width=50%}

## TangoJS from developer's perspective

TangoJS framework it targeting software developers as it's end users.
Most of the time the developers interact either with the Core module or the Web
Components module. The Connector module is an implementation detail transparent
to the developers and it's configuration depends on environment.

TangoJS has been designed to *minimize dependencies on third party code* and use
the *latest web standards*, like HTML5, CSS Level 3 modules or ECMAScript 2016.
The standard solutions rarely become deprecated. Instead, they evolve
gradually, which makes easy to keep the project up-to-date. These technologies
are already implemented in all modern browsers, thus no transcompilation is
required. To start using TangoJS, the developer should be familiar with Tango
and know the basic web-development concepts and techniques.

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
[@Lst:03-widget-instantiation-js]. Apart from the imperative access, there is
also a way to create widgets declaratively, by simply putting a desired tag
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
characterized by a name, a data type and a default value.

## Control panel application - software stack

TangoJS is just a set of APIs and widgets. To build a real application,
other technologies have to be incorporated. TangoJS provides widgets that
behave like ordinary HTML elements. This allows for a seamless integration
of TangoJS with any web framework.
It's up to the developer to decide if he/she creates the application using
Angular [@www-angular; @darwin2013angularjs], React [@www-react] or just
plain DOM APIs.

Among all frontend frameworks the Facebook's React is often chosen by the
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
*views*. For most real-world applications, like the TangoJS Panel, a state, or
a data *model*, needs to be introduced. While it is possible to represent the
state as a bunch of variables scattered accross the codebase, mutating these
variables from different places is error prone, hard to test and hard to
maintain. To address this problem, Facebook proposed the *Flux architecture*
[@www-flux].
In Flux, the state is stored in a central place, called *store*. Various
*actions* can change the state, but these changes always happen inside the store
in a well-defined order. The store acts as a *single source of truth* for an
application. Only changes in the store can result in UI updates. There are many
implementations of Flux architecture, all offer some sort of *predictable state
container* that can transform under a stream of events. For building TangoJS
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

The bootstrapping code fetches Tango database address from browser's query
string, configures an appropriate TangoJS Connector and initializes the
application inside the HTML document's body. Top level components of TangoJS
Panel application and interactions between the are presented in
[@Fig:03-tangojs-panel-arch]. These components can be further divided into
smaller units of functionality, like functions or classes.

## Control panel application - selected aspects of implementation

This section covers the most important aspects of the implementation, including
backend configuration, TangoJS initialization, Preact/Redux-based state
maintenance and dynamic widget discovery. Complete source code of the TangoJS
Panel application is available online[^foot-app-repo].

[^foot-app-repo]: <https://github.com/mliszcz/tangojs-panel>

**mTango configuration**. \quad
TangoJS Panel application uses mTango server to access the Tango infrastructure.
mTango requires some initial configuration to handle requests from TangoJS.

* TangoJS Panel can be deployed in a different domain (*origin*), thus mTango
needs to be configured to accept cross-domain connections. CORS[^foot-cors]
requests can be enabled in most servlet containers using configuration files.
There's no need to change application's code.

[^foot-cors]: Cross Origin Resource Sharing

* *TangoJS mTango Connector* uses HTTP basic authentication and such method
should be supported by the mTango server. Most servlet containers allow one to
configure such authentication with differen backends, e.g. a fixed list of users,
a database or a LDAP directory.

A preconfigured mTango REST server is available in a Docker container
[^foot-mtango-docker]. This container has been created during the TangoJS
development. It may be used with the existing Tango deployment.

[^foot-mtango-docker]: <https://hub.docker.com/r/mliszcz/mtango/>

**Initialization of the TangoJS framework**. \quad
Before TangoJS can be used, a connector needs to be configured. This can be done
immediately after required objects are loaded. To instantiate mTango Connector
one has to supply the address of the server-side API endpoint and authentication
credentials. This process is shown in [@Lst:03-tangojs-mtango-connector]. To
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

TangoJS widget's are loaded asynchronously using HTML Imports []. In some
scenarios it is desirable to postopne application initialization until all
imports are loaded. If native HTML Imports feature is available in the
browser, `DOMContentLoaded` event indicates that all imports have been resolved.
In cases where the webcomponents.js polyfill[^foot-wc-poly] is being used, one
has to wait for `HTMLImportsLoaded` event instead. Complete TangoJS Panel
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
updates the application's state. This change causes WidgetSelector component
to be rendered. Later, when the user selects the desired widget to represent
his/her object, another action is sent to the store. This new action causes
widget creation and rendering it on the Dashboard. The whole scenario is shown
in a sequence chart in [@Fig:03-tangojs-panel-flow].

![Sequence of actions resulting in widget creation.
](../figures/uml/03-tangojs-panel-flow.tex){#fig:03-tangojs-panel-flow width=100%}

**Discovering available widgets**. \quad

# Deployment strategies for TangoJS applications

An important advantage of the web applications over the desktop applications
is the ease of deployment. End users access the application that is stored on
a remote server. The only requirement on the client side is a web browser.
Developers and administrators can easily push a new version to the server and
users always access the up-to-date application. This is especially important in
the large-scale deployments, like corporate intranets or control rooms in
scientific facilities, where the application has to be delivered to tenths of
users.

In case of the TangoJS Panel application deployment planning a few aspect have
to be considered. The existing Tango installation needs to be accessible from
TangoJS backend server. The backend server should also has access to some sort
of users' directory, like e.g. LDAP. This is needed for authentication and
authorization purposes. mTango can be used on server side to perform these
tasks. The Panel application communicates with mTango via AJAX calls. Although
mTango is released with an embedded Tomcat servlet container, a separate
container gives offers greater flexibility and better configuration options.

The frontend part, which is a TangoJS Panel application itself, has to be
stored in a ordinary web server. Since no server-side processing is required,
any server can be used. Possible examples are Apache, nginx or Node.js-based
`http-server` package.

Zipping together a web server, a servlet container and (optionally) a Tango
database with an example devic requires using tools for service orchestration.
These tools are discussed later in this section.

## Containerizing applications

Docker [] is a popular tool that provides isolated, reproducible environments
for running applications. Docker uses LXC containers [], cgroups [] and other
Linux kernel features to isolate processes from the host operating system.
A fine-grained management of available resources like fileststems and networks
is possible for Docker *containers*.

Docker instantiates containers from *images*. Image definitions are stored in
plaintext *Dockerfiles*. Dockerfile is a recipe that describe steps required to
build a minimal filesystem required to run the desired application.
An online service, called DockerHub [], can be used to publish and share
Docker images.

TangoJS project offers Docker images with mTango and Tango itself. The images
require zero configuration and are designed for instant TangoJS deployment.
The Tango image [^docker-tangocs] is available in the registry as
`tangocs/tango-cs`. The mTango image [^docker-mtango] is available as
`mliszcz/mtango`.

[^docker-tangocs]: <https://hub.docker.com/r/tangocs/tango-cs/>
[^docker-mtango]: <https://hub.docker.com/r/mliszcz/mtango/>

TangoJS Panel application is straightforward to install, as the only
requirement is a static web server. Since it is a Node.js project, we can
use npm to pull the dependencies on a production server and run directly from
a git checkout. A simple Node.js-based web server can be used instead a
full-blown solution like the Apache
The Dockerfile (based on tiny Alpine linux) with TangoJS Panel application is
shown on Lst. [].

```Dockerfile
FROM alpine:edge

RUN  apk add git nodejs \
  && git clone https://github.com/mliszcz/tangojs-panel /tangojs-panel \
  && cd /tangojs-panel \
  && npm install

EXPOSE 8080

CMD cd /tangojs-panel && npm run server
```

*Lst. ?: A Dockerfile with TangoJS application.*

## Service orchestration

To efficiently manage three (or even four if we separate TangoTest device from
Tango database server) containers described in the previous section, an
orchestration tool is required. The Docker Compose [], a community project
which recently became an official part of Docker, has been designed to address
this problem.

Docker Compose allows one to define containers, dependencies, network links
and mount points using convenient YAML file.
This file together with all other artifacts required to run the TangoJS Panel
application together with a minimal Tango installation are available at [].
When the administrator runs `docker-compse up` command, an image with TangoJS
Panel application will be created from the Dockerfile shown in the previous
section. Other images, like the Tango database, TangoTest device or mTango
server will be pulled down from the Docker registry. TangoJS Panel application
will be available at `http://{container-ip}:8080` immediately after the start
of the cluster.

# Summary

The approach described in this work proved that the framework-less TangoJS can
easily be integrated with any frontend framework. The was Preact was used in
this case study, but use of other technologies is possible. TangoJS does not
enforce any specific technology stack or development style.

The TangoJS Panel application is a fully functional synoptic panel. It
allows users and developers new to TangoJS immediately try the framework. As it
can be configued with an existing Tango database or use an in-memory mocked
database, it is suitable for demonstrational purposes. When additional security
is added, like configuring web server to work over SSL, the application can also
be used in real-world environments in production-grade deployments.

have been developed [@daneels1999selection]. A common name for these systems is
[@daneels1999scada; @boyer2009].
Tango [@gotz1999tango] is a generic framework for building SCADA systems.
CORBA [@www-corba; @www-corba-spec; @natan1995] and ZeroMQ [@www-zeromq].
A central MySQL database [@tools-mysql] is


# References

<div id="refs"></div>

