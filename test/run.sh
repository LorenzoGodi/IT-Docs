#!/bin/sh
# Test end-to-end della classe IT-Docs: compila uno studio di prova
# (tutti i tipi di documento) e verifica i contenuti dei PDF.
# Requisiti: pdflatex (TeX Live completo) e ghostscript (gs).
set -e
cd "$(dirname "$0")"
ROOT=$(cd .. && pwd)
export TEXINPUTS="$ROOT:$ROOT/templates:$ROOT/img:"

fail() { echo "FAIL: $1"; exit 1; }

# build <cartella> <tipo> <dirname-simulato>
# Doppia compilazione come il Makefile degli studi (data automatica,
# LastPage) e con le \def del titolo automatico.
build() {
  d="$1"; tipo="$2"; dn="$3"
  for pass in 1 2; do
    ( cd "$d" && pdflatex -interaction=nonstopmode -jobname=main \
        "\\def\\itdocstipo{$tipo}\\def\\itdocsdirname{$dn}\\input{main.tex}" \
        >/dev/null 2>&1 ) || fail "compilazione $d (pass $pass)"
  done
  [ -s "$d/main.pdf" ] || fail "$d/main.pdf mancante o vuoto"
  echo "OK  build $d"
}

txt() { gs -q -dNOPAUSE -dBATCH -sDEVICE=txtwrite -sOutputFile=- "$1" 2>/dev/null; }

# assert <pdf> <testo atteso>
# L'estrazione testo perde alcuni spazi (es. nei titoli in grassetto):
# il confronto avviene con gli spazi rimossi da entrambe le parti.
assert() {
  needle=$(printf '%s' "$2" | tr -d ' ')
  txt "$1" | tr -d ' ' | grep -qF "$needle" || fail "'$2' non trovato in $1"
  echo "OK  assert '$2' in $1"
}

build resoconto  resoconto  2026-1
build report     report     2026-1
build preventivo preventivo 2026-1
build proposta   proposta   2026-1
build storico    storico    storico

# ── Titoli automatici ────────────────────────────────────────────────
assert resoconto/main.pdf  "RESOCONTO"
assert resoconto/main.pdf  "2026/1"
assert report/main.pdf     "REPORT TECNICO"
assert preventivo/main.pdf "PREVENTIVO"
assert proposta/main.pdf   "PROPOSTA"

# ── Data automatica (max attività) e giorno calcolato da \setdocdata ─
assert resoconto/main.pdf  "05/02/2026"
assert report/main.pdf     "15/02/2026"

# ── Conti: 4,5+2 ore * 22 = 143,00; sottrazioni 13,50; saldo 129,50 ──
assert resoconto/main.pdf  "143,00"
assert resoconto/main.pdf  "13,50"
assert resoconto/main.pdf  "129,50"
assert resoconto/main.pdf  "Da corrispondere"
assert resoconto/main.pdf  "Tariffa oraria"

# ── Separatore migliaia e totali del preventivo ──────────────────────
assert preventivo/main.pdf "1.234,00"
assert preventivo/main.pdf "1.300,00"

# ── Titolo single-source e report ────────────────────────────────────
assert resoconto/main.pdf  "Richiesta di prova"
assert report/main.pdf     "Incidente di prova sul server"
assert report/main.pdf     "49,20"

# ── Registro dello storico: gruppi + tipologia sconosciuta in Altri ──
assert storico/main.pdf    "Incident"
assert storico/main.pdf    "Altri"
assert storico/main.pdf    "Voce di tipologia sconosciuta"

# ── Nessun riferimento irrisolto (??CODICE?? / ??titolo?? / ??data??) ─
for p in resoconto report preventivo proposta storico; do
  if txt "$p/main.pdf" | grep -q "??"; then
    fail "marcatore ?? presente in $p/main.pdf"
  fi
done
echo "OK  nessun ?? nei PDF"

echo ""
echo "Tutti i test superati."
