---
title: Adaptive Web User Interfaces for TANGO Control System
subtitle: |
  MSc thesis\
  PP P4 presentation: modern web-development trends
author: |
  Michal Liszcz\
  Supervisor: Wlodzimierz Funika, PhD

date: Mar, 2016

documentclass: beamer

header-includes:
  - \newcommand{\columnsbegin}{\begin{columns}}
  - \newcommand{\columnsend}{\end{columns}}
  - \graphicspath{{../beamerthemeAGH/}}
  - \usepackage{{../beamerthemeAGH/beamerthemeAGH}}

include-before:
  - \graphicspath{{./}}

revealjs-url: ../../reveal.js-3.2.0

toc: true

---

# Introduction

## HTML

* stands for HyperText Markup Language,
* describes the structure and the semantic content of a web document,
* web page is constructed from HTML elements such as `<div>`,
* standard maintained by The World Wide Web Consortium (W3C),
* October 28, 2014 - HTML5 was published as a W3C Recommendation.

* <https://developer.mozilla.org/en-US/docs/Web/HTML>

## DOM

* stands for Document Object Model,
* programming interface for HTML (and SVG and XML) documents,
* provides a structured representation of the document as a tree,
* programs can change the document structure, style and content via DOM
  manipulation APIs.

> HTML is text and the DOM is the in-memory object model to represent the tree
  that the HTML described.

* <https://developer.mozilla.org/en-US/docs/Web/API/Document_Object_Model/Introduction>

---

![DOM tree (source: wikimedia.org)](images/DOM-model.svg.png)

## CSS

* stands for Cascading Style Sheet,
* used to describe the presentation of a document,
* CSS2.1 - W3C recommendation,
* CSS3 - split into smaller modules.

> The basic goal is to allow a browser engine to paint elements of the page
  with specific features, like colors, positioning, or decorations.

* <https://developer.mozilla.org/en-US/docs/Web/CSS>

## Javascript

* standardized by Ecma International in ECMAScript specification
  (ECMAScript 2015 is the latest release),
* *de-facto standard* for client-side scripting in web browsers,
* object-oriented, prototype-based,
* with support for functional programming,
* thousands of *X-to-Javascript* compilers available,
* Javascript, JavaScript, ECMAScript, SpiderMonkey, V8 - all these terms refer
  to diffrent things.

## Standardization bodies

* World Wide Web Consortium

* <https://www.w3.org/>

* Specification development:
    * Editor Draft
    * Working Draft
    * Candidate Recommendation
    * Recommendation

* Standards:
    * DOM Level 4: <https://www.w3.org/TR/dom/>,
    * HTML5: <https://www.w3.org/TR/html5/>,
    * and many others.

# ECMAScript 2015

## Features (1/5)

* extended standard library:
    * `Map`, `Set`, `WeakMap`, `WeakSet`,
    * `Promise`,
    * `Symbol`,
    * `Proxy`
* spread operator / destructuring
    ```javascript
    [first, second, ...rest] = [1,2,3,4,5]
    ```
* default parameters
* rest parameters

## Features (2/5)

* template literals
    ```javascript
    `can contain ${variables}
    and span over multiple lines`
    ```
* generators
* block-scoped declarations
    * `let`, `const`, `function`
* shorthand names in initializers
    ```javascript
    const field = 1
    const object = { field }
    ```

## Features (3/5)

* tail-call-optimization
* arrow functions
    * lexical `this` scoping
    ```javascript
    function () {
      const that = this
      setTimeout(() => {
        this === that // true
      })
    }
    ```

## Features (4/5)

* classes
    ```javascript
    class MyClass extends AnotherClass {
      constructor (value) {
        super(value)
      }
      method () {
        // implementation
      }
    }
    ```

## Features (5/5)
* modules
    ```javascript
    export const MyClass = MyClass

    export let mySharedVal = 1

    export MyClass2 { /* definition */ }

    export function myFunc (x, y) { /* body */ }

    import { MyClass2, mySharedVal } from './my/module'
    import * as data from './data'
    ```

## Browser support

* https://kangax.github.io/compat-table/es6/
* works in all evergreen browsers
* % of implemented features:
    * *Babel* transpiler - 74%
    * Firefox 45 - 85%
    * Firefox 48 - 90%
    * Chrome 49 - 91% (Opera 36)
    * Chrome 51 - 96% (Opera 38)
    * Edge 13 - 79%
    * Edge 14 - 85%
    * Safari 9 - 53%

# CSS3 and beyond

## History

* 7 June 2011 - W3C Recommendation for CSS2.1,
* CSS3:
    * split into modules, evolves independently,
    * each iteration produces new *level* which builds upon previous one,
    * Recommendations:
        * Selectors Level 3 (general sibling combinator `~`),
        * Media Queries (`@media(...)`),
        * CSS Color Module Level 3 (`rgba(...)`, `hsla(...)`),
        * and many others.

---

![CSS Taxonomy (source: wikimedia.org)](images/CSS3_taxonomy_and_status-v2.png)

## CSS Selectors Level 4

* <https://drafts.csswg.org/selectors-4/>
* validity pseudo-classes: `:valid`, `:invalid`
* `:matches(...)` pseudo-class
    ```css
    :matches(*:hover, *:focus)
    ```
* `:not(...)` and `:has(...)` - **parent selector**!
    ```css
    a:has(> img)
    section:not(:has(h1, h2, h3, h4, h5, h6))
    li:has(> a.active) {
      /* styles to apply to the li tag */ }
    ```
* `:root` pseudo-class
* and more ...

## CSS Custom Properties for Cascading Variables Module Level 1

* <https://www.w3.org/TR/css-variables-1/>,
* custom properties prefixed with `--*`,
* and referenced with `var(...)` syntax,
    ```css
    :root {
      --main-color: #06c;
      --accent-color: #006;
    }

    #foo h1 {
      color: var(--main-color);
    }
    ```

## CSS Values and Units Module Level 3

* <https://www.w3.org/TR/css3-values/>,
* mathematical expression (`calc(...)`)
    ```css
    section {
      float: left;
      margin: 1em; border: solid 1px;
      width: calc(100%/3 - 2*1em - 2*1px);
    }
    ```
* attribute references (`attr(...)`)
    ```css
    stock > * {
      display: block;
      width: attr(length em); /* default 0 */
      height: 1em;
    }
    ```

## CSS Conditional Rules Module Level 3

* <https://drafts.csswg.org/css-conditional-3/>,
* <http://www.w3.org/TR/mediaqueries-4/>,
* extended media queries
    ```css
    @media screen and (color), projection and (color) {
      /* page is displayed on a screen/projector
       with color support */
    }
    ```
* feature queries
    ```css
    @supports ( display: flex ) {
      /* use flexbox here */
    }
    ```

## CSS @apply rule

* <https://tabatkins.github.io/specs/css-apply-rule/>
    ```css
    :root {
      --toolbar-title-theme: {
        color: green;
      };
    }

    .toolbar > .title {
      @apply --toolbar-title-theme;
    }
    ```

## CSS @extend rule

* <https://tabatkins.github.io/specs/css-extend-rule/>
    ```css
    .error {
      color: red;
    }

    .serious-error {
      @extend .error;
      font-weight: bold;
    }
    ```

## CSS Flexible Box Layout Module Level 1

* <https://www.w3.org/TR/css-flexbox-1/>,
* <https://css-tricks.com/snippets/css/a-guide-to-flexbox/>,
    ```css
    .root {
      display: flex;
      flex-direction: column;
    }
    .root > * {
      flex: 1;
    }
    ```

---

![CSS Flexbox (source: w3.org)](images/css-flexbox.png)

## CSS Grid Layout Module Level 1 (1/4)

* <https://www.w3.org/TR/css-grid-1/>,
* <http://gridbyexample.com/examples/>,
* divides space into rows and columns (both explicit and implicit),
* can be easily styled with media-queries,
* is source order independent,
* no nested selectors - simple DOM.

## CSS Grid Layout Module Level 1 (2/4)

![CSS Grid Layout (source: w3.org)](images/game-landscape.png)

## CSS Grid Layout Module Level 1 (3/4)

```css
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
```

## CSS Grid Layout Module Level 1 (4/4)

* placement by area:
    ```css
    #title { grid-area: title }
    ```
* by numeric coordinates and spane:
    ```css
    #A { grid-column: 1 / span 2; grid-row: 2;}
    ```
* or may be handled automatically by grid-placement algorithm.

# Web Components

## Introduction

* **Web Components**,
* common name for 4 independent standards:
    * HTML Templates
    * HTML Imports
    * Custom Elements
    * Shadow DOM
* allow for building **reusable**, **self-contained** widgets,
* there are frameworks built on-top of Web Components, like Google Polymer,
  Microsoft X-Tag or Mozilla Brick.

## HTML Templates

* included in HTML5 standard,
* <https://www.w3.org/TR/html5/scripting-1.html#the-template-element>

> The HTML template element <template> is a mechanism for holding client-side
  content that is not to be rendered when a page is loaded but may subsequently
  be instantiated during runtime using JavaScript.

```html
<template> <!-- content --> </template>
```

```javascript
const documentFragment = document
  .querySelector('template').content
  .cloneNode(true)
```

## HTML Imports (1/2)

* packaging mechanism for Web Components,
* <https://www.w3.org/TR/html-imports/>,
* new `<link>` type: `import`,
* imported document available in `linkNode.import`,
* synchronous or not (according to the spec).

```html
<!-- index.html -->
<html>
  <head>
    <!-- ... -->
    <link rel="import" href="imported-document.html">
  </head>
  <body> <!-- ... --> </body>
</html>
```

## HTML Imports (2/2)

```html
<!-- imported-document.html -->
<html>
  <script type="text/javascript">

    // index.html
    const document = window.document

    // imported-document.html
    const currentDocument =
      document.currentScript.ownerDocument

  </script>
</html>
```

## Custom Elements

* <https://www.w3.org/TR/custom-elements/>,
* support for **custom tags**,
* also existing tags may be extended,
* support for both ES5 and ES6 classes,
* dead simple API.

## Custom Elements - element definition

* all elements should have `HTMLElement` is prototype chain

```javascript
class MyCustomElement extends HTMLElement {

  constructor () {
    // actually constructor may be never called!
  }
}
```

## Custom Elements - lifecycle callbacks

* four lifecycle callbacks:
    * `createdCallback()`,
    * `attachedCallback()`,
    * `detachedCallback()`,
    * `attributeChangedCallback(name, oldVal, newVal)`

```javascript
class MyCustomElement extends HTMLElement {

  createdCallback () {
    // put your initialization here
  }
}
```

## Custom Elements - element lifecycle

1. parser encounters `<my-custom-element>` tag,
1. `HTMLUnknownElement` DOM node is created,
1. element definition is loaded (asynchronously, via HTML import),
1. element is **upgraded** - becomes `MyCustomElement`,
1. `createdCallback()` is invoked.

## Custom Elements - element registration

* browser upgrades only elements it knows about,
* to introduce `MyCustomElement` to the browser:
    ```javascript
    const HTMLMyCustomElement =
      document.registerElement('my-custom-element', {
        prototype: MyCustomElement.prototype
      })
    ```
* the best place to put the registration code is the imported document,
* to create instance programmatically:
    ```javascript
    const e1 = document.createElement('my-custom-element')
    const e2 = new HTMLMyCustomElement()
    ```

## Custom Elements = extending existing elements

* to extend `<button>`:
    * make sure `HTMLButtonElement` is in prototype chain,
    * pass `extends` option to the `registerElement` API,
    * use `is="..."` attribute to upgrade buttons to your element

```javascript
MyButtonElement extends HTMLButtonElement { }

document.registerElement('my-button', {
  prototype: MyButtonElement.prototype,
  extends: 'button'
})
```

```html
<button is="my-button">click!</button>
```

## Shadow DOM

* sometimes we do not want external scripts and stylesheets to affect our
  component.

> Shadow DOM provides encapsulation for the JavaScript, CSS, and templating
  in a Web Component. Shadow DOM makes it so these things remain separate
  from the DOM of the main document.

* <https://developer.mozilla.org/en-US/docs/Web/Web_Components/Shadow_DOM>,
* <https://www.w3.org/TR/shadow-dom/>.

---

![Shadow tree hierarchy (source: w3.org)](images/shadow-trees.png)

## Shadow DOM - features

* nodes inside Shadow DOM cannot be accessed from outside
  (with APIs like `document.querySelector(...)`),

* nodes inside Shadow DOM cannot be affected by CSS stylesheets placed
  outside shadow tree; note: shadow-piercing selectors
  (`/deep/`, `>>>`, `::shadow`) has been deprecated,

* it is common practice to put your element's internals inside a shadow tree.

## Shadow DOM - API

* to create shadow a tree hosted at the given element, use:

    ```javascript
    const root = element.createShadowRoot()
    element.appendChild(root)

    const divInShadowTree = document.createElement('div')
    root.appendChild(divInShadowTree)
    ```

* *note*: `createShadowRoot()` has been deprecated in favor of
`attachShadow(...)`.

# Summary

## Hands-on lab

1. you are going to see all Web Components technologies in action,
1. to begin:
1. clone the repo: <https://github.com/mliszcz/agh-webcomponents-tutorial>

1. run the example (you need Firefox 45+ or Chrome ~49 and Node.js)

## Thank you
