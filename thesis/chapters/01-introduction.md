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

The hardware is controlled by the operators. They use graphical client
applications, that connect to the device servers and manipulate their state.
These applications are often deticated for the hardware they operatr on, but
there are applications where the operator may adapt the interface by selecting
which attributes of which devices he wants to control. Applications that allow
one to control multiple attributes and give an overview of a whole part of the
system, are called *synoptic panels*.

Altough relying heavily on CORBA, TANGO also uses ZeroMQ for event-based
communication. There are events that client register for, and is notified
whenever the event occurs, e.g. a value of attribute changes significantly.
This allows for efficient communication in scenarios where client would
otherwise constantly poll the device server.

The concepts described in this section are just an overview to give the reader
understanding what TANGO is. Providing extensive description of TANGO is out of
scope of this thesis and some simplifications have been made here. All these
topics are discussed deeply in the TANGO Control System Manual
[@tango2016manual].

**Architecture overview.**
TANGO deployment usually spans over several machines, connected in a network.
There are clients and servers. Clients are just terminals that allow operators
to interact with the hardware. Servers machines are responsible for direct
access to the hardware.

Each TANGO server runs several processes called *device servers*. Device
server is an abstraction that represents a single device in a TANGO deployment.
Each device server has a well-defined interface, and is exposed to the rest of
the system as a CORBA remote object.

![TANGO Control System architecture overview.](
  figures/uml/01-tango-architecture.tex){
  #fig:01-tango-architecture width=80% }

*TODO*

The TANGO ecosistem is not only the core middleware, but tons of software,
developed by the community.

## TANGO GUI frameworks

**Taurus.**
TODO.

* Tiago Coutinho
* First official release: 2008-05-07
* <http://www.taurus-scada.org/en/stable/>

## Web applications

**Trends in application development.**
TODO.

**Modern web technologies.**
TODO.

## Adaptive user interfaces

## Aims, goals and objectives
