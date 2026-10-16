# Innlevering 7 - ING3504 Signalbehandling

Komplett besvarelse av alle ni hovedoppgaver og alle deloppgaver.
Samme LaTeX-oppsett og mappestruktur som besvarelsen til innlevering 6.
Forklarende tekst foran hver vist formel, utregning og kodeblokk slutter med kolon.

```text
A7/
    Innl_7_2025.pdf
    Latx/
        sections/
            oppgave1.tex
            ...
            oppgave9.tex
        Media/
            grapf1.png
        code/
            oppgave3.m
            kontroll.m
        main.tex
        main.pdf
        README.md
```

Oppgaveteksten er inkludert uendret.

## Oppsett og kompilering

A4, 12 pt Latin Modern, 2.5 cm marger, unummererte hovedoverskrifter,
deloppgaver merket a), b) osv., sentrerte formler, innrammede hovedsvar,
ingen forside og sidetall midtstilt nederst. Hver hovedoppgave starter
på en ny side. Overskriftene har samme plassering som i A4/A6-malen.

Kompiler fra `Latx`-mappen:

```bash
latexmk -pdf main.tex
```

Alternativt kjøres følgende kommando to ganger:

```bash
pdflatex -interaction=nonstopmode -halt-on-error main.tex
```

Ved bruk av Overleaf settes `main.tex` som hovedfil. Filene er UTF-8.
Norsk Babel lastes hvis `norsk.ldf` er tilgjengelig.

## Matlab/Octave

Fra `Latx`-mappen kan skriptene kjøres med:

```matlab
run('code/oppgave3.m')
run('code/kontroll.m')
```

`oppgave3.m` løser den positive kapasitetsligningen og lagrer figuren i
`Media/grapf1.png`. `kontroll.m` beregner alle hovedsvar og inkluderer
numeriske toleransekontroller. Ingen ekstra toolbox er nødvendig.

## Modellforutsetninger

- Oppgave 1 og 9: minste båndbredde tolkes som ideell, ensidig
  Nyquist-båndbredde, Rb/2. Første spektralnull for rektangulære NRZ-pulser
  ligger ved Rb. Denne forskjellen forklares i besvarelsen.
- Oppgave 2: Shannon-kapasiteten er 37.074 kbit/s. I del b brukes
  oppgavens heltallsmodell med fast symbolrate 2B, som gir 5 bit per
  symbol og 31 kbit/s. Det formelle M i del a er 63.10; avrundet opp
  tilsvarer dette 64 tilstander. 6 bit per symbol ved symbolrate 2B
  ville gitt 37.2 kbit/s, som overskrider Shannon-grensen.
- Oppgave 3, 4 og 5: Shannon-grense for en kanal med additiv hvit
  Gauss-støy. Beregningene er teoretiske grenser.
- Oppgave 6 og 7: Raised Cosine-pulsforming uten intersymbolinterferens,
  binær overføring og ensidig basisbåndbredde.
- Oppgave 8 og 9: bipolar NRZ tolkes som antipodal/polar signalering
  (-A og +A), ikke tre-nivå AMI. Like sannsynlige bit, optimal deteksjon
  og ingen intersymbolinterferens. Eb er gjennomsnittlig energi per bit.
  Unipolar NRZ bruker nivåene 0 og A. Oppgave 9 oppgir både BER og
  forventet antall bitfeil per sekund.

## Kontroll

PDF-en er kompilert og visuelt kontrollert. Beregningene er kontrollert
uavhengig med Python/SciPy, og alle viste formelblokker er kontrollert
for kolon i den foregående teksten.

Matlab/Octave var ikke tilgjengelig i produksjonsmiljøet, så `.m`-filene
er ikke kjørt der. Figuren er generert fra samme formel som Matlab-koden
med Python/Matplotlib.

Standarduttrykkene for antipodal signalering og on-off/unipolar
signalering er også kontrollert mot MITs materiale:
https://web.mit.edu/16.36/2006directory/psets/hw5-sol.pdf
