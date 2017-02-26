---
title: A case study of a web-based control panel with TangoJS
subtitle: subtitle
author:
    - Michał Liszcz
    - Włodzimierz Funika
date: 20.01.2017
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
  The TANGO Controls is SCADA software widely used in science and industry.
  As it is based on CORBA, developers cannot build control applications using
  web technologies. Recently, the TangoJS project provided a new way for
  integrating TANGO with web browsers. This paper presents a case study that
  demonstrates process of building a web-based control panel application using
  TangoJS. Lightweight frontend technology stack has been paired with TangoJS
  to build interactive synoptic panel inspired by SarDemo, a widget container
  for Tango on desktop. The application is finally deployed in a production
  environment using Docker containers.
---

# Introduction

Conducting an experiment in a scientific facility requires orchestration of
multiple hardware components, like motors, pumps and power-supplies.
Hardware operators use various software systems that facilitate this task.
One of such systems is TANGO Controls [], a generic framework for building
SCADA [] software, developed at ESRF synchrotron radiation facility.

TANGO is a distributed system built on top of CORBA [] and ZeroMQ []. Each
physical piece of hardware is represented by a *device server*, that has
parameters (*attributes*) and can perform some actions (*commands*).
Device servers are registered in a central MySQL database.
Client applications, used by the operators, can access device servers on remote
machines via CORBA protocols. These client applications can be created in C++,
Java or Python, but due to incorporation of CORBA, cannot run inside a web
browser.

There were many attempts to allow building web-based client applications for
Tango, including Canone [], GoTan [], Taurus Web [], mTango [].
In [] the TangoJS project has been presented.
In this paper, we show how to use TangoJS  develop a web-based control panel
application.

# Building a web-based control panel

The following sections
formulate requirements for dynamic control panel application,
provide introduction to TangoJS,
present development process step-by-step
and give an overview of configuration and deployment process.

## Goal setting and requirements analysis

Application presented in this work is inspired by SarDemo, which is often used
to demonstrate abilities of Sardana suite and Taurus widgets. Main SarDemo's UI
is shown on Fig. []. It is a dashboard, where user can place widgets and move
them around. (TODO: more on SarDemo). To help TangoJS gain adoption across
the TANGO community, a similar application has to be created. Users should be
able to test TangoJS widgets with their own TANGO deployment. The
*TangoJS Panel* should be easy to deploy and should require zero-configuration.

*TODO: SarDemo screenshot*

A set of functional requirements was formulated as a guidance for development
process. The user should be able to:

* use panel application with his own mTango installation,
* change the Tango database instance the application is using,
* browse defined device servers,
* create interactive widgets for selected attributes of the devices,
* place widgets on a dashboard,
* move widgets freely over the dashboard,
* save and restore the dashboard layout.

Web technologies are very suitable for creating any kind of dashboard-like
layouts. Pairing TangoJS with a lightweight frontend framework should do the
job perfectly. Technical details of implementation and architectural
considerations are described later in the paper.

## TangoJS introduction

TangoJS framework takes a novel approach to address the problem of integrating
Tango Controls with web browser environments.

* blah blah blah copy paste from thesis, Ch. 4.

## Interactive synoptic panel development

This chapter describes the full design and development process process of a
control panel application. First, a technology stack is defined. Then, overall
architecture of the solution is discussed. Finally, most important aspects of
implementation are presented.

### Software stack

TangoJS is just a set of APIs and widgets. To build a real application,
other technologies has to be incorporated. TangoJS provides widgets that
behave like a ordinary HTML elements. This allows for seamless integration
of TangoJS with any framework.
It's up to the developer to decide if he creates his application using
Angular[], React[] or stick to plain DOM manipulation APIs[].

Among all
frontend frameworks, it is the Facebook's React which gained a lot attention
from developers in recent days. Although it offers some controversal features
like JSX (which implies transcompilation) and is heavyweight with all its
components and dependencies[], a stripped-down version, called Preact[]
is availabe. It contains everything what is needed to build highly reactive
applications including stateless views, functional rendering logic or ???.

React on its own is merely a presentation layer, a *view*. For real application,
like the control panel, a state, or *model*, needs to be introduced. When it
is possible to represent stante as a bunch of variables, mutating them from
different places as a result of various events is error prone, hard to test,
hard to track bugs and hard to maintain. Using predictable state containers
had become popular in recent days. They force developers to perform state
mutations from a centralized place. Such functionality can be implemented by
a developer, but there are existing solutions like [], [] or [], which provide
convenient *reductors*, to predicably transform state under a stream of events.
For building control panel application, we have choosen ???, as it integrates
neatly with React Core.

### Application architecture

TODO

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
