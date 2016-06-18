# State of the Art

There has been few a projects aiming to enable development of web-based TANGO
client applications. Most of them has been abandoned at early proof-of-concept
stage. This chapters presents existing solutions and evaluates different
approaches to web-enabled TANGO clients.

## Canone

Canone [@pelkocanone07] allows for creating customizable, web-based TANGO
panels, composed from various widgets. The widgets can be arranged on panels
and configured according to operator's requirements. This is similar to the
Taurus approach. Canone also allows for creating user accounts, which are
stored in the database, and provides fine-grained authorization for these
accounts with permissions at a device level. Example application is presented
on [@Fig:02-canone-gui].

![Canone Web Interface. (source[^02-canone-url])](
  figures/images/02-canone-tutorial4.png){
  #fig:02-canone-gui width=60% }

[^02-canone-url]: <http://plone.tango-controls.org/download/canone/canone>

Canone development has started in 2005. The last release that brought new
features was in May 2007. Since then, there was a bugfix release in 2011.
The project is no longer maintained and has never been widely adopted by the
TANGO community.

**Architecture.**
Canone is divided into two parts. There is a server part called *socket
server*, written in Python, and a frontend part, the Canone Web application,
written in PHP. __The *socket server* acts like a proxy__ between existing
TANGO infrastructure and the frontend part. The connection between these layers
is handled over a standard TCP socket. Canone requires to be deployed on
PHP server, e.g. Apache Httpd. Also, a separate database server is required
for storing Canone configuration. The architecture is depicted on
[@Fig:02-canone-arch].

![Canone architecture.](figures/uml/02-canone-architecture.tex){
  #fig:02-canone-arch width=80% }

**User experience.**
Unmaintained for almost 10 years, Canone shows it's age and may be considered
a legacy software today. This is reflected in it's  limited interaction options
and the poor overall user experience. Actions performed by the user are most
of the time submitted to the PHP server, which then forwards the calls to the
*socket server*. There is a limited support for AJAX in some widgets. These
two layers of indirection and incorporation of old technologies negatively
impacts user experience and makes Canone not suitable for today's world of
dynamic web applications.

**Technological aspects.**
Canone generates UI on the server side, during HTTP request processing.
However, there is no model-view-* framework or even templating engine used.
All HTML is printed to the response stream. This makes the code extremely
unreadable and unmaintainable. When it comes to the frontend part, there is a
minimal amount of CSS, but tables are used for maintaining page layout.
All these factors make it impossible to extend or reuse any parts of this
10-year-old project.

All Canone drawbacks described above were acceptable 10 years ago. This is
a very important project and a first step in moving TANGO client applications
to the browser. It is also the first project that introduced the concept of
a *proxy server* that connects CORBA-based world and to the web browser.

## Taurus Web

Taurus Web [@taurusweb2013] is part of the Taurus project. Taurus Web provides
access to TANGO devices from a web browser. The user interface is very limited
and there are no customizable widgets. The source code is distributed with
few demo applications, where just few basic fields are displayed. Available
interaction options are very limited. The example GUI panel is presented
on [@Fig:02-taurusweb-gui].

![Taurus Web Interface. (source [@taurusweb2013])](
  figures/images/02-taurusweb-gui.png){
  #fig:02-taurusweb-gui width=60% }

**Architecture.**
The architecture of the Taurus Web is, like in Canone, divided into server part
and frontend part. The server is written in Python and links browser-based GUI
with TANGO using WebSocket connection. This provides full duplex link, that may
be used for robust integration of TANGO event system with browser. The frontend
part requires WebSocket-enabled browser, but this is not a problem today.

**Technological aspects.**
According to the creators, Taurus Web is meant to be a framework, that may be
used to create a dedicated GUI applications, rather than being a generic
standalone application, like Canone. The backend part uses Tornado web server
for handling WebSocket connection. The frontend part is written in Javascript,
HTML5 and CSS3. The authors state that it is ready for integration with modern
web technologies like Angular, jQuery, Node.js and Dojo framework.


Taurus Web development has started in 2011 and the project has been abandoned
at early proof of concept stage. There are just few hundred lines of server
code and **almost no frontend code**.

## Tango REST

Tango REST [@tangorest2015] is a RESTful interface for TANGO. The goal of this
project was to expose a subset of TANGO APIs over a HTTP protocol. Tango REST
acts as a proxy between *device servers* and RESTful client, which may run in
e.g. a web browser. The system may be configure to authenticate users against
LDAP database. The project also includes a mobile application for Android
devices, which provides Jive-like functionality using Tango REST server. Since
this application is a native Java application, it is out of scope of this
discussion.

**Technological aspects.**
Tango REST is implemented as a Java EE servlet. It may be deployed on any
application server or on a servlet container. It uses the standard JAX-RS API
to provide a RESTful endpoint.

Tango REST, on its own, is not useful for building web user interfaces.
However, paired with a frontend client, it may be used as a complete solution
for accessing TANGO API from a web browser.

## GoTan

GoTan [@gotan2012] is a complete ecosystem for accessing TANGO via RESTful
interface over HTTP protocol. The project consists of multiple modules.
However, it has no web frontend layer. GoTan has been written in Java and
Groovy. The API has been well documented, which makes it easy to write a client
for GoTan server. Example minimal client applications are available for Android
phones and iPhone. These are native clients, written i Java and Objective-C
respectively. GoTan does not support user accounts or permissions.

**Technological aspects.**
GoTan server is a standalone application, that exposes RESTful API using
Restlet framework. It is written mostly in Groovy, with some parts written in
Java. It is capable of accessing classes and servers defined in TANGO database
as well as using attributes, commands and properties of any device.

The project is not actively developed and has been discontinued in 2013,
reaching only a proof-of-concept stage.

## mTango

## Summary
