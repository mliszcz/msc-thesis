# Developing widgets for TangoJS { #sec:widget-development }

TangoJS is extensible project and aims to simplify the process of adding a new
widget. This section shows how to create a simple widget. Only  ageneral
knowledge of web technologies like DOM and Web Components is required to
proceed.

## *TangoJS WebComponents* utilities

TangoJS ships with utilities that facilitate development of new widgets. The
APIs described here are completely optional to use and are provided just for
convenience. One may start with a blank html file as well.

Mentioned utilities are part of the `tangojs-web-components` package. In a
TangoJS application this package is available at the runtime as a `tangojs.web`
object. The structure of this package is described below.

The `tangojs.web.components` is an object where constructor functions for all
widgets should be attached. Attaching constructors to this object is not
necessary, but this is the standard place where tools like `TangoJS Panel`
look for widgets. This object is discussed later in this section.

The `tangojs.web.util` package contains a set of generic utility functions and
two subpackages, namely: `converters` and `mixins`. The `converters` package
contains functions for conversion between Javascript properties and DOM
attributes. This is useful for implementing e.g the reflecting properties.
The `mixins` package contains mixins, or traits that provide common behaviors
for widgets. The most important utilities from this package are presented
below.

**Functions from `tangojs.web.util` package.**

* ```javascript
  export function registerComponent (tagName, constructor, descriptor) 
  ```

  Registers custom element in current document. The `tagName` is a `string`
  that will be used as a HTML tag for the new widget. The `constructor` is a
  constructor function. The third argument, `descriptor` is optional and is
  not required for simple widgets.

* ```javascript
  export function getCurrentDocument ()
  ```

  Returns a `document` object that contains the currently executed script. This
  is useful for loading templates from imported HTML files.

* ```javascript
  export function hypenatedForm (s)
  ```

  Converts the `s` from a camelCasedString to a hypenated-string; this is the
  preferable naming convention in the DOM.

**Functions from `tangojs.web.util.mixins` package.**
There are many ways how Javascript mixins may be implemented. TangoJS uses the
convention proposed in [^B-url-mixins]. The mixins are just functions that
append various methods to a given class prototype. This prototype is passed
as `this`, thus mixing-in has to be performed using e.g. a `call` method, like
```mixin.call(prototype, args...)```.

[^B-url-mixins]: <https://javascriptweblog.wordpress.com/2011/05/31/a-fresh-look-at-javascript-mixins/>

* ```javascript
  export function withPolledModel ()
  ```

  Adds polling behavior to the widget. The underlying attribute model is
  constantly polled to keep the widget up-to-date. The prototype that mixes
  this in should have following methods defined:

  * `onModelRead` which takes a map from model `string` to read result
    `Object`. This method is invoked whenever a new value is obtained from
    TANGO;

  * `onModelError` which takes an `Error` object. This method is called
     whenever an error occurs;

  * `createProxy` that takes a `string` model and returns a proxy, either
    `DeviceProxy` or `AttributeProxy`;

  * `readProxy` that takes the proxy and returns a promise of
    `DevState or `DeviceAttribute`;  

  Following methods are then added to the prototype:

  * `onModelChange` which should be invoked by the widget's author whenever
    the model should be changed;

  * `onPollPeriodChange` which should be invoked by the widget's author
    whenever the poll period should be changed;

  This mixins supports multiple attributes, when a string array is passed to
  the `onModelChange` method. The polling is started when this method is called
  for the first time.
  An example on how to use this mixin is presented later.

* ```javascript
  export function withReflectedAttribute (descriptor)
  ````

  Adds a reflected attribute to the widget. It is a widely adopted convention
  that it should be possible to configure HTML elements using only DOM
  attributes and pure HTML. However, it may be inconvenient to use the
  `getAttribute`/`setAttribute` functions and manually converting the values
  when programmatic access is required. Instead, attributes may be reflected
  as a Javascript properties. This mixin adds a property that is backed by an
  attribute. The binding is bidirectional. Any conversions are performed
  automatically.

  The mixin is configured via a `descriptor` argument, that should have
  following properties:

  * `attributeName` - a `string` with name of the attribute;
  * `reflectedName` - a `string` with name of the reflected property;
  * `type` - a type of the attribute; `string` or constructor function;
  * `defaultValue` - optional default value, returned when attribute is not
    present;
  * `onChange` - a callback function, called whenever attribute value is
    changed;

## Building a basic widget

With the utilities described in previous section, it is relatively easy to
build a simple widget for TangoJS.

**Widget structure.**
One may start with an empty html file and populate it with contents shown at
[@Lst:B-html-blank]. It is a standard HTML file with two elements, `template`
and `script`. The `template` element is part of *HTML Templates* standard and
allows for defining reusable HTML blocks. This will become the view of the
widget. The `script` element will contain the widgets logic. It is wrapped
in IIFE and the `window`, `document` and `tangojs` global variables are
injected.

```{#lst:B-html-blank .html .numberLines}
<!DOCTYPE html>
<html>

  <template>
    <span id="label"></span>
  </template>

  <script type="text/javascript">
  (function (window, document, tangojs) {
    'use strict'
  })(window, window.document, window.tangojs)
  </script>

</html>
```
Listing: Empty widget file.

**Populating the view.**
Any valid HTML can be placed in the `template` tag. Then, the template may be
accessed from the Javascript code by querying the document, like
`tangojs.web.util.getCurrentDocument().querySelector('template')`. Each widget
instance clones this template and attaches it to is's DOM. Alternatively,
widgets may create layouts imperatively, using APIs like
`document.createElement`.

The widget described here will be a simple label that displays value of an
attribute. A single `span` element will be enough to achieve this. This has
been already appended to the `template` element. An id has been assigned to
that element, but still there may be multiple instances of this widget in a
single document, thanks to the encapsulation provided by the *Shadow DOM*.

**The widget class.**
A widget is a class, or a prototype, that extends `HTMLElement` and is
registered in the browser as a custom element. The definition of this simple
widget is shown at []. It is discussed in the following paragraphs. This code
should be placed inside the `script` tag.

The widget usually sets it's layout during `createdCallback`. The code that
clones the view template and attaches it to the shadow root[^B-note-shadow]
is shown at [@Lst:B-js-class]. This code should be put inside the `script` tag.

```{#lst:B-js-class .javascript .numberLines}
const template = tangojs.web.util.getCurrentDocument()
                                   .querySelector('template')

class SimpleTangoLabelElement extends window.HTMLElement {
  createdCallback () {
    const clone = document.importNode(template.content, true)
    const root = this.createShadowRoot()
    root.appendChild(clone)
    this.appendChild(root)
    this._label = clone.querySelector('#label')
  }
}
```
Listing: Basic widget class.

[^B-note-shadow]: This example uses the *Shadow DOM V0* API, which has been
deprecated, but no browser implements the V1 API yet.

**Polling the model.**
To poll the model, the `withPolledModel` mixin may be used. This requires
implementing the four methods and invoking the mixin on the prototype, as
shown on [@Lst:B-js-model].

```{#lst:B-js-model .javascript .numberLines}
class SimpleTangoLabelElement extends window.HTMLElement {
  // ...
  createProxy (model) {
    const [_, devname, name] = model.match(/^(.+)\/([A-Za-z0-9_]+)$/)
    return new tangojs.core.api.AttributeProxy(devname, name)
  }
  readProxy (proxy) {
    return proxy.read()
  }
  onModelRead (deviceAttributes) {
    const attribute = deviceAttributes[this.model]
    this._label.textContent = attribute.value
  }
  onModelError (error) {
    this._label.textContent = '-error-'
  }
}

tangojs.web.util.mixins.withPolledModel
                          .call(SimpleTangoLabelElement.prototype)
```
Listing: Polling the model with mixin.

The `createProxy` method parses the model and
instantiates an `AttributeProxy` from the *TangoJS Core*. The mixin supports
multiple models, thus `onModelRead` method is called with a map of results.
However, in this simple widget, only a single model will be supported. One may
assume it will be stored in the `model` property. The `onModelRead` and
`onErrorRead` are responsible for updating the widgets view, by setting the
label's text. After class definition, the mixin is called.

**Reflecting the attributes.**
The widget will have two attributes, `model` and `poll-period`. The first one
will be the TANGO model string. The second one is a number that denotes how
frequently the model is polled. These attributes should also be reflected into
`model` and `pollPeriod` properties of the widget class. The
`withReflectedAttribute` mixin may be used to create such properties. This is
presented on [@Lst:B-js-attributes]. The `onChange` callbacks are used to
invoke methods added by the `withPolledModel` mixin.

```{#lst:B-js-attributes .javascript .numberLines}
tangojs.web.util.mixins.withReflectedAttribute.call(
  SimpleTangoLabelElement.prototype,
  {
    attributeName: 'model',
    reflectedName: 'model',
    type: 'string',
    onChange: function (model) {
      if (model) {
        this.onModelChange(model) // this is bound to the widget
      }
    }
  })
tangojs.web.util.mixins.withReflectedAttribute.call(
  SimpleTangoLabelElement.prototype,
  {
    attributeName: 'poll-period',
    reflectedName: 'pollPeriod',
    type: 'string',
    onChange: SimpleTangoLabelElement.prototype.onPollPeriodChange
  })
```
Listing: Adding reflected attributes.

**Registering the widget.**
The last step is to register the widget. The `registerComponent` utility
function may be used. This is shown on [@Lst:B-js-register]. This function
should be called after all mixins have been applied.

```{#lst:B-js-register .javascript .numberLines}
tangojs.web.util.registerComponent(
  'simple-tango-label',
  SimpleTangoLabel)
```
Listing: Registering the widget in browser.

**Using the widget.**
The widget is now ready. It may be included in any web application that uses
TangoJS. Putting the widget in a HTML file allows it to be loaded using the
*HTML imports*, as shown on [@Lst:B-html-include]. The widget behaves like an
ordinary HTML element.

```{#lst:B-html-include .html .numberLines}
<!DOCTYPE html>
<html>
  <head>
    <script src="tangojs-core.js"></script>
    <script src="tangojs-web-components.js"></script>
    <link rel="import" href="simple-tango-label.html">
    <!-- configure TangoJS Connector -->
  </head>
  <body>
    <simple-tango-label
      model="sys/tg_test/double_scalar"
      poll-period="1000">
    </simple-tango-label>
  </body>
</html>
```
Listing: Using the created widget.
