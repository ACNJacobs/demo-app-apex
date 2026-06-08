# Teken-encoding herstel in SCAFF APP (APEX)

## Probleem
Op de home cards verschenen teksten zoals vraagtekens/ruitjes in plaats van correcte tekens (bijvoorbeeld Poolse letters).

Voorbeelden:
- Zamowienie materia?u
- Zloz nowe zamowienie materia?u
- en vergelijkbare fouten in meerdere talen

## Oorzaak
De fout zat niet alleen in de browserweergave. In de APEX exportbron stonden message-teksten zelf al corrupt (mojibake) in:
- apex_app/scaff-app/shared-components/messages.apx

De echte bron van correcte vertalingen stond wel goed in:
- db/i18n/messages_*.sql

Daarom bleef de fout terugkomen zolang messages.apx niet volledig werd hersteld.

## Wat er is gedaan
### 1. Snelle diagnose
- Gezocht op verdachte patronen (zoals replacement tekens en dubbele vraagtekens) in de APEX bron.
- Bevestigd dat messages.apx veel corrupte teksten bevatte.
- Bevestigd dat dezelfde keys in db/i18n/messages_*.sql wel correcte Unicode tekst bevatten.

### 2. Eerste directe fix (specifieke Poolse card)
Twee sleutelteksten zijn eerst handmatig hersteld:
- SCAFF.MENU.MATERIAAL.TITLE (pl)
- SCAFF.MENU.MATERIAAL.SUBTITLE (pl)

Daarna:
- scripts/apex-validate.ps1
- scripts/apex-import.ps1

Resultaat: de eerste card was direct correct.

### 3. Volledige bulk-fix voor alle talen
Omdat er nog veel andere corrupte teksten waren, is een volledige sync gedaan:
- Voor elke regel HD_I18N_INSTALL.upsert('KEY','LANG','TEXT') in db/i18n/messages_*.sql
- De bijbehorende textMessage KEY + language in messages.apx vervangen met TEXT

Samengevat:
- Bron van waarheid: db/i18n/messages_*.sql
- Doelbestand: apex_app/scaff-app/shared-components/messages.apx
- Aantal vervangen messageblokken: 577

Daarna opnieuw:
- scripts/apex-validate.ps1
- scripts/apex-import.ps1

Resultaat: geen mojibake-patronen meer in messages.apx en import succesvol.

## Hoe de talen zijn gedaan
De talen zijn niet handmatig per scherm aangepast, maar volledig key-based gesynchroniseerd.

### Taalbestanden (bron)
Deze bestanden zijn gebruikt als bron van waarheid:
- db/i18n/messages_ar.sql
- db/i18n/messages_de.sql
- db/i18n/messages_en.sql
- db/i18n/messages_fr.sql
- db/i18n/messages_nl.sql
- db/i18n/messages_pl.sql
- db/i18n/messages_ru.sql
- db/i18n/messages_tr.sql

### Gebruikte language codes
- ar = Arabisch
- de = Duits
- en = Engels
- fr = Frans
- nl = Nederlands
- pl = Pools
- ru = Russisch
- tr = Turks

### Synchronisatielogica
Per message-regel in SQL:
- HD_I18N_INSTALL.upsert('SLEUTEL','TAAL','TEKST')

is gezocht naar het overeenkomstige APEXlang blok:
- textMessage SLEUTEL
- message.language: TAAL

en alleen de text: waarde is vervangen met TEKST uit SQL.

Daardoor zijn alle talen consequent op dezelfde manier hersteld, zonder per taal of per pagina aparte handmatige edits.

### Waarom dit belangrijk is
- De matching gebeurt op combinatie van SLEUTEL + TAAL.
- Dus bijvoorbeeld SCAFF.MENU.RETOUR.TITLE + pl en SCAFF.MENU.RETOUR.TITLE + de blijven correct gescheiden.
- Hierdoor ontstaat geen taalvermenging en blijft elke vertaling in de juiste taalvariant staan.

## Reproduceerbare aanpak (kort)
1. Controleer of de fout in export zit:
- Zoek in apex_app/scaff-app/shared-components/messages.apx op corrupte tekens.

2. Vergelijk met i18n SQL bron:
- Controleer db/i18n/messages_*.sql voor dezelfde message keys.

3. Herstel messages.apx vanuit SQL bron (bulk sync):
- Parse alle HD_I18N_INSTALL.upsert regels.
- Match op combinatie KEY + language.
- Overschrijf text: waarde in textMessage blokken.

4. Deploy:
- pwsh scripts/apex-validate.ps1
- pwsh scripts/apex-import.ps1

5. Browser:
- Hard refresh met Ctrl+Shift+R
- Eventueel opnieuw inloggen als sessietaal/caching nog oud is

## Waarom dit werkt
APEX import gebruikt de appbronbestanden. Als messages.apx corrupt is, overschrijft import correcte database-waarden opnieuw met corrupte tekst.

Door messages.apx eerst te herstellen op basis van db/i18n/messages_*.sql en pas daarna te importeren, worden correcte Unicode vertalingen persistent en consistent.

## Notities
- FILE_IGNORED waarschuwingen tijdens validate/import waren aanwezig maar niet blokkerend.
- Dit was een data/bron-synchronisatie probleem, niet alleen een frontend rendering probleem.
