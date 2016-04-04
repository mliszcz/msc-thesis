# Introduction

This chapter provides introduction to the field of research and briefly
describes problems addressed in this thesis. At the end, project goals are
formulated.

## TANGO Control System

Control of the expensive and sensitive hardware components in large
installations like scientific facilities may be a challenging task. In order to
conduct an experiment, multiple elements like motors, ion pumps, valves and
power-supplies have to be orchestrated. To address this problem, the TANGO
Control System [@gotz1999tango] has been developed at ESRF
synchrotron-radiation facility.

### General introduction

TANGO Controls is a distributed system built on top of CORBA and ZeroMQ.

*TODO*

### Architecture overview

TANGO deployment usually spans over several machines, connected in a network.
There are clients and servers. Clients are just terminals that allow operators
to interact with the hardware. Servers machines are responsible for direct
access to the hardware.

Each TANGO server runs several processes called *device servers*. Device
server is an abstraction that represents a single device in a TANGO deployment.
Each device server has a well-defined interface, and is exposed to the rest of
the system as a CORBA remote object.

*TODO*

### GUI Tools and Frameworks

## Web applications

### Trends in application development

### Modern web technologies

## Adaptive user interfaces

### Adaptation techniques

### Manual adaptation

## Aims and goals

## Objectives
