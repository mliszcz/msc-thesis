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
components and dependencies[], a stripped-down version, called React Core[]
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

## Deployment

* tango container
* mTango container
* app repository + deployed online version

# Summary

* work summary
