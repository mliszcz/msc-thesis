---
title: A case study of a web-based control panel built with TangoJS
title-short: TangoJS Case Study
author: Michał \surname{Liszcz}, Włodzimierz \surname{Funika}
author-short: M. Liszcz, W. Funika
affiliation: AGH UST
keywords: SCADA, web, browser, Javascript, Tango, HTML, CORBA, REST
mathclass: AB-XYZ
bibliography: ../../thesis/build/references.bib
link-citations: true
lof: false
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
object that can be accessed from client applications over the network.
Tango embraces OOP paradigm, characterizing devices with *attributes*
(parameters of the hardware), *commands* (actions the hardware can perform)
and *properties* of the device server itself. Tango
supports creating client applications in **Java**, **Python** and **C++**.
Tango's middleware layer is built on top of
CORBA [@www-corba; @www-corba-spec; @natan1995] and ZeroMQ [@www-zeromq].
A central MySQL database [@tools-mysql] is
used to store all registered devices and their configuration. An overview of
Tango architecture is depicted in [@Fig:01-tango-architecture].

![TANGO Control System architecture overview.](
  ../../../thesis/figures/uml/01-tango-architecture.tex){
  #fig:01-tango-architecture width=80% }

During the years of development, Tango has been also widely adopted in the
automation industry and gained popularity in the community, who contribute
a lot of tools and utilities related to the Tango project.
The core Tango is a free and open source software, released under GPLv3
license.

# Web-based control applications

Motivations TODO

## Related work

There were many attempts to create web-based client applications for Tango,
including Canone [], GoTan [], Taurus Web [] and mTango []. Only mTango is
being actively developed, but most of the development effort is put into the server
part. In [praca mgr] a modular web frontend framework for Tango, the TangoJS,
has been presented. In this paper we show how to use TangoJS to develop a
web-based control panel application.

## TangoJS introduction

TangoJS allows building Tango client applications with standard front-end
technologies like HTML, CSS and Java. It gives Tango developers a complete set
of tools and APIs required for this task. There is a minimal set of dependencies
required.

TangoJS has been designed to be a modular ecosystem - one includes only the
modules one needs and configures everything according to the project
requirements. There are three separate layers, which are connected via
well-defined interfaces.

**TangoJS Core** is a Javascript API for programmatic interactions with Tango
from a web browser. It has been partly generated from Tango IDL [], which makes
its interface familiar to the Tango developers.

**TangoJS Connector** is an interface that abstracts-out communication with
Tango infrastructure via pluggable backend services. mTango can be used on the
server side as a RESTful endpoint used to access a existing Tango installation.

**TangoJS WebComponents** is a collection of standalone widgets useful for rapid
application development. The library offers counterparts of the most popular widgets
from the Taurus framework on desktops. Each widget can represent one or more
attributes or commands of a device, e.g. the *tangojs-line-edit* widget is an
textbox which allows one to view and change the value of an attribute. The
widgets use a set of W3C standards known under a common name as the *Web
Components* []. From the developer point of view, these widgets behave like
native web controls, e.g. an *input* or a *button*.

TangoJS widgets are usually bound to a *model*, which can be a Tango device,
device's attribute or a command. Each widget periodically polls the
underlying model and updates its layout basing on the changes in the model.
Examples of such widgets are `tangojs-label`, `tangojs-line-edit`,
`tangojs-command-button`, `tangojs-state-led`, `tangojs-trend`, or
`tangojs-form`. One widget that differs from the others is the
`tangojs-tree-view`. It does not represent a particular model. Instead it
visualizes all the objects defined in the Tango database using a tree-like
structure.

All TangoJS widgets which are available in the TangoJS WebComponents module
have their constructor functions attached to the
`window.tangojs.web.components` global object. Each constructor has a
static property `capabilities`, which describes what kind of models (devices,
attributes or commands) the widget can visualize.
Apart from the capabilities, each constructor function exposes the `attributes`
property, which describes all the configurable HTML attributes of a widget. Each
HTML attribute is characterized by a name, a data type and a default value.


# Building a web-based control panel

In the following sections we formulate the requirements for a dynamic control
panel application, provide a brief introduction to TangoJS, present selected
aspects of development process and give an overview of possible deployment
options.

## Goal setting and requirements analysis

The demo application described in this work is inspired by the SarDemo project,
which is often used to demonstrate the abilities of the Sardana toolset []
on desktop installations of Tango. The main view of SarDemo's user interface
is shown in Fig. []. It is a dashboard where the user can place multiple
widgets representing the attributes and commands of various devices.

*Fig. ?: SarDemo user interface.*

A similar application for TangoJS, the *TangoJS Panel*, will help TangoJS
project to gain popularity in the Tango community. The users should be able
to test TangoJS widgets with their own Tango installation. The Panel
application needs to be easy to deploy and should require zero configuration.
A set of functional requirements was formulated as a guidance for development
process. The user should be able to:

* use Panel application with his own Tango installation (and mTango on server
  side),
* browse all device servers defined in the database,
* create interactive widgets for selected attributes of the devices,
* place the widgets on a dashboard and move them around,
* save and restore the layout of the dashboard.

The web technologies are the best choice for creating dashboard-like layouts.
TangoJS paired with a lightweight frontend framework will allow to address
goals formulated above with minimal effort required.
Technical details of implementation and architectural considerations are
described later in this section.

## Interactive synoptic panel development

In this chapter we describe the design and development process process of the
TangoJS Panel application. First a technology stack is defined. Then the overall
architecture of the solution is discussed. Finally, the most important aspects
of implementation are covered.

## Software stack

TangoJS is just a set of APIs and widgets. To build a real application,
other technologies have to be incorporated. TangoJS provides widgets that
behave like ordinary HTML elements. This allows for a seamless integration
of TangoJS with any web framework.
It's up to the developer to decide if he/she creates the application using
Angular [], React [] or with raw DOM APIs.

Among all frontend frameworks the Facebook's React is often chosen by the
developers to create web applications of any scale. Although it comes with some
controversial features like the JSX (which, when used, requires
transcompilation), and is heavyweight with all its dependencies [], a
stripped-down fork called Preact [] is availabe. It offers API compatibility
with React, but is much smaller in size (due to the limited support of legacy
browsers). Preact contains everything what is required to build highly reactive
applications including stateless (functional) components, and unidirectional
data flow.

React on its own is merely a presentation layer, that can be used to create
*views*. For most real-world applications, like the TangoJS Panel, a state, or
a data *model*, needs to be introduced. While it is possible to represent the
state as a bunch of variables scattered accross the codebase, mutating these
variables from different places is error prone, hard to test and hard to
maintain. To address this problem, Facebook proposed the Flux architecture [].
In Flux, the state is stored in a central place, called *store*. Various
*actions* can change the state, but these changes always happen inside the store
in a well-defined order. The store acts as a *single source of truth* [] for an
application. Only changes in the store can result in UI updates. There are many
implementations of Flux architecture, all offer some sort of predictable state
container that can transform under a stream of events. For building TangoJS
Panel we have chosen Redux [], as it easily integrates with Preact.

## Application architecture

The application follows a standard React-Redux architecture. The state (or store)
contains both the domain-specific parts like list of visible widgets and the
ordinary UI state, like indication that a modal window is visible. The read-only
state is passed to the *presentational components* [], which the
application's UI is composed of. The components trigger various actions that are dispatched
back to the store.

There are just three *presentational components*, the `Dashboard`, the
`Menu` and the `WidgetSelector`. Each has a corresponding *container component*
[] defined that maps the global application's state to component's properties. These container
components are combined into the `Application` component.

The `Dashboard` component is a thin wrapper around the `react-grid-layout`
component []. Its purpose is to visualize TangoJS widgets on a grid with
draggable and resizable elements. It is responsive and different layouts can
be used for differens screen sizes.

The `Menu` is a sidebar that contains `tangojs-tree-view` widget and additional
controls for interacting with the device tree. The user can use this tree to
browse all objects stored in the Tango database. When he/she selects a desired
object, he/she can create a widget to visualize this object on the `Dashboard`.

The `WidgetSelector` is a modal window, built with `react-modal` [], that is
displayed when the user chooses a device, an attribute or a command from the
`Menu`. `WidgetSelector` uses the *capabilities* property of each possible
TangoJS widget to determine which widget is the most suitable to visualize
the selected objects. When the user selects the desired widget, a dynamic form
with all configurable HTML attributes of this widget is generated using the
`react-jsonschema-form` component [].

The bootstrapping code fetches Tango database address from query string,
configures an appropriate TangoJS Connector and initializes the application
inside the HTML document's body. All the components and interactions between
them are presented on Fig. [].

*Fig. ?: Demo application architecture.*

## Selected aspects of implementation

The example dashboard of a complete application is shown in Fig. []. An online
demo is available at <https://mliszcz.github.io/(...)>. The source code can be
cloned from the repository [^app-repo]. This section describes the most
important aspects of the implementation.

[^app-repo]: <https://github.com/mliszcz/tangojs-panel>

### Initialization of the TangoJS framework

### Interacting with `tangojs-tree-view` from a React application

### Inspecting widgets and rendering widget configuration form

# Deployment strategies

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

