
\newglossaryentry{javascript}
{
  name=Javascript,
  description={is a scripting language for web browsers}
}

\newglossaryentry{json}
{
  name=JSON,
  description={(Javascript Object Notation) is a textual data exchange format
    which uses \gls{javascript} syntax to represent objects}
}

\newglossaryentry{ajax}
{
  name=AJAX,
  description={(Asynchronous Javascript and XML) is a set of technologies used
    by the web browsers to make asynchronous requests to the web servers. Often
    XML is replaced by \gls{json}}
}

\newglossaryentry{framework}
{
  name=framework,
  description={is a software used by another software to facilitate certain
    tasks}
}

\newglossaryentry{api}
{
  name=API,
  description={(Application Programming Interface) is a set of procedures and
    interfaces exposed by a library or a \gls{framework} to its users}
}

\newglossaryentry{atk}
{
  name=ATK,
  description={(Tango Application ToolKit) is a \gls{framework} for creating
  Swing-based graphical TANGO applications in Java}
}

\newglossaryentry{backend}
{
  name=backend,
  description={is the part of a web application that runs on a web server.
    It is usually responsible for data processing}
}

\newglossaryentry{cli}
{
  name=CLI,
  description={(Command-line Interface) is a textual UI where any
    interactions are performed by typing commands}
}

\newglossaryentry{comet}
{
  name=Comet,
  description={is a model of connection handling between a browser and a
  server where the server side can initialize communication}
}

\newglossaryentry{middleware}
{
  name=middleware,
  description={is a software that allows connecting systems created using
    different technologies. It often works in distributed environments}
}

\newglossaryentry{corba}
{
  name=CORBA,
  description={(Common Object Request Broker Architecture) is an
    object-oriented \gls{middleware} based on GIOP protocol}
}

\newglossaryentry{cors}
{
  name=CORS,
  description={(Cross Origin Resource Sharing) is a technique that allows
    accessing resources from another \textit{origin} (domain) using
    OPTIONS HTTP method}
}

\newglossaryentry{html}
{
  name=HTML,
  description={(HyperText Markup Language) is a markup language for defining
    web page layout}
}

\newglossaryentry{css}
{
  name=CSS,
  description={(Cascading Style Sheets) is a styling language for \gls{html}}
}

\newglossaryentry{device-server}
{
  name={device server},
  description={is an abstract entity in TANGO system. It often controls a
    single piece of hardware}
}

\newglossaryentry{tango-database}
{
  name={TANGO database},
  description={is a database where configuration of all \glspl{device-server}
    is stored}
}

\newglossaryentry{databaseds}
{
  name=DataBaseds,
  description={is a purely software \gls{device-server} that allows for
    interactions with \gls{tango-database}}
}

\newglossaryentry{dom}
{
  name=DOM,
  description={(Document Object Model) is an \gls{api} for manipulating
  \gls{html} from within \gls{javascript}}
}

\newglossaryentry{ecmascript}
{
  name=ECMAScript,
  description={is a dynamic scripting language standardized by ECMA
    International. \Gls{javascript} is one of ECMAScript implementations}
}

\newglossaryentry{end-user}
{
  name={end user},
  description={is a person for whom the software has been designed}
}

\newglossaryentry{frontend}
{
  name=frontend,
  description={is the part of a web application that runs in a browser. It is
    usually the presentation layer}
}

\newglossaryentry{gui}
{
  name=GUI,
  description={(Graphical User Interface) is an UI where iteractions may
    be performed using graphical icons and dialogs}
}

\newglossaryentry{idl}
{
  name=IDL,
  description={(Interface Definition Language) is a language for defining
    language-independent interfaces}
}

\newglossaryentry{jsdoc}
{
  name=JSDoc,
  description={is a tool that generates \gls{api} documentation from
    \gls{javascript} source comments}
}

\newglossaryentry{jsonp}
{
  name=JSONP,
  description={is a technique that allows to bypass the
    \gls{same-origin-policy} restrictions without implementing the \gls{cors}
    protocol}
}

\newglossaryentry{ldap}
{
  name=LDAP,
  description={(Lightweight Directory Access Protocol) is a protocol for
    accessing objects in remote directory. It is often used for authentication
    purposes}
}

\newglossaryentry{taurus}
{
  name=Taurus,
  description={is a Qt-based \gls{framework} for creating TANGO
    \gls{gui} applications in Python}
}

\newglossaryentry{model}
{
  name=model,
  description={is, in \Gls{taurus} framework, an abstract entity that
    represents a physical device or its attribute}
}

\newglossaryentry{model-view}
{
  name={Model-View-*},
  description={is a common name for \textit{Model-View-Controller},
    \textit{Model-View-Presenter}, \textit{Model-View-Adapter} and
    \textit{Model-View-ViewModel} architectural patterns}
}

\newglossaryentry{nodejs}
{
  name={Node.js},
  description={is a cross-platform \gls{javascript} runtime based on
    Google's V8}
}

\newglossaryentry{npm}
{
  name=npm,
  description={is a package manager and a package repository for \gls{nodejs}}
}

\newglossaryentry{operator}
{
  name=operator,
  description={is a person who controls the hardware during an experiment.
    Also \gls{end-user} of TANGO \gls{gui} tools}
}

\newglossaryentry{polyfill}
{
  name=polyfill,
  description={is a patch that provides functionality from latest
    language releases to the older browsers}
}

\newglossaryentry{promise}
{
  name=promise,
  description={is a class introduced in ECMAScript 2015 that encapsulates a
    result of an asynchronous computation}
}

\newglossaryentry{rest}
{
  name=REST,
  description={(Representational State Transfer) is an architectural pattern
    used by web applications which navigate between resource representations,
    usually \gls{json} objects}
}

\newglossaryentry{rpc}
{
  name=RPC,
  description={(Remote Procedure Call) is a concept of executing a procedure on
    a remote machine}
}

\newglossaryentry{same-origin-policy}
{
  name={same origin policy},
  description={is a security policy that prevents from accessing resources
    located on another domain (\textit{origin})}
}

\newglossaryentry{servlet-container}
{
  name={servlet container},
  description={is a JVM program that runs servlets and provides them with
    common APIs}
}

\newglossaryentry{servlet}
{
  name=servlet,
  description={is an entity that runs inside a \gls{servlet-container} and
    acts as a web server, receiving requests and sending responses}
}

\newglossaryentry{synoptic-panel}
{
  name={synoptic panel},
  description={is a common name for TANGO applications that provide provide
    control over multiple devices}
}

\newglossaryentry{tango-access-control}
{
  name=TangoAccessControl,
  description={is a purely software \gls{device-server} that allows for
    fine-grained access control over other \glspl{device-server}}
}

\newglossaryentry{tango-idl}
{
  name={TANGO IDL},
  description={is an IDL document that defines all TANGO objects and data
    types}
}

\newglossaryentry{ui}
{
  name=UI,
  description={(User Interface) is a general term that describes interactions
    between the software and the user. Most common UIs are \glspl{gui}
    and \glspl{cli}}
}

\newglossaryentry{umd}
{
  name=UMD,
  description={(Universal Module Definition) is a module specification for
    \gls{javascript} which allows creating modules for both \gls{nodejs} and
    browsers}
}

\newglossaryentry{vanilla-js}
{
  name={Vanilla JS},
  description={is a term for a \gls{framework}-less \gls{javascript}
    application that uses only standard \glspl{api}}
}

\newglossaryentry{W3C}
{
  name=W3C,
  description={(World Wide Web Consortium) is a standardization body for
    multiple web technologies like \gls{html} or \gls{css}}
}

\newglossaryentry{webcomponents}
{
  name=WebComponents,
  description={is a set of web standards that allows building componentized
    web applications}
}

\newglossaryentry{websocket}
{
  name=WebSocket,
  description={is a full-duplex protocol for communication between a browser
    and a server}
}

\newglossaryentry{widget}
{
  name=widget,
  description={is a small, reusable, isolated, self contained piece of
    \gls{gui}}
}

\newglossaryentry{zeromq}
{
  name=ZeroMQ,
  description={is a \gls{middleware} for \gls{rpc} and message-based
    communication}
}

\glsaddall
\printglossaries
