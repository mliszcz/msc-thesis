# Results

This chapter discusses the outcomes of the presented work, reviews fullfilment
of initial goals and summarizes achievements. TangoJS is compared to existing
solutions and it's usability and usefulness in web development is evaluated.

## Goals review

Goals formulated initially has not been in a form of a strict, measurable
requirements. It was rather a set of design principles and and advices to
follow during the project development. **All the goals have been achieved.**

The main reason behind TangoJS development was to provide **simple, yet
extnsible and flexible** solution for building web-based client applications
for TANGO Control System. This has been reflected in design decisions, software
architecture, platform choice and even the distribution model. Below are
highlighted areas where most focus has been put into.

**Adaptability.**
Adaptive user interface changes it's layout depending on current context. This
process may be performed automatically bu the UI layer, or the UI may provide
end-user with option to change the layout manually. In TangoJS, case both
options are supported. This is true on a widget level and also for the whole
*TangoJS Panel* application, built with these widgets.

TangoJS widgets benefit from latest CSS features, like
Flexbox[^05-css-flexbox] and Grid Layout[^05-css-grid-layout]. This allows for
flexible layout adaptation to available space and other sizing constraints.
As a web technology, TangoJS layout may be configured via CSS rules. The
application developer may then use media queries [] together with the
shadow-piercing selectors [] to adapt the widgets automatically to the device
they are displayed on. 

[^05-css-flexbox]: <https://www.w3.org/TR/css-flexbox-1/>
[^05-css-grid-layout]: <https://www.w3.org/TR/css-grid-1/>

Apart from all adaptability aspects offered by separate widgets, the *TangoJS
Panel* application allows users to configure the interface manually, by
choosing what widgets are displayed, where the widgets are displayed and what
fields are included in each widget. This allows user for building personalized
*synpotic panels*, adapted for current requirements and changed dynamically.

**Simplicity.**
TangoJS is simple to start with and has a minimal learning curve. Only general
knowledge of web development is required to create own applications. There
are no third-party frameworks involved and the set of dependencies is kept
minimal. All components from the TangoJS stack have been deployed to the npm.
Thus, inclusion of TangoJS is as simple as adding a new dependency to the
project. Developers new to TangoJS may choose to start with an blank web
application template available in TangoJS repositories.

**Extensibility.**
TODO.

**Standards-driven.**
TODO.

**User experience.**
Any piece of software exposed for direct interactions with end-users that has
to care about user experience. This is especially crucial in case of graphical
applications. Overall user experience consists of various factors like UI's
usability, accessibility and design. Since TangoJS is a library, not an
application, thus, it makes no sense to evaluate TangoJS against these factors.
Instead, more detailed analysis of *TangoJS Panel* application is provided in
[@Sec:05-usability-evaluation].

## Compared to existing solutions

TangoJS may be used as a frontend for any of existing backend solutions,
including *Tango REST*, *Taurus Web* or *mTango*. In case of *mTango* it may be
used as a replacement for it's native frontend layer.
[@Tbl:05-comparison-existing] compares TangoJS to existing web-based TANGO
frontend libraries.

 | Canone | Taurus Web | mTango | TangoJS
-|--------|------------|--------|--------
TODO | | | |

Table: Comparison to existing web-based GUI libraries. {#tbl:05-comparison-existing}

## UI-metrics

## Usability evaluation { #sec:05-usability-evaluation }

* <https://en.wikipedia.org/wiki/Usability_testing#Expert_review>