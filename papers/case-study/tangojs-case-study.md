---
title: A case study of a web-based control panel with TangoJS
subtitle: subtitle
author:
    - Michał Liszcz
    - Włodzimierz Funika
date: 12.03.2017
geometry: margin=6em
header-includes:
    - \usepackage{mathrsfs}
    - \usepackage{amssymb}
    - \usepackage{empheq}
    - \usepackage{braket}
    - \usepackage{empheq}
    - \usepackage{graphicx}
    - \usepackage{float}
    - \usepackage{color}
    - \usepackage{listings}
    - \usepackage{gensymb}
    - \usepackage{caption}
    - \usepackage{subcaption}

abstract: >
  The Tango Controls is SCADA software widely used in science and industry.
  As it is based on CORBA, the developers cannot build control applications
  using web technologies. Recently the TangoJS project has been developed as
  an attempt to integrate Tango with web browsers.
  This paper presents a case study that demonstrates the process of building
  a web-based control panel application using TangoJS. Lightweight frontend
  technology stack has been paired with TangoJS to build interactive synoptic
  panel similar to existing desktop solutions. The application is deployed
  in a production environment using Docker containers.
---

# Introduction

Conducting an experiment in a scientific facility requires orchestration of
multiple hardware components, like motors, pumps and power-supplies.
Hardware operators use various software systems that facilitate this task.
One of such systems is Tango Controls [], a generic framework for building
SCADA [] software, developed at ESRF synchrotron radiation facility.

Tango is a distributed system built on top of CORBA [] and ZeroMQ []. Each
physical piece of hardware is represented by a *device server*, that has
some parameters (*attributes*) and can perform some actions (*commands*).
Device servers are registered in a MySQL database.
Hardware operators use graphical client applications that can access device
servers running on remote machines using standard IIOP protocol [].
The client applications can be created using languages like C++, Java or
Python, but due to dependency on CORBA, these applications cannot run inside
a web browsers.

There were many attempts to create web-based client applications for Tango,
including Canone [], GoTan [], Taurus Web [] and mTango []. Only mTango is
being actively developed, but most of development effort is put into the server
part. In [praca mgr] a modular web frontend framework for Tango, the TangoJS,
has been presented. In this paper we show how to use TangoJS to develop a
web-based control panel application.

# Building a web-based control panel

In the following sections we formulate the requirements for a dynamic control
panel application, provide a brief introduction to TangoJS, present selected
aspects of development process and give an overview of possible deployment
options.

## Goal setting and requirements analysis

The application described in this work is inspired by the SarDemo project,
which is often used to demonstrate the abilities of the Sardana toolset []
on desktop installations of Tango. The main view of SarDemo's user interface
is shown on Fig. []. It is a dashboard where the user can place multiple
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
application development. The library offers counterparts of most popular widgets
from the Taurus framework on desktops. Each widget can represent one or more
attributes or commands of a device, e.g. the *tangojs-line-edit* widget is an
textbox which allows one to view and change the value of an attribute. The
widgets use a set of W3C standards known under a common name as the *Web
Components* []. From the developer point of view, these widgets behave like
native web controls, e.g. an *input* or a *button*.

TangoJS widgets are usually bound to a model, which can be a Tango device,
device's attribute or a command. Each widgets periodically pollis the
underlying model and update its layout basing on the changes in the model.
Examples of such widgets are `tangojs-label`, `tangojs-line-edit`,
`tangojs-command-button`, `tangojs-state-led`, `tangojs-trend`, or
`tangojs-form`. One widget that differs from the others is the
`tangojs-tree-view`. It is not bound to any model. Instead it visualizes all
models defined in the Tango database using a tree-like structure.

In TangoJS Panel application the user should be able to freely choose widgets
suitable to visualize his/her devices. All TangoJS widgets which are available
in the TangoJS WebComponents module have their constructor functions attached
to the `window.tangojs.web.components` global object. Each constructor has a
static property `capabilities` which describes what kind of models (devices,
attributes or commands) the widget can visualize. Given a set of models, the
Panel application can use these capabilities to find the most suitable widgets.
Apart from capabilities, each constructor exposes the `attributes`
property, which describes all configurable HTML attributes of the widget. Each
attribute is characterized by a name, a data type and a default value.

## Interactive synoptic panel development

This chapter describes the design and development process process of the TangoJS
Panel application. First a technology stack is defined. Then obverall
architecture of the solution is discussed. Finally, the most important aspects
of implementation are covered.

### Software stack

TangoJS is just a set of APIs and widgets. To build a real application,
other technologies have to be incorporated. TangoJS provides widgets that
behave like ordinary HTML elements. This allows for a seamless integration
of TangoJS with any web framework.
It's up to the developer to decide if he/she creates the application using
Angular [], React [] or with raw DOM APIs.

Among all frontend frameworks the Facebook's React is often choosen by the
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
Panel we have choosen Redux [], as it integrates easily with Preact.

### Application architecture

The application has a standard React-Redux architecture. The state (or store)
contains both the domain-specific parts like list of visible widgets and the
ordinary UI state, like indication that modal window is visible. The read-only
state is passed to the *presentational components* [], which build the
application's UI. The components trigger various actions that are dispatched
back to the store.

There are just three *presentational components*, the `Dashboard`, the
`Menu` and the `WidgetSelector`. Each has a corresponding *container component*
defined that maps the state to component's properties. These components are
combined into the `Application` component.

The `Dashboard` component is a thin wrapper around `react-grid-layout`
component []. Its purpose is to visualize TangoJS widgets on a grid with draggable
and resizable elements. It is responsive and different layouts can be used for
differens screen sizes.

The `Menu` is a sidebar that contains `tangojs-tree-view` widget and additional
controls for interacting with the device tree. The user can use this tree to
browse all objects stored in the Tango database. When he/she selects a desired
object, he can create widget to visualize it on the `Dashboard`.

The `WidgetSelector` is a modal window (built with `react-modal` []) that is
triggered when the user chooses a device, an attribute or a command from the
`Menu`. `WidgetSelector` uses the *capabilities* property defined on each
TangoJS widget to determine widgets suitable for visualizing selected object.
When the user selects the desired widget, a dynamic form with configurable
attributes of this widget is generated using the `react-jsonschema-form`
component [].

All the components and interactions between them are presented on Fig. [].

*Fig. ?: Application architecture.*

### Selected aspects of implementation

TODO

## Deployment

An important advantage of web applications over desktop applications is the ease
of deployment. Users access the application stored on a server. Thus, the only
requirement on client side is a web browser. Served application is always
up-to-date. This is especially important in large-scale deployments, like
applications for use in big companies or scientific facilities.

In case of the TangoJS panel application, apart from Tango installation, a
two separate parts have to be considered during deployment planning: the mTango
server and the application itself.

The application is a bunch of static HTML files and other resources, like JS
scripts or CSS stylesheets. It can be stored on an ordinary web server, like
Apache. No server-side procesing is involved.

The application communicates with mTango via AJAX calls. Although mTango is
released with an embedded Tomcat servlet container, a separate container
gives the administrators a greater flexibility and better configuration
options.

Zipping together a web server, a servlet container and (optionally, for
demonstration purposes) a Tango database server with TangoTest device
requires using tools for configuration management (???) and service
orchestration, widely adopted and popular in DevOps culture.

### Containerizing applications

A popular tool that provides isolated, repeatable environments for running
applications is Docker. Docker uses LXC containers[], cgroups[] ando other
Linux kernel features to isolate processes from the host operating system and
to restrict the resources available to these processes.

Docker instantiates containers from images. Image definitions are stored in
plaintext Dockerfiles. Dockerfile contains instructions required to build a
minimal operating system image required to run desired application. An online
service, called DockerHub[] can be used to publish and share ready images.

As an additional outcome of the TangoJS project, Docker images with mTango and
Tango itself have been developed. The Tango image[] is available in
Docker registry as `tangocs/tango-cs`. The mTango image[] is available as
`mliszcz/mtango`.

TangoJS Panel application is straightforward to install, as the only requirement
is a web server. Since it is a Node.js project, we can leverage npm to pull the
dependencies on a production server and run directly from a git checkout. Also,
a simple web server running on Node.js can be used instead a full-blown Apache
solution. The Dockerfile (based on tiny Alpine linux) with TangoJS Panel
applications is shown on [].

```Dockerfile
FORM alpine
```

### Service orchestration

To efficiently manage three (four if we separate TangoTest from DatabaseDs)
containers described in previous section, an orchestration tool is required.
The Docker Compose, a community project which recently became an official Docker
part, has been designed to address this problem.

Docker Compose allows one to define containers, dependencies between them,
network links and mount points using convenient YAML file.
A popular tools suitable for this tasks and widely adopted in DevOps culture
are Docker[] and Docker Compose[]. Docker uses LXC containers[], cgroups[] and
other Linux kernel features to provide isolated, repeatable environments for
running applications. The Docker Compose, a community project which recently
became an official Docker part, allows for orchestration of multiple Docker
containers.

The containers, dependencies between them and network links are defined in a
convenient YAML file. Definitions required to run TangoJS Panel application are
shown on []. After running:

`docker-compose up`

TangoJS Panel image will be built from `Dockerfile` in current directory whereas
images with Tango and mTango will be pulled down from Docker registry.

### Securing the application

The further work is to make the application secureDefinitions required to run
TangoJS Panel application are
shown on []. After running:

`docker-compose up`

TangoJS Panel image will be built from `Dockerfile` in current directory whereas
images with Tango and mTango will be pulled down from Docker registry.

### Securing the application

The final part of the work before moving to production is to harden/enforce/made(?)
the application secure. This includes adding encryption on the HTTP interfaces
of TangoJS Panel and mTango and providing better authentication mechanism on
mTango side, instead of hardcoded credentials.

# Summary

link to online version of the app

link to the repo

TODO
