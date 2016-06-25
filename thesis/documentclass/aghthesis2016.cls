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
  Uprzedzony o odpowiedzialności karnej na podstawie art. 115 ust. 1 i 2 ustawy
  z dnia 4 lutego 1994 r. o prawie autorskim i prawach pokrewnych (t.j. Dz.U.
  z 2006 r. Nr 90, poz. 631  z późn. zm.): "Kto przywłaszcza sobie autorstwo
  albo wprowadza w błąd co do autorstwa całości lub części cudzego utworu albo
  artystycznego wykonania, podlega grzywnie, karze ograniczenia wolności albo
  pozbawienia wolności do lat 3. Tej samej karze podlega, kto rozpowszechnia
  bez podania nazwiska lub pseudonimu twórcy cudzy utwór w wersji oryginalnej
  albo w postaci opracowania, artystyczne wykonanie albo publicznie
  zniekształca taki utwór, artystyczne wykonanie, fonogram, wideogram lub
  nadanie.", a także uprzedzony o odpowiedzialności dyscyplinarnej na
  podstawie art. 211 ust. 1 ustawy z dnia 27 lipca 2005 r. Prawo o
  szkolnictwie wyższym (t.j. Dz. U. z 2012 r. poz. 572, z późn. zm.) "Za
  naruszenie przepisów obowiązujących w uczelni oraz za czyny uchybiające
  godności studenta student ponosi odpowiedzialność dyscyplinarną przed komisją
  dyscyplinarną albo przed sądem koleżeńskim samorządu studenckiego, zwanym
  dalej 'sądem koleżeńskim'", oświadczam, że niniejszą pracę dyplomową
  wykonałem(-am) osobiście i samodzielnie i że nie korzystałem(-am) ze źródeł
  innych niż wymienione w pracy.
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
