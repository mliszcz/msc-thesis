# Introduction

This chapter provides introduction to the field of research and briefly
describes problems addressed in this thesis. At the end, the thesis goals are
formulated.

## TANGO Control System

Control of the expensive and sensitive hardware components in large
installations like scientific facilities may be a challenging task. In order to
conduct an experiment, multiple elements like motors, ion pumps, valves and
power-supplies have to be orchestrated. To address this problem, the TANGO
Control System [@gotz1999tango] has been developed at the ESRF synchrotron
radiation facility.

During the years of development, it has been also widely adopted in the
automation industry and gained a popularity among the community, who contribute
a lot of tools and utilities related to the TANGO project.
The core TANGO is a free and open source software, released under GPLv3
license.

**General introduction.**
TANGO Controls is a distributed system built on top of CORBA and ZeroMQ.
It introduces a *device server* concept to represent a physical piece of
hardware. This device server is available as a *remote object*, that
implements a well defined interface. TANGO is object-oriented middleware, and
each device server is characterized by:

* *name* - unique string in a form of a `group/family/member`;
* *attributes* - a set of data fields, that may be writable or read only,
  e.g a current of a power supply;
* *commands* - a set of actions that device may perform, e.g. a reset action;
* *properties* - a set of parameters not related directly reflected in the
  hardware, but impact how the device server works;

Device servers are distributed by vendors with the hardware or are created by
the community. The internal implementation, especially how the device server
connects to the hardware, is out of scope of TANGO.

Another important part of TANGO is the database, where the TANGO schema is
stored. This schema keeps information of all available devices registered in
the system. The clients use the database for device server discovery. The
database also stores the properties of each device. Device servers and clients
do not access the database directly. Instead, the database is exposed as a
device server, called *DataBaseds*, and interaction is performed using
commands, e.g. there is a command that returns a list of all registered device
servers or to exports a new device. 
A MySQL or MariaDB server is required to run TANGO. It is also possible to to
TANGO without a database and with a limited functionality. Also, multi-database
configurations are possible. 

The hardware is controlled by the operators. They use **graphical client
applications**, that connect to the device servers. Typical tasks include
manipulating device's attributes, observing the status of the hardware and
collecting logs.
These client applications are often deticated for the hardware they operate on,
but there are also applications where the operator may adapt the interface by
selecting which attributes of which devices he wants to control. Applications
that allow one to control multiple attributes and give an overview of set of
the devices and attributes are called *synoptic panels*.

Although relying heavily on CORBA, TANGO also uses ZeroMQ for **event-based
communication**. There are events that the client registers for, and is
notified
whenever the event occurs, e.g. a value of attribute changes significantly.
This allows for efficient communication in scenarios where client would
otherwise constantly poll the device server. Device server developers may
also fire events when server-initiated communication is required.

The concepts described in this section are just an overview to give the reader
understanding what TANGO is. Providing extensive description of TANGO is out of
scope of this thesis and some simplifications have been made here. All these
topics are discussed deeply in the TANGO Control System Manual
[@tango2016manual].

**Architecture overview.**
TANGO deployment usually spans over several machines, connected in a network.
There are clients and servers. Clients are just terminals that allow operators
to interact with the hardware. Servers machines are responsible for accessing
the hardware, and they are the place where *device servers* run. Single machine
can host any number of device server instances. The details of communication
are hidden behind the CORBA and TANGO abstractions. Client application
developer may treat the system just as a pool of device servers.

There are some special device servers, that do not control any hardware. These
are the mentioned earlier database device server, the *DataBaseds*, and the
authorization service, the *TangoAccessControl* device server. This
*TangoAccessControl* device server is responsible for user authorization
and offers fine-grained permission control, at a single attribute level.
The overview of the TANGO architecture is depicted at
[@Fig:01-tango-architecture].

![TANGO Control System architecture overview.](
  figures/uml/01-tango-architecture.tex){
  #fig:01-tango-architecture width=80% }

## TANGO GUI frameworks

The TANGO has been designed to allow uniform access to the hardware resources.
The end-users of TANGO-based software are hardware operators, who are
responsible for controlling the hardware during an experiment. They need
reliable and convenient graphical client applications to do their job
effectively.

The TANGO API offers abstractions like *DeviceProxy* or *AttributeProxy* that
allow to access devices programmatically. Using these proxies, a client
applications may be built using any technology and language where TANGO is
available, including **C++, Java and Python**. Most of the client applications
have share common goals and requirements. They also use common patterns to
fulfill these goals. This raised the need for standardization and development
of universal frameworks that will speed up TANGO client applications
development.

**ATK**.
[@poncet2005atk].

The TANGO ecosistem is not only the core middleware, but tons of software,
developed by the community.

**Taurus.**
TODO.

* Tiago Coutinho
* First official release: 2008-05-07
* <http://www.taurus-scada.org/en/stable/>

*TODO*

## Web applications

**Trends in application development.**
TODO.

**Modern web technologies.**
TODO.

## Adaptive user interfaces

## Aims, goals and objectives
