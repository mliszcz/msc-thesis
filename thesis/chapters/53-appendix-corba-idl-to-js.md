# CORBA IDL to Javascript translation { #sec:corba-idl-to-js }

One of TangoJS's goals was to bring the standard TANGO data types to the
browser. These types represent abstractions that TANGO developers are already
familiar with. The use of standard structures and enumerations will allow for
easier integration with other TANGO technologies in the future.

**TANGO IDL.**
All data types in TANGO are defined in the *IDL* file. The *IDL*, *Interface
Description Language*, is a specification language describes interfaces and
data types of a system. The purpose of using IDL for interface description is
to provide the *language independence*. The components of the system can be
written in different programming languages, but still they are able to
communicate. The IDL is used to *generate interfaces in concrete languages*,
and then the *middleware* carries the messages between components. This
middleware is meant to take care of message serialization and deserialization.

TANGO uses the *OMG IDL*, which is the standard IDL in CORBA. The middleware
that connects the components in the system is CORBA itself.

**Code generation.**
There are tools that parse the IDLs and generate *stubs* and *skeletons* for
both the client and the server. This can be done e.g. for C++ or Java. Since
Javascript is not supported by CORBA, there are no tools that can generate
Javascript from IDL. To address this, we have developed the
*idl2js*[^C-url-idl2js] tool.

[^C-url-idl2js]: <https://github.com/mliszcz/idl2js>

**idl2js.**
The *idl2js* does not aim to be a Javascript equivalent of the existing tools
that generate *stubs* and the marshalling code. This is not possible, since
CORBA cannot run in a web browser. All what TangoJS needs is to have the TANGO
structures, enumerations and interfaces translated to the Javascript. The
mapping is relatively simple:

* a `struct` becomes a `class` with properties reflecting the fields;
* an `enum` becomes a *frozen* object with properties reflecting the enumerated
  values;
* an `interface` becomes a `class` with empty methods;
* a `typedef` becomes an ESDoc `@typedef` comment;

For each generated entity a docstring comment is also generated. The comments
use the syntax supported by the JSDoc and ESDoc tools. These comment strings
can be used to generate the API documentation. Also, static typecheckers or
code intelligence tools can use such comments as a source of information about
data types. The example output of generated Javascript code is shown in
[@Lst:C-generated-code].

```{#lst:C-generated-code .javascript .numberLines}
/**
 * @public
 */
export class DevAttrHistory {

  /** @param {Object} data */
  constructor(data = {}) {
    /** @private */
    this._data = Object.assign({}, data)
  }

  /** @type {boolean} */
  get attr_failed() {
    return this._data.attr_failed
  }

  /** @type {AttributeValue} */
  get value() {
    return this._data.value
  }

  /** @type {DevError[]} */
  get errors() {
    return this._data.errors
  }
}
```
Listing: Example structure translated from IDL to Javascript.

**Translation.**
The translator has been written in Scala language. It uses the `IDLLexer`,
`IDLParser` and `IDLVisitor` classes from the Apache Axis2 [@www-axis2]
project to generate the internal representation of the parsed IDL. Then, each
type is transformed to its Javascript equivalent, as discussed above.

**Using the idl2js.**
The *idl2js* is a simple, command line utility, that takes a single argument,
the path to the *OMG IDL* file and prints generated Javascript to standard
output. Assuming that SBT is used to build the project, it can be used this
way:

```{.bash .numberLines}
$ sbt compile pack
$ ./target/pack/bin/main ./idl/tango.idl > ./generated.js
```
