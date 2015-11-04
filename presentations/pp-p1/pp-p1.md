## Adaptive web user interfaces for TANGO Control System

*MSc thesis, P1*

Michal Liszcz

Supervisor:  
Wlodzimierz Funika

Collaboration:  
National Synchrotron Radiation Centre SOLARIS

2015-11-04

---

## Agenda

0. (Brief) Introduction to TANGO Controls
   0. Core
   0. GUIs
0. Thesis goal
0. Objectives

---

## TANGO

http://www.tango-controls.org/

* A software toolkit for controlling hardware in distributed environment,
* built on top of CORBA,
* with bindings for C++, Java and Python.

Main purpose: controlling accelerator-related systems  
in physics experiments. <!-- .element: style="margin:1.5em" -->

Sites using TANGO:
* ESRF (France), SOLEIL (France), MAX-IV (Sweden), SOLARIS (Poland)
* and many others ...



http://iramis.cea.fr/en/Phocea/Vie_des_labos/Ast/ast_sstechnique.php?id_ast=1776

![](http://iramis.cea.fr/Images/astImg/1776_1.gif)

---

## Tools

* GUI frameworks
  * ATK (Java, Swing)
  * Taurus (Python, Qt)
  * QTango (C++, Qt)
* administrative tools
  * Jive
  * Astor

Applications with specific requirements may be:
* developed from a scratch with above frameworks,
* designed with JDraw (GUI designer),
* designed and modified at runtime with Taurus toolkit



JDraw - drag-and-drop GUI designer:

![](tango9-jdraw.png)



Taurus - *panels* may be modified at runtime:

![](tango9-taurus.png)

---

## Thesis aims

Only desktop client apps are currently supported.

**Main goal:**

### *Move TANGO to the Web*
... and build Taurus-like application for SOLARIS

---

## Why web applications?

* easy to develop,

* cheap to maintain,

* multiplatform,

* available on PCs, tablets, terminals  
  (low deployment cost).

---

## Objectives

0. Find a way to integrate CORBA middleware with browser technologies,

0. Stick to the standard TANGO interfaces (defined in IDL),

0. Design and develop presentation layer:
  * extendable collection of widgets,
  * not tied to any web-framework,

0. Handle communication in a secure way,

0. Become a *de-facto-standard* for developing TANGO
   web-applications.

---

## Thank you

Q&A time.
