% rgcv.cls -- Unified CV class for Rohit Goswami
% Modes: fullcv (multi-page academic), twopage (concise), onepage (highlight)
\ProvidesClass{rgcv}[2025/03/09 Unified CV class]
\NeedsTeXFormat{LaTeX2e}

% Mode options
\newif\if@fullcv\@fullcvfalse
\newif\if@twopage\@twopagefalse
\newif\if@onepage\@onepagefalse

\DeclareOption{fullcv}{\@fullcvtrue}
\DeclareOption{twopage}{\@twopagetrue}
\DeclareOption{onepage}{\@onepagetrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

% Base class -- fullcv uses moderncv, others use article
\if@fullcv
  \LoadClass[10pt,a4paper,final,factor=1100,stretch=18,shrink=18]{moderncv}
  \moderncvstyle{classic}
  \definecolor{color1}{RGB}{1, 52, 64}
\else
  \LoadClass{article}
\fi

%-----------------------------------------------------------------------
% Shared color
%-----------------------------------------------------------------------
\RequirePackage[usenames,dvipsnames]{xcolor}
\definecolor{cvteal}{RGB}{1, 52, 64}
\if@fullcv\else
  \definecolor{primary}{HTML}{2b2b2b}
  \definecolor{headings}{HTML}{6A6A6A}
  \definecolor{subheadings}{HTML}{333333}
  \definecolor{date}{HTML}{666666}
\fi

%-----------------------------------------------------------------------
% Fonts (compact modes)
%-----------------------------------------------------------------------
\if@fullcv\else
  \RequirePackage{fontspec}
  \RequirePackage{hyperref}

  % Use Minion Pro / Myriad Pro matching fullcv
  \setmainfont[
    Path = ../shared/Fonts/MinionPro/,
    Numbers=OldStyle,
    Extension = .otf,
    UprightFont = *_Regular,
    ItalicFont = *_It,
    BoldFont = *_Bold,
    BoldItalicFont = *_BoldIt
  ]{MinionPro}

  \setsansfont[
    Path = ../shared/Fonts/MyriadPro/,
    Numbers=OldStyle,
    Extension = .otf,
    UprightFont = *_Regular,
    ItalicFont = *_It,
    BoldFont = *_Bold,
    BoldItalicFont = *_BoldIt,
    Ligatures=TeX,
    Scale=MatchLowercase
  ]{MyriadPro}
\fi

%-----------------------------------------------------------------------
% Geometry (mode-dependent)
%-----------------------------------------------------------------------
\if@fullcv
  \RequirePackage{geometry}
  \geometry{a4paper, left=12mm, right=12mm, top=13mm, bottom=13mm}
  \setlength{\hintscolumnwidth}{2.5cm}
  \AtBeginDocument{\recomputelengths}
\fi
\if@twopage
  \RequirePackage{geometry}
  \geometry{a4paper, left=11mm, right=11mm, top=10mm, bottom=10mm}
\fi
\if@onepage
  \RequirePackage{geometry}
  \geometry{letterpaper, left=10mm, right=10mm, top=5mm, bottom=5mm}
\fi

%-----------------------------------------------------------------------
% Spacing macros
%-----------------------------------------------------------------------
\if@fullcv
  \newcommand{\spacesection}{\vspace{0.4cm}}
  \newcommand{\spacesubsection}{\vspace{0.2cm}}
\fi
\if@twopage
  \newcommand{\spacesection}{\vspace{0.2cm}}
  \newcommand{\spacesubsection}{\vspace{0.1cm}}
\fi
\if@onepage
  \newcommand{\spacesection}{\vspace{0.1cm}}
  \newcommand{\spacesubsection}{\vspace{0.05cm}}
\fi

%-----------------------------------------------------------------------
% Compact mode commands (twopage + onepage)
%-----------------------------------------------------------------------
\if@fullcv\else
  \RequirePackage[absolute]{textpos}
  \RequirePackage[UKenglish]{isodate}
  \RequirePackage{titlesec}

  \setlength{\TPHorizModule}{0.01\paperwidth}
  \setlength{\TPVertModule}{0.01\paperwidth}

  % Last updated stamp
  \newcommand{\lastupdated}{%
    \begin{textblock}{25}(75,2)
    \color{date}\fontsize{8pt}{10pt}\selectfont
    Last Updated on \today
    \end{textblock}}

  % Name section
  \newcommand{\namesection}[3]{%
    \centering{%
      \if@onepage
        \fontsize{40pt}{60pt}\selectfont
      \else
        \fontsize{30pt}{45pt}\selectfont
      \fi
      {\fontseries{ul}\selectfont #1}
      {\fontseries{l}\selectfont #2}%
    }\\[5pt]
    \centering{%
      \color{headings}\fontsize{11pt}{14pt}\selectfont #3}
    \noindent\makebox[\linewidth]{\color{headings}\rule{\paperwidth}{0.4pt}}
    \vspace{-5pt}}

  % Section titles
  \titlespacing{\section}{0pt}{0pt}{0pt}
  \titlespacing{\subsection}{0pt}{0pt}{0pt}
  \newcommand{\sectionspace}{\vspace{8pt}}

  \titleformat{\section}{%
    \color{headings}\scshape\fontsize{16pt}{24pt}\selectfont\raggedright\uppercase}{}{0em}{}

  \titleformat{\subsection}{%
    \color{subheadings}\fontsize{12pt}{12pt}\selectfont\bfseries\uppercase}{}{0em}{}

  % Run subsection (inline title)
  \newcommand{\runsubsection}[1]{%
    \color{subheadings}\fontsize{12pt}{12pt}\selectfont\bfseries\uppercase{#1}\normalfont}

  % Description
  \newcommand{\descript}[1]{%
    \color{subheadings}\raggedright\scshape\fontsize{11pt}{13pt}\selectfont{#1\\}\normalfont}

  % Location
  \newcommand{\location}[1]{%
    \color{headings}\raggedright\fontsize{10pt}{12pt}\selectfont{#1\\}\normalfont}

  % Tight itemize
  \newenvironment{tightitemize}{%
    \vspace{-\topsep}\begin{itemize}\itemsep1pt \parskip0pt \parsep0pt}
    {\end{itemize}\vspace{-\topsep}}

  % CV entry for twopage mode (date-title-org-loc-desc)
  \newcommand{\cventry}[5]{%
    {\color{headings}\fontsize{10pt}{12pt}\selectfont #1}\hfill
    {\color{subheadings}\fontsize{11pt}{13pt}\selectfont\bfseries #2}\\
    {\color{subheadings}\scshape\fontsize{11pt}{13pt}\selectfont #3}%
    \if\relax\detokenize{#4}\relax\else{ -- \color{headings}\fontsize{10pt}{12pt}\selectfont #4}\fi\\
    \if\relax\detokenize{#5}\relax\else{\fontsize{10pt}{12pt}\selectfont #5}\fi
    \vspace{4pt}}

  % Skills section
  \newcommand{\skillsection}[2]{%
    {\color{subheadings}\fontsize{11pt}{13pt}\selectfont\bfseries #1:}
    {\fontsize{10pt}{12pt}\selectfont #2}\\}
\fi

%-----------------------------------------------------------------------
% Microtype (all modes, loaded by moderncv for fullcv)
%-----------------------------------------------------------------------
\if@fullcv\else
  \RequirePackage[final,factor=1000,stretch=18,shrink=18]{microtype}
\fi

%-----------------------------------------------------------------------
% Shared utilities
%-----------------------------------------------------------------------
\RequirePackage{xspace}

% Logo commands
\newcommand{\metatensor}{\texttt{metatensor}\xspace}
\newcommand{\metatomic}{\texttt{metatomic}\xspace}
\newcommand{\metatrain}{\texttt{metatrain}\xspace}
\newcommand{\cxx}{C\nolinebreak\hspace{-.05em}\raisebox{.4ex}{\tiny\bf +}\nolinebreak\hspace{-.10em}\raisebox{.4ex}{\tiny\bf +}\xspace}

\endinput
