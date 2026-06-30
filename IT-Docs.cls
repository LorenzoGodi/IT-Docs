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
%   1. Classe base ............... Identificazione, opzioni, LoadClass
%   2. Pacchetti ................. Tutti i RequirePackage
%   3. Colori .................... 8 definecolor (primario, stati, tabelle)
%   4. Formattazione sezioni ..... \setsectionstyle (classico|barra|banda)
%   5. Icone modalita ............ modRemoto, modPresenza, modAuto
%   6. Icone stato ............... staFatto, staFacendo, staDafare, staIdea
%   7. Lista compatta ............ ambiente D
%   8. Comandi di utilita ........ ppf, vspaceheader, tablespacing
%   9. Formattazione valuta ...... \eur
%  10. Caselle legenda ........... legendabox, legendaModalita, legendaStato
%  11. Separatore righe .......... \rowsep
%  12. Sistema riferimenti ....... defref, rif, rifdesc
%  13. Comando attivita .......... \att (con tracciamento data)
%  14. Comando roadmap ........... \road
%  15. Rapporto ore .............. addhours, contatore tothours
%  16. Sottrazioni ............... addsubt, contatore totsubt
%  17. Tabelle riusabili ......... tabellaAttivita, tabellaRoadmap,
%                                  tabellaOre, tabellaSottrazioni
%  18. Sezione report ............ \reportsezione
%  19. Componenti preventivo ..... comp, tabellaComponenti, preventivototale
%  20. Toggle orientamento ....... setlandscape, setportrait
%  21. Layout pagina ............. fancyhdr, secnumdepth, parindent
%  22. Logo ...................... \showlogo
%


%#region Classe base
% ─── Identificazione classe ─────────────────────────────────────────────────
%
% \NeedsTeXFormat specifica la versione minima di LaTeX richiesta.
% Usiamo 2020/10/01 perche da quella data il kernel LaTeX include
% nativamente \NewDocumentCommand e il supporto L3 per \fpeval.
%
% \ProvidesClass registra il nome, la data e la descrizione della classe.
% La data segue il formato ISO: AAAA/MM/GG.
%
\NeedsTeXFormat{LaTeX2e}[2020/10/01]
\ProvidesClass{IT-Docs}[2025/11/24 v1.0 Classe documenti IT professionali]


% ─── Opzioni ────────────────────────────────────────────────────────────────
%
% Tutte le opzioni passate a IT-Docs vengono inoltrate alla classe article.
% Questo permette di scrivere:
%   \documentclass[a4paper,9pt]{IT-Docs}
% e avere a4paper e 9pt gestiti normalmente da article.
%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax


% ─── Classe base ────────────────────────────────────────────────────────────
%
% IT-Docs estende la classe article standard di LaTeX.
% Article e adatta a documenti brevi senza capitoli — perfetta per
% resoconti, report, preventivi e proposte di poche pagine.
%
\LoadClass{article}
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
% lmodern, textcomp
%   Latin Modern: versione moderna e scalabile di Computer Modern.
%   textcomp fornisce simboli aggiuntivi come \texteuro.
%   Senza lmodern, la codifica T1 ricadrebbe sui font bitmap.
%
% microtype
%   Abilita raffinamenti tipografici invisibili singolarmente ma che
%   rendono la pagina complessivamente piu gradevole: protrusione dei
%   caratteri ed espansione del font per ridurre le sillabazioni.
%
\RequirePackage[utf8]{inputenc}
\RequirePackage{lmodern,textcomp}
\RequirePackage[T1]{fontenc}
\RequirePackage{microtype}


% ─── Layout ──────────────────────────────────────────────────────────────────
%
% geometry
%   Imposta le dimensioni della pagina.  Margini stretti (1 cm laterali)
%   per massimizzare lo spazio utile in documenti densi di tabelle.
%   Il top maggiorato (3 cm) lascia spazio all'header a tre colonne.
%   headheight=38pt e necessario perche l'header contiene due righe di testo.
%
\RequirePackage[
  margin=1cm,
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
\RequirePackage{enumitem}
\RequirePackage{ltablex,booktabs}
\keepXColumns


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
% xfp
%   Fornisce \fpeval per calcoli in virgola mobile — usato per
%   calcolare importi (ore * tariffa) nei rapporti ore.
%
\RequirePackage{amsmath}
\RequirePackage{nicefrac}
\RequirePackage{xfp}


% ─── Utility ────────────────────────────────────────────────────────────────
%
% xparse
%   Estende la sintassi di \newcommand con \NewDocumentCommand, permettendo
%   argomenti opzionali multipli, argomenti "long" (+m) e altro.
%   Usato per i comandi \att e \road che hanno argomenti multi-paragrafo.
%
\RequirePackage{xparse}


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
\RequirePackage{tikz}
\usetikzlibrary{trees}


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
    [\vspace{-4pt}{\color{colPrimario}\titlerule[1.2pt]}]%
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
\newcommand{\staIdea}{{\color{colIdea}\footnotesize \faLightbulb[O]}}
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
\newcommand{\hspaceRheader}{\hspace{1cm}}
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
%   Formatta un importo in euro con due decimali e il simbolo €.
%
%   Esempio: \eur{1020} produce "1020.00 €"
%
%   Nota: il formato NON usa il separatore delle migliaia.
%   Per importi con decimali specifiche, passare il valore gia formattato:
%     \eur{1020.50} produce "1020.50.00 €" — ERRATO.
%   In quel caso usare direttamente "1020.50 \texteuro".
% =============================================================================

\newcommand{\eur}[1]{#1.00 \texteuro}
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


%#region Separatore righe
% =============================================================================
%
%  SEPARATORE RIGHE TABELLE
%
% =============================================================================
%
% \rowsep
%   Semplice alias per \\, usato come separatore tra righe nelle tabelle
%   roadmap e componenti.  Definito come comando per uniformita e per
%   permettere eventuali ridefinizioni locali (es. aggiungere \hline).
% =============================================================================

\newcommand{\rowsep}{\\}
%#endregion Separatore righe


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
  \ifcsname ref@#1\endcsname
    #1%
  \else
    \textbf{??#1??}%
    \ClassWarning{IT-Docs}{Riferimento '#1' non definito in riferimenti.tex}%
  \fi
}

\newcommand{\rifdesc}[1]{%
  \ifcsname ref@#1\endcsname
    \csname ref@#1\endcsname
  \else
    \textbf{??#1??}%
    \ClassWarning{IT-Docs}{Riferimento '#1' non definito in riferimenti.tex}%
  \fi
}
%#endregion Sistema riferimenti


%#region Comando attivita
% =============================================================================
%
%  COMANDO ATTIVITA
%
% =============================================================================
%
% \att{data}{riferimento}{descrizione}{modalita}{ore}
%
%   Genera una riga nella tabella attivita.  Se la data e uguale alla
%   riga precedente, la cella "data" resta vuota per evitare ripetizioni.
%
%   Argomenti:
%     #1 = data        (es. "17/09/2025")
%     #2 = riferimento (es. "\rif{M2503}")
%     #3 = descrizione (puo contenere \begin{D}...\end{D} — argomento +m)
%     #4 = modalita    (es. "\modRemoto")
%     #5 = ore         (es. "3")
%
%   Il tracciamento della data precedente usa il token \att@prevdate,
%   inizializzato a "@NONE@" all'inizio di ogni tabella da \tabellaAttivita.
% =============================================================================

\makeatletter
\gdef\att@prevdate{@NONE@}

\NewDocumentCommand{\att}{m m +m m m}{%
  \ifnum\pdfstrcmp{#1}{\att@prevdate}=0\relax\else #1\fi
    & #2
    & #3
    & #4
    & #5\ppf \\
  \gdef\att@prevdate{#1}%
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
% \road{riferimento}{descrizione}{stato}{urgenza}{commenti}
%
%   Genera una riga nella tabella roadmap.  La prima riga non ha
%   separatore sopra; le successive sono precedute da \rowsep (\\).
%
%   Argomenti:
%     #1 = riferimento (es. "\rif{R2501}")
%     #2 = descrizione (argomento +m per contenuto multi-riga)
%     #3 = stato       (es. "\staFatto")
%     #4 = urgenza     (testo libero)
%     #5 = commenti    (argomento +m per contenuto multi-riga)
%
%   Il flag \firstroadrow viene resettato da \tabellaRoadmap.
% =============================================================================

\newif\iffirstroadrow \firstroadrowtrue

\NewDocumentCommand{\road}{m +m m m +m}{%
  \iffirstroadrow
    \global\firstroadrowfalse
  \else
    \rowsep
  \fi
  #1
    & #2
    & #3
    & #4
    & #5
}
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
% tothours (contatore)
%   Accumula il totale delle ore.  Resettato a zero da \tabellaOre.
%
% \addhours{data}{ore}
%   Aggiunge una riga alla tabella ore.  Calcola automaticamente
%   l'importo come ore * \doctariffa usando \fpeval (calcolo floating point).
%   La prima riga usa \hline\hline, le successive \hline singolo.
%
% \tabellaOre{file}
%   Genera la tabella ore completa: un riepilogo a destra con data, ore
%   e importo per ogni voce, e una riga "Totale" con sfondo colTotale.
%   Il file viene incluso con \input e deve contenere chiamate \addhours.
% =============================================================================

\newcounter{tothours}
\setcounter{tothours}{0}

\newif\iffirsthourrow \firsthourrowtrue

\newcommand{\addhours}[2]{%
  \iffirsthourrow
    \\ \hline\hline \global\firsthourrowfalse
  \else
    \\ \hline
  \fi
  #1 & #2 & \eur{\fpeval{(#2)*\doctariffa}}
  \addtocounter{tothours}{#2}%
}
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
% totsubt (contatore)
%   Accumula il totale delle sottrazioni.  Resettato da \tabellaSottrazioni.
%
% \addsubt{data}{info}{importo}
%   Aggiunge una riga alla tabella sottrazioni.
%   Stessa logica di separazione riga di \addhours.
% =============================================================================

\newcounter{totsubt}
\setcounter{totsubt}{0}

\newif\iffirstsubtrow \firstsubtrowtrue

\newcommand{\addsubt}[3]{%
  \iffirstsubtrow
    \\ \hline\hline \global\firstsubtrowfalse
  \else
    \\ \hline
  \fi
  #1 & #2 & \eur{#3}
  \addtocounter{totsubt}{#3}%
}
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
  \gdef\att@prevdate{@NONE@}%
  {\tablespacing
  \setlength{\aboverulesep}{0pt}%
  \setlength{\belowrulesep}{0pt}%
  \rowcolors{2}{}{colZebra}%
  \begin{tabularx}{\textwidth}{
      l
      | >{\ttfamily\arraybackslash}p{0.06\linewidth}
      | >{\arraybackslash}X
      | l
      >{\ttfamily\centering\arraybackslash}p{0.05\linewidth}
  }
      \textbf{Data} & \textnormal{\textbf{Rif.}} & \textbf{Descrizione attivit\`a} & \multicolumn{2}{c}{\textnormal{\textbf{Ore}}}
      \\ \midrule[\heavyrulewidth]
  \input{#1}
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
%   Resetta il flag \firstroadrow.
%
\newcommand{\tabellaRoadmap}[1]{%
  \global\firstroadrowtrue
  {\tablespacing
  \setlength{\aboverulesep}{0pt}%
  \setlength{\belowrulesep}{0pt}%
  \rowcolors{2}{}{colZebra}%
  \begin{tabularx}{\textwidth}{
      >{\ttfamily}l
      | >{\arraybackslash}X
      c
      | l
      | >{\arraybackslash}p{0.3\linewidth}
  }
      \textnormal{\textbf{\normalsize Rif.}} & \textbf{Descrizione} & \textbf{Stato} & \textbf{Urgenza} & \textbf{Commenti}
      \\ \midrule[\heavyrulewidth]
  \input{#1}
      \\
  \end{tabularx}
  }%
}


% ─── Tabella ore ────────────────────────────────────────────────────────────
%
% \tabellaOre{file}
%   Layout a due colonne: testo a sinistra, tabella ore a destra.
%   La tabella mostra data, ore e importo per ogni voce, con una riga
%   totale in basso con sfondo colTotale.
%
%   Il file deve contenere chiamate \addhours{}{}.
%   Resetta il contatore tothours e il flag firsthourrow.
%
\newcommand{\tabellaOre}[1]{%
  \global\firsthourrowtrue
  \setcounter{tothours}{0}%
  \noindent\begin{minipage}[t]{0.55\textwidth}
      \vspace{17.5pt}
      Nuove ore accumulate al giorno \docdata:
  \end{minipage}
  \hfill
  \noindent\begin{minipage}[t]{0.4\textwidth}
      \vspace{0pt}
      \begin{flushright}
          \begin{tabularx}{\textwidth}{
              | X
              | >{\centering\arraybackslash}p{15mm}
              | >{\raggedleft\arraybackslash}p{20mm} |
          }
              \hline
              \textbf{Data} & \textbf{Ore} & \textbf{Importo}
              \input{#1} \\ \hline
              \noalign{\vskip 6pt} \cline{2-3}
              \multicolumn{1}{r|}{\textbf{Totale}}
                & \cellcolor{colTotale}\textbf{\arabic{tothours}}
                & \cellcolor{colTotale}\textbf{\eur{\fpeval{round(\arabic{tothours}*\doctariffa,2)}}}
              \\ \cline{2-3}
          \end{tabularx}
      \end{flushright}
  \end{minipage}
}


% ─── Tabella sottrazioni ───────────────────────────────────────────────────
%
% \tabellaSottrazioni{file}
%   Layout simile a \tabellaOre ma per le sottrazioni.
%   Colonne: Data | Info | Importo, con riga totale.
%
%   Il file deve contenere chiamate \addsubt{}{}{}.
%
\newcommand{\tabellaSottrazioni}[1]{%
  \global\firstsubtrowtrue
  \setcounter{totsubt}{0}%
  \noindent\begin{minipage}[t]{0.35\textwidth}
      \vspace{17.5pt}
      Sottrazioni al giorno \docdata:
  \end{minipage}
  \hfill
  \noindent\begin{minipage}[t]{0.55\textwidth}
      \vspace{0pt}
      \begin{flushright}
          \begin{tabularx}{\textwidth}{
              | >{\raggedright\arraybackslash}p{25mm}
              | X
              | >{\raggedleft\arraybackslash}p{20mm} |
          }
              \hline
              \textbf{Data} & \textbf{Info} & \textbf{Importo}
              \input{#1} \\ \hline
              \noalign{\vskip 6pt} \cline{3-3}
              \multicolumn{2}{r|}{\textbf{Totale}}
                & \cellcolor{colTotale}\textbf{\eur{\arabic{totsubt}}}
              \\ \cline{3-3}
          \end{tabularx}
      \end{flushright}
  \end{minipage}
}
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
%   Riga nella tabella componenti.  La prima riga non ha separatore;
%   le successive sono precedute da \rowsep.
%
% \compcategoria{nome}
%   Riga separatrice con il nome della categoria in grassetto
%   (es. "Altro", "Accessori").  Occupa tutte e 4 le colonne.
%
% \tabellaComponenti{file}
%   Tabella a 4 colonne con righe zebrate:
%     Componente | Range | Proposta | Prezzo
%   Il file deve contenere chiamate \comp e/o \compcategoria.
%
% \preventivototale{etichetta}{importo}
%   Riga di totale allineata a destra con cella evidenziata in colTotale.
%   Esempio: \preventivototale{Totale indicativo IVA inclusa}{1580}
% =============================================================================

\newif\iffirstcomprow \firstcomprowtrue

\NewDocumentCommand{\comp}{m m m m}{%
  \iffirstcomprow
    \global\firstcomprowfalse
  \else
    \rowsep
  \fi
  #1 & #2 & #3 & \eur{#4}
}

\newcommand{\compcategoria}[1]{%
  \\
  \multicolumn{4}{l}{\textbf{#1}}
}

\newcommand{\tabellaComponenti}[1]{%
  \global\firstcomprowtrue
  {\tablespacing
  \setlength{\aboverulesep}{0pt}%
  \setlength{\belowrulesep}{0pt}%
  \rowcolors{2}{}{colZebra}%
  \begin{tabularx}{\textwidth}{
      >{\arraybackslash}X
      | >{\raggedleft\arraybackslash}p{25mm}
      | >{\arraybackslash}X
      | >{\raggedleft\arraybackslash}p{20mm}
  }
      \textbf{Componente} & \textbf{Range} & \textbf{Proposta} & \textbf{Prezzo}
      \\ \midrule[\heavyrulewidth]
  \input{#1}
      \\
  \end{tabularx}
  }%
}

\newcommand{\preventivototale}[2]{%
  \vspace{4mm}%
  \noindent\hfill
  \begin{tabular}{r >{\raggedleft\arraybackslash}p{25mm}}
    \textbf{#1} & \cellcolor{colTotale}\textbf{\eur{#2}} \\
  \end{tabular}%
  \par
}
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
      margin=1cm,
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
\renewcommand{\headrule}{\hrule height 0.8pt}
\renewcommand{\footrulewidth}{0pt}


% ─── Footer ─────────────────────────────────────────────────────────────────
%
% Footer centrato con "Pagina X di Y" in grigio.
% \pageref{LastPage} e fornito dal pacchetto lastpage.
%
\fancyfoot[C]{{\small\color{gray} Pagina \thepage\ di \pageref{LastPage}}}


% ─── Contenuto header ──────────────────────────────────────────────────────

\fancyhead[L]{
  \shortstack[l]{\textbf{\docstudio}\\\docluogo \vspaceheader}
}

\fancyhead[C]{%
  \shortstack[c]{\textbf{\large \doctitolo}\\ \docdata \vspaceheader}
}

\fancyhead[R]{
    \shortstack[r]{\textbf{\docautore\hspaceRheader}\hspaceRheader\\ \href{mailto:\docmail}{\docmail}\hspaceRheader\vspaceheader}
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
%     \showlogo{\shareddir/img/LG_logo.png}
% =============================================================================

\newcommand{\showlogo}[1]{%
  \AddToShipoutPictureFG{%
    \put(
      \LenToUnit{\paperwidth-1.42cm},
      \LenToUnit{\paperheight-0.83cm}
    ){\vtop{{\null}\makebox[0pt][c]{
      \includegraphics[height=.7cm]{#1}
    }}}%
  }%
}
%#endregion Logo


\endinput
