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


* SarDemo
* screenshot + functionality

## TangoJS introduction

TangoJS framework takes a novel approach to address the problem of integrating
Tango Controls with web browser environments.

* blah blah blah copy paste from thesis, Ch. 4.

## Interactive synoptic panel

## Deployment

* tango container
* mTango container
* app repository + deployed online version

# Summary

* work summary
