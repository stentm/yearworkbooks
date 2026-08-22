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

## Git: SOLO il thread "root" fa commit/push/deploy

**I thread per-anno (year2/3/4/5, landing) modificano SOLO i propri file. Non fanno
mai `git add`, `git commit`, `git push`, `git rebase` né toccano `.git` in alcun modo.**
Tutti i thread condividono la stessa cartella `.git` fisica — se più thread eseguono
comandi git in contemporanea, l'indice di git può mescolare le modifiche di thread
diversi in un unico commit sbagliato (già successo una volta: due commit paralleli si
sono fusi, e un `git commit --amend` successivo ha perso di vista le modifiche di un
thread finché non sono state recuperate a mano). Nessun dato è mai andato perso, ma
va evitato.

Il thread "root" (quello con working directory sulla radice del repo, gestito
dall'utente in una sessione separata) è l'unico responsabile di:
- fare commit isolati per ogni fascia d'età modificata
- fare fetch/rebase/push su GitHub
- rigenerare gli zip di deploy (`./make-zips.sh`)
- pubblicare su Cloudflare (`wrangler deploy` da ogni sottocartella)

Se un thread per-anno ha finito le sue modifiche, deve semplicemente lasciarle nella
working tree (non committate) e segnalarlo all'utente o al thread root — non deve
mai provare a salvarle da solo con git.
