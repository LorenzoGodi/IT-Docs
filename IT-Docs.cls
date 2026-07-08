% =============================================================================
% IT-Docs.cls — Classe LaTeX per documenti IT professionali
% =============================================================================
%
% Questa classe fornisce l'infrastruttura completa per generare documenti
% di consulenza informatica: resoconti attivita, report tecnici, preventivi
% e proposte.
%
% Basata sulla classe standard "article", aggiunge:
%   - Palette colori coerente per stati e tabelle
%   - Icone modalita di lavoro (remoto / presenza / con trasporto)
%   - Icone stato attivita (completato / in corso / programmato / idea)
%   - Tabelle attivita, roadmap, ore e sottrazioni pronte all'uso
%   - Sistema di riferimenti centralizzato con validazione
%   - Layout pagina con header a tre colonne e footer con numero pagina
%   - Comando \showlogo per posizionare un logo in alto a destra
%
% USO:
%   \documentclass[a4paper,9pt]{IT-Docs}
%   \input{info_common}     % identita studio (docstudio, docautore, ...)
%   \input{riferimenti}     % registro codici riferimento
%   \input{info}            % metadati documento (doctitolo, docdata, ...)
%   \begin{document}
%     ...
%   \end{document}
%
% DIPENDENZE ESTERNE:
%   Il documento deve definire i seguenti comandi prima di \begin{document}:
%     \docstudio   — nome dello studio / azienda
%     \docluogo    — sede dello studio
%     \doctitolo   — titolo del documento
%     \docdata     — data del documento
%     \docautore   — nome dell'autore
%     \docmail     — e-mail dell'autore
%
%   Comandi opzionali (richiesti solo da certi tipi di documento):
%     \doctariffa      — tariffa oraria in euro (per resoconti)
%     \docriferimento  — codice riferimento (per report tecnici)
%     \docsottotitolo  — sottotitolo (per preventivi e proposte)
%
% PERSONALIZZAZIONE:
%   \setsectionstyle{nome}  — stile titoli sezione (classico|barra|banda)
%
% =============================================================================
%
%
% INDICE SEZIONI
% ──────────────
%   1. Classe base ............... Identificazione, opzioni ([discorsivo])
%   2. Pacchetti ................. Tutti i RequirePackage, metadati PDF
%   3. Colori .................... 8 definecolor (primario, stati, tabelle)
%   4. Formattazione sezioni ..... \setsectionstyle (classico|barra|banda)
%   5. Icone modalita ............ modRemoto, modPresenza, modAuto
%   6. Icone stato ............... staFatto, staFacendo, staDafare, staIdea
%   7. Lista compatta ............ ambiente D
%   8. Comandi di utilita ........ ppf, vspaceheader, tablespacing
%   9. Formattazione valuta ...... \eur, \numero
%  10. Caselle legenda ........... legendabox, legendaModalita, legendaStato
%  11. Configurazione ............ \ITDocsSetup (colori, logo), \doclogo
%  12. Sistema riferimenti ....... defref, rif, rifdesc
%  12a.Titolo documento automatico  tipo + cartella dal Makefile
%  12b.Data documento automatica . \setdocdata, data max attivita
%  13. Comando attivita .......... \att (tracciamento data, \ripetidate)
%  14. Comando roadmap ........... \road
%  15. Rapporto ore .............. addhours, totale fp \tothoursval
%  16. Sottrazioni ............... addsubt, totale fp \totsubtval
%  17. Tabelle riusabili ......... tabellaAttivita, tabellaRoadmap,
%                                  tabellaOre, tabellaSottrazioni,
%                                  \saldodovuto
%  18. Sezione report ............ \reportsezione
%  19. Componenti preventivo ..... comp, tabellaComponenti, preventivototali
%  20. Toggle orientamento ....... setlandscape, setportrait
%  21. Layout pagina ............. fancyhdr, secnumdepth, parindent
%  22. Logo ...................... \showlogo (altezza via ITDocsSetup)
%


%#region Classe base
% ─── Identificazione classe ─────────────────────────────────────────────────
%
% \NeedsTeXFormat specifica la versione minima di LaTeX richiesta.
% Usiamo 2022/06/01 perche da quella data il kernel LaTeX include
% nativamente \NewDocumentCommand (xparse), \fpeval (xfp), i simboli
% di textcomp e il layer di programmazione expl3: nessuno di quei
% pacchetti va piu caricato.
%
% \ProvidesClass registra il nome, la data e la descrizione della classe.
% La data segue il formato ISO: AAAA/MM/GG.
%
\NeedsTeXFormat{LaTeX2e}[2022/06/01]
\ProvidesClass{IT-Docs}[2026/07/08 v1.2 Classe documenti IT professionali]


% ─── Opzioni ────────────────────────────────────────────────────────────────
%
% discorsivo
%   Margini laterali piu ampi (2cm invece di 1cm) per i documenti
%   prevalentemente testuali (report, proposte): con 1cm la giustezza
%   arriva a ~110 battute per riga, faticosa da leggere.  I documenti
%   tabellari (resoconti, preventivi) restano a 1cm per sfruttare la
%   larghezza.
%
% Tutte le altre opzioni vengono inoltrate alla classe base:
%   \documentclass[a4paper,9pt]{IT-Docs}
%   \documentclass[a4paper,9pt,discorsivo]{IT-Docs}
%
\newif\if@itdocs@discorsivo \@itdocs@discorsivofalse
\DeclareOption{discorsivo}{\@itdocs@discorsivotrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\ProcessOptions\relax


% ─── Classe base ────────────────────────────────────────────────────────────
%
% IT-Docs estende extarticle (pacchetto extsizes), variante di article
% adatta a documenti brevi senza capitoli — perfetta per resoconti,
% report, preventivi e proposte di poche pagine.
%
% Si usa extarticle e NON article perche article supporta solo 10/11/12pt:
% l'opzione 9pt usata da tutti i documenti verrebbe SILENZIOSAMENTE
% ignorata (warning "Unused global option(s)") componendo a 10pt.
% extarticle supporta corpi da 8 a 20pt ed e drop-in compatibile.
%
\LoadClass{extarticle}
%#endregion Classe base


%#region Pacchetti
% =============================================================================
%
%  PACCHETTI
%
% =============================================================================
%
% Tutti i pacchetti necessari sono caricati qui, in un ordine preciso.
% In un file .cls si usa \RequirePackage al posto di \usepackage —
% il comportamento e identico, ma \RequirePackage e la convenzione
% standard per le classi perche puo essere chiamato anche prima di
% \documentclass.
%
% REGOLA: aggiungere nuovi pacchetti QUI, non nei file di progetto.
% =============================================================================


% ─── Codifica e font ─────────────────────────────────────────────────────────
%
% fontenc [T1]
%   Seleziona la codifica di output T1 (256 glifi per font).
%   Senza di essa LaTeX usa la vecchia codifica OT1 (128 glifi), che non
%   riesce a sillabare correttamente parole con caratteri accentati e
%   produce risultati errati nel copia-incolla dal PDF.
%
% inputenc [utf8]
%   Indica a LaTeX che i file sorgente sono salvati in UTF-8.
%   Il LaTeX moderno lo usa gia di default, ma caricarlo esplicitamente
%   rende l'assunzione visibile e previene sorprese.
%
% lmodern
%   Latin Modern: versione moderna e scalabile di Computer Modern.
%   Senza lmodern, la codifica T1 ricadrebbe sui font bitmap.
%   (I simboli di textcomp, incluso \texteuro, sono nel kernel dal 2020.)
%
% microtype
%   Abilita raffinamenti tipografici invisibili singolarmente ma che
%   rendono la pagina complessivamente piu gradevole: protrusione dei
%   caratteri ed espansione del font per ridurre le sillabazioni.
%
\RequirePackage[utf8]{inputenc}
\RequirePackage{lmodern}
\RequirePackage[T1]{fontenc}
\RequirePackage{microtype}

% babel [italian]
%   Localizzazione italiana: pattern di sillabazione corretti per il
%   testo dei documenti, \today in italiano, nomi delle strutture.
%   Senza babel la sillabazione usa i pattern inglesi (errata su testo
%   italiano) e \today produce "July 3, 2026".
%
\RequirePackage[italian]{babel}


% ─── Layout ──────────────────────────────────────────────────────────────────
%
% geometry
%   Imposta le dimensioni della pagina.  Margini laterali stretti (1 cm)
%   per massimizzare lo spazio utile in documenti densi di tabelle;
%   con l'opzione di classe [discorsivo] salgono a 2 cm per una
%   giustezza piu leggibile nei documenti testuali.
%   Il top maggiorato (3 cm) lascia spazio all'header a tre colonne.
%   headheight=38pt e necessario perche l'header contiene due righe di testo.
%
%   \itdocs@hmargin e condiviso con la geometria landscape di
%   \setlandscape: un solo punto di verita per i margini laterali.
%
\if@itdocs@discorsivo
  \def\itdocs@hmargin{2cm}
\else
  \def\itdocs@hmargin{1cm}
\fi

\RequirePackage[
  hmargin=\itdocs@hmargin,
  top=3cm,
  headheight=38pt,
  headsep=1cm,
  marginparwidth=0cm,
  bottom=2cm,
  footskip=1cm,
]{geometry}


% ─── Colori ──────────────────────────────────────────────────────────────────
%
% xcolor [table]
%   L'opzione [table] carica anche il pacchetto colortbl, necessario per
%   \rowcolors e \cellcolor nelle tabelle zebrate.
%   Va caricato PRESTO perche molti altri pacchetti (hyperref, tikz)
%   potrebbero provare a caricarlo con opzioni diverse, causando conflitti.
%
\RequirePackage[table]{xcolor}


% ─── Tabelle e liste ────────────────────────────────────────────────────────
%
% enumitem
%   Controllo completo sugli ambienti di elenco (itemize, enumerate).
%   Usato per definire la lista compatta "D" con [nosep].
%
% ltablex
%   Combina le funzionalita di longtable (tabelle multi-pagina) e
%   tabularx (colonne X a larghezza flessibile).
%
% booktabs
%   Filetti orizzontali di qualita editoriale: \toprule, \midrule,
%   \bottomrule.  Standard de-facto per tabelle professionali.
%
% \keepXColumns
%   Direttiva di ltablex: mantiene le colonne X alla larghezza calcolata
%   anche nelle righe successive.  Senza di essa, la larghezza puo
%   variare da riga a riga producendo tabelle disallineate.
%
% hhline
%   Filetti orizzontali parziali compatibili con colortbl.  \cline viene
%   parzialmente COPERTA dal pannello colorato della riga successiva
%   (\cellcolor/\rowcolor): la linea sopra le celle "Totale" risultava
%   assottigliata.  \hhline non soffre del problema; va caricato dopo
%   colortbl (gia caricato da xcolor[table]).
%
\RequirePackage{enumitem}
\RequirePackage{ltablex,booktabs}
\keepXColumns
\RequirePackage{hhline}


% ─── Grafica ────────────────────────────────────────────────────────────────
%
% graphicx
%   Il modo standard per includere immagini esterne con
%   \includegraphics[opzioni]{file}.
%
% adjustbox [export]
%   L'opzione [export] rende disponibili le chiavi di adjustbox
%   direttamente in \includegraphics (es. max width, center).
%
% eso-pic [pscoord]
%   Permette di posizionare elementi in coordinate assolute sulla pagina
%   con \AddToShipoutPictureFG.  Usato dal comando \showlogo.
%   L'opzione [pscoord] usa coordinate PostScript (origine in basso a
%   sinistra), necessaria per il posizionamento preciso del logo.
%
\RequirePackage{graphicx}
\RequirePackage[export]{adjustbox}
\RequirePackage[pscoord]{eso-pic}


% ─── Matematica ──────────────────────────────────────────────────────────────
%
% amsmath
%   Pacchetto matematico essenziale con ambienti align, gather, ecc.
%
% nicefrac
%   Frazioni compatte stile 1/2 con \nicefrac{1}{2}.
%
% (\fpeval, usato per gli importi ore*tariffa, e nel kernel dal 2022:
%  il pacchetto xfp non serve piu.)
%
\RequirePackage{amsmath}
\RequirePackage{nicefrac}

% siunitx
%   Formattazione professionale dei numeri.  Usato da \eur e \numero per
%   stampare importi e quantita in convenzione italiana: virgola decimale,
%   punto delle migliaia (es. 1.020,00).  I default italiani sono impostati
%   qui una volta sola e valgono per ogni \num nei documenti.
%
\RequirePackage{siunitx}
\sisetup{
  output-decimal-marker={,},
  group-separator={.},
  group-minimum-digits=4,
}


% (\NewDocumentCommand — usato per \att, \road, \eur, ecc. — e nel
%  kernel dal 2020: il pacchetto xparse non serve piu.)


% ─── Icone ───────────────────────────────────────────────────────────────────
%
% fontawesome5
%   Oltre 1500 icone vettoriali utilizzabili come caratteri di testo.
%   Usato per le icone di modalita (\faRss, \faUser, \faCarSide) e
%   stato (\faCheck, \faSync, \faThumbtack, \faLightbulb).
%
\RequirePackage{fontawesome5}


% ─── TikZ ───────────────────────────────────────────────────────────────────
%
% tikz
%   Linguaggio di disegno integrato per diagrammi vettoriali.
%
% trees
%   Libreria TikZ per layout automatici ad albero.
%
% pgfcalendar
%   Modulo PGF per i calcoli sulle date.  Usato per ricavare il giorno
%   della settimana nella data documento automatica (vedi regione
%   "Data documento automatica").
%
\RequirePackage{tikz}
\usetikzlibrary{trees}
\RequirePackage{pgfcalendar}


% ─── Titoli ──────────────────────────────────────────────────────────────────
%
% titlesec
%   Personalizza completamente il formato dei titoli \section e
%   \subsection: font, colore, spaziatura, decorazioni.
%
\RequirePackage{titlesec}


% ─── Hyperlink e navigazione ────────────────────────────────────────────────
%
% hyperref [hidelinks]
%   Rende ogni \ref e URL un collegamento cliccabile nel PDF.
%   L'opzione [hidelinks] nasconde i riquadri colorati attorno ai link,
%   mantenendo un aspetto pulito per la stampa.
%   IMPORTANTE: hyperref va caricato QUASI ALLA FINE.
%
% fancyhdr
%   Sostituisce intestazioni e pie di pagina predefiniti con versioni
%   personalizzabili a tre colonne.
%
% lastpage
%   Fornisce \pageref{LastPage} per mostrare "Pagina X di Y" nel footer.
%
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}

% ─── Metadati PDF ───────────────────────────────────────────────────────────
%
% Titolo e autore nelle proprieta del PDF: il cliente che apre il file
% vede "RESOCONTO 2025/1 (Studio X)" nella finestra del viewer invece
% di un campo vuoto.  Impostati ad inizio documento, quando \doctitolo,
% \docstudio e \docautore sono ormai definiti.
%
\AtBeginDocument{%
  \itdocs@autotitolo% definisce \doctitolo se mancante (titolo automatico)
  \hypersetup{
    pdftitle={\doctitolo\ (\docstudio)},
    pdfauthor={\docautore},
  }%
}
%#endregion Pacchetti


%#region Colori
% =============================================================================
%
%  COLORI
%
% =============================================================================
%
% Ogni colore usato dalla classe e definito qui con nome descrittivo.
% I documenti possono usare questi nomi ovunque serva un colore
% (\color{colPrimario}, \textcolor{colFatto}{...}, \cellcolor{colTotale}).
%
% \definecolor{nome}{modello}{valore}
%   - "HTML"  = notazione esadecimale stile web (senza #)
%   - "gray"  = scala di grigi da 0 (nero) a 1 (bianco)
% =============================================================================

\definecolor{colPrimario}{HTML}{1A237E}  % blu scuro — titoli, filetti header
\definecolor{colFatto}{HTML}{2E7D32}     % verde     — stato: completato
\definecolor{colFacendo}{HTML}{E65100}   % arancione — stato: in corso
\definecolor{colDafare}{HTML}{C62828}    % rosso     — stato: programmato
\definecolor{colIdea}{HTML}{1565C0}      % azzurro   — stato: proposte / idee
\definecolor{colZebra}{gray}{0.93}       % grigio ch.— righe alternate tabelle
\definecolor{colLegenda}{gray}{0.95}     % grigio ch.— sfondo caselle legenda
\definecolor{colTotale}{HTML}{E8EAF6}    % lavanda   — celle totale nelle tabelle
%#endregion Colori


%#region Formattazione sezioni
% =============================================================================
%
%  FORMATTAZIONE SEZIONI
%
% =============================================================================
%
% La classe offre tre stili per i titoli \section, selezionabili con
% \setsectionstyle{nome} nel preambolo del documento.
%
% Stili disponibili:
%
%   classico — (default) Testo \Large grassetto in colPrimario con un
%              filetto orizzontale di 1.2pt a tutta larghezza sotto il titolo.
%
%   barra    — Barra verticale spessa (3pt) a sinistra in colPrimario,
%              testo rientrato.  Nessun filetto sotto.
%              Stile moderno, usato in report aziendali e CV.
%
%   banda    — Banda piena colPrimario a tutta larghezza con testo bianco.
%              Massima visibilita, stile "presentazione aziendale".
%              Richiede TikZ (gia caricato dalla classe).
%
% Uso:
%   \setsectionstyle{barra}     % nel preambolo
%   \setsectionstyle{classico}  % per tornare allo stile predefinito
%
% Lo stile puo essere cambiato anche a meta documento: ogni \section
% successiva usera l'ultimo stile impostato.
% =============================================================================


% ─── Stile "classico" ───────────────────────────────────────────────────────
%
% Filetto pieno sotto il titolo.  E lo stile predefinito della classe.
%
\makeatletter
\newcommand{\@sectionstyle@classico}{%
  \titleformat{\section}
    {\Large\bfseries\color{colPrimario}}%
    {}{0pt}{}%
    [\vspace{-1pt}{\color{colPrimario}\titlerule[1.2pt]}]%
  \titlespacing*{\section}{0pt}{12pt}{6pt}%
}


% ─── Stile "barra" ──────────────────────────────────────────────────────────
%
% Barra verticale 3pt a sinistra.  Il testo e rientrato di 8pt.
%
\newcommand{\@sectionstyle@barra}{%
  \titleformat{\section}
    {\Large\bfseries\color{colPrimario}}%
    {}{0pt}%
    {\rule[-4pt]{3pt}{1.2em}\hspace{8pt}}%
    []%
  \titlespacing*{\section}{0pt}{12pt}{6pt}%
}


% ─── Stile "banda" ──────────────────────────────────────────────────────────
%
% Banda piena colPrimario con testo bianco.  Usa un \fill TikZ in overlay
% per colorare l'intera larghezza del testo, poi stampa il titolo sopra
% in bianco.
%
\newcommand{\@sectionstyle@banda}{%
  \titleformat{\section}[block]
    {\Large\bfseries\color{white}}%
    {}{0pt}%
    {\tikz[overlay]\fill[colPrimario]
      (-2pt,-4pt) rectangle (\textwidth+2pt, 1.35em);%
    \hspace{6pt}}%
    []%
  \titlespacing*{\section}{0pt}{14pt}{10pt}%
}


% ─── Comando pubblico ───────────────────────────────────────────────────────
%
% \setsectionstyle{nome}
%   Imposta lo stile attivo per i titoli \section.
%   Valori validi: classico, barra, banda.
%   Se il nome non e valido, emette un warning e non cambia nulla.
%
\newcommand{\setsectionstyle}[1]{%
  \ifcsname @sectionstyle@#1\endcsname
    \csname @sectionstyle@#1\endcsname
  \else
    \ClassWarning{IT-Docs}{%
      Stile sezione '#1' non riconosciuto.\MessageBreak
      Valori validi: classico, barra, banda}%
  \fi
}
\makeatother

% Stile predefinito
\setsectionstyle{classico}
%#endregion Formattazione sezioni


%#region Icone modalita
% =============================================================================
%
%  ICONE MODALITA DI LAVORO
%
% =============================================================================
%
% Tre icone FontAwesome che indicano come e stata svolta un'attivita.
% Si usano nella colonna "modalita" delle tabelle attivita.
%
%   \modRemoto   — antenna RSS: lavoro da remoto
%   \modPresenza — omino: lavoro in presenza
%   \modAuto     — omino + auto: in presenza con trasporto
% =============================================================================

\newcommand{\modRemoto}{{\footnotesize \faRss}}
\newcommand{\modPresenza}{{\footnotesize \faUser}}
\newcommand{\modAuto}{{\footnotesize \faUser\hspace{0.4mm}\tiny\faCarSide}}
%#endregion Icone modalita


%#region Icone stato
% =============================================================================
%
%  ICONE STATO ATTIVITA
%
% =============================================================================
%
% Quattro icone colorate per indicare lo stato di un'attivita nella roadmap.
%
%   \staFatto    — spunta verde: completata
%   \staFacendo  — frecce arancioni: in corso
%   \staDafare   — puntina rossa: programmata
%   \staIdea     — lampadina azzurra: proposta / idea
% =============================================================================

\newcommand{\staFatto}{{\color{colFatto}\footnotesize \faCheck}}
\newcommand{\staFacendo}{{\color{colFacendo}\footnotesize \faSync}}
\newcommand{\staDafare}{{\color{colDafare}\footnotesize \faThumbtack}}
% NB: lo stile outline in fontawesome5 si seleziona con [regular];
% la vecchia sintassi FontAwesome 4 "[O]" non esiste piu e causava un
% font warning a ogni compilazione (con fallback allo stile solid).
\newcommand{\staIdea}{{\color{colIdea}\footnotesize \faLightbulb[regular]}}
%#endregion Icone stato


%#region Lista compatta
% =============================================================================
%
%  LISTA COMPATTA
%
% =============================================================================
%
% Ambiente di elenco "D" (descrizione sintetica) senza spazi extra tra le voci.
% Usato all'interno delle celle tabella dove lo spazio verticale e limitato.
%
% Uso:
%   \begin{D}
%     \item Prima voce
%     \item Seconda voce
%   \end{D}
% =============================================================================

\newlist{D}{itemize}{2}
\setlist[D]{nosep,label=\textbullet}
%#endregion Lista compatta


%#region Comandi di utilita
% =============================================================================
%
%  COMANDI DI UTILITA
%
% =============================================================================
%
% Comandi brevi per spaziature ricorrenti e impostazioni tabella.
%
%   \ppf           — spazio fantasma orizzontale da 0.5pt.
%                    Usato nelle celle "ore" per allineare i numeri.
%
%   \vspaceheader  — spazio verticale da 0.3cm.
%                    Usato negli shortstack dell'header per distanziare
%                    le due righe di testo dal bordo inferiore.
%
%   \hspaceRheader — spazio orizzontale da 1cm.
%                    Usato nella colonna destra dell'header per allineare
%                    il testo dal margine destro della pagina.
%
%   \tablespacing  — imposta \arraystretch a 1.8.
%                    Aumenta l'altezza delle righe nelle tabelle per
%                    migliorare la leggibilita con contenuto denso.
% =============================================================================

\newcommand{\ppf}{\phantom{.5}}
\newcommand{\vspaceheader}{\vspace{.3cm}}
% \hspace* (indiscartabile): uno \hspace normale a fine riga di uno
% \shortstack viene SCARTATO da TeX, azzerando il rientro dal margine
% (e facendo finire il nome autore sotto il logo).
\newcommand{\hspaceRheader}{\hspace*{1cm}}
\newcommand{\tablespacing}{\renewcommand{\arraystretch}{1.8}}
%#endregion Comandi di utilita


%#region Formattazione valuta
% =============================================================================
%
%  FORMATTAZIONE VALUTA
%
% =============================================================================
%
% \eur{importo}
%   Formatta un importo in euro in convenzione italiana: virgola decimale,
%   punto delle migliaia, sempre due decimali, spazio unificatore prima
%   del simbolo € (niente a-capo tra numero e simbolo).
%
%   L'argomento puo essere un numero o un'espressione \fpeval-compatibile:
%     \eur{1020}        -> "1.020,00 €"
%     \eur{49.20}       -> "49,20 €"
%     \eur{3*20.5}      -> "61,50 €"
%
%   L'importo viene arrotondato a due decimali.  La formattazione e
%   affidata a \num di siunitx (robusto in tabelle e argomenti mobili);
%   i separatori italiani sono i default di classe (vedi \sisetup).
%
% \numero{valore}
%   Numero semplice in convenzione italiana, senza decimali forzati:
%     \numero{11}  -> "11"        \numero{1.5} -> "1,5"
%   Usato per le quantita (es. totale ore).  Accetta espressioni \fpeval.
% =============================================================================

\NewDocumentCommand{\eur}{m}{%
  \num[
    round-mode=places,
    round-precision=2,
    minimum-decimal-digits=2,
  ]{\fpeval{round((#1),2)}}~\texteuro%
}

\NewDocumentCommand{\numero}{m}{\num{\fpeval{#1}}}
%#endregion Formattazione valuta


%#region Caselle legenda
% =============================================================================
%
%  CASELLE LEGENDA
%
% =============================================================================
%
% Le legende appaiono sopra le tabelle per spiegare il significato delle
% icone usate nelle colonne.
%
% \legendabox{contenuto}
%   Crea un riquadro grigio chiaro a tutta larghezza con testo piccolo.
%   E il blocco base usato dalle legende specifiche.
%
% \legendaModalita
%   Legenda per le tre icone di modalita di lavoro.
%   Mostra: antenna = Da remoto, omino = In presenza, omino+auto = Con trasporto
%
% \legendaStato
%   Legenda per le quattro icone di stato attivita.
%   Mostra: spunta = Completato, frecce = In corso, puntina = Programmato,
%           lampadina = Proposte / Idee
% =============================================================================

\newcommand{\legendabox}[1]{%
  \par\noindent
  \colorbox{colLegenda}{\parbox{\dimexpr\textwidth-2\fboxsep}{%
    \small #1%
  }}%
  \par
}

\newcommand{\legendaModalita}{%
  \legendabox{%
    \textbf{Legenda modalit\`a:}
    \hspace{3mm}\modRemoto$\,$ Da remoto%
    \hspace{3mm}\modPresenza$\,$ In presenza%
    \hspace{3mm}\modAuto$\,$ In presenza, comprende trasporto%
  }%
}

\newcommand{\legendaStato}{%
  \legendabox{%
    \textbf{Legenda:}
    \hspace{3mm}\staFatto$\,$ Completato%
    \hspace{3mm}\staFacendo$\,$ In corso%
    \hspace{3mm}\staDafare$\,$ Programmato%
    \hspace{3mm}\staIdea$\,$ Proposte / Idee%
  }%
}
%#endregion Caselle legenda


%#region Configurazione
% =============================================================================
%
%  CONFIGURAZIONE
%
% =============================================================================
%
% \ITDocsSetup{chiave=valore, ...}
%   Personalizza l'identita visiva senza toccare la classe.  Da usare
%   tipicamente in shared/info_common.tex dello studio.
%
%   Chiavi disponibili:
%     primario = RRGGBB   colore identitario (titoli, filetti header)
%     fatto    = RRGGBB   icona stato: completato
%     facendo  = RRGGBB   icona stato: in corso
%     dafare   = RRGGBB   icona stato: programmato
%     idea     = RRGGBB   icona stato: proposte/idee
%     zebra    = RRGGBB   sfondo righe alternate delle tabelle
%     legenda  = RRGGBB   sfondo caselle legenda
%     totale   = RRGGBB   sfondo celle Totale
%     tablestretch = N    interlinea righe tabella (default 1.8)
%     logoaltezza  = DIM  altezza del logo nell'angolo (default 0.7cm)
%
%   Esempio: \ITDocsSetup{primario=00695C, logoaltezza=0.9cm}
%
% \doclogo
%   Nome file del logo usato dai template (default LG_logo.png, risolto
%   via TEXINPUTS in IT-Docs/img/).  Ridefinibile per studio con
%   \renewcommand{\doclogo}{MioLogo.png} in info_common.tex.
% =============================================================================

\newlength{\itdocslogoheight}
\setlength{\itdocslogoheight}{0.7cm}

\newcommand{\doclogo}{LG_logo.png}

\ExplSyntaxOn
\keys_define:nn { itdocs }
  {
    primario .code:n = { \definecolor{colPrimario}{HTML}{#1} },
    fatto    .code:n = { \definecolor{colFatto}{HTML}{#1} },
    facendo  .code:n = { \definecolor{colFacendo}{HTML}{#1} },
    dafare   .code:n = { \definecolor{colDafare}{HTML}{#1} },
    idea     .code:n = { \definecolor{colIdea}{HTML}{#1} },
    zebra    .code:n = { \definecolor{colZebra}{HTML}{#1} },
    legenda  .code:n = { \definecolor{colLegenda}{HTML}{#1} },
    totale   .code:n = { \definecolor{colTotale}{HTML}{#1} },
    tablestretch .code:n =
      { \renewcommand{\tablespacing}{\renewcommand{\arraystretch}{#1}} },
    logoaltezza .code:n = { \setlength{\itdocslogoheight}{#1} },
  }
\NewDocumentCommand{\ITDocsSetup}{m}{ \keys_set:nn { itdocs } {#1} }
\ExplSyntaxOff
%#endregion Configurazione


%#region Sistema riferimenti
% =============================================================================
%
%  SISTEMA RIFERIMENTI CENTRALIZZATO
%
% =============================================================================
%
% Sistema per registrare e richiamare codici di riferimento (es. I2501,
% R2502, M2503).  I codici vengono definiti una sola volta nel file
% riferimenti.tex e possono essere usati ovunque nel documento.
%
% \defref{CODICE}{descrizione}
%   Registra un riferimento.  Internamente crea un comando \ref@CODICE
%   contenente la descrizione.  Non produce output visibile.
%
%   Nello storico, \defref viene ridefinito localmente per renderizzare
%   l'indice dei riferimenti come tabella.
%
% \rif{CODICE}
%   Stampa il codice.  Se il codice non e stato registrato con \defref,
%   stampa "??CODICE??" e genera un warning nel log di compilazione.
%
% \rifdesc{CODICE}
%   Stampa la descrizione associata al codice.  Stesso comportamento
%   di fallback di \rif se il codice non esiste.
% =============================================================================

\newcommand{\defref}[2]{%
  \expandafter\def\csname ref@#1\endcsname{#2}%
}

\newcommand{\rif}[1]{%
  \ifcsname ref@#1\endcsname%
    #1%
  \else%
    \textbf{??#1??}%
    \ClassWarning{IT-Docs}{Riferimento '#1' non definito in riferimenti.tex}%
  \fi%
}

\newcommand{\rifdesc}[1]{%
  \ifcsname ref@#1\endcsname%
    \csname ref@#1\endcsname%
  \else%
    \textbf{??#1??}%
    \ClassWarning{IT-Docs}{Riferimento '#1' non definito in riferimenti.tex}%
  \fi%
}
%#endregion Sistema riferimenti


%#region Titolo documento automatico
% =============================================================================
%
%  TITOLO DOCUMENTO AUTOMATICO
%
% =============================================================================
%
% \doctitolo e il titolo del documento (header e metadati PDF).
% Se il documento NON lo definisce, la classe lo costruisce da tipo e
% cartella del documento, che il Makefile passa a pdflatex:
%
%   pdflatex "\def\itdocstipo{resoconto}\def\itdocsdirname{2025-3}\input{main.tex}"
%     -> \doctitolo = "RESOCONTO 2025/3"
%
% Tipi riconosciuti: resoconto, report, preventivo, proposta (mappa
% qui sotto).  Lo storico — o qualunque documento con un titolo suo —
% continua a definire \doctitolo a mano, che ha sempre la precedenza.
%
% Compilando A MANO (pdflatex main.tex, senza le \def del Makefile) il
% titolo automatico non e disponibile: il documento mostra ??titolo??
% con un warning.  Compilare via make, oppure definire \doctitolo.
% =============================================================================

\makeatletter
% Mappa tipo -> etichetta del titolo
\def\itdocs@titolo@resoconto{RESOCONTO}
\def\itdocs@titolo@report{REPORT TECNICO}
\def\itdocs@titolo@preventivo{PREVENTIVO}
\def\itdocs@titolo@proposta{PROPOSTA}

% "2025-3" -> "2025/3"
\def\itdocs@dirtonum#1-#2\@nil{#1/#2}

% Guardia sul formato cartella <numero>-<numero>
\ExplSyntaxOn
\NewDocumentCommand{\itdocs@ifdirnum}{mmm}
  { \regex_match:nnTF { \A\d+-\d+\Z } {#1} {#2} {#3} }
\ExplSyntaxOff

% Chiamato a inizio documento (prima dei metadati PDF): definisce
% \doctitolo se il documento non l'ha fatto.
\newcommand{\itdocs@autotitolo}{%
  \@ifundefined{doctitolo}{%
    \ifdefined\itdocstipo
      \ifcsname itdocs@titolo@\itdocstipo\endcsname%
        \expandafter\itdocs@ifdirnum\expandafter{\itdocsdirname}%
          {\protected@edef\doctitolo{%
             \csname itdocs@titolo@\itdocstipo\endcsname\space
             \expandafter\itdocs@dirtonum\itdocsdirname\@nil}}%
          {\def\doctitolo{\textbf{??titolo??}}%
           \ClassWarningNoLine{IT-Docs}{%
             Cartella '\itdocsdirname' non in formato <anno>-<n>:\MessageBreak
             impossibile costruire il titolo automatico}}%
      \else%
        \def\doctitolo{\textbf{??titolo??}}%
        \ClassWarningNoLine{IT-Docs}{%
          Tipo documento '\itdocstipo' senza titolo automatico:\MessageBreak
          definire \string\doctitolo\space in info.tex}%
      \fi%
    \else
      \def\doctitolo{\textbf{??titolo??}}%
      \ClassWarningNoLine{IT-Docs}{%
        \string\doctitolo\space non definito e compilazione fuori da make:\MessageBreak
        compilare con "make" oppure definire \string\doctitolo}%
    \fi
  }{}%
}
\makeatother
%#endregion Titolo documento automatico


%#region Data documento automatica
% =============================================================================
%
%  DATA DOCUMENTO AUTOMATICA
%
% =============================================================================
%
% \docdata e la data del documento (mostrata nell'header e nei testi
% "al giorno ...").  Comportamento:
%
%   - Se il documento NON definisce \docdata, la classe la calcola da sola
%     come la data PIU RECENTE tra le attivita \att, formattata col giorno
%     della settimana (es. "mercoled\`i 14/01/2026").
%
%   - Per forzare una data specifica si usa \setdocdata{...} nel preambolo
%     o in info.tex (equivale a definire \docdata a mano con \newcommand).
%
% Poiche la data massima si conosce solo dopo aver letto la tabella ma serve
% gia nell'header (in cima a ogni pagina), il valore viene propagato tramite
% il file .aux: come per \pageref{LastPage}, servono DUE compilazioni (il
% Makefile le esegue gia).  Le date \att devono essere in formato GG/MM/AAAA.
% =============================================================================

\makeatletter
\newcount\docdate@jul
\newcount\docdate@wd
\gdef\docdate@maxnum{0}     % massimo numerico AAAAMMGG visto finora
\gdef\docdate@maxstr{}      % stringa GG/MM/AAAA del massimo
\gdef\docdate@auxstr{}      % massimo dal run precedente (letto dal .aux)

% Callback scritto nel .aux: propaga il massimo al run successivo.
\newcommand{\docdatecache}[1]{\gdef\docdate@auxstr{#1}}

% \itdocs@ifdataformat{testo}{vero}{falso}
%   Esegue "vero" se il testo e esattamente GG/MM/AAAA, "falso" altrimenti.
%   Usato per validare le date prima di parsarle: senza questo controllo
%   una data malformata in \att esploderebbe dentro \numexpr con errori
%   di basso livello che non menzionano ne \att ne il formato atteso.
\ExplSyntaxOn
\NewDocumentCommand{\itdocs@ifdataformat}{mmm}
  { \regex_match:nnTF { \A\d\d/\d\d/\d\d\d\d\Z } {#1} {#2} {#3} }
\ExplSyntaxOff

% \docdate@track{GG/MM/AAAA} — aggiorna il massimo (chiamato da \att).
% Le date non conformi vengono ignorate con un warning esplicito.
% NB: si memorizza il VALORE espanso (\xdef), non il token \docdate@n,
% altrimenti la successiva \edef ne cambierebbe anche il massimo.
\def\docdate@track#1{%
  \itdocs@ifdataformat{#1}%
    {\docdate@track@#1\@nil}%
    {\ClassWarning{IT-Docs}{%
       Data '\detokenize{#1}' di \string\att\space non in formato
       GG/MM/AAAA:\MessageBreak ignorata per la data documento automatica}}%
}
\def\docdate@track@#1/#2/#3\@nil{%
  \edef\docdate@n{\number\numexpr#3*10000+#2*100+#1\relax}%
  \ifnum\docdate@n>\docdate@maxnum\relax
    \xdef\docdate@maxnum{\docdate@n}%
    \gdef\docdate@maxstr{#1/#2/#3}%
  \fi}

% Giorno della settimana italiano da GG/MM/AAAA (via pgfcalendar).
\def\docdate@weekday#1{\expandafter\docdate@weekday@#1\@nil}
\def\docdate@weekday@#1/#2/#3\@nil{%
  \pgfcalendardatetojulian{#3-#2-#1}{\docdate@jul}%
  \pgfcalendarjuliantoweekday{\docdate@jul}{\docdate@wd}%
  \ifcase\docdate@wd
    luned\`i\or marted\`i\or mercoled\`i\or gioved\`i\or
    venerd\`i\or sabato\or domenica\fi}

% Data automatica formattata "<giorno> GG/MM/AAAA".  Usa il valore del .aux
% (stabile su tutto il run, header incluso); al primo run, quando il .aux non
% c'e ancora, ripiega sul massimo corrente.
\newcommand{\docdate@auto}{%
  \edef\docdate@use{\docdate@auxstr}%
  \ifx\docdate@use\@empty \edef\docdate@use{\docdate@maxstr}\fi
  \ifx\docdate@use\@empty
    \textbf{??data??}%
  \else
    \docdate@weekday{\docdate@use} \docdate@use
  \fi}

% A fine documento scrive il massimo nel .aux per il run successivo.
% Se il massimo differisce da quanto letto dal .aux (prima compilazione,
% o attivita nuova con data piu recente), l'header di questo run mostra
% ancora la data vecchia: avvisa di ricompilare, come fa lastpage.
\AtEndDocument{%
  \ifx\docdate@maxstr\@empty\else
    \immediate\write\@auxout{\string\docdatecache{\docdate@maxstr}}%
    \ifx\docdate@auxstr\docdate@maxstr\else
      \ClassWarningNoLine{IT-Docs}{%
        Data documento automatica cambiata (\docdate@maxstr):\MessageBreak
        ricompilare per aggiornare l'header}%
    \fi
  \fi}

% Override esplicito della data documento.
%   \setdocdata{14/01/2026}          -> "mercoledi 14/01/2026"
%     (giorno della settimana calcolato automaticamente: uno in meno da
%      scrivere e nessun rischio di giorno sbagliato)
%   \setdocdata{testo qualunque}     -> usato tale e quale
\newcommand{\setdocdata}[1]{%
  \itdocs@ifdataformat{#1}%
    {\def\docdata{\docdate@weekday{#1} #1}}%
    {\def\docdata{#1}}%
}

% Se il documento non ha definito \docdata, usala automatica.
\AtBeginDocument{\@ifundefined{docdata}{\def\docdata{\docdate@auto}}{}}
\makeatother
%#endregion Data documento automatica


%#region Comando attivita
% =============================================================================
%
%  COMANDO ATTIVITA
%
% =============================================================================
%
% \att{data}{codice}{descrizione}{modalita}{ore}
%
%   Genera una riga nella tabella attivita.  Se la data e uguale alla
%   riga precedente, la cella "data" resta vuota per evitare ripetizioni
%   (a meno che non sia attivo \ripetidate, vedi sotto).
%
%   Argomenti:
%     #1 = data        (es. "17/09/2025")
%     #2 = codice      (NUDO, es. "M2503": la validazione \rif e la
%                       stampa nel formato della colonna le fa la classe)
%     #3 = descrizione (puo contenere \begin{D}...\end{D} — argomento +m).
%                       VUOTA ({}) = usa il titolo registrato nel
%                       registro riferimenti (\rifdesc): il titolo di un
%                       item si scrive UNA volta sola, in riferimenti.tex.
%                       Testo esplicito = dettaglio della sessione, usato
%                       tale e quale (es. "Ordine nuovo PC" su R2501).
%     #4 = modalita    (es. "\modRemoto")
%     #5 = ore         (es. "3")
%
%   Il tracciamento della data precedente usa il token \att@prevdate,
%   inizializzato a "@NONE@" all'inizio di ogni tabella da \tabellaAttivita.
%
%   \ripetidate (nel preambolo o in info.tex) disattiva la deduplica:
%   la data viene stampata su ogni riga.  Default: deduplica attiva.
%
%   Ogni \att alimenta inoltre la data documento automatica: vedi la regione
%   "Data documento automatica".
% =============================================================================

% Le righe non vengono stampate direttamente: ogni \att le ACCUMULA nel
% token-macro \attbody (separatore e zebra inclusi), che \tabellaAttivita
% inserisce poi in un colpo solo dopo l'intestazione.  In questo modo il
% corpo della tabella e un singolo blocco "pulito": niente riga fantasma
% in cima o in fondo (problema che si presenta con \rowcolors quando una
% riga comincia con una macro/assegnazione anziche con contenuto).
\makeatletter
\gdef\att@prevdate{@NONE@}
\newcounter{attrow}

% Confronto stringhe portabile (kernel expl3): \pdfstrcmp e un primitivo
% di pdfTeX e legherebbe la classe al solo motore pdflatex.
\ExplSyntaxOn
\cs_new_eq:NN \itdocs@strifeqTF \str_if_eq:eeTF
\ExplSyntaxOff

% Deduplica data: di default, se la data e uguale alla riga precedente la
% cella "Data" resta vuota.  \ripetidate (nel preambolo / info.tex) disattiva
% la deduplica e fa stampare la data su OGNI riga.
\newif\if@attrep \@attrepfalse
\newcommand{\ripetidate}{\@attreptrue}

\NewDocumentCommand{\att}{m m +m m m}{%
  \stepcounter{attrow}%
  \docdate@track{#1}% alimenta la data documento automatica
  \ifnum\value{attrow}>1 \g@addto@macro\attbody{\\}\fi
  \ifodd\value{attrow}\else \g@addto@macro\attbody{\rowcolor{colZebra}}\fi
  \if@attrep
    \g@addto@macro\attbody{#1}%
  \else
    \itdocs@strifeqTF{#1}{\att@prevdate}{}{\g@addto@macro\attbody{#1}}%
  \fi
  \gdef\att@prevdate{#1}%
  \g@addto@macro\attbody{& \rif{#2} & }%
  \if\relax\detokenize{#3}\relax
    \g@addto@macro\attbody{\rifdesc{#2}}%
  \else
    \g@addto@macro\attbody{#3}%
  \fi
  \g@addto@macro\attbody{ & #4 & #5\ppf}%
}
\makeatother
%#endregion Comando attivita


%#region Comando roadmap
% =============================================================================
%
%  COMANDO ROADMAP
%
% =============================================================================
%
% \road{codice}{descrizione}{stato}{urgenza}{commenti}
%
%   Accumula una riga nel token-macro \roadbody (separatore e zebra
%   inclusi), che \tabellaRoadmap inserisce poi in blocco.  Non stampa
%   nulla di per se.
%
%   Argomenti:
%     #1 = codice      (NUDO, es. "R2501", come in \att)
%     #2 = descrizione (argomento +m per contenuto multi-riga).
%                       VUOTA ({}) = titolo dal registro riferimenti;
%                       testo esplicito = usato tale e quale.
%     #3 = stato       (es. "\staFatto")
%     #4 = urgenza     (testo libero)
%     #5 = commenti    (argomento +m per contenuto multi-riga)
%
%   Il contatore roadrow viene azzerato da \tabellaRoadmap.
% =============================================================================

% Come \att, le righe vengono accumulate in \roadbody e inserite in blocco
% da \tabellaRoadmap (vedi nota su \att): evita la riga fantasma di \rowcolors.
\makeatletter
\newcounter{roadrow}

\NewDocumentCommand{\road}{m +m m m +m}{%
  \stepcounter{roadrow}%
  \ifnum\value{roadrow}>1 \g@addto@macro\roadbody{\\}\fi
  \ifodd\value{roadrow}\else \g@addto@macro\roadbody{\rowcolor{colZebra}}\fi
  \g@addto@macro\roadbody{\rif{#1} & }%
  \if\relax\detokenize{#2}\relax
    \g@addto@macro\roadbody{\rifdesc{#1}}%
  \else
    \g@addto@macro\roadbody{#2}%
  \fi
  \g@addto@macro\roadbody{ & #3 & #4 & #5}%
}
\makeatother
%#endregion Comando roadmap


%#region Rapporto ore
% =============================================================================
%
%  RAPPORTO ORE
%
% =============================================================================
%
% Sistema per accumulare ore lavorate e calcolare l'importo dovuto.
%
% \tothoursval (macro numerica)
%   Accumula il totale delle ore in virgola mobile (\fpeval): supporta
%   mezze ore e frazioni (es. 1.5), cosa impossibile con un contatore
%   LaTeX intero.  Azzerata da \tabellaOre.
%
% \addhours{data}{ore}
%   Accumula una riga della tabella ore nel token-macro \hoursbody
%   (separatore e zebra inclusi, come \att) e somma le ore al totale.
%   L'importo e calcolato come ore * \doctariffa.  Non stampa nulla
%   di per se: e \tabellaOre a comporre la tabella.
% =============================================================================

\makeatletter
\gdef\tothoursval{0}
\newcounter{hourrow}

\NewDocumentCommand{\addhours}{m m}{%
  \stepcounter{hourrow}%
  \ifnum\value{hourrow}>1 \g@addto@macro\hoursbody{\\}\fi
  \ifodd\value{hourrow}\else \g@addto@macro\hoursbody{\rowcolor{colZebra}}\fi
  \g@addto@macro\hoursbody{#1 & \numero{#2} & \eur{(#2)*\doctariffa}}%
  \xdef\tothoursval{\fpeval{\tothoursval+(#2)}}%
}
\makeatother
%#endregion Rapporto ore


%#region Sottrazioni
% =============================================================================
%
%  SOTTRAZIONI
%
% =============================================================================
%
% Sistema per accumulare sottrazioni (acquisti, rimborsi, deduzioni).
%
% \totsubtval (macro numerica)
%   Accumula il totale delle sottrazioni in virgola mobile: supporta
%   importi con centesimi (es. 12.99), lo scenario normale per gli
%   acquisti.  Azzerata da \tabellaSottrazioni.
%
% \addsubt{data}{info}{importo}
%   Accumula una riga della tabella sottrazioni nel token-macro
%   \subtbody, con la stessa logica di \addhours.
% =============================================================================

\makeatletter
\gdef\totsubtval{0}
\newcounter{subtrow}

\NewDocumentCommand{\addsubt}{m m m}{%
  \stepcounter{subtrow}%
  \ifnum\value{subtrow}>1 \g@addto@macro\subtbody{\\}\fi
  \ifodd\value{subtrow}\else \g@addto@macro\subtbody{\rowcolor{colZebra}}\fi
  \g@addto@macro\subtbody{#1 & #2 & \eur{#3}}%
  \xdef\totsubtval{\fpeval{\totsubtval+(#3)}}%
}
\makeatother
%#endregion Sottrazioni


%#region Tabelle riusabili
% =============================================================================
%
%  TABELLE RIUSABILI
%
% =============================================================================
%
% Macro che generano tabelle complete, pronte per essere incluse nei
% template.  Ogni macro accetta il percorso di un file dati che viene
% incluso con \input dentro la tabella.
%
%
% ─── Tabella attivita ───────────────────────────────────────────────────────
%
% \tabellaAttivita{file}
%   Tabella a 5 colonne con righe zebrate:
%     Data | Rif. | Descrizione attivita | Modalita+Ore
%
%   Il file deve contenere chiamate \att{}{}{}{}{}.
%   Resetta \att@prevdate per il tracciamento delle date duplicate.
%
\makeatletter
\newcommand{\tabellaAttivita}[1]{%
  \gdef\attbody{}%
  \gdef\att@prevdate{@NONE@}%
  \setcounter{attrow}{0}%
  \input{#1}% le chiamate \att riempiono \attbody, senza stampare nulla
  {\tablespacing
  \setlength{\aboverulesep}{0pt}%
  \setlength{\belowrulesep}{0pt}%
  \begin{tabularx}{\textwidth}{
      l
      | >{\ttfamily\arraybackslash}p{0.06\linewidth}
      | >{\arraybackslash}X
      | l
      >{\ttfamily\centering\arraybackslash}p{0.05\linewidth}
  }
      \textbf{Data} & \textnormal{\textbf{Rif.}} & \textbf{Descrizione attivit\`a} & \multicolumn{2}{c}{\textnormal{\textbf{Ore}}}
      \\ \arrayrulecolor{colPrimario}\midrule[\heavyrulewidth]\arrayrulecolor{black}
  \attbody
  \end{tabularx}
  }%
}
\makeatother


% ─── Tabella roadmap ────────────────────────────────────────────────────────
%
% \tabellaRoadmap{file}
%   Tabella a 5 colonne con righe zebrate:
%     Rif. | Descrizione | Stato | Urgenza | Commenti
%
%   Il file deve contenere chiamate \road{}{}{}{}{}.
%   Azzera il contatore roadrow e raccoglie le righe in \roadbody.
%
\newcommand{\tabellaRoadmap}[1]{%
  \gdef\roadbody{}%
  \setcounter{roadrow}{0}%
  \input{#1}% le chiamate \road riempiono \roadbody
  {\tablespacing
  \setlength{\aboverulesep}{0pt}%
  \setlength{\belowrulesep}{0pt}%
  \begin{tabularx}{\textwidth}{
      >{\ttfamily}l
      | >{\arraybackslash}X
      c
      | l
      | >{\arraybackslash}p{0.3\linewidth}
  }
      \textnormal{\textbf{\normalsize Rif.}} & \textbf{Descrizione} & \textbf{Stato} & \textbf{Urgenza} & \textbf{Commenti}
      \\ \arrayrulecolor{colPrimario}\midrule[\heavyrulewidth]\arrayrulecolor{black}
  \roadbody
  \end{tabularx}
  }%
}


% ─── Tabella ore ────────────────────────────────────────────────────────────
%
% ALLINEAMENTO DEL BLOCCO ECONOMICO
%   Le tabelle ore/sottrazioni e il box del saldo sono ancorati a destra
%   con \hfill e usano SOLO colonne a larghezza fissa, con lo stesso
%   totale (85mm di colonne + 6 \tabcolsep + 2 filetti): bordi destro e
%   sinistro coincidono al punto per costruzione.
%   NON si usa tabularx qui: con ltablex la larghezza effettiva puo
%   discostarsi di qualche punto dal target (misurato: -3pt/-5.5pt),
%   producendo tabelle visibilmente non allineate tra loro.
%
% \tabellaOre{file}
%   Etichetta (e tariffa oraria) a sinistra, tabella ore a destra.
%   Colonne: Data 50mm | Ore 15mm | Importo 20mm.  In coda la riga
%   "Totale" staccata, con sfondo colTotale e bordi \hhline.
%
%   La tariffa oraria (\doctariffa) viene dichiarata sotto l'etichetta:
%   in un documento quasi-fattura il fattore unitario degli importi e
%   un'informazione contrattuale che il cliente deve poter verificare.
%
%   Il file deve contenere chiamate \addhours{}{}, che accumulano le
%   righe in \hoursbody (vedi regione "Rapporto ore").
%
\makeatletter
% Larghezza complessiva del blocco economico (per il separatore del saldo)
\newlength{\itdocs@ecowidth}
\AtBeginDocument{%
  \setlength{\itdocs@ecowidth}{\dimexpr 85mm + 6\tabcolsep + 2\arrayrulewidth\relax}}

\newcommand{\tabellaOre}[1]{%
  \gdef\hoursbody{}%
  \gdef\tothoursval{0}%
  \setcounter{hourrow}{0}%
  \input{#1}% le chiamate \addhours riempiono \hoursbody
  \noindent\begin{minipage}[t]{0.40\textwidth}
      \vspace{0pt}
      Nuove ore accumulate al giorno \docdata:
      \par\vspace{2mm}
      {\small\itshape Tariffa oraria: \eur{\doctariffa}/h}
  \end{minipage}%
  \hfill
  {\tablespacing
  \setlength{\aboverulesep}{0pt}%
  \setlength{\belowrulesep}{0pt}%
  \begin{tabular}[t]{
      >{\raggedright\arraybackslash}p{50mm}
      | >{\centering\arraybackslash}p{15mm}
      | >{\raggedleft\arraybackslash}p{20mm}
  }
      \textbf{Data} & \textbf{Ore} & \textbf{Importo}
      \\ \arrayrulecolor{colPrimario}\midrule[\heavyrulewidth]\arrayrulecolor{black}
      \hoursbody
      \\ \noalign{\vskip 6pt} \hhline{~|--|}
      \multicolumn{1}{r}{\textbf{Totale}}
        & \multicolumn{1}{|c|}{\cellcolor{colTotale}\textbf{\numero{\tothoursval}}}
        & \multicolumn{1}{r|}{\cellcolor{colTotale}\textbf{\eur{\tothoursval*\doctariffa}}}
      \\ \hhline{~|--|}
  \end{tabular}%
  }\par
}
\makeatother


% ─── Tabella sottrazioni ───────────────────────────────────────────────────
%
% \tabellaSottrazioni{file}
%   Stile e ancoraggio identici a \tabellaOre.  Colonne: Data 22mm |
%   Info 43mm | Importo 20mm (stesso totale di 85mm: impilate, le due
%   tabelle coincidono su entrambi i bordi e la colonna Importo resta
%   incolonnata).  Riga Totale in coda.
%
%   Il file deve contenere chiamate \addsubt{}{}{}, che accumulano le
%   righe in \subtbody (vedi regione "Sottrazioni").
%
\makeatletter
\newcommand{\tabellaSottrazioni}[1]{%
  \gdef\subtbody{}%
  \gdef\totsubtval{0}%
  \setcounter{subtrow}{0}%
  \input{#1}% le chiamate \addsubt riempiono \subtbody
  \noindent\begin{minipage}[t]{0.40\textwidth}
      \vspace{0pt}
      Sottrazioni al giorno \docdata:
  \end{minipage}%
  \hfill
  {\tablespacing
  \setlength{\aboverulesep}{0pt}%
  \setlength{\belowrulesep}{0pt}%
  \begin{tabular}[t]{
      >{\raggedright\arraybackslash}p{22mm}
      | >{\raggedright\arraybackslash}p{43mm}
      | >{\raggedleft\arraybackslash}p{20mm}
  }
      \textbf{Data} & \textbf{Info} & \textbf{Importo}
      \\ \arrayrulecolor{colPrimario}\midrule[\heavyrulewidth]\arrayrulecolor{black}
      \subtbody
      \\ \noalign{\vskip 6pt} \hhline{~~|-|}
      \multicolumn{2}{r}{\textbf{Totale}}
        & \multicolumn{1}{|r|}{\cellcolor{colTotale}\textbf{\eur{\totsubtval}}}
      \\ \hhline{~~|-|}
  \end{tabular}%
  }\par
}
\makeatother


% ─── Saldo dovuto ───────────────────────────────────────────────────────────
%
% \saldodovuto
%   Riga conclusiva del resoconto: l'importo netto che il cliente deve
%   corrispondere = (ore totali * tariffa) - sottrazioni totali.
%   E la riga che chiude il conto della pseudo-fattura: senza di essa
%   il cliente deve sottrarre a mano i due totali.
%
%   Va chiamata DOPO \tabellaOre (ed eventualmente \tabellaSottrazioni):
%   usa gli accumulatori \tothoursval e \totsubtval; se le sottrazioni
%   non sono presenti nel documento, \totsubtval vale 0.
%
%   La colonna importo replica la colonna Importo (p{20mm}) delle
%   tabelle economiche e l'ancoraggio a destra e lo stesso: i tre
%   importi restano incolonnati.  Un filetto in colPrimario largo
%   quanto il blocco economico separa il saldo dalle tabelle, come la
%   riga di chiusura di una fattura.
%
\makeatletter
\newcommand{\saldodovuto}{%
  \par\vspace{5mm}%
  \noindent\hfill{\color{colPrimario}\rule{\itdocs@ecowidth}{0.6pt}}\par
  \vspace{2mm}%
  \noindent\hfill
  {\tablespacing
  \setlength{\aboverulesep}{0pt}%
  \setlength{\belowrulesep}{0pt}%
  \begin{tabular}{r >{\raggedleft\arraybackslash}p{20mm}}
    \noalign{\vskip 3pt}\hhline{~|-|}
    \textbf{Da corrispondere}
      & \multicolumn{1}{|>{\raggedleft\arraybackslash}p{20mm}|}{\cellcolor{colTotale}\textbf{\eur{\tothoursval*\doctariffa-\totsubtval}}}
    \\ \hhline{~|-|}
  \end{tabular}%
  }%
  \par
}
\makeatother


% ─── Tabella registro riferimenti ──────────────────────────────────────────
%
% \tabellaRegistro{file}
%   Indice di tutti i codici riferimento, RAGGRUPPATO PER TIPOLOGIA
%   (la prima lettera del codice), nello stile delle altre tabelle
%   della classe.  Usata nello storico.
%
%   Il file (tipicamente shared/riferimenti.tex) viene riletto con
%   \defref ridefinito localmente: ogni voce viene smistata nel gruppo
%   della sua lettera iniziale.  L'ordine dei gruppi e fisso
%   (I, R, M, X); le voci di tipi non riconosciuti finiscono nel
%   gruppo "Altri" in coda.  L'ordine DENTRO il gruppo e quello del file.
%
%   Le etichette dei gruppi sono ridefinibili per studio:
%     \renewcommand{\registroI}{...}   (idem R, M, X, Altri)
%
%   Per aggiungere una tipologia: definire \registro<Lettera> e
%   aggiungere la lettera in \tabellaRegistro (accumulatore + emissione).
%
\makeatletter
\newcommand{\registroI}{Incident --- guasti e malfunzionamenti}
\newcommand{\registroR}{Request --- richieste e nuove attivit\`a}
\newcommand{\registroM}{Maintenance --- manutenzione ordinaria}
\newcommand{\registroX}{Extra --- attivit\`a fuori perimetro IT}
\newcommand{\registroAltri}{Altri}

\newcounter{regrow}

% Prima lettera di un codice ("I2501" -> "I")
\def\reg@first#1#2\@nil{#1}

% Riga voce e riga di gruppo.  Le intestazioni di gruppo NON partecipano
% alla zebratura (altrimenti risulterebbero grigie o bianche a caso, a
% seconda della parita della riga) e la zebratura RIPARTE da bianco a
% ogni gruppo: contatore regitem azzerato da \reg@cat.  Il vskip prima
% di ogni intestazione stacca visivamente i gruppi.
\newcounter{regitem}

\newcommand{\reg@item}[2]{%
  \stepcounter{regrow}%
  \stepcounter{regitem}%
  \ifnum\value{regrow}>1 \g@addto@macro\regbody{\\}\fi
  \ifodd\value{regitem}\else \g@addto@macro\regbody{\rowcolor{colZebra}}\fi
  \g@addto@macro\regbody{\texttt{#1} & #2}%
}

\newcommand{\reg@cat}[1]{%
  \stepcounter{regrow}%
  \setcounter{regitem}{0}%
  \ifnum\value{regrow}>1 \g@addto@macro\regbody{\\ \noalign{\vskip 10pt}}\fi
  \g@addto@macro\regbody{\multicolumn{2}{l}{\textbf{#1}}}%
}

% Emette un gruppo (etichetta + voci) solo se non e vuoto.
\newcommand{\reg@emit}[2]{%
  \expandafter\ifx\csname reg@g#2\endcsname\@empty\else
    \reg@cat{#1}%
    \csname reg@g#2\endcsname
  \fi}

\newcommand{\tabellaRegistro}[1]{%
  \begingroup
  % accumulatori per tipologia
  \gdef\reg@gI{}\gdef\reg@gR{}\gdef\reg@gM{}\gdef\reg@gX{}\gdef\reg@gA{}%
  % \defref smista la voce nel gruppo della lettera iniziale
  \def\defref##1##2{%
    \edef\reg@l{\reg@first##1\@nil}%
    \ifcsname reg@g\reg@l\endcsname
      \expandafter\g@addto@macro\csname reg@g\reg@l\endcsname{\reg@stored{##1}{##2}}%
    \else
      \g@addto@macro\reg@gA{\reg@stored{##1}{##2}}%
    \fi}%
  \input{#1}%
  % costruzione del corpo: gruppi nell'ordine I, R, M, X, Altri
  \gdef\regbody{}%
  \setcounter{regrow}{0}%
  \setcounter{regitem}{0}%
  \let\reg@stored\reg@item
  \reg@emit{\registroI}{I}%
  \reg@emit{\registroR}{R}%
  \reg@emit{\registroM}{M}%
  \reg@emit{\registroX}{X}%
  \reg@emit{\registroAltri}{A}%
  {\tablespacing
  \setlength{\aboverulesep}{0pt}%
  \setlength{\belowrulesep}{0pt}%
  \begin{tabularx}{\textwidth}{
      >{\ttfamily}l
      | >{\arraybackslash}X
  }
      \textnormal{\textbf{Codice}} & \textbf{Descrizione}
      \\ \arrayrulecolor{colPrimario}\midrule[\heavyrulewidth]\arrayrulecolor{black}
      \regbody
  \end{tabularx}
  }%
  \endgroup
}
\makeatother
%#endregion Tabelle riusabili


%#region Sezione report
% =============================================================================
%
%  SEZIONE REPORT TECNICO
%
% =============================================================================
%
% \reportsezione{titolo}{contenuto}
%   Crea una sottosezione non numerata con il titolo dato, seguita dal
%   contenuto e da uno spazio verticale di 4mm.  Usata nei report tecnici
%   per le sezioni Contesto, Analisi, Conclusioni, Considerazioni.
% =============================================================================

\newcommand{\reportsezione}[2]{%
  \subsection*{#1}
  #2\par\vspace{4mm}%
}
%#endregion Sezione report


%#region Componenti preventivo
% =============================================================================
%
%  COMPONENTI PREVENTIVO
%
% =============================================================================
%
% Comandi per la tabella componenti nei preventivi (stime di costo).
%
%
% \comp{componente}{range}{proposta}{prezzo}
%   Accumula una riga nel token-macro \compbody (separatore e zebra
%   inclusi); non stampa nulla di per se.
%
% \compcategoria{nome}
%   Riga separatrice con il nome della categoria in grassetto
%   (es. "Altro", "Accessori").  Occupa tutte e 4 le colonne.
%   Anch'essa viene accumulata in \compbody.
%
% \tabellaComponenti{file}
%   Tabella a 4 colonne con righe zebrate:
%     Componente | Range | Proposta | Prezzo
%   Il file deve contenere chiamate \comp e/o \compcategoria.
%   Azzera il contatore comprow e raccoglie le righe in \compbody.
%
% \preventivototali{righe}{etichetta finale}{importo finale}
%   Blocco totali unico allineato a destra, incolonnato con la colonna
%   Prezzo della tabella componenti (stessa larghezza 20mm).  Le righe
%   secondarie (argomento 1, anche vuoto) sono composte in tono normale
%   con \totriga; la riga finale — l'importo che il cliente paga — e
%   l'UNICA evidenziata: grassetto, sfondo colTotale, bordi propri.
%
%   Esempio:
%     \preventivototali{%
%       \totriga{Totale indicativo (esente IVA)}{1250}%
%     }{Totale indicativo (IVA inclusa)}{1580}
%
% \totriga{etichetta}{importo}
%   Riga secondaria del blocco totali (usare solo dentro il primo
%   argomento di \preventivototali).
%
% \preventivototale{etichetta}{importo}
%   COMPATIBILITA: blocco totali con la sola riga finale.  Equivale a
%   \preventivototali{}{etichetta}{importo}.
% =============================================================================

% Come \att/\road, le righe (comp e categorie) sono accumulate in \compbody
% e inserite in blocco da \tabellaComponenti: evita la riga fantasma.
\makeatletter
\newcounter{comprow}

\NewDocumentCommand{\comp}{m m m m}{%
  \stepcounter{comprow}%
  \ifnum\value{comprow}>1 \g@addto@macro\compbody{\\}\fi
  \ifodd\value{comprow}\else \g@addto@macro\compbody{\rowcolor{colZebra}}\fi
  \g@addto@macro\compbody{#1 & #2 & #3 & \eur{#4}}%
}

\newcommand{\compcategoria}[1]{%
  \stepcounter{comprow}%
  \ifnum\value{comprow}>1 \g@addto@macro\compbody{\\}\fi
  \ifodd\value{comprow}\else \g@addto@macro\compbody{\rowcolor{colZebra}}\fi
  \g@addto@macro\compbody{\multicolumn{4}{l}{\textbf{#1}}}%
}
\makeatother

\newcommand{\tabellaComponenti}[1]{%
  \gdef\compbody{}%
  \setcounter{comprow}{0}%
  \input{#1}% le chiamate \comp/\compcategoria riempiono \compbody
  {\tablespacing
  \setlength{\aboverulesep}{0pt}%
  \setlength{\belowrulesep}{0pt}%
  \begin{tabularx}{\textwidth}{
      >{\arraybackslash}X
      | >{\raggedleft\arraybackslash}p{25mm}
      | >{\arraybackslash}X
      | >{\raggedleft\arraybackslash}p{20mm}
  }
      \textbf{Componente} & \textbf{Range} & \textbf{Proposta} & \textbf{Prezzo}
      \\ \arrayrulecolor{colPrimario}\midrule[\heavyrulewidth]\arrayrulecolor{black}
  \compbody
  \end{tabularx}
  }%
}

% Riga secondaria del blocco totali: etichetta + importo, tono normale.
\newcommand{\totriga}[2]{#1 & \eur{#2} \\}

% Blocco totali: righe secondarie, poi la riga finale evidenziata con
% bordi propri via \hhline (convive con \cellcolor, vedi nota hhline).
% La colonna importi replica esattamente la colonna Prezzo della tabella
% componenti (p{20mm}): i numeri restano incolonnati.
\NewDocumentCommand{\preventivototali}{+m m m}{%
  \vspace{4mm}%
  \noindent\hfill
  {\tablespacing
  \setlength{\aboverulesep}{0pt}%
  \setlength{\belowrulesep}{0pt}%
  \begin{tabular}{r >{\raggedleft\arraybackslash}p{20mm}}
    #1%
    \noalign{\vskip 3pt}\hhline{~|-|}
    \textbf{#2}
      & \multicolumn{1}{|>{\raggedleft\arraybackslash}p{20mm}|}{\cellcolor{colTotale}\textbf{\eur{#3}}}
    \\ \hhline{~|-|}
  \end{tabular}%
  }%
  \par
}

% Compatibilita con la vecchia API a riga singola.
\newcommand{\preventivototale}[2]{\preventivototali{}{#1}{#2}}
%#endregion Componenti preventivo


%#region Toggle orientamento
% =============================================================================
%
%  TOGGLE ORIENTAMENTO PAGINA
%
% =============================================================================
%
% Permette di impostare l'orientamento del documento (verticale o
% orizzontale) aggiungendo \setlandscape nel preambolo del documento
% (tipicamente nel file info.tex).
%
% \setlandscape
%   Attiva la modalita orizzontale.  La nuova geometria viene applicata
%   in \AtBeginDocument con gli stessi margini della modalita verticale.
%
% \setportrait
%   Disattiva la modalita orizzontale (comportamento predefinito).
% =============================================================================

\newif\iflandscapemode \landscapemodefalse

\newcommand{\setlandscape}{\landscapemodetrue}
\newcommand{\setportrait}{\landscapemodefalse}

\AtBeginDocument{%
  \iflandscapemode
    \newgeometry{
      landscape,
      hmargin=\itdocs@hmargin,
      top=3cm,
      headheight=38pt,
      headsep=1cm,
      marginparwidth=0cm,
      bottom=2cm,
      footskip=1cm
    }%
  \fi
}
%#endregion Toggle orientamento


%#region Layout pagina
% =============================================================================
%
%  LAYOUT PAGINA
%
% =============================================================================
%
% Configurazione di intestazione (header), pie di pagina (footer) e
% impostazioni globali della pagina.
%
%
% ─── Numerazione sezioni ────────────────────────────────────────────────────
%
% secnumdepth=0 disabilita la numerazione di tutte le sezioni.
% I documenti IT usano titoli descrittivi senza numeri.
%
\setcounter{secnumdepth}{0}


% ─── Indentazione paragrafi ─────────────────────────────────────────────────
%
% Nessuna indentazione per i paragrafi.  I documenti tecnico-professionali
% usano spaziatura verticale tra paragrafi, non rientri.
%
\AtBeginDocument{\setlength\parindent{0pt}}


% ─── Header a tre colonne ──────────────────────────────────────────────────
%
% L'header e diviso in tre sezioni:
%   Sinistra — nome studio + sede
%   Centro   — titolo documento + data
%   Destra   — nome autore + e-mail
%
% Ogni sezione usa \shortstack per impilare due righe di testo.
% I comandi \docstudio, \doctitolo, ecc. vengono definiti dal documento
% e sono espansi al momento del rendering della pagina (non alla
% definizione dell'header).
%
% Il filetto sotto l'header e colorato in colPrimario con spessore 0.8pt.
%
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrule}{{\color{colPrimario}\hrule height 0.8pt}}
\renewcommand{\footrulewidth}{0pt}


% ─── Footer ─────────────────────────────────────────────────────────────────
%
% Footer centrato con "Pagina X di Y" in grigio.
% \pageref{LastPage} e fornito dal pacchetto lastpage.
%
\fancyfoot[C]{{\small\color{gray} Pagina \thepage\ di \pageref{LastPage}}}


% ─── Contenuto header ──────────────────────────────────────────────────────

\fancyhead[L]{%
  \shortstack[l]{\textbf{\docstudio}\\\docluogo \vspaceheader}%
}

\fancyhead[C]{%
  \shortstack[c]{\textbf{\large \doctitolo}\\ \docdata \vspaceheader}%
}

% Entrambe le righe della colonna destra usano UN SOLO \hspaceRheader:
% cosi nome e e-mail condividono lo stesso filo destro, comunque fuori
% dall'ingombro del logo posizionato da \showlogo nell'angolo.
\fancyhead[R]{%
    \shortstack[r]{\textbf{\docautore}\hspaceRheader\\ \href{mailto:\docmail}{\docmail}\hspaceRheader\vspaceheader}%
}
%#endregion Layout pagina


%#region Logo
% =============================================================================
%
%  LOGO
%
% =============================================================================
%
% \showlogo{percorso-immagine}
%   Posiziona un logo in alto a destra su ogni pagina del documento.
%   Il logo e alto 0.7cm e viene ancorato all'angolo superiore destro
%   della pagina con un margine di circa 1.4cm dal bordo destro e
%   0.8cm dal bordo superiore.
%
%   Usa \AddToShipoutPictureFG del pacchetto eso-pic per inserire
%   l'immagine nel foreground di ogni pagina.
%
%   Uso tipico (nei template):
%     \showlogo{\doclogo}
%
%   L'altezza (default 0.7cm) si cambia con \ITDocsSetup{logoaltezza=...}.
% =============================================================================

\newcommand{\showlogo}[1]{%
  \AddToShipoutPictureFG{%
    \put(
      \LenToUnit{\paperwidth-1.42cm},
      \LenToUnit{\paperheight-0.83cm}
    ){\vtop{{\null}\makebox[0pt][c]{
      \includegraphics[height=\itdocslogoheight]{#1}
    }}}%
  }%
}
%#endregion Logo


\endinput
