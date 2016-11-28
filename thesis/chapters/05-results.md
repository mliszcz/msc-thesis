# Results { #sec:results }

In this chapter we discuss the outcomes of the presented work, review the
fulfillment of the initial goals and summarize the achievements. TangoJS is
compared to the existing solutions and its usability and usefulness in web
development is evaluated.

## Goals review

The goals of this work formulated initially has not been in a form of strict,
measurable requirements. It was rather a set of design principles and
guidelines to follow during the project development. **All the goals have been
achieved.**

The main reason behind the development of TangoJS was to provide a **simple, yet
extensible and flexible** solution for building web-based client applications
for TANGO Control System. This has been reflected in design decisions, software
architecture, platform choice and even the distribution model. There are
highlighted the areas where most focus has been put into.

**Adaptability.**
An adaptive user interface changes its layout depending on the current context.
This process can be performed automatically by the UI layer, or the UI can
provide end-user with an option to change the layout manually. In TangoJS' case
both options are supported. This is true at a widget level and also for the
whole *TangoJS Panel* application, built with these widgets.

TangoJS widgets benefit from the latest CSS features, like Flexbox
[@www-w3c-css-flexbox] and Grid Layout [@www-w3c-css-grid]. This allows for
flexible layout adaptation to the available space and other sizing constraints.
As a web technology, TangoJS layout can be configured via CSS rules. The
application developer may then use media queries [@gardner2011responsive]
together with appropriate selectors to adapt the widgets automatically to the
device they are displayed on.

Apart from all the adaptability aspects offered by separate widgets, the
*TangoJS Panel* application allows users to configure the interface manually,
by choosing *what widgets* are displayed, *where* the widgets are displayed and
*what fields* are included in each widget. This allows the user for building
personalized *synpotic panels*, adapted for the current requirements and
changed dynamically.

**Simplicity.**
TangoJS is simple to start with and has a minimal learning curve. Only general
knowledge of web development is required to create own applications. There
are no third-party frameworks involved and the set of dependencies is kept
minimal. All components from the TangoJS stack have been deployed to the npm.
Thus, including TangoJS is as simple as adding a new dependency to the
project. Novice developers to TangoJS may choose to start with a blank web
application template available in TangoJS repositories.

**Extensibility.**
TangoJS has been designed to be extensible at many levels. The whole backend
part, which connects TangoJS to the TANGO infrastructure, may be replaced, by
writing a dedicated *Connector*. This pluggable backends allow TangoJS to be
adapted to certain deployment requirements and network configuration.
It is also possible to extend the behavior of TangoJS by implementing new
widgets. Developers are supported in this task by the various utility functions
available in the *TangoJS Web Components* package.

**Standards-driven.**
By using only standard web technologies, a wider audience of developers can be
targeted. Web standards form the core of browser-based development, and every
other framework is built upon them. It is safe to assume that most
web developers are familiar with raw DOM APIs. This also makes TangoJS a
future-proof technology and does not expose it to the risk of being tied to
old, unpopular or deprecated third party libraries.

**User experience.**
Any piece of software exposed for direct interactions with end-users that has
to care about user experience. This is especially crucial in case of graphical
applications. The overall user experience consists of various factors like UI's
usability, accessibility and design. Since TangoJS is a library, not an
application, thus, it makes no sense to evaluate TangoJS against these factors.
Instead, a more detailed analysis of *TangoJS Panel* application is provided in
[@Sec:05-usability-evaluation].

## Comparison with existing solutions

TangoJS can be used as a frontend for any of the existing backend solutions,
including *Tango REST*, *Taurus Web* or *mTango*. In case of *mTango* it may be
used as a replacement for its native frontend layer.
[@Tbl:05-comparison-existing] compares TangoJS to the existing web-based TANGO
frontend libraries.

+---------------+---------------+---------------+---------------+---------------+
| Feature       | Canone        | Taurus Web    | mTango        | TangoJS       |
+===============+===============+===============+===============+===============+
| Has widgets   | yes, (limited | no            | yes, (5 views,| **yes, (7 base|
|               | AJAX support) |               |image and plot)| widgets and   |
|               |               |               |               | variants)**   |
+---------------+---------------+---------------+---------------+---------------+
|               |               |               |               |               |
+---------------+---------------+---------------+---------------+---------------+
| Has           | yes           | N/A           | no            | **yes, (      |
| interactive   |               |               |               | *TangoJS      |
| *synoptic     |               |               |               | Panel*)**     |
| panel*        |               |               |               |               |
+---------------+---------------+---------------+---------------+---------------+
|               |               |               |               |               |
+---------------+---------------+---------------+---------------+---------------+
| Supports user | yes (database)| no            | yes (multiple | **N/A,        |
| accounts      |               |               | options)      | (depends on   |
|               |               |               |               | backend)**    |
+---------------+---------------+---------------+---------------+---------------+
|               |               |               |               |               |
+---------------+---------------+---------------+---------------+---------------+
| Supports      | no            | no            | ues           | **no**        |
| TANGO events  |               |               |               |               |
+---------------+---------------+---------------+---------------+---------------+
|               |               |               |               |               |
+---------------+---------------+---------------+---------------+---------------+
| Backend server| PHP, Python   | Python,       | Java,         | **N/A,        |
| technology    |               | Tornado,      | RESTEasy,     | (depends on   |
|               |               | WebSocket     | HTTP          | backend)**    |
+---------------+---------------+---------------+---------------+---------------+

Table: Comparison of TangoJS with existing web-based GUI libraries. {#tbl:05-comparison-existing}

Only the web-related aspects have been chosen as comparison criteria. The
comparison indicates that the TangoJS is the leading choice in all categories
but TANGO events support. **Events are currently not implemented and shall be
addressed in future releases. Use of events can significantly reduce network
traffic, but it requires support on both the frontend and backend side.**

## Usability evaluation { #sec:05-usability-evaluation }

A quantitative evaluation of user interfaces is a complex task and the results
are often different from real user experiences [@vaananen2008towards]. This is
due to the involvement of rather unpredictable human factors, like mind,
perception or personal preferences. To address these issues, a method called
*heuristic evaluation* has emerged [@nielsen1990heuristic]. This is one of the
*usability engineering* methods.

The heuristic evaluation helps to detect problems with the software usability,
by examining the user interface in the context of a set of well-defined
principles, called *heuristics*. The most widely used heuristics have been
proposed by the Jakob Nielsen in 1994 [@nielsen1994heuristic]. They are however
still applicable to today's software.

The heuristic evaluation is not the only method of *usability inspection*.
There have been other, more formal methods proposed [@nielsen1994usability],
like *cognitive walkthrouhgs*, *formal inspections*, *feature inspections* or
*standards inspections*. These methods usually require involving domain
experts who provide a usability feedback.

The heuristic evaluation is quite a simple method and produces a
reasonable outcome. It has been chosen to evaluate TangoJS' usability and user
experience. The 10 heuristics, as formulated by Nielsen [@nielsen1994usability]:

> 1. **Visibility of system status:**
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

The above heuristics have been applied to *TangoJS Panel* application as well as to
separate widgets to detect potential usability issues.

**Visibility of system status.**
Most widgets in TangoJS have a *quality*/*status* LED bulb indicator. In the
normal mode of operation this bulb shows status received from device server.
Whenever a communication error occurs, the indicator changes its color. This
directly translates to the visibility of system in the case of *Panel*
application.

**Match between system and the real world.**
TangoJS widgets map directly to the corresponding entities in TANGO's object
model, like *devices* or *attributes*. Each widget has a strict set of
responsibilities and usually performs a limited number of operations, like
reading or writing a value. The dashboards in the *Panel* application correspond to
physical panels and switches in real-world control rooms.

**User control and freedom.**
The use cases for TangoJS widgets are simple and often consist of a single
action. In case of the *Panel* application, users can re-arrange the widgets
and remove unwanted ones.

**Consistency and standards.**
The widgets are consistent one with another and they share the same set of
design principles related to the functionality and layout. The widgets have
been inspired by the Taurus framework, which is the leading and widely used
library for creating widget-based GUI clients for TANGO on desktops.

**Error prevention.**
In case of web-based or distributed applications it is impossible to prevent
errors from occurring. This is due to the fact that whenever network
communication is involved, the errors may happen. In such a case, the widgets
are inoperable, until the communication is back, e.g. the backend server
becomes reachable again. These errors are indicated to the user. Other kinds of
errors are handled and corrected by the widget code, e.g. a bad input.

**Recognition rather than recall.**
The widgets in TangoJS are simple pieces of UI. There are no dialog boxes or
nested views and user always interacts with a single view that maps directly to
a TANGO entity. The *Panel* application uses dialogs, e.g. for initial widget
configuration, but the dialog view includes only entries related to a single
widget, like HTML attributes configuration.

**Flexibility and efficiency of use.**
From the end-user's perspective, the *accelerators*, as defined by Nielsen,
are not applicable to TangoJS at the current stage. The UI is flat, with almost
no nested dialogs. Most of the time use cases are just single actions.

**Aesthetic and minimalist design.**
The TangoJS GUI is kept clean and minimal. It's up to the application developer
to decide what information will be included in the widget's layout, e.g a unit
field or a quality bulb. In the case of the *Panel* application, the user can
decide which widgets are present on the dashboard and what fields are included.

**Help users recognize, diagnose, and recover from errors.**
If an error occurs within a widget, the user is only informed by the change of
indicator's color. No message is displayed to the user. The same applies to
the *Panel* application.

**Help and documentation.**
TangoJS provides an extensive set of resources, for both developers and
end-users, including webpage, widget specifications, API documentation and
template project to get started.

From the analysis carried out, we see that the **rule related to error the
diagnosis is violated by TangoJS**, as the user does not get sufficient
information in case of an error. An explanation of error cause may help him/her
to diagnose the problem and find a solution, or at least submit a descriptive
ticket in the TangoJS issue tracker. This problem is going to be addressed in
future TangoJS releases. Since a widget should not pop with alerts on its own,
a reasonable way of error indication has to be proposed.

The analysis performed according to Nielsen's heuristics may quickly provide
GUI developers with a useful feedback, without a need to involve other people,
like UI experts or targeted users. The outcome of heuristic evaluation are
those usability problems that may affect user experience. By performing the
analysis during software development, one may address these issues at an early
stage.
