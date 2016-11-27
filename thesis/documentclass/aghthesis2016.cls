\NeedsTeXFormat{LaTeX2e} %
\ProvidesClass{aghthesis2016}

\RequirePackage[utf8]{inputenc}

% DECLARING OPTIONS

\DeclareOption{titlepage-polish}
{
\newcommand*{\LangAgh}{Akademia Goóniczo-Hutnicza\\[2mm] im. Stanisława Staszica w Krakowie}
\newcommand*{\LangFaculty}{Wydział Informatyki, Elektroniki i Telekomunikacji}
\newcommand*{\LangDepartment}{Katedra Informatyki}
\newcommand*{\LangSupervisor}{Opiekun pracy}
\newcommand*{\LangStatementHead}{OŚWIADCZENIE AUTORA PRACY}
\newcommand*{\LangStatementBody}{
  Uprzedzony o~odpowiedzialności karnej na podstawie art. 115 ust. 1 i 2 ustawy
  z~dnia 4~lutego 1994 r. o~prawie autorskim i~prawach pokrewnych (t.j. Dz.U.
  z~2006 r. Nr 90, poz. 631  z~późn. zm.): "Kto przywłaszcza sobie autorstwo
  albo wprowadza w~błąd co do autorstwa całości lub części cudzego utworu albo
  artystycznego wykonania, podlega grzywnie, karze ograniczenia wolności albo
  pozbawienia wolności do lat 3. Tej samej karze podlega, kto rozpowszechnia
  bez podania nazwiska lub pseudonimu twórcy cudzy utwór w~wersji oryginalnej
  albo w~postaci opracowania, artystyczne wykonanie albo publicznie
  zniekształca taki utwór, artystyczne wykonanie, fonogram, wideogram lub
  nadanie.", a~także uprzedzony o~odpowiedzialności dyscyplinarnej na
  podstawie art. 211 ust. 1~ustawy z~dnia 27 lipca 2005 r. Prawo o
  szkolnictwie wyższym (t.j. Dz. U. z~2012 r. poz. 572, z~późn. zm.) "Za
  naruszenie przepisów obowiązujących w~uczelni oraz za czyny uchybiające
  godności studenta student ponosi odpowiedzialność dyscyplinarną przed komisją
  dyscyplinarną albo przed sądem koleżeńskim samorządu studenckiego, zwanym
  dalej 'sądem koleżeńskim'", oświadczam, że niniejszą pracę dyplomową
  wykonałem(-am) osobiście i~samodzielnie i~że nie korzystałem(-am) ze źródeł
  innych niż wymienione w~pracy.
}
\newcommand*{\LangSignature}{PODPIS}
\newcommand*{\LangThesisType}{Praca dyplomowa magisterska}
\newcommand*{\LangAuthor}{Autor}
\newcommand*{\LangMajor}{Kierunek}
}

\DeclareOption{titlepage-english}
{
\newcommand*{\LangAgh}{AGH University of Science and Technology}
\newcommand*{\LangFaculty}{Faculty of Computer Science, Electronics and Telecommunications}
\newcommand*{\LangDepartment}{Department of Computer Science}
\newcommand*{\LangSupervisor}{Supervisor}
\newcommand*{\LangStatementHead}{NON-PLAGIARISM STATEMENT}
\newcommand*{\LangStatementBody}{
  I hereby declare that I have written this thesis completely by myself, that
  I have used no other sources or resources than the ones mentioned, and that
  I am aware of the rules of the Penal Code referring to criminal liability
  for providing false evidence.
}
\newcommand*{\LangSignature}{SIGNATURE}
\newcommand*{\LangThesisType}{MSc thesis}
\newcommand*{\LangAuthor}{Author}
\newcommand*{\LangMajor}{Major}
}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}


% PROCESSING OPTIONS
\ProcessOptions
\LoadClass[a4paper,twoside]{report}


\RequirePackage{setspace}
\RequirePackage{times}
\RequirePackage[T1]{fontenc}
\RequirePackage{graphicx}
\RequirePackage{geometry}
\RequirePackage[usenames]{color}
\RequirePackage{fancyhdr}
\RequirePackage{titlesec}
\RequirePackage{babel}

% LaTeX Error: Command `\lll' already defined.
% http://www.rexamine.com/2013/04/latex-polish-babel-and-amssymb-conflict/
\let\lll\undefined



\addto\captionspolish{%
  \def\bibname{Materialy zrodlowe}%
  \def\refname{Materialy zrodlowe}%
  \def\listtablename{Spis tabel}%
  \def\tablename{Tabela}%
}


\geometry{bindingoffset=10mm, lmargin=20mm, rmargin=20mm, tmargin=25mm, bmargin=25mm, foot=10mm, head=10mm}


\renewcommand{\baselinestretch}{1.1}

\def\title#1        {\gdef\@title{#1}}
\def\subtitle#1     {\gdef\@subtitle{#1}}
\def\faculty#1      {\gdef\@faculty{#1}}
\def\thesistype#1   {\gdef\@thesistype{#1}}
\def\supervisor#1   {\gdef\@supervisor{#1}}
\def\major#1   {\gdef\@major{#1}}

\bibliographystyle{abbrv}

%------------------------------------------------------------------------------


\renewcommand{\maketitle}{%


\newpage \titlepage

\begin{center}

\includegraphics[width=160pt,viewport=250 350 350 500]{{agh_nzw_s_pl_1w_wbr_cmyk}.pdf}

\MakeUppercase{\textbf{\normalsize \LangFaculty}}
\vspace*{0.5cm}

\MakeUppercase{\small \LangDepartment}
\vspace*{1.5cm}

\MakeUppercase{\textbf{\large \LangThesisType}}\\
\vspace*{2.5cm}

% \doublespacing

\textit{\LARGE \@title}\\
\vspace*{1.5cm}

\textit{\normalsize \@subtitle}\\
\vspace*{1.5cm}

\vspace*{2.5cm}

\end{center}

{\small
\begin{tabular}{p{100pt}l}
\LangAuthor: & \@author \\
\LangMajor: & \@major \\
\LangSupervisor: & \@supervisor
\end{tabular}
}

\vspace*{\fill}

\begin{center}

\vspace*{1mm}
{\large Kraków, \@date}

\end{center}

%------------------------------------------------------------------------------

\newpage
\thispagestyle{empty}

%\vspace*{15cm}
\mbox{}
\vfill

\begin{flushright}
\begin{minipage}[!h]{13cm}
\mbox{\large{\scshape \LangStatementHead}}\\[3mm]
{\small \LangStatementBody}\\
\end{minipage}

\vspace{2cm}

\makebox[6cm][s]{\dotfill}\par
\makebox[6cm][c]{\small \LangSignature}

\end{flushright}

%------------------------------------------------------------------------------

\clearpage
\setcounter{page}{3}

\newenvironment{acknowledgements}%
{\cleardoublepage\thispagestyle{plain}\null\vfill\begin{center}%
\bfseries Acknowledgements\end{center}}%
{\vfill\null}
\begin{acknowledgements}

I would like to express my gratitude to my supervisor, \textbf{Dr.~Włodzimierz
Funika} for his guidance and support over the last two years. This work would
not have been possible without his help and engagement.


I would also like to thank the whole NSRC Solaris team, especially \textbf{
Mr.~Łukasz Żytniak} and \textbf{Mr.~Piotr Goryl}. Łukasz was an invaluable
source of field-related expertise while Piotr took the responsibility for the
project management.

\end{acknowledgements}

%------------------------------------------------------------------------------

\cleardoublepage

\begin{abstract}

\setcounter{page}{5}
\thispagestyle{plain}

Hardware installations in natural sciences and industry are becoming more and
more complex. This raised a need for more sophisticated methods of control
over growing number of devices. To address these needs, the \textbf{TANGO
Control System} has been developed at ESRF as a generic framework for building
distributed control systems. TANGO allows building graphical control panels
composed of various widgets. As TANGO is a CORBA-based software, these client
applications can run only on desktop.


Recently,
thanks to their numerous benefits over conventional desktop applications,
\textbf{web applications} are more and more widely used in different areas.
Among a few attempts of moving TANGO applications to the web browsers, none
gained popularity and wide adoption. Most projects have been abandoned
reaching only a proof-of-concept stage.


In Thesis we present \textbf{TangoJS}, a modular, extensible software
stack for building TANGO client applications. TangoJS addresses the faults and
drawbacks of the existing solutions. Its architecture is layered for increased
flexibility and easier maintenance. Multiple backend modules are supported,
which allows accessing TANGO infrastructure using different technologies and
protocols. TangoJS' Programmable API uses well-defined abstractions and
interfaces from TANGO IDL specification. Web application developers are
provided with a set of configurable widgets, which are building blocks for
more complex user interfaces.
TangoJS has been designed in compliance with the latest web standards and
componentization in mind.
The use of frontend technologies allows for building adaptive user interfaces,
where widget's sizing and layout depends on context. Other than that,
TangoJS provides an interactive application that allows to manually manipulate
its interface at runtime.
\end{abstract}

\cleardoublepage

% \clearpage
% \setcounter{page}{3}

}

%\ProcessOptions

\pagestyle{fancy}
\renewcommand{\sectionmark}[1]{\markright{\thesection.\ #1}}
\renewcommand{\headrulewidth}{0.5pt}
\fancyhf{}
\fancyhead{}

\fancyhead[LE]{\bfseries \thepage}
\fancyhead[RO]{\bfseries \thepage}

\frenchspacing
\sloppy
\widowpenalty     9999
\clubpenalty      9999
\flushbottom




\titleformat{\section}[block]
{\bfseries\Large}{\filright \Large\thesection. }{0ex}{}
\titleformat{\subsection}[block]
{\bfseries\large}{\filright \large\thesubsection. }{0ex}{}
\titleformat{\subsubsection}[block]
{\bfseries\normalsize}{\filright \normalsize\thesubsubsection. }{0ex}{}
