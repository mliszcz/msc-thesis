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

**Standard library.**

**Classes.**

**Block scoped declarations.**

**Arrow functions.**

**Modules.**


## HTML5 and CSS3

## Limitations and browser support
