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
TangoJS has been designed to be extensible at many levels. The whole backend
part, which connects TangoJS to the TANGO infrastructure, may be replaced, by
writing a dedicated *Connector*. This pluggable backends allow TangoJS to be
adapted to the cretain deployment requirements and network configuration.
It is also possible to extend the behavior of TangoJS, by implementing new
widgets. Developers are supported in this task by the various utility functions
available in the *TangoJS Web Components* package.

**Standards-driven.**
By using only standard web technologies, a wider audience of developers may be
targeted. Web standards form the core of browser-based development, and every
other framework is built upon them. It is safe to assume that most
webdevelopers are familiar with raw DOM APIs. This also makes TangoJS a
future-proof technology and does not expose it to the risk of being tied to
old, unpopular or deprecated third party libraries.

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

Feature | Canone | Taurus Web | mTango | TangoJS
---------------|---------------|---------------|---------------|---------------
Has widgets | yes, (limited AJAX support) | no | yes, (5 default views) | **yes, (7 base widgets + variants)**
Ships with interactive *synoptic panel* | yes | N/A | no | **yes, (*TangoJS Panel*)**
Supports user accounts | yes, (database) | no | yes, (multiple options) | **N/A, (depends on backend)**
Supports TANGO events | no | no | yes | **no**
Backend server technology | PHP, Python | Python, Tornado, WebSocket | Java, RESTEasy, HTTP | **any possible**

Table: Comparison to existing web-based GUI libraries. {#tbl:05-comparison-existing}

Only a web-related aspects have been chosen as comparison criterias. The
comparison has shown that the TangoJS is the leading choice in all categories
but TANGO events support. **Events are currently not implemented and shall be
addressed in future releases. Use of events may significantly reduce network
traffic, but requires support on both frontend and backend side.**

## Usability evaluation { #sec:05-usability-evaluation }

Quantitive evaluation of user interfaces is a complex task and the results are
often diffrent than real user experiences []. This is due to involvement of
rather unpredictable human factors, like mind, perception or personal
preferences. To address these issues, a method called *heuristic evaluation*
has emerged [@nielsen1990heuristic]. This is one of the
*usability engineering* methods.

The heuristic evaluation helps to detect problems with the software usability,
by examining the user interface in context of a set of well-defined principles,
called *heuristics*. The most widely used heuristics have been propsed by the
Jakob Nielsen in 1994 [@nielsen1994heuristic]. They are however still
applicable to today's software.

The heuristic evaluation is not the only one method of *usability inspection*.
There have been other, more formal methods proposed [@nielsen1994usability],
like *cognitive walkthrouhgs*, *formal inspections*, *feature inspections* or
*standards inspections*. These methods usually require to involve a domain
experts who provide usability feedback.

The heuristic evaluation is relatively a simple method and produces reasonable
outcome. It has been choosen to evaluate TangoJS' usability and user
experience. The 10 heuristics, as formulated by Nielsen:

> 1. **Visibility of sytstem status:**
>    *«The system should always keep users informed about what is going on,
>    through appropriate feedback within reasonable time».*
> 1. **Match between system and the real world:**
>    *«The system should speak the user's language, with words, phrases and
>    concepts familiar to the user, rather than system-oriented terms. Follow
>    real-world conventions, making information appear in a natural and logical
>    order».*
> 1. **User control and freedom:**
>    *«Users often choose system functions by mistake and will need a clearly
>    marked "emergency exit" to leave the unwanted state without having to go
>    through an extended dialogue. Support undo and redo».*
> 1. **Consistency and standards:**
>    *«Users should not have to wonder whether different words, situations, or
>    actions mean the same thing. Follow platform conventions».*
> 1. **Error prevention:**
>    *«Even better than good error messages is a careful design which prevents
>    a problem from occurring in the first place. Either eliminate error-prone
>    conditions or check for them and present users with a confirmation option
>    before they commit to the action».*
> 1. **Recognition rather than recall:**
>    *«Minimize the user's memory load by making objects, actions, and options
>    visible. The user should not have to remember information from one part
>    of the dialogue to another. Instructions for use of the system should be
>    visible or easily retrievable whenever appropriate».*
> 1. **Flexibility and efficiency of use:**
>    *«Accelerators—unseen by the novice user—may often speed up the
>    interaction for the expert user such that the system can cater to both
>    inexperienced and experienced users. Allow users to tailor frequent
>    actions».*
> 1. **Aesthetic and minimalist design:**
>    *«Dialogues should not contain information which is irrelevant or rarely
>    needed. Every extra unit of information in a dialogue competes with
>    the relevant units of information and diminishes their relative
>    visibility».*
> 1. **Help users recognize, diagnose, and recover from errors:**
>    *«Error messages should be expressed in plain language (no codes),
>    precisely indicate the problem, and constructively suggest a solution».*
> 1. **Help and documentation:**
>    *«Even though it is better if the system can be used without
>    documentation, it may be necessary to provide help and documentation.
>    Any such information should be easy to search, focused on the user's
>    task, list concrete steps to be carried out, and not be too large».*

These heuristics has been applied to *TangoJS Panel* application as well as to
separate widgets to detect potential usability issues.

**Visibility of sytstem status.**
Most widgets in TangoJS have a *quality*/*status* LED bulb indicator. In normal
mode of operation this bulb shows status received from device server. Whenever
a communication error occurs, the indicator changes it's color. This directly
translates to the visibility of system in the case of *Panel* application.

**Match between system and the real world.**
TangoJS widgets map directly to the corresponding entities in TANGO object
model, like *devices* or *attributes*. Each widget have a strict set of
resposibilities and usually performs limited number of operations, like reading
or writing a value. The dashboards in the *Panel* application correspond to
physical panels and switches in real-world control rooms.

**User control and freedom.**
Usecases for TangoJS widgets are simple and often consist of a single action.
Thus, this rule has no application here.

**Consistency and standards.**
The widgets are consisted one with another and they share the same set of
design principles related to the functionality and layout. The widgets have
been inspired by the Taurus framework, which is the leading and widely library
for creating adopted widget-based GUI clients for TANGO on desktops. 

**Error prevention.**
In case of web-based or distributed applications it is impossible to prevent
error. This is due to fact that where network communication is involved, the
errors may happen. In such case, the widgets are inoperable, until
communication is back. These errors are indicated to the user. Other kind of
errors are handled and corrected by the widget code, e.g. bad input. 

**Recognition rather than recall.**
The widgets in TangoJS are simple pieces of UI. There are no dialog boxes or
nested views and user interacts always with single view that maps directly to
a TANGO entity. The *Panel* application uses dialogs, e.g. for initial widget
configuration, but the dialog view includes only entries related to the single
widget, like HTML attributes configuration. 

**Flexibility and efficiency of use.**
From the end-user's perspective, the *accelerators* for *power users*, that may
boost their productivity, are not applicable to TangoJS at current state. The
UI is flat and, most of the time, use cases are just single actions. 

**Aesthetic and minimalist design.**
The TangoJS GUI is kept clean and minimal. It's up to the application developer
to decide what information will be included in widget's layout, e.g an unit
field or a quality bulb. In case of the *Panel* application, the user may
decide which widgets are present on the dashboard and what fields are included.

**Help users recognize, diagnose, and recover from errors.**
If error occurs within widget, the user is only informed by the change of
indicator's color. No message is displayed to the user. The same applies to
the *Panel* application.

**Help and documentation.**
TangoJS provides extensive set of resouces, for both developers and end-users,
including webpage, widget specifications, API documentation and template
project to get started.

From the analysis performed, it may be seen that the **rule related to error
diagnosis is violated by TangoJS**, as the user does not get sufficient
information in case of an error. An explanation of error cause may help him
to diagnose the problem and find a solution, or at least submit a descriptive
ticket in the TangoJS issue tracker. This problem has to be addressed in future
TangoJS releases. Since a widget should not pop with alerts, a reasonable way
of error indication has to be proposed.

Analysis performed according to Nielsen's heuristics may quickly provide GUI
developers with useful feedback, without the need to involve other people,
like UI experts or targeted users. The outcome of heuristic evaluation are
usability problems, that may negatively impact user experience. Performing the
analysis during software development, one may address these issues early.
