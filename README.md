# IT-Docs

Classe LaTeX per documenti professionali di consulenza IT: **resoconti
attività, report tecnici, preventivi e proposte** — documenti
quasi-fattura pronti da consegnare al cliente.

Usata dagli "studi" del monorepo
[IT-LorenzoGodi](https://github.com/LorenzoGodi/IT-LorenzoGodi), dove è
agganciata come submodule.

## Contenuto

```
IT-Docs.cls      La classe (ampiamente commentata: indice in testa al file)
templates/       Corpi standard: template_resoconto, _report, _preventivo, _proposta
skel/            Skeleton per lo scaffolding ("make nuovo-*" nel monorepo)
img/             Loghi (LG_logo.png)
```

**Requisiti**: TeX Live completo (pdflatex), kernel LaTeX ≥ 2022/06/01.

## Uso

I documenti compilano con `TEXINPUTS` che elenca classe, template e
loghi (cartelle **esplicite**, niente ricerca ricorsiva `//`: gli
skeleton contengono `main.tex` e oscurerebbero i documenti):

```sh
TEXINPUTS="<path>/IT-Docs:<path>/IT-Docs/templates:<path>/IT-Docs/img:" \
  pdflatex main.tex
```

Anatomia di un documento (vedi gli skeleton in `skel/` per i file dati):

```latex
\documentclass[a4paper,9pt]{IT-Docs}   % + [discorsivo] per report/proposte
\def\shareddir{../../shared}           % identità studio + registro codici
\def\datadir{.}
\input{\shareddir/riferimenti}         % \defref{CODICE}{titolo}
\input{\shareddir/info_common}         % \docstudio, \docluogo, \docautore, \docmail
\input{\datadir/info}                  % \doctariffa, \setdocdata, ...
\begin{document}
\input{template_resoconto}             % o _report / _preventivo / _proposta
\end{document}
```

## Automatismi

- **Titolo automatico** — tipo + cartella (`resoconti/2025-3` →
  "RESOCONTO 2025/3"), passati dal Makefile via
  `\def\itdocstipo{...}\def\itdocsdirname{...}`; override con `\doctitolo`.
- **Data automatica** — la più recente tra le attività, con giorno della
  settimana calcolato (richiede doppia compilazione); manuale:
  `\setdocdata{GG/MM/AAAA}` (giorno aggiunto da solo).
- **Valuta italiana** — `\eur{1020}` → "1.020,00 €"; accetta espressioni
  (`\eur{3*20.5}`); ore e importi frazionari ammessi ovunque.
- **Titoli single-source** — nelle righe `\att`/`\road` la descrizione
  vuota `{}` usa il titolo registrato con `\defref`: si scrive una volta
  sola.
- **Saldo** — `\saldodovuto` chiude il conto: ore × tariffa − sottrazioni.
- **Metadati PDF** — titolo e autore impostati automaticamente.

## Comandi per riga (file dati)

| Comando | Uso |
|---|---|
| `\defref{CODICE}{titolo}` | registra un riferimento (`I`/`R`/`M`/`X` + anno + progressivo) |
| `\att{data}{CODICE}{desc}{mod}{ore}` | attività (mod: `\modRemoto` `\modPresenza` `\modAuto`) |
| `\road{CODICE}{desc}{stato}{urg}{note}` | roadmap (stati: `\staFatto` `\staFacendo` `\staDafare` `\staIdea`) |
| `\addhours{data}{ore}` | riga rapporto ore |
| `\addsubt{info}{importo}` | riga sottrazioni |
| `\comp{c.}{range}{proposta}{prezzo}` | riga preventivo (+ `\compcategoria{...}`) |
| `\preventivototali{righe}{etich.}{imp.}` | blocco totali preventivo (+ `\totriga`) |
| `\reportsezione{titolo}{testo}` | sezione di report tecnico |

Le tabelle si compongono nei template con `\tabellaAttivita`,
`\tabellaRoadmap`, `\tabellaOre`, `\tabellaSottrazioni`,
`\tabellaComponenti`, `\tabellaRegistro` (registro raggruppato per
tipologia, per lo storico).

## Personalizzazione per studio

```latex
\ITDocsSetup{primario=00695C, logoaltezza=0.9cm, tablestretch=1.6}
\renewcommand{\doclogo}{MioLogo.png}      % file in img/
\renewcommand{\registroI}{...}            % etichette gruppi del registro
\ripetidate                               % data su ogni riga attività
\setsectionstyle{banda}                   % stili titoli: classico|barra|banda
```

## Versioni

v1.2 — vedi `git log` per la storia completa; il dettaglio di ogni
comando è documentato nei commenti di `IT-Docs.cls`.
