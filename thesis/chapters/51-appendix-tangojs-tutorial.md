# Getting started with TangoJS

TangoJS has been designed to be easy to start with. Only a basic experience
in web development is required to build a simple application. This process
is described in following steps.

## Configuring the backend

First of all, a backend server has to be configured. One may skip this step if
he wants to use the simple in-memory *Connector*. However, for accessing a real
TANGO infrastructure, a working instance of mTango is required.

A preconfigured mTango REST server is available in a Docker container
[^A-mtango-docker]. This container has been created during the TangoJS
development. It may be used with existing TANGO deployment. The rest of this
sections show how to configure mTango manually from a scratch.

[^A-mtango-docker]: <https://hub.docker.com/r/mliszcz/mtango/>

**Deploying mTango on Tomcat.**
A servlet container, like Apache Tomcat[^A-tomcat], is required to make mTango
work with TangoJS. The standalone `.jar` version of mTango won't work, since
additional configuration is required. A standard `.war` archive may be
downloaded from the mTango webpage[^A-mtango-war]. This archive should be
deployed in the container as usual, e.g. by placing the archive in the
`webapps` directory.
Then, a device with following parameters should be registered in the
TANGO database using tool like e.g. Jive:

* class/instance: `TangoRestServer/development`;
* device `test/rest/0`;

[^A-tomcat]: <http://tomcat.apache.org/>
[^A-mtango-war]: <https://bitbucket.org/hzgwpn/mtango/downloads/mtango.server-rc2-0.3.zip>

mTango uses the role-based authorization offered by Tomcat. One have to add a
new user to the `config/tomcat-users.xml` file, like shown on
[@Lst:A-mtango-user].

```{#lst:A-mtango-user .xml .numberLines}
<role rolename="mtango-rest"/>
<user username="tango" password="secret" roles="mtango-rest"/>
```
Listing: `tomcat-users.xml` - defining a user for mTango.

At this point the container may be started to check if mTango has been
set up properly. After starting Tomcat, the following URL, when typed in the
browser, should return a list of all TANGO devices:
<http://localhost:8080/mtango/rest/rc2/devices>.

**Enabling CORS.**
Cross Origin Resource Sharing has to be enabled in the container to allow
TangoJS access the mTango RESTful API. With the container shut down, one should
edit the `web.xml` file located where the mTango archive has been extracted.
A new filter has to be appended to the filter chain. Tomcat, like most web
containers, ships with a configurable filter that can handle the CORS
preflights. Apart from configuring the filter, the OPTIONS request should be
allowed to pass the security constraints. This requires modifications to the
default security configuration, also in the `web.xml` file. The changes are
shown on [@Lst:A-mtango-cors].

```{#lst:A-mtango-cors .xml .numberLines}
<?xml version="1.0"?>
<web-app>

  <!-- rest of the file omited ... -->

  <filter>
    <filter-name>CorsFilter</filter-name>
    <filter-class>org.apache.catalina.filters.CorsFilter</filter-class>
  
    <init-param>
      <param-name>cors.allowed.methods</param-name>
      <param-value>GET,HEAD,POST,PUT,DELETE,OPTIONS</param-value>
    </init-param>
  
    <init-param>
      <param-name>cors.allowed.headers</param-name>
      <param-value>
Accept,Accept-Encoding,Accept-Language,Access-Control-Request-Method,
Access-Control-Request-Headers,Authorization,Cache-Control,Connection,
Content-Type,Host,Origin,Referer,User-Agent,X-Requested-With
      </param-value>
    </init-param>
  </filter>
  
  <filter-mapping>
     <filter-name>CorsFilter</filter-name>
     <url-pattern>/rest/*</url-pattern>
  </filter-mapping>
  
  <security-constraint>
    <web-resource-collection>
      <web-resource-name>Tango RESTful gateway</web-resource-name>
      <url-pattern>/rest/*</url-pattern>
      <http-method>OPTIONS</http-method>
    </web-resource-collection>
  </security-constraint>
  
  <security-constraint>
    <web-resource-collection>
      <web-resource-name>Tango RESTful gateway</web-resource-name>
      <url-pattern>/rest/*</url-pattern>
    </web-resource-collection>
    <auth-constraint>
      <role-name>mtango-rest</role-name>
    </auth-constraint>
  </security-constraint>

</web-app>
```
Listing: `web.xml` - mTango CORS configuration.

## Managing a Node.js project

The Node.js [@tools-nodejs] is the most commonly used runtime for Javascript.
It also comes with the npm [@tools-npmjs], a package manager. The TangoJS
packages are available in npm registry under the following names:

* *TangoJS Core* - `tangojs-core`;
* *TangoJS WebComponents* - `tangojs-web-components`;
* in-memory mock connector - `tangojs-connector-local`;
* mTango connector - `tangojs-connector-mtango`;

The rest of this sections assumes that Node.js has been installed and
configured. To create an empty project, one have to type `npm init` in an
empty directory and then respond to a few questions. The TangoJS packages may
be then installed like: `npm install tangojs-core`. The required steps are
shown below:

```{.bash .numberLines}
~ $ mkdir webapp
~ $ cd webapp
~/webapp $ npm init
~/webapp $ npm install tangojs-core tangojs-web-components
```

During above process,
the TangoJS packages have been pulled to the `node_modules` directory.
Also, a `package.json` file has been created in the current directory.
This files contains the project definition, including all instaled
dependencies. Changes to this file may be done manually, but when a version
of a dependency is changed or a new dependency is added, one should type
`npm install`, with no package names, to update the dependencies.

## Using the *TangoJS WebApp Template*

The steps described in previous section may be omited, and the *TangoJS WebApp
Template*[^A-tangojs-webapp-link] may be used instead. It is a starter TangoJS
project that has all required dependencies declared and provides an
`index.html` file skeleton.

[^A-tangojs-webapp-link]: <https://github.com/tangojs/tangojs-webapp-template>

To use the project, one has to just clone the repository, select a branch with
a desired backend and pull the dependencies. The steps are shown below:

```{.bash .numberLines}
~ $ git clone https://github.com/tangojs/tangojs-webapp-template
~ $ cd tangojs-webapp-template
~/tangojs-webapp-template $ git checkout mtango
~/tangojs-webapp-template $ npm install
~/tangojs-webapp-template $ npm run server
```

A simple HTTP server has been started. This server binds to the 8080 port by
default and serves the files from the project's repository. To see the
`index.html` rendered in the browser, one should type the
<http://localhost:8080> in the address bar.

**NOTE:** TangoJS requires the *Web Components* and *CSS Grid Layout* to run
properly. These features may be disabled in some browsers. For Mozilla Firefox,
the flags `dom.webcomponents.enabled` and `layout.css.grid.enabled` should be
set to `true`. In Chromium and derivatives *Experimental Web Platform
features* should be enabled.

## Application code

With the *WebApp Template* up and running, one may start to customize it,
in order to create own web-based TANGO client application. Any libraries
and frameworks may be included at this stage.

**Loading TangoJS.**
The `index.html` file, mentioned earlier, is a standard HTML file. In the
`head` section, after the usual entries like title and `meta` tags, the
TangoJS is loaded and configured. This template application uses the *trend*
widget, thus *Chart.js* and *Moment.js* dependencies are loaded first. Then
the TangoJS packages like *core* and *connector* are loaded. These packages
are standard Javascript files loaded with the `script` tag. After the packages,
the developer may choose which widgets to load. Each widget is packaged in
a separate file, which should be loaded as an *HTML Import*, using the `link`
element.

When all packages have been loaded, the onnector has to be configured.
This is also usually done in the `head` section, inside a `script` tag. One
may instantiate desired connector, e.g. the *TangoJS mTango Connector* and then
pass this connector to the `tangojs.core.setConnector(connector)`
function. The process described here is shown at [@Lst:A-tangojs-setup].

```{#lst:A-tangojs-setup .html .numberLines}
<head>

  <!-- ... -->

  <!-- Dependencies required if you plan to use the tangojs-trend. -->
  <script src="node_modules/moment/min/moment.min.js"></script>
  <script src="node_modules/chart.js/dist/Chart.min.js"></script>

  <!-- TangoJS stack. -->
  <script src="node_modules/tangojs-core/lib/tangojs-core.js"></script>
  <script src="node_modules/[...]/tangojs-connector-mtango.js"></script>
  <script src="node_modules/[...]/tangojs-web-components.js"></script>

  <!-- Include desired widgets. -->
  <link rel="import" href="node_modules/[...]/tangojs-line-edit.html">
  <link rel="import" href="node_modules/[...]/tangojs-trend.html">

  <!-- Connector setup. -->
  <script type="text/javascript">
    (function (tangojs) {
      'use strict'

      const connector = new tangojs.connector.mtango.MTangoConnector(
        'http://172.18.0.5:8080/rest/rc2', // endpoint
        'tango',                           // username
        'secret')                          // password

      tangojs.core.setConnector(connector)

    })(window.tangojs)
  </script>

  <!-- The widgets may be styled with CSS. -->
  <style>
    tangojs-trend {
      width: 500px;
      height: 400px;
      display: block;
      padding-bottom: 10px;
    }

    tangojs-line-edit {
      display: block;
      width: 500px;
    }
  </style>

</head>
```
Listing: TangoJS configuration.

**Using the widgets.**
TangoJS widgets may be used declaratively, by placing desired tags in the
document `body`. Widgets may be also created using the imperative DOM
manipulation APIs. The available widgets have been discussed in the
[@Sec:solution-tangojs-webcomponents] of this thesis. The TangoJS project
webpage[^A-tangojs-link] also lists the widgets, as well as provides
description of the attributes that may alter widgets's layout or behavior.

[^A-tangojs-link]: <http://tangojs.github.io/>

In this example application, two widgets will be added to the page, using two
possible approaches. The first widget is a `tangojs-trend`, which displays
values of two attributes over time. These attributes are, namely,
`sys/tg_test/1/long_scalar_w` and `sys/tg_test/1/double_scalar`. The
`long_scalar_w` is a writable attribute. Thus, another widget,
`tangojs-line-edit` will be added to allow one change value of this attribute.
The code shown on [@Lst:A-tangojs-widgets] should be added to the `body` tag.

```{#lst:A-tangojs-widgets .html .numberLines}
<body>

  <tangojs-trend
    model="sys/tg_test/1/long_scalar_w,sys/tg_test/1/double_scalar"
    poll-period="1000"
    data-limit="20">
  </tangojs-trend>

  <script>
  (function (window) {
    'use strict'

    const document = window.document

    function initApplication () {

      const lineEdit = document.createElement('tangojs-line-edit')

      lineEdit.setAttribute('model', 'sys/tg_test/1/long_scalar_w')
      lineEdit.pollPeriod = 1000
      lineEdit.showName = true
      lineEdit.showQuality = true

      document.querySelector('body').appendChild(lineEdit)
    }

    if (HTMLImports && !HTMLImports.useNative) {
      // If HTMLImports polyfill is used, custom elements are not yet
      // upgraded when the DOMContentLoaded is fired. The polyfill
      //fires special event to indicate that all imports have been
      loaded. This is required to work in Firefox.
      window.addEventListener('HTMLImportsLoaded', initApplication, true)
    } else {
      window.addEventListener('DOMContentLoaded', initApplication, true)
    }
  })(window)
  </script>

</body>
```
Listing: Using TangoJS widgets.

The application built in this section is shown at
[@Fig:A-tangojs-webapp-template].

![The *TangoJS WebApp Template* application.](
  figures/images/A-tangojs-webapp-template.png){
  #fig:A-tangojs-webapp-template width=49% }
