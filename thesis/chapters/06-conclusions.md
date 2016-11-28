# Conclusions { #sec:conclusions }

It's there to conclude the thesis, the research performed and the solution
delivered.

The work presented in this thesis had two mail goals: to evaluate the existing
solutions for building web-based TANGO applications and to bring up to date web
development techniques to the TANGO web clients. The evaluation has showed
that there is only one solution which achieved success and is recognized by
the TANGO community. However, due to some disputable assumptions and design
decisions, it may be unsuitable for everyone. The TangoJS presented in Thesis
tries to address these issues. The initial goals have been fulfilled and an
extensible, adaptive and modular solution has been proposed.

## Role of web-based solutions in GUI development

The web-based approach is the trending solution in building graphical user
interfaces for web browsers, desktops and mobile phones. There are strong
reasons behind that - the applications are portable, may easily be adjusted
for different devices and screen sizes, lots of libraries and frameworks are
available and applications may be developed using different styles, like
object-oriented or functional programming. The web applications are fast to
prototype due to the use of declarative HTML and styling with CSS.

This has been verified through TangoJS development. The TangoJS applications
may be ported to desktop or mobile, using tools like Electron or Cordova.
The developers may use any framework they like, because TangoJS widgets behave
like native UI controls, derived from `HTMLElement`. The commonly agreed
semantics applies here - the widgets can work without any configuration, and to
write a simple web application using TangoJS, one has to write nearly no
Javascript code.

**Framework-less solutions.**
From many available frontend frameworks, like Angular [@www-angular] or
React [@www-react], TangoJS chooses
none. Developing even complex web applications using plain DOM APIs is possible
nowadays. Features once available only in libraries like jQuery have been
incorporated into the DOM. A one popular argument against this framework-less
approach was that the *vanilla* JS application are unstructured, and thus
unmaintainable. This is not true anymore, thanks to the technologies like
*Web Components*.

**Componentized approach.**
The recent emergence of *Web Components* standard is going to put a definitive
end to monolithic web applications. The componentized approach is already used
in frameworks like Angular 2, React or Polymer [@www-polymer], but *Web
Components* allow to
achieve the same effects, when not being tied to any particular framework.
The component-based web applications are more maintainable than a classic
MVC applications, especially when they grow larger.
This approach has been applied successfully during *TangoJS Panel* development,
where each piece of UI, e.g. a tabs bar or a modal window, is a separate
component that talks to other components via DOM events.

## Connecting TANGO and the Web

There were many attempts to access TANGO infrastructure from within web browsers.
All of them however have a common concept of a *proxy server* that connects
both worlds. This server has to run on a platform where the TANGO is already
supported. On one side of this proxy, there is CORBA, IIOP and ZeroMQ in some
cases. On the opposite side, the proxy exposes an interface accessible from the
browser. This uses different technologies for data transport, including HTTP and
WebSockets. Each approach have advantages and disadvantages.

**HTTP**.
The most obvious choice for the transport technology is HTTP, because it is the
native communication protocol of the Web. It is a high-level application
protocol, and the HTTP methods may be mapped on to operations on TANGO resources,
like GET maps to reading an attribute value, and PUT sets the value. A RESTful
API can be built using HTTP protocol. The HTTP is supported by all, even old
browsers. Proxies and firewalls can handle HTTP traffic. It may be cached,
both on the server and browser side. HTTP scales horizontally, since it is a
stateless protocol. The security can be provided with SSL for encryption.

However, in control systems, a near real-time transmission is required. The
HTTP introduces large overhead which affects performance.
This overhead is even larger when SSL handshake is involved.
As a text based protocol and use of headers, HTTP requests and responses
exhibit poor efficiency when it comes to the data-to-header ratio in case of
small messages, like reading or writing a single attribute. HTTP is also
not suitable for delivery of asynchronous events triggered on the server side.
Applications has to constantly poll the resource to detect any changes.
This limitation is commonly bypassed by using the Comet model, like
long-polling. There is support for server-sent events in HTML5 standard, but
it has not been widely adopted yet in web applications.

HTTP is used by Canone, Tango REST, GoTan and mTango projects. Thus, it is
also used in TangoJS for accessing its default backend, mTango.

**WebSocket.**
The goal behind WebSocket development was to provide full-duplex,
bidirectional communication between the client and the server. This protocol
is currently supported in all modern browsers. It is TCP-based, but uses HTTP
for initial handshakes. The servers may then handle HTTP and WebSocket traffic
on the same port. The WebSocket protocol have been developed to fill the gap
where communication has to be initiated from the server side, and obsoletes
the non-standard solutions like Comet. It is the best choice, when
event-driven communication is required, like in TANGO applications. Again,
SSL can be used for encryption of WebSocket traffic.

When compared with the HTTP, the WebSocket is a low-level one. The abstractions
like request, response or methods have to be implemented at application level.
This requires some effort but also gives the developer flexibility and field
for optimizations.

The only web-based TANGO solution that uses WebSocket is the Taurus Web.

**Generic RPC.**
To communicate with TANGO *device servers*, the abstractions like *DeviceProxy*
or *DeviceAttribute* have to be available in the browser. In the currently
discussed model with a middleman proxy server, these abstractions are already
present on the server side. Instead of creating a dedicated RESTful or
WebSocket-based API, to access the proxies from a web browser, it may be
possible to use some generic middleware to perform this task. This approach,
compared to the dedicated backend implementation, is depicted in
[@Fig:06-connection-dedicated-generic-compared]

\begin{figure}
  \centering
  \begin{subfigure}[b]{0.45\textwidth}
    \includegraphics[width=\textwidth]{figures/uml/06-connect-dedicated.tex}
    \caption{Dedicated client-server solution.}
  \end{subfigure}
  \quad
  \begin{subfigure}[b]{0.45\textwidth}
    \includegraphics[width=\textwidth]{figures/uml/06-connect-generic.tex}
    \caption{Generic Javascript RPC.}
  \end{subfigure}
  \caption{Comparison of backend access methods.}
  \label{fig:06-connection-dedicated-generic-compared}
\end{figure}

One example of such a middleware is JSON-WS [@www-jsonws] based on
JSON-RPC specification. This project aims to support creating of RPC-based
application that may be accessed from a web-browser. It can automatically
generate code for in-browser client proxies. Both HTTP and WebSocket are
supported as transport mechanisms.

Currently, no project uses the above mentioned approach. **Future work aims to
investigate the RPC-based solutions more deeply and try to implement a new
backend for TangoJS using the JSON-WS to access jTango library on the server
side.** Such solution should be easy to integrate with TangoJS, thanks to
its support for pluggable backends.

**HTIOP.**
The GIOP, *General Inter-ORB Protocol*, is the specification if a protocol
that CORBA uses for communication. The IIOP, *Internet Inter-ORB Protocol*
is the default implementation of GIOP used by the request brokers. It requires
full access to the TCP/IP stack, which is not possible in web browsers.
There is also an implementation called HTIOP [@www-ace-htiop], *HyperText
Inter-ORB protocol*, which is basically an IIOP over HTTP. This protocol has
been developed as part of ACE [@www-ace], the Adaptive Communication
Environment, which offers TAO, a CORBA-compliant ORB. However, this project
has been abandoned by the authors.

Using TAO broker in TANGO implementation may put into question the need of
using a proxy server for TANGO-browser communication. This significantly
simplifies the architecture, as depicted in [@Fig:06-connection-htiop].
**The future research is going to investigate this possibility and try to
implement support for HTIOP in TangoJS.**

![Accessing TANGO from within web browser over HTIOP.](
  figures/uml/06-connect-htiop.tex){ #fig:06-connection-htiop width=35% }

**Removing the CORBA.**
There have been several attempts to remove the heavyweight and complex CORBA
from TANGO and replace it by another technology, e.g.
ZeroMQ[@www-tango-zmq]. All these attempts have failed. With the recent
emergence of lightweight RPC frameworks that work in a web browser like gRPC
or Apache Thrift, it should be possible to replace the middleware layer
without any modifications to the TANGO code, just by implementing proxy
wrappers for new stubs and skeletons, to expose CORBA-like interface to the
TANGO code.

## Future work

The Evaluation of the proposed solution has shown that there is still place for
improvements and a few issues have to be addressed in TangoJS.

**Widgets.**
The set of the currently implemented widgets allows for developing even complex
web clients for TANGO, but there are some use cases which are currently not
covered, e.g. a scatter X-Y plots. TangoJS widget toolkit has been designed
to be extensible, and such a widget can be added at any time without any impact
on the rest of the project.

**Event support.**
At the current stage, TANGO events are not supported in TangoJS. The constant
polling can affect performance and generate unnecessary traffic. To implement
event support in TangoJS, a backend with event support is required. The mTango
supports events, but uses JSONP and Comet model. As a design decision, TangoJS
should use only standardized technologies, and it would be possible to handle
events with WebSocket connection or using server-sent events from HTML5.
This should be investigated to propose the best solution.

**Error indication.**
This issue has arisen during the usability evaluation. The user is not
sufficiently informed about the cause when error happened. Some way to indicate
such problems has to be developed, since changing the indicator bulb is not
enough and does not help user to find a solution for the problem's root cause.

**Backends.**
Even that mTango does its job as a default backend reasonably well, it would
be better to have such a backend generated automatically by some third-party
RPC framework. This shall probably introduce some overhead and optimizations
will not be possible, but the maintenance of backend and *Connector* will be
simplified. Other scenarios, e.g. backend-less one, as described above, should
also be investigated.
