# Developing widgets for TangoJS { #sec:widget-development }

TangoJS is an extensible project and aims to simplify the process of adding a
new widget. This section shows how to create a simple widget. Only  a general
knowledge of web technologies like DOM and Web Components is required to
proceed.

## *TangoJS WebComponents* utilities

TangoJS provides utilities that facilitate development of new widgets. The
APIs described here are completely optional to use and are provided just for
convenience. One may start with a blank HTML file as well.

The mentioned utilities are part of the `tangojs-web-components` package. In a
TangoJS application this package is available at runtime as a `tangojs.web`
object. The structure of this package is described below.

The `tangojs.web.components` is an object where constructor functions for all
widgets should be attached. Attaching constructors to this object is not
necessary, but this is the standard place where tools like `TangoJS Panel`
look for widgets. This object is discussed later in this section.

The `tangojs.web.util` package contains a set of generic utility functions and
two subpackages, namely: `converters` and `mixins`. The `converters` package
contains functions for conversion between Javascript properties and DOM
attributes. This is useful for implementing, e.g the reflecting properties.
The `mixins` package contains mixins, or traits that provide common behaviors
for widgets. The most important utilities from this package are presented
below.

**Functions from the `tangojs.web.util` package.**

* ```javascript
  export function registerComponent (tagName, constructor, descriptor)
  ```

  Registers a custom element in the current document. The `tagName` is a
  `string` that will be used as a HTML tag for the new widget. The
  `constructor` is a constructor function. The third argument, `descriptor`
  is optional and is not required for simple widgets.

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

**Functions from the `tangojs.web.util.mixins` package.**
There are many ways how Javascript mixins can be implemented. TangoJS uses the
convention proposed in [^B-url-mixins]. The mixins are just functions that
append various methods to a given class prototype. This prototype is passed
as `this`, thus mixing-in has to be performed using, e.g. a `call` method, like
```mixin.call(prototype, args...)```.

[^B-url-mixins]: <https://javascriptweblog.wordpress.com/2011/05/31/a-fresh-look-at-javascript-mixins/>

* ```javascript
  export function withPolledModel ()
  ```

  Adds polling behavior to the widget. The underlying attribute model is
  constantly polled to keep the widget up-to-date. The prototype that mixes
  this in should have the following methods defined:

  * `onModelRead` which takes a map from model `string` to read result
    `Object`. This method is invoked whenever a new value is obtained from
    TANGO;

  * `onModelError` which takes an `Error` object. This method is called
     whenever an error occurs;

  * `createProxy` that takes a `string` model and returns a proxy, either
    `DeviceProxy` or `AttributeProxy`;

  * `readProxy` that takes the proxy and returns a promise of
    `DevState or `DeviceAttribute`.

  The following methods are then added to the prototype:

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
  `getAttribute`/`setAttribute` functions and manually converting their
  arguments in application's code. Instead, attributes may be reflected
  as Javascript properties. This mixin adds a property that is backed by an
  attribute. The binding is bidirectional. Any conversions are performed
  automatically on the fly.

  The mixin is configured via a `descriptor` argument that should have
  following the properties:

  * `attributeName` - a `string` with the name of the attribute;
  * `reflectedName` - a `string` with the name of the reflected property;
  * `type` - a type of the attribute; `string` or constructor function;
  * `defaultValue` - optional default value, returned when the attribute is not
    present;
  * `onChange` - a callback function, called whenever the attribute value is
    changed.

## Building a basic widget

With the utilities described in previous section, it is relatively easy to
build a simple widget for TangoJS.

**Widget structure.**
One may start with an empty HTML file and populate it with the contents shown
on [@Lst:B-html-blank]. It is a standard HTML file with two elements, `template`
and `script`. The `template` element is part of *HTML Templates* standard and
allows for defining reusable HTML blocks. This template is the widget's view,
which will be rendered on the webpage. The `script` element will contain the
widget's logic. It is wrapped in an IIFE and the `window`, `document` and
`tangojs` global variables are injected into this function.

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
Any valid HTML can be placed in the `template` tag. Then, the template can be
accessed from the Javascript code by querying the document, like
`tangojs.web.util.getCurrentDocument().querySelector('template')`. Each widget
instance clones this template and attaches it to its DOM tree. Alternatively,
widgets may create layouts imperatively, using APIs like
`document.createElement`.

The widget described here will be a simple label that displays the value of an
attribute. A single `span` element will be enough to achieve this. This has
been already appended to the `template` element. An `id` has been assigned to
that element, but still there may be multiple instances of this widget in a
single document, thanks to the encapsulation provided by the *Shadow DOM*.

**The widget class.**
A widget is a class, or a prototype that extends `HTMLElement` and is
registered in the browser as a custom element. The definition of this simple
widget is shown on [@Lst:B-js-full]. It is discussed in the following
paragraphs. This code should be placed inside the `script` tag.

```{#lst:B-js-full .javascript .numberLines}
const template = tangojs.web.util.getCurrentDocument()
                                   .querySelector('template')

class SimpleTangoLabel extends window.HTMLElement {
  createdCallback () {
    const clone = document.importNode(template.content, true)
    const root = this.createShadowRoot()
    root.appendChild(clone)
    this.appendChild(root)
    this._label = clone.querySelector('#label')
  }
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

tangojs.web.util.mixins.withPolledModel.call(SimpleTangoLabel.prototype)

tangojs.web.util.mixins.withReflectedAttribute.call(
  SimpleTangoLabel.prototype, {
    attributeName: 'model',
    reflectedName: 'model',
    type: 'string',
    onChange: SimpleTangoLabelElement.prototype.onModelChange
  })

tangojs.web.util.mixins.withReflectedAttribute.call(
  SimpleTangoLabel.prototype, {
    attributeName: 'poll-period',
    reflectedName: 'pollPeriod',
    type: 'string',
    onChange: SimpleTangoLabelElement.prototype.onPollPeriodChange
  })

tangojs.web.util.registerComponent('simple-tango-label', SimpleTangoLabel)
```
Listing: Simple *label*-like widget prototype implementation.


The widget usually sets its layout in the `createdCallback`. This method is
invoked whenever the widget is *upgraded* from `HTMLUnknownElement`. In the
example implementation, the template is cloned and attached to the shadow
root[^B-note-shadow].

[^B-note-shadow]: This example uses the *Shadow DOM V0* API, which has been
deprecated, but no browser implements the V1 API yet.

**Polling the model.**
To poll the device and be notified whenever a new value is obtained, the
`withPolledModel` mixin may be used. This requires implementing the four
methods mentioned above.
The `createProxy` method parses the model and instantiates an `AttributeProxy`
from the *TangoJS Core* package. The `onModelRead` is called with a map of
models, but this widget expects only one model, stored in the `model` property.
This property is defined later. The `onModelRead` and `onErrorRead` are
responsible for updating the widget's view periodically. In these methods,
the label's text is set to the obtained value.
This mixin is invoked on the widget's prototype, immediately after class
definition.

**Reflecting the attributes.**
The widget has two attributes, a `model` and a `poll-period`. The first one
is a string that represents TangoJS model. The second one is a number that
denotes how frequently the model is polled. These attributes should be
reflected into the `model` and `pollPeriod` properties of the widget class. The
`withReflectedAttribute` mixin can be used to create such properties. The
`onChange` callbacks are used to invoke methods added by the `withPolledModel`
mixin.

**Registering the widget.**
The last step is to register the widget. The `registerComponent` utility
function can be used. This function registers the widget in the current
document and attaches its constructor to the `tangojs.web.components` object.
It should be called after all mixins have been applied.

**Using the widget.**
The widget is now ready. It may be included in any web application that uses
TangoJS. Putting the widget in an HTML file allows it to be loaded using the
*HTML imports*. The widget behaves like an ordinary HTML element.
