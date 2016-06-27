# Getting started with TangoJS

TangoJS has been designed to be easy to start with. Only a basic experience
in web development is required to build a simple application. This process
is described in following steps.

## Configuring the backend

First of all, a backend server has to be configured. One may skip this step if
he wants to use the simple in-memory *Connector*. However, for accessing a real
TANGO infrastructure, a working instance of mTango is required.

If one is familiar with the Docker, a mTango container[^A-mtango-docker]
created during TangoJS development may be used. The mTango in this container
is already configured to work with TangoJS.

[^A-mtango-docker]: <https://hub.docker.com/r/mliszcz/mtango/>

**Configuring mTango on Tomcat.**
A servlet container, like Apache Tomcat[], is required to make mTango work
with TangoJS. The standalone `.jar` version won't work. The `.war` archive may
be downloaded from the mTango webpage[^A-mtango-war]. This archive should be
deployed as a standard Java web application. Then, the device with following
parameters should be registered in the TANGO database:

* class/instance: `TangoRestServer/development`;
* device `test/rest/0`;

[^A-mtango-war]: <https://bitbucket.org/hzgwpn/mtango/downloads/mtango.server-rc2-0.3.zip>

After successful deployment, when the archive is extracted by the container,
the CORS support should be enabled in the appropriate `web.xml` file. This is
shown on [@Lst:A-mtango-cors]. The CORS preflight should be allowed to pass
the security constraints, by replacing the default one with the definition from
[@Lst:A-mtango-security].
Finally, a user with role `mtango-rest` has to be defined in the
`tomcat-users.xml` file, as shown at [@Lst:A-mtango-user].

```{#lst:A-mtango-cors .xml}
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
```
Listing: `web.xml` - mTango CORS configuration (servlet filter).

```{#lst:A-mtango-security .xml}
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
```
Listing: `web.xml` - mTango CORS configuration (security constraints).

```{#lst:A-mtango-user .xml}
<role rolename="mtango-rest"/>
<user username="tango" password="secret" roles="mtango-rest"/>
```
Listing: `tomcat-users.xml` - defining a user for mTango.

## Managing a Node.js project

The Node.js [] is the most commonly used runtime for Javascript. It also comes
with the npm, a package manager. The TangoJS packages are available in npm
registry under the following names:

* *TangoJS Core* - `tangojs-core`;
* *TangoJS WebComponents* - `tangojs-web-components`;
* in-memory mock connector - `tangojs-connector-local`;
* mTango connector - `tangojs-connector-mtango`;

The following instructions assume that Node.js have been installed.

To create an empty project, one have to type `npm init` in an empty directory
and then respond to a few questions. The TangoJS packages may be then installed
like: `npm install tangojs-core`.

During above process,
the TangoJS packages have been pulled to the `node_modules` directory.
Also, a `package.json` file has been created in the current directory.
This files contains the project definition, including all instaled
dependencies. Changes to this file may be done manually, but when version
of dependency is changed, one should type `npm install` to pull the new
packages.

## Basic application

The steps described in previous section may be omited, and the *TangoJS WebApp
Template* may be used instead. It is an empty TangoJS project hosted at
GitHub[^A-tangojs-webapp-link].

[^A-tangojs-webapp-link]: <https://github.com/tangojs/tangojs-webapp-template>

To use the project, one has to clone the repository, and then type
`npm install` in project's directory. The `master` branch is configured with
in-memory connector and the `mtango` branch is configured for mTango connector.

TangoJS should be hosted on a HTTP server, otherwise AJAX requests are blocked.
There is a simple server included in this starter project. To run it, one have
to type `npm run server`. The `index.html` file is served at
`http://localhost:8080`.

The mentioned earlier `index.html` file contains a section with connector
configuration and a simple `tangojs-trend` and `tangojs-line-edit` widgets
declared in HTML markup. A detailed list of available widgets and information
how to use them can be found at TangoJS project webpage[^A-tangojs-link].

[^A-tangojs-link]: <http://tangojs.github.io/>

One may access the address in a web browser to see the TangoJS working.
**The Web Components and CSS Grid Layout support must be enabled in web browser
for TangoJS to work.**
