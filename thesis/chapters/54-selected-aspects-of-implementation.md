# Selected Aspects of Implementation

This chapter discusses the web technologies used by TangoJS. The focus is
put on frontend-related aspects, like layout, styling and componentization.
The benefits of each technology are highlighted together with an explanation
why it has been chosen over the competiting solutions.

## Web Components

The *Web Components*[^D-url-webcomponents-w3c] standard is the most important
technology used by TangoJS.
It is a set of four independent standards that emerged recently to satisfy
the growing need for componentization and reusability in today's web. The
specification is open and maintained by W3C. Although the standardization
process is currently in progress, the vendors have already implemented these
features in their browsers. For older browsers the community have developed a
set of polyfills[^D-url-webcomponents-polyfills]. The mentioned four standards
are discussed next.

[^D-url-webcomponents-w3c]: <https://www.w3.org/standards/techs/components>
[^D-url-webcomponents-polyfills]: <http://webcomponents.org/polyfills/>

**HTML Templates.**
The specification for HTML Templates[^D-url-webcomponents-templates] has been
already finished and it has been included in the HTML5 standard. This feature
adds the new `template` element to the set of HTML tags. The purpose of the
`template` element is to hold a reusable fragment of HTML that may be later
cloned and inserted into the document. To achieve the same goal without use of
the *HTML Templates* one have to invoke `document.createElement` and
`element.setAttribute` multiple times, which may be inconvenient, especially
for creating more complex views. The `template` is never rendered by
the browser, but it may be accessed programatically, using APIs like
`document.querySelector`. The `content` property of a `template` is a
`DocumentFragment` that represents all it's children. Example of cloning the
template and inserting the clone into document are shown on
[@Lst:D-code-html-templates].

[^D-url-webcomponents-templates]: <https://www.w3.org/TR/html-templates/>

```{#lst:D-code-html-templates .html .numberLines}
<body>

  <template>
    <span>Hello</span>
    <span>World</span>
  </template>

  <script>
    (function (document) {
      const template = document.querySelector('template')
      const body = document.querySelector('body')

      body.appendChild(template.cloneNode(true))
      body.appendChild(template.cloneNode(true))
    })(window.document)
  </script>

</body>
```
Listing: Using the HTML Template.

**Custom Elements.**
The *Custom Elements*[^D-url-webcomponents-elements] standard provides a way to
extend the HTML with user-defined custom tags. These tags behave like ordinary
HTML elements, e.g. `input`, and may be created both declaratively in HTML and
using the `document.createElement` in Javascript. Any prototype that extends
`HTMLElement`, directly or not, may be *registered* in the browser, like:

```{.javascript .numberLines}
document.registerElement('tag-name', { prototype: tagPrototype })
```

There is a restriction that the name of a custom element must contain a dash.
The prototype passed in the second argument may define four lifecycle
callbacks, that are invoked by the browser on certain conditions:

* `createdCallback()` is invoked when the element is *upgraded*, that means
  the HTML parser has encountered the tag and the element has been already
  registered. Otherwise the tag is rendered as a `HTMLUnknownElement`;
* `attachedCallback()` is invoked whenever the element is appended to the DOM;
* `detachedCallback()` is invoked whenever the element is removed from the DOM;
* `attributeChangedCallback(name, oldVal, newVal)` is invoked whenever an
  attribute on this element is added, changed or removed;

[^D-url-webcomponents-elements]: <https://www.w3.org/TR/custom-elements/>

The custom element may also extend any of the existing HTML elements. The base
prototype should be in element's prototype chain and the `extends` property
has to be added to the second argument of the `document.registerElement`,
like `{ ..., extends: 'button' }`.

The calbacks described above cover the whole lifecycle of an element. This
allows to implement even complex use cases. A custom element may be used as
a widget, that is seen by the users as a single entity. A simple widget
shown on [@Lst:D-code-custom-elements] creates is's layout programatically.
The real widgets often use *HTML Templates* for this task.

```{#lst:D-code-custom-elements .javascript .numberLines}
class ReverseWidget extends HTMLElement {
  createdCallback () {
    const input = document.createElement('input')
    const button = document.createElement('button')

    this.appendChild(input)
    this.appendChild(button)

    button.innerHTML('reverse!')
    button.addEventListener('click', () => {
      input.value = input.value.split('').reverse().join('')
    })
  }
}

document.registerElement('reverse-widget', {
  prototype: ReverseWidget.prototype
})
```
Listing: Creating a Custom Element.

**HTML Imports.**
The *HTML Imports*[^D-url-webcomponents-imports] specification describes how
HTML documents (*imported documents*) may be included from another documents
(*import referrers*). The `link` element has been extended to support *HTML
Imports*. It's `rel` attribute may be also `import`:

```{.html .numberLines}
<link rel="import" href="imported-document.html">
```

[^D-url-webcomponents-imports]: <https://www.w3.org/TR/html-imports/>

The external document is asynchronously fetched and parsed when such `link`
is encountered. When accessed from Javascript, the `import` property of a
`link` element returns the imported document, of type `Document`.

The *HTML Imports* are natural way of distributing a self-contained widgets,
that consist of HTML, CSS and Javascript code, packed into single file. The
scripts inside the imported document are evaluated when the document is being
parsed. This allows custom elements, like widgets, to register itself in the
browser.

**Shadow DOM.**
The *Shadow DOM*[^D-url-webcomponents-shadow] is most complex of the *Web
Components* standards. It brings a concept of *shadow tree* to the DOM. The
existing DOM trees are called *light DOM* from now on. With each HTML element
there may be multiple `ShadowRoot` elements associated. A *shadow tree* may be
attached to each `ShadowRoot`. A `ShadowRoot` node is the root of all nodes is
corresponding *shadow tree*, like `document` is the root of all nodes in the
DOM.

During rendering, the shadow trees are merged with the element they are
attached to. However, these trees are not part of the DOM. Nodes in a shadow
tree cannot be accessed by querying the `document`. Also, they are not
affected by the stylesheets other than `style` elements inside the shadow
tree[^D-note-shadow-piercing]. This encapsulation may be desired in some cases,
e.g. the contents of a custom element may be put inside a shadow tree to create
a widget that appears to the user as a single entity that has no internal
structure. The widget will always look the same, no matter what stylesheets
are loaded. External code cannot modify widget's behavior accidentally.
Example that creates a shadow root is shown on [@Lst:D-code-shadow].

[^D-url-webcomponents-shadow]: <https://www.w3.org/TR/shadow-dom/>

[^D-node-shadow-piercing]: The *shadow-piercing selectors* have been deprecated
and no alternative has been proposed yet.

```{#lst:D-code-shadow .javascript .numberLines}
const outer = document.createElement('div')
const inner = document.createElement('div')

// using the Shadow DOM V0 API
const root = outer.createShadowRoot()
root.appendChild(inner)

// using the Shadow DOM V1 API
const root = outer.attachShadow({ mode: 'open' })
root.appendChild(inner)
```
Listing: Creating a shadow tree.

The *Shadow DOM* also allows for creating a *slots*, elements in a shadow tree
where another elements may be inserted. This feature is however not used by
TangoJS.

**Component-based development.**
The *Web Components* standard brings in a new set of possibilities to web
development. The *components* may be self-contained, reusable and highly
encapsulated, thus writing componentized applications becomes more and more
popular.
These applications are created from a basic building blocks, the components,
which have a small set of responsibilities, are easy to create, easy to test
and easy to maintain. This is the opposite to building a large, unstructured
application or using the MVC pattern where *view* is the whole page, managed
by a single *controller*. In the component-based approach, the MVC pattern
may be applied component level.

**Alternatives.**
*Web Components* allow for building componentized applications without using
third-party frameworks. This is often desirable, e.g. when building a widget
libaray like TangoJS. The user can integrate such widgets with any framework,
just like the standard `input`s or `button`s.
If one want's to sacrifice the flexibility for a nicier APIs, there are few
alternatives available, the frameworks like Angular 2[^D-url-angular] and
built on top of the *Web Components*: Google's Polymer[^D-url-polymer],
Mozilla's Brick[^D-url-brick] and Microsoft's X-Tag[^D-url-xtag].

[^D-url-angular]: <https://angular.io/>
[^D-url-polymer]: <https://www.polymer-project.org/1.0/>
[^D-url-brick]: <http://brick.mozilla.io/>
[^D-url-xtag]: <https://x-tag.github.io/>

## ECMAScript 2015

The Javascript development has been stalled for years. The 5th version of the
standard has been published by the Ecma International, the standardization body
behind Javascript, in 2009. From that time, new features have not been added
to the language until 2015. The rapid growth of web development popularity has
forced the Ecma to speed up the standardization process. In June, 2015, the
ECMAScript 2015 specification has been published. It contained numerous
improvements over the previous version and a set of new features. After the
ECMAScript 2015 release, the development schedule has been changed. A new
version of ECMAScript shall be expected every year.

This section discussed the new features introduced in the latest releases and
extensively used by TangoJS. 

**Standard library.**
The list of standard prototypes has been extended, by adding new collection
classes, like `Map`, `Set` `WeakMap`, `WeakSet` and utilities like `Promise`,
`Symbol` and `Proxy`.

The `Map` and the `Set` are standard collections known
from other languages. Until now, an `Object` has been a common replacement for
`Map`. However, `Object`s keys are always converted to `string`s. The `Map`
may be indexed with any type. In the `WeakMap` and `WeakSet` the objects may
be garbage-collected when there are no references to the keys or entries.

The `Promise` is an abstract object that represents an asynchronous
computation, which may succed and resolve the promise, or may fail, rejecting
the promise. This allows asynchronous functions to return a value, instead of
accepting a callback as an argument. The promises are chainable which means
that the result of previous computation may be passed to the next one. The
errors may safely flow through the chain and should be catched at the end.
The example code is shown at [@Lst:D-es-promise].

```{#lst:D-es-promise .javascript .numberLines}
(new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve(1)
  }, 1000)
}))
.then(x => Promise.resolve(x + 1)) // promises may be returned
.then(x => x / 0)
.then(x => x * 2)
.then(x => console.log(`result: ${x}`))
.catch(e => console.error(`error: ${e}`))
```
Listing: Using ECMAScript 2015 Promises.

**Classes.**
The Javascript is an object-oriented language with a prototypical inheritance.
This means that for every object there is also another object, it's prototype.
Each prototype has it's own prototype. This relations form a prototype chain.
There are multiple ways to define a *class* in Javascript. There are also
multiple ways to make this class extend another class. The ECMAScript 2015
introducates one more method, with the `class` keyword. This method is however
more the most readable. Class can define methods, properties and static
attributes. Diffrent ways of defining a class are shown on
[@Lst:D-es-class-es5] and [@Lst:D-es-class-es2015].

```{#lst:D-es-class-es5 .javascript .numberLines}
const Base = function (x) {
  this._x = x
}
Base.prototype.add = function (y) {
  return this._x + y
}
const Derived = function (x) {
  Base.call(this, x)
}
Derived.prototype = Object.create(Base.prototype);
Derived.prototype.constructor = Derived
Derived.prototype.mul = function (y) {
  return this._x * y
}
```
Listing: Classes and inheritance in ES5.

```{#lst:D-es-class-es2015 .javascript .numberLines}
class Base {
  constructor (x) {
    this._x = x
  }
  add (y) {
    return this._x + y
  }
}
class Derived extends Base {
  constructor (x) {
    super(x)
  }
  mul (y) {
    return this._x * y
  }
}
```
Listing: Classes and inheritance in ES2015.

**Arrow functions.**
The ECMAScript 2015 introduced a new kind of functions, called *arrow
functions*. In a normal function,
`this` may point to diffrent things, depending on how the function has been
called. In the *arrow functions* `this` is lexically scoped, which means that
`this` from a surrounding scope may be accessed without creating a variable for
it. This is useful in e.g. anonymous functions. Example of such function is
shown on [@Lst:D-es-arrow].

```{#lst:D-es-arrow .javascript .numberLines}
class Calculator {
  constructor (x) {
    this._x = x
  }
  addLater (y) {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(this._x + y)
      }, 1000)
    })
  }
}
```
Listing: Arrow functions in ES2015.

**Modules.**
In Javascript a module is usually an object that holds another objects or
classes. When browser environment is considered, the modules are often attached
to the global `window` object. This is diffrent for e.g. a server-side runtime,
Node.js, where modules are loaded synchronously with `require` function.

The important part of ECMAScript 2015 is the modules specification. This is the
first step to a truly modular Javascript applications. The standard specifies
only the syntax used to export and import objects from modules. The *module
loader* specification is still under development, but new module syntax may be
used already thanks to the tools like Rollup[^D-url-rollup]. Rollup
preprocesses Javascript sources and changes the `export`s and `import`s to
the global variables or `require` calls, depending on the targeted environment.

[^D-url-rollup]: <http://rollupjs.org/>

A module in ECMAScript 2015 is a *file*, that contains `import` and `export`
statements. Any variable or constant may be exported. Example of such module
is shown on [@Lst:D-es-modules].

```{#lst:D-es-modules .javascript .numberLines}
import functionA from './util/functions'
import * as helpers from './util/helpers'

export function functionB (x) {
  return functionA(helpers.mul(x))
}
```
Listing: Modules in ES2015.

**Other features.**
Apart from the major features described above, a few less important but useful
improvements have been introduced in ECMAScript 2015. This includes
*destructuring* which allows to assing an object or array to an expected
pattern, the default parameters, the template literals where variables can be
interpolated, the block-scoped declarations like `let` and `const` and the
short object initializers.

**Alternative languages.**
Javascript is a dynamic and flexible langage, which makes it easy to create
a *x-to-javascript* transcompilers. A lot of new languages has been developed
in recent years. The two most popular are *CoffeeScript* and *TypeScript*.
Both are compiled to Javascript and there is no runtime overhead.
The CoffeScript aims to simplify Javascript's syntax with classes, arrow
functions and template literals. There features however are available in pure
Javascript since ECMAScript 2015. The TypeScript is a Javascript with optional
typechecking.

## CSS Level 3 modules

After the release of CSS2, the CSS specification has been divided into modules.
Each module evolves independently, reaching new *levels*. Each builds upon
previous level. TangoJS uses modules described here to handle is's layout.

**CSS Custom Properties.**
The *CSS Custom Properties for Cascading Variables Module Level
1*[^D-url-properties] adds support for variables to the stylesheets. Variables
may be defined on any element using the syntax `--name: value;`. Variables are
cascading and are inherited by all child nodes. An example of a variable is
shown on [@Lst:D-css-variables].

[^D-url-properties]: <https://www.w3.org/TR/css-variables-1/>

```{#lst:D-css-variables .css .numberLines}
:root {
  --main-color: #06c;
  --accent-color: #006;
}
#foo h1 {
  color: var(--main-color);
}
```
Listing: Using the CSS variables.

**CSS Values.**
The *CSS Values and Units Module Level 3*[^D-url-values] introduces two new
functions, namely `calc` and `attr`. The first one allows to calculate values
for attributes dynamically. The second one allows to reference a value of a
certain attribute. An example using this functions is shown on
[@Lst:D-css-values].

[^D-url-values]: <https://www.w3.org/TR/css3-values/>

```{#lst:D-css-values .css .numberLines}
section {
  float: left;
  margin: 1em; border: solid 1px;
  width: calc(100%/3 - 2*1em - 2*1px);
  height: attr(width em);
}
```
Listing: Using the CSS values.

**CSS Flexible Box.**
The *CSS Flexible Box Layout Module Level 1*[D^url-flexbox] is a new `display`
option for building containers filled with items that occupy all available
space in horizontal or vertical direction. Each item gets space proportional to
it's `flex` attribute. On the orthogonal axis the elements may be aligned,
centered or stretched. This gives the flexibility in positioning elements and
building complex user interfaces without the need for *floats*. The elements
within a flexbox may be reordered using CSS attributes. A vertical flexbox
where each item gets the same space is shown on [@Lst:D-css-flexbox]/

[^D-url-flexbox]: <https://www.w3.org/TR/css-flexbox-1/>

```{#lst:D-css-flexbox .css .numberLines}
.root {
  display: flex;
  flex-direction: column;
}
.root > * {
  flex: 1;
}
```
Listing: Using the CSS Flexbox.

**CSS Grid Layout.**
The *CSS Grid Layout Module Level 1*[^D-url-grid]
allows to specify `grid` as a `display`
option. An element which is displayed as a grid is divided into a number of
rows and columns. Each of it's may be assigned a `grid-column` or a `grid-row`
attribute to position the item on a certain grid cell. Items spanning over
multiple grid cells are also allowed. This gives the developer a ultimate
flexibility on how the items may be aligned on the grid. Multiple areas may
be defined on the grid. An area is a named set of adjacent cells. Child nodes
may be assigned to this areas without need for setting rows and columns.
This is shown on [@Lst:D-css-grid].

[^D-url-grid]: <https://www.w3.org/TR/css-grid-1/>

```{#lst:D-css-grid .css .numberLines}
#grid {
  display: grid;
  grid-template-areas: "title stats"
                       "score stats"
                       "board board"
                       "ctrls ctrls";
  grid-template-columns:
    auto minmax(min-content, 1fr);
  grid-template-rows:
    auto auto minmax(min-content, 1fr) auto
}

#title { grid-area: title }

#board { grid-column: 1 / span 2; grid-row: 3;}
```
Listing: Using the CSS Grid Layout.

## Limitations and browser support

Most technologies described in this chapter are undergoing the standardization
process. They are often implemented in major browser, but are disabled and
hidden behind various flags. This is because the features has not been fully
tested yet and APIs may slightly change during standardization. All features
from this chapter has been verified to work on Mozilla Firefox 46 and Google
Chrome 50. For Mozilla Firefox, the flags `dom.webcomponents.enabled` and
`layout.css.grid.enabled` should be set to `true` in *about:config* tab.
In Google Chrome, the *Experimental Web Platform features* should be enabled
in the *chrome://flags* tab.
