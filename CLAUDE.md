# Webapp compiti — struttura del progetto

Repo unico con un sito/app per fascia d'età più una landing page:

- `year2/` — workbook Year 2
- `year3/` — workbook Year 3
- `year4/` — workbook Year 4
- `year5/` — workbook Year 5
- `landing/` — landing page pubblica del progetto

Ogni sottocartella è pensata come lavoro isolato di un thread dedicato a quella fascia
d'età (o alla landing). Un thread assegnato a una sottocartella specifica non deve
leggere o modificare file nelle altre sottocartelle.

## Modifiche comuni a tutti gli anni

Quando serve una modifica che riguarda più fasce d'età insieme, va fatta da un thread
con working directory sulla **radice** del repo (`webapp-compiti/`), non da uno dei
thread per-anno. Usare un branch dedicato per queste modifiche trasversali e poi
mergiare, per non entrare in conflitto con il lavoro in corso nei thread per-anno.
