# Webapp compiti — struttura del progetto

Repo unico con un sito/app per fascia d'età più una landing page:

- `year2/` — workbook Year 2
- `year3/` — workbook Year 3
- `year4/` — workbook Year 4
- `year5/` — workbook Year 5
- `year6/` — workbook Year 6
- `landing/` — landing page pubblica del progetto

Ogni sottocartella è pensata come lavoro isolato di un thread dedicato a quella fascia
d'età (o alla landing). Un thread assegnato a una sottocartella specifica non deve
leggere o modificare file nelle altre sottocartelle.

## Modifiche comuni a tutti gli anni

Quando serve una modifica che riguarda più fasce d'età insieme, va fatta da un thread
con working directory sulla **radice** del repo (`webapp-compiti/`), non da uno dei
thread per-anno. Usare un branch dedicato per queste modifiche trasversali e poi
mergiare, per non entrare in conflitto con il lavoro in corso nei thread per-anno.

## Git: SOLO il thread "root" fa commit/push/deploy

**I thread per-anno modificano SOLO i propri file. Non fanno mai `git add`,
`git commit`, `git push`, `git rebase` né toccano `.git` in alcun modo.** Questa
regola esiste perché in passato più thread hanno condiviso la stessa cartella `.git`
fisica, e comandi git lanciati in contemporanea hanno mescolato le modifiche di
thread diversi in un unico commit sbagliato (nessun dato è mai andato perso, ma va
evitato).

Il thread "root" (working directory sulla radice del repo principale
`webapp-compiti/`, gestito dall'utente in una sessione separata) è l'unico
responsabile di:
- fare commit isolati per ogni fascia d'età modificata
- fare fetch/rebase/push su GitHub
- rigenerare gli zip di deploy (`./make-zips.sh`)
- pubblicare su Cloudflare (`wrangler deploy` da ogni sottocartella)

Se un thread per-anno ha finito le sue modifiche, deve semplicemente lasciarle nella
working tree (non committate) e segnalarlo all'utente o al thread root — non deve
mai provare a salvarle da solo con git.

## Struttura fisica: un git worktree per thread (protezione tecnica, non solo di regola)

Oltre alla regola sopra, dal 22 agosto 2026 ogni thread per-anno lavora in un **git
worktree separato** — stessa cronologia/oggetti del repository, ma cartella e indice
fisicamente distinti, così due thread non possono più scontrarsi sull'indice nemmeno
per errore:

- `webapp-compiti/` — repo principale, branch `main`, usato SOLO dal thread root
- `webapp-compiti-year2/` — worktree dedicato, branch `work-year2`
- `webapp-compiti-year3/` — worktree dedicato, branch `work-year3` (da creare quando riattivato)
- `webapp-compiti-year4/` — worktree dedicato, branch `work-year4` (da creare quando riattivato)
- `webapp-compiti-year5/` — worktree dedicato, branch `work-year5`
- `webapp-compiti-year6/` — worktree dedicato, branch `work-year6` (da creare quando riattivato)
- `webapp-compiti-landing/` — worktree dedicato, branch `work-landing` (da creare quando riattivato)

Un thread per-anno lavora **dentro il proprio worktree**, nella propria sottocartella
(es. il thread year2 in `webapp-compiti-year2/year2/`), esattamente come prima — le
cartelle delle altre fasce d'età esistono anche lì (checkout completo del repo) ma
non vanno toccate, per lo stesso motivo di isolamento di sempre.

Per creare un nuovo worktree quando un thread year3/year4/landing si riattiva, il
thread root esegue dalla cartella `webapp-compiti/`:
```
git worktree add ../webapp-compiti-year3 -b work-year3
```
