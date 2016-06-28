# CORBA IDL to Javascript translation

One of TangoJS goals was to bring the standard TANGO data types to the browser.
These types represent abstractions that TANGO developers are familiar with
already. Use of standard structures and enumerations will allow for easier
integration with other TANGO technologies in the future.

**TANGO IDL.**
All data types in TANGO are defined in the *IDL* file. The *IDL*, *Interface
Description Language*, is a specification language describes interfaces and
data types of a system. The purpose of using IDL for interface description is
to provide the *language independency*. The components of the system may be
written in difffrent programming languages, but still they are able to
communicate. The IDL is used to *generate interfaces in concrete languages*,
and then the *middleware* carries the messages between components. This
middleware takes care of message serialization and deserialization.

TANGO uses the *OMG IDL*, which is the standard IDL in CORBA. The middleware
that connects the components in the system is the CORBA itself.

**Code generation.**
There are tools that parse the IDLs and generate *stubs* and *sekeletons* for
both the client and the server. This can be done e.g. for C++ or Java. Since
Javascript is not supported by CORBA, there are no tools that can generate
Javascript from IDL. To address this, the *idl2js*[^C-url-idl2js] tool has
been developed.

[^C-url-idl2js]: <https://github.com/mliszcz/idl2js>

**idl2js.**
The goal behind *idl2js* development was not to provide a Javascript equivalent
of existing tools, that generate *stubs* and handle marshalling. No matter
what, CORBA currently cannot run in browser. Instead TODO.

**Translation.**
TODO.

**Using the idl2js.**
The *idl2js* simple, command line utitlity, that takes a single argument, the
path to the *OMG IDL* file and prints generated Javascript to standard output.
Assuming that SBT is used to build the project, iIt may be used like:

```{.bash .numberLines}
$ sbt compile pack
$ ./target/pack/bin/main ./idl/tango.idl > ./generated.js
```
