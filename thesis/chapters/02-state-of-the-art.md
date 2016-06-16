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

## Tango REST

## mTango

## Summary
