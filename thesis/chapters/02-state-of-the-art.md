# State-of-the-art { #sec:state-of-the-art }

There have been a few projects aiming to enable development of web-based TANGO
client applications. Most of them have been abandoned at early proof-of-concept
stage. This chapter presents the existing solutions and evaluates different
approaches to web-enabled TANGO clients.

## Canone

Canone [@pelkocanone07] allows for creating customizable, web-based TANGO
panels, composed from various widgets. The widgets can be arranged on panels
and configured according to operator's requirements. This is similar to the
Taurus approach. Canone also allows for creating user accounts which are
stored in a database, and provides fine-grained authorization for these
accounts with permissions at a device level. An example application built with
Canone is presented in [@Fig:02-canone-gui].

![Canone Web Interface. (source [@www-canone])](
  figures/images/02-canone-tutorial4.png){
  #fig:02-canone-gui width=60% }

Canone development started in 2005. The last release that brought new
features was in May 2007. Since then, there was a bugfix release in 2011.
The project is no longer maintained and has never been widely adopted by the
TANGO community.

**Architecture.**
Canone is divided into two parts. There is a server part called *socket
server*, written in Python, and a frontend part, the Canone Web application,
written in PHP. __The *socket server* acts like a proxy__ between the existing
TANGO infrastructure and the frontend part. The connection between these layers
is handled over a standard TCP socket. Canone requires to be deployed on
PHP server, e.g. Apache Httpd. Also, a separate database server is required
for storing Canone configuration. The architecture is depicted in
[@Fig:02-canone-arch].

![Canone architecture.](figures/uml/02-canone-architecture.tex){
  #fig:02-canone-arch width=80% }

**User experience.**
Being unmaintained for almost 10 years, Canone shows its age and may be
considered a legacy software today. This is reflected in its  limited
interaction options and the poor overall user experience. The actions performed
by the user are most of the time submitted to the PHP server, which next
forwards the calls to the *socket server*. There is a limited support for AJAX
in some widgets. These two layers of indirection and incorporation of old
technologies affect user experience and makes Canone unsuitable for today's
world of dynamic web applications.

**Technological aspects.**
Canone generates UI on the server side, during HTTP request processing.
However, there is no model-view- * framework or even templating engine used.
All HTML code is printed to the response stream. This makes the code extremely
unreadable and unmaintainable. When it comes to the frontend part, there is a
minimal amount of CSS, but tables are used for maintaining the page layout.
All these factors make it impossible to extend or reuse any parts of this
10-year-old project.

All Canone drawbacks described above were acceptable 10 years ago. This is
a very important project and a first step in moving TANGO client applications
to the browser. It is also the first project that introduced the concept of
*proxy server* that connects CORBA-based world and that of the web browser.

## Taurus Web

Taurus Web [@taurusweb2013] is part of the Taurus project. Taurus Web provides
access to TANGO devices from a web browser. The user interface is very limited
and there are no customizable widgets. The source code is distributed with
several demo applications, where just a few basic fields are displayed. The
available interaction options are very limited. The example GUI panel is
presented in [@Fig:02-taurusweb-gui].

![Taurus Web Interface. (source [@taurusweb2013])](
  figures/images/02-taurusweb-gui.png){
  #fig:02-taurusweb-gui width=60% }

**Architecture.**
The architecture of the Taurus Web is, like in Canone, divided into a server
part and a frontend part. The server is written in Python and links the
browser-based GUI with TANGO using WebSocket connection. This provides a full
duplex link that may be used for robust integration of TANGO's event system
with browser. The frontend part requires a WebSocket-enabled browser, but this
is not a problem today.

**Technological aspects.**
According to its creators, Taurus Web is meant to be a framework that can be
used to create a dedicated GUI applications rather than being a generic
standalone application, like Canone. The backend part uses Tornado web server
for handling WebSocket connection. The frontend part is written in Javascript,
HTML5 and CSS3. The authors claim that it is ready for integration with modern
web technologies like Angular, jQuery, Node.js and Dojo framework.

Taurus Web development has started in 2011 and the project was abandoned at the
early proof of concept stage. There are just a few hundred lines of server
code and **nearby no frontend code**.

## Tango REST

Tango REST [@tangorest2015] is a RESTful interface for TANGO. The goal of this
project was to expose a subset of TANGO APIs over a HTTP protocol. Tango REST
acts as a proxy between *device servers* and a RESTful client, which may run in
e.g. a web browser. The system can be configured to **authenticate users
against an LDAP database**. The project also includes a mobile application for
Android devices, which provides a Jive-like functionality using Tango REST
server. Since this application is a native Java application and cannot run
in a web browser, it is out of scope of this discussion.

**Technological aspects.**
Tango REST is implemented as a Java EE servlet. It can be deployed on any
application server or on a servlet container. It uses the standard JAX-RS API
to provide a RESTful endpoint.

Tango REST, on its own, is not useful for building web user interfaces.
However, being paired with a frontend client, **it can be used as a backend
layer** for accessing TANGO API from a web browser.

## GoTan

GoTan [@gotan2012] is a complete ecosystem for accessing TANGO via RESTful
interface over HTTP protocol. The project consists of multiple modules.
However, it has no web frontend layer. GoTan has been written in Java and
Groovy. The API is well documented, which makes it easy to write own client
for GoTan server. Example minimal client applications are available for Android
phones and iPhone. These are native clients, written in Java and Objective-C,
respectively. GoTan does not support user accounts or permissions.

**Technological aspects.**
GoTan server is a standalone application that exposes a RESTful API using the
Restlet framework. It is written mostly in Groovy, with some parts written in
Java. It is a generic solution, capable of accessing classes and servers
defined in TANGO database as well as using the attributes, commands and
properties of any device.

The project is not actively developed and has been discontinued in 2013,
reaching only a proof-of-concept stage. The project can be integrated with a
third party frontend layer to create a complete web-based TANGO client.

## mTango

mTango [@mtango2016] is a complete solution for building TANGO client
applications for **web browsers** and **mobile devices**. It consists of
multiple components, which can be used together to create flexible web-based
TANGO GUIs. The key part of mTango is a REST server which allows to access
TANGO *device servers* using HTTP protocol and a well defined API. The UI part
ships with a set of widgets useful in building client applications. mTango,
as a Java-based web application, allows for **flexible security
configuration, including authentication with LDAP**.

**Architecture.**
The mTango architecture consists of a few loosely coupled components. There is
a server part, called *mTangoREST server*, which interacts directly with TANGO
and exposes its APIs via a RESTful gateway. The clients connect directly to
this server via HTTP protocol. mTango offers two types of clients. The first
one is called *mTangoREST client* and is written in Java. The second client,
called *jsTangORB* is written in Javascript and runs in web browsers. On top of
this browser-based client there is a UI layer, called *mTangoUI*. The
architecture is depicted in [@Fig:02-mtango-architecture].

![mTango architecture.](figures/uml/02-mtango-architecture.tex){
  #fig:02-mtango-architecture width=70% }

**mTangoREST server.**
The server part is implemented in Java as a standard Java EE servlet. It uses
JBoss RESTEasy to provide a RESTful web service. The server is distributed as
a `web archive` package, or as a standalone application with embedded Apache
Tomcat servlet container. User authentication can be performed in the filter
chain during request processing. mTango integrates with TangoAccessControl to
provide authorization. The server performs some optimizations, like caching.
TANGO events are supported, thanks to the Comet model [@crane2009].

**mTangoREST client.**
This client is a Java library that allows applications which run on JVM to
communicate with *mTangoREST server*. With full access to TCP/IP stack, Java
applications can use TANGO APIs directly, but in some cases using mTango may
be required, e.g. in a network where all traffic but HTTP is blocked.

**jsTangORB.**
The Javascript client allows for accessing *mTangoREST server* from a web
browser. It uses **JavascriptMVC framework** to model abstractions like
*Request* and *Response* or TANGO-specific proxies, e.g. *DeviceProxy*. It uses
**JSONP** to overcome the same-origin policy restrictions which prevent clients
from accessing servers on different hosts. The API is callback-based which
makes it difficult to write clean and maintainable code (problem known as the
*callback hell*). mTango performs client-side caching and other optimizations.

**mTangoUI.**
mTangoUI is a **JavascriptMVC application** built on top of *jsTangORB*. It
provides abstractions like *Page*, and widgets like *DeviceAttribute*,
*DeviceCommand* or *Plot*. One has to use the mTango CLI tools (which are
wrappers for the JavascriptMVC CLI tools) to create a minimal application
template. Then, widgets can be created declaratively, by placing an
`mtango:attr` tag on a webpage. The `mtango:attr` tag can be customized by
using a *view* attribute that controls widget's appearance. Two views are
available: a text field and a list, both in read-only and writable variants.
The user may also implement his/his own view. The `mtango:img` and
`mtango:plot` tags can be used to create an image or a plot.

The mTango project is under active development since 2013, with the last
release dating to August 2016. The frontend part has been updated in 2015. The
server side part is very flexible and may be extended with custom filters when
deployed on a standalone servlet container. In 2016 the standardization of the
official TANGO REST API was started by the community, and mTango has been
chosen as a reference implementation. **This is the most complete and feature
rich RESTful interface to TANGO**.

On the other side, the frontend part, both `jsTangORB` and `mTangoUI` have some
drawbacks. They are dependent on an old version of JavascriptMVC, a
framework that never gained attention and has not been widely adopted by the
web developers community. This is especially controversial in case of
`jsTangORB`, as a non-UI library, to depend on a model-view-controller
framework. Also, the **Rhino runtime** (and thus Java) is required for
development. Today, the Node.js is a *de-facto-standard* in Javascript
development and package management. Another drawback is that `jsTangORB` uses
JSONP for handling cross origin requests. The canonical way for doing this is
to implement the CORS protocol. The `jsTangORB` API has been designed to use
callback functions for asynchronous code. This may lead to writing
unmaintainable and unreadable code [@kambona2013]. A solution for the *callback
hell* problem is to use standard *Promise* API, or a polyfill library when
older browsers have to be supported.
Taking into consideration all these factors, **building lightweight, modern,
standards-driven user interfaces for a web browser using `jsTangoORB` and
`mTangoUI` may be a challenging task.**

Due to the incorporation of an unpopular, third party frontend framework and
CLI tools, mTango has a steep learning curve that may slow developers down. It
is hard to spin up a simple application if the user is not familiar with
JavascriptMVC.

## Summary

[@Tbl:02-summary-comparison] summarizes the solutions discussed above.
The main focus is put on user experience, flexibility, extensibility. The
technological aspects and software architecture are important factors as well,
since they affect the way the software can be extended (e.g. with new widgets).

+------------+-----------+-------------+-------------+------------+------------+
| Feature    | Canone    | Taurus Web  | TangoREST   | GoTan      | mTango     |
+============+===========+=============+=============+============+============+
| Has        | yes,      | yes,        | no,         | no         | yes,       |
| frontend   | (PHP)     | (Javascript)| (native     | (native    |(Javascript)|
| layer      |           |             | Android)    | Android    |            |
|            |           |             |             | an iOS)    |            |
+------------+-----------+-------------+-------------+------------+------------+
|            |           |             |             |            |            |
+------------+-----------+-------------+-------------+------------+------------+
| Has        | yes,      | no          | N/A         | N/A        | yes,       |
| widgets    | (basic    |             |             |            | (just a few|
|            | AJAX)     |             |             |            | views)     |
+------------+-----------+-------------+-------------+------------+------------+
|            |           |             |             |            |            |
+------------+-----------+-------------+-------------+------------+------------+
| Has        | yes       | N/A         | N/A         | N/A        | no[^02-mtango-explain] |
| interactive|           |             |             |            |            |
| *synoptic  |           |             |             |            |            |
| panel*     |           |             |             |            |            |
+------------+-----------+-------------+-------------+------------+------------+
|            |           |             |             |            |            |
+------------+-----------+-------------+-------------+------------+------------+
| Supports   | yes,      | no          | yes,        | no         | yes,       |
| user       | (database)|             | (multiple   |            | (multiple  |
| accounts   |           |             | options)    |            | options)   |
+------------+-----------+-------------+-------------+------------+------------+
|            |           |             |             |            |            |
+------------+-----------+-------------+-------------+------------+------------+
| Supports   | N/A       | no          | no          | no         | yes,       |
| TANGO      |           |             |             |            | (Comet     |
| events     |           |             |             |            | model)     |
+------------+-----------+-------------+-------------+------------+------------+
|            |           |             |             |            |            |
+------------+-----------+-------------+-------------+------------+------------+
| Backend    | PHP,      | Python,     | Java,       | Groovy,    | Java,      |
| server     | Python    | Tornado,    | JAX-RS,     | Restlet    | RESTEasy,  |
| technology |           | WebSocket   | HTTP        | HTTP       | HTTP       |
+------------+-----------+-------------+-------------+------------+------------+
|            |           |             |             |            |            |
+------------+-----------+-------------+-------------+------------+------------+
| Released   | 2005      | 2011        | 2015        | 2012       | 2013       |
|            |           |             |             |            |            |
+------------+-----------+-------------+-------------+------------+------------+
|            |           |             |             |            |            |
+------------+-----------+-------------+-------------+------------+------------+
| Is         | no        | no          | no          | no         | yes        |
| actively   |           |             |             |            |            |
| developed  |           |             |             |            |            |
+------------+-----------+-------------+-------------+------------+------------+

Table: Comparison of existing solutions. {#tbl:02-summary-comparison}

[^02-mtango-explain]: In August 2016 the development of a mTango-based *Tango Webapp* has been announced.

The solutions discussed in this chapter use different techniques to access
TANGO infrastructure from within a web browser. Most of them are no longer
maintained and have been abandoned years ago. Only mTango project is actively
developed and it user base is constantly growing making mTango the leading
technology for integrating TANGO with the browser. The server part is flexible,
configurable and well-performing. However, the evaluation have showed that
mTango frontend layer (`jsTangORB` and `mTangoUI` modules) has some drawbacks
and issues that have to be addressed before it may become the ultimate solution
for building web-based TANGO client applications.
