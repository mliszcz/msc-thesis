# Introduction

This chapter provides an introduction to the field of research and briefly
describes problems addressed in this thesis. Later on the thesis goals are
formulated.

TODO: tu napisac o aspektach sterowania i ... w zlozonych systemach

## Visualization and control functionality in TANGO Control System

Control of the expensive and sensitive hardware components in large
installations like scientific facilities may be a challenging task. In order to
conduct an experiment, multiple elements like motors, ion pumps, valves and
power-supplies have to be orchestrated. To address this problem, the TANGO
Control System [@gotz1999tango] has been developed at the ESRF synchrotron
radiation facility.

During the years of development, it has been also widely adopted in the
automation industry and gained popularity among the community, who contribute
a lot of tools and utilities related to the TANGO project.
The core TANGO is a free and open source software, released under GPLv3
license.

**What is TANGO?**
TANGO Controls is a distributed system built on top of CORBA and ZeroMQ.
It introduces a concept of *device server* to represent a physical piece of
hardware. This device server is available as a *remote object* that implements
a well defined interface. TANGO is object-oriented middleware, and each device
server is characterized by:

* *name* - an unique string in the form of a `group/family/member`;
* *attributes* - a set of data fields that may be writable or read only,
  e.g a current of a power supply;
* *commands* - a set of actions that device can perform, e.g. a reset action;
* *properties* - a set of parameters not reflected in the hardware, but
  essential to the device server's implementation;

Device servers are distributed by vendors with the hardware or they are created
by the community. The internal implementation, especially how the device server
connects to the hardware, is out of scope of TANGO.

Another important part of TANGO is the database, where the TANGO schema is
stored. This schema keeps information of all the available devices registered
in the system. Client applications use the database for device server discovery.
The database also stores the properties of each device. Device servers and
clients do not access the database directly. Instead, the database is exposed
as a device server, called *DataBaseds*, and interaction is performed using
commands, e.g. there is a command that returns a list of all the registered
device servers or a command that exports a new device.
A MySQL or MariaDB server is required to run TANGO. It is also possible to run
TANGO without a database and with a limited functionality. When high
availability is required TANGO may run in a multi-database configuration
[^01-multi-db].

[^01-multi-db]: http://www.esrf.eu/computing/cs/tango/tango_doc/kernel_doc/ds_prog/node10.html

The hardware is controlled by human operators. They use **graphical client
applications**, that connect to the device servers. Typical tasks include
manipulating device's attributes, observing the status of the hardware and
collecting logs.
Client applications are often dedicated to the hardware they operate on,
but there are also applications where the operator may adapt the interface by
selecting which attributes of which devices he wants to control. The
applications that allow one to control multiple attributes and give an overview
of a set of devices and attributes are called *synoptic panels*.

Although relying heavily on CORBA, TANGO also uses ZeroMQ for **event-based
communication**. There are events that the client registers for, and is
notified whenever the event occurs, e.g. a value of attribute changes
significantly. This allows for efficient communication in scenarios where
client would otherwise constantly poll the device server. Device server
developers may also fire events when server-initiated communication is
required.

The concepts ~~described in this section~~ are just an overview to give the reader
understanding what TANGO is. Providing an extensive description of TANGO is out
of scope of this thesis and some simplifications have been made here. All these
topics are discussed deeply in the TANGO Control System Manual
[@tango2016manual].

**Architecture overview.**
TANGO deployment usually spans over several machines, connected in a network.
There are clients and servers. *Clients* are just terminals that allow operators
to interact with the hardware. *Server* machines are responsible for accessing
the hardware, and they are the place where *device servers* run. A single
machine can host any number of device server instances. The details of
communication are hidden behind the CORBA and TANGO abstractions. Client
application developer may treat the system just as a pool of device servers.

There are some special device servers that do not control any hardware. These
are the above mentioned database device server, the *DataBaseds*, and the
authorization service, the *TangoAccessControl* device server. This
*TangoAccessControl* device server is responsible for user authorization
and offers fine-grained permission control, at a single attribute level.
An overview of the TANGO architecture is depicted in
[@Fig:01-tango-architecture].

TODO: uproscic rysunek (jak?) + wczesniej zdjecie hardwaru

![TANGO Control System architecture overview.](
  figures/uml/01-tango-architecture.tex){
  #fig:01-tango-architecture width=80% }

## TANGO GUI frameworks

The TANGO has been designed to allow uniform access to the hardware resources.
The end-users of TANGO-based software are hardware operators who are
responsible for controlling the hardware during an experiment. They need
reliable and convenient graphical client applications to do their job
effectively.

The TANGO API offers abstractions like *DeviceProxy* or *AttributeProxy* that
allow to access devices programmatically. Using these proxies, a client
application may be built using any technology and language where TANGO is
available, including **C++**, **Java** and **Python**. Most of the client
applications have share a common goals and requirements. They also use common
patterns to fulfill these goals. This raised the need for GUI standardization
and development of universal frameworks that will speed up TANGO client
applications development. The two leading solutions are ATK and Taurus,
discussed below.

**ATK**.
The *Tango Application Toolkit*[@poncet2005atk], ATK, has been developed to
address the need for consistent, easy to develop TANGO GUI applications.
It provides universal *viewers*, for attributes and commands. These viewers
are called widgets nowadays. ATK has been implemented with Java and Swing,
which makes it portable in desktop environments.

ATK uses Model-View-Controller architecture, and is internally divided into
two parts, the *ATKCore*, which offers APIs to access the *models* (e.g.
devices, attributes or commands), and *ATKWidget*, which
is a set of Swing-based viewers. There is also the third component, a graphical
editor called *JDraw*. It provides a way to interactively build a schema of
the system and then attach TANGO models, like commands or attributes, to it.
This schema may be stored in a file and rendered at runtime by ATK as a
*synoptic panel*. The *JDraw* interface is presented in
[@Fig:01-tango-gui-jdraw].

![\textit{JDraw} synoptic panel editor.](
  figures/images/01-tango-gui-jdraw.png){
  #fig:01-tango-gui-jdraw width=80% }

ATK became a standard solution for building graphical TANGO clients and
multiple applications, like *AtkPanel* or *AtkMoni*, has been built using this
framework.

**Taurus.**
The Taurus framework [@pascual2015taurus] has been developed with the same
concepts in mind as the ATK, but targets Python environments and uses Qt
library for GUI rendering. It shares with the ATK some common concepts and
design principles. It is divided into two packages, *taurus.core* and
*taurus.qt*. The former one brings *TaurusModel* object, which represents an
entity from TANGO world, e.g. device or attribute. The latter one is a set of
widgets that behave like standard Qt widgets, but each is bound to possibly
multiple *TaurusModels*.

![Taurus GUI.](
  figures/images/01-tango-gui-taurus.png){
  #fig:01-tango-gui-taurus width=80% }

Taurus applications can be created using any tools suitable for creating
Python/Qt applications. However, Taurus ships with an interactive GUI builder,
the *TaurusGUI* application. The users may put any widgets on a set of panels,
without writing a single line of code. This GUI may be later adjusted at
runtime. This application is shown in [@Fig:01-tango-gui-taurus].

The Taurus has been widely adapted by the community and is currently more
popular than ATK, since Python is the leading platform in science, where
TANGO is mainly used.

## Web-based approach

Whereas it is easy to create a desktop client application, the __*web-based*
approach to TANGO GUI development is still an unexplored area__. This is
mainly because TANGO, as CORBA-based technology, requires access to the TCP/IP
stack, which is not the case for the web browsers.

**Trends in GUI development.**
The use of Web frontend technologies for GUI development for both mobile and
desktop is
gaining more and more popularity. Compared with the traditional approach of
writing a native, dedicated application for each platform, it brings many
benefits, including:

* the deployment process is simplified, especially in case of browser
  applications, where new version is immediately available to users;
* there are many frameworks and libraries available, multiple programming
  styles are supported like object-oriented or functional programming;
* there is a wide choice of tools like linters, transpilers, build tools,
  editors and other utilities appreciated by developers;
* over 250,000 open source packages are available in npm, which is the
  standard repository for Javascript and other frontend code;
* the applications are portable between platforms thanks to the projects like
  Electron[^01-web-electron] or Apache Cordova[^01-web-cordova];

[^01-web-electron]: <http://electron.atom.io/>
[^01-web-cordova]: <https://cordova.apache.org/>

There are also disadvantages of using web technologies [@charland2011mobile],
like performance degradation and limitations in UI, but this are the costs
of increased productivity and maintainability.

**Server-side processing.**
In the present thesis we focus only on frontend solutions that run solely
inside a web browser, and any server side processing, like in e.g. PHP, is not
necessary. The *old* approach, where web pages were generated on the server and
returned in a HTTP response, is always paired with some Javascript whenever
interactivity is required. With the emergence of *single-page web applications*
[], where each piece of UI is updated independently using AJAX calls or a
similar technology, the number of use cases for server-side approach
decreases significantly.

## Adaptive user interfaces

An Adaptive user interface, or AUI, is an user interface that both adapts, or
changes its layout depending on the context where it is used and also allows the
user to perform this adaptation manually.
Providing the adaptive interface is a key part of maximizing the *user
experience*.

**Automatic adaptation.**
The interface can adapt its layout to the surrounding environement. Fo
instance, parts of a widget may be shown or hidden and the widgets may be
reordered when displayed on e.g. a mobile device. This is critical part behind
the success of *mobile web* approach to web development. Automatic adaptation
may be easily achieved thanks to web technologies like *media queries*, but is
often unsupported in desktop solutions. This also applies to existing GUI
frameworks for TANGO.

**Manual adaptation.**
The second form of adaptive user interface is an interface that may be
dynamically changed by the user according to their needs. This allows for
creating personalized views for diffrent users and diffrent situations.
This approach is supported in TANGO world by the Taurus framework, which offers
tools for manipulating the UI at runtime.

## Goals and objectives

The web-based approach to building user interfaces gains popularity. However,
it has not beed widely adopted among the TANGO Control System client
applications and GUI frameworks. The thesis goals may be formulated as follows:

* **evaluate existing solutions (if any) for building TANGO clients for web
  browsers**; find out why these solutions have not been adopted by the
  community like ATK or Taurus has; identify any pain points;

* consider the extending and updating of the existing solutions if possible,
  or **design and develop a new one**, reusing the ~~good~~ parts;

* if the new solution is delivered, it shall be implemented according to the
  following principles:

  * use modern, standardized web technologies; it should not be tied to any
    particular web framework and should have a limited number of dependencies;

  * focus on *user experience* and adaptivity; the interface should be adaptive
    both automatically and manually;

  * be widget based, providing at least basic widgets from the Taurus
    framework, which are recognized and appreciated by the users;

  * be flexible and modular, allowing users to create their own widgets and
    extend the system functionality via plugins;

  * offer a *TaurusGUI*-like application, where end-users can build and adapt
    the GUI at runtime;

  * be lightweight, easy to start with and have a documentation for both
    developers and end users;

TODO: skrocic introduction do 2.5 strony; wyrzucic tekst czy przeniesc?

