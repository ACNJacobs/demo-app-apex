# Installatiehandleiding: Altrad SCAFF APP

Deze handleiding beschrijft de stappen om de volledige Oracle APEX (26.1) ontwikkelomgeving voor de **Altrad SCAFF APP** te reproduceren en te installeren op macOS, Ubuntu Linux en Windows 11.

De applicatie maakt gebruik van:
- **Docker Compose** voor de Oracle 23ai Free database en ORDS (Oracle REST Data Services).
- **PowerShell (pwsh)** voor de installatie- en deploymentscripts.
- **Git** voor versiebeheer.

---

## 1. Vereisten (Prerequisites)

Voordat je begint, moeten de volgende tools op het doelsysteem zijn geïnstalleerd. De installatiewijze verschilt per besturingssysteem.

### macOS (Apple Silicon of Intel)
1. **Docker Desktop**: Download en installeer vanaf [Docker's website](https://www.docker.com/products/docker-desktop).
2. **Git**: Installeer via Homebrew (`brew install git`) of installeer de Xcode command line tools door `git` in de terminal te typen.
3. **PowerShell Core**: Installeer via Homebrew: 
   ```bash
   brew install --cask powershell
   ```

### Ubuntu Linux
1. **Docker Engine & Compose**:
   ```bash
   sudo apt update
   sudo apt install docker.io docker-compose-v2
   sudo usermod -aG docker $USER
   # Log uit en weer in (of start de terminal opnieuw) om de groepsrechten toe te passen
   ```
2. **Git**: 
   ```bash
   sudo apt install git
   ```
3. **PowerShell Core**:
   ```bash
   sudo apt-get install -y wget apt-transport-https software-properties-common
   wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
   sudo dpkg -i packages-microsoft-prod.deb
   sudo apt-get update
   sudo apt-get install -y powershell
   ```

### Windows 11
1. **Docker Desktop**: Download en installeer vanaf [Docker's website](https://www.docker.com/products/docker-desktop). Zorg ervoor dat de WSL2-backend in de instellingen is geactiveerd.
2. **Git**: Download en installeer [Git voor Windows](https://git-scm.com/download/win).
3. **PowerShell Core (pwsh)**: Open de Microsoft Store en zoek naar **PowerShell**, of installeer via winget in de command prompt/terminal:
   ```powershell
   winget install --id Microsoft.Powershell --source winget
   ```

---

## 2. Het project voorbereiden

Kloon (of kopieer) de projectbestanden naar je lokale machine en navigeer naar de projectmap:

```bash
git clone https://github.com/ACNJacobs/scaff-app.git oracle-apex
cd oracle-apex
```

> [!IMPORTANT]
> Zorg ervoor dat je terminal of PowerShell geopend is in de hoofdmap van het project (waar `docker-compose.yml` en de `.ps1` scripts zich bevinden) voordat je verder gaat.

---

## 3. Containers opstarten (Oracle DB & ORDS)

Start de Docker-stack op in de achtergrond. Hiermee worden de Oracle 23ai Free database en de ORDS webserver gedownload en gestart.

```bash
docker compose up -d
```

> [!WARNING]
> De Oracle Database container heeft even tijd nodig om voor de eerste keer volledig te initialiseren. Wacht een paar minuten voordat je verder gaat. Je kunt de status volgen met:
> ```bash
> docker logs -f apex_db
> ```
> Wacht tot je een melding ziet in de logs dat de database operationeel is.

---

## 4. Oracle APEX Installeren

Zodra de database draait, voeren we het geautomatiseerde PowerShell-script uit om Oracle APEX (26.1) in de container te downloaden en te configureren.

Start een terminal, zorg dat je in de projectmap bent, en voer het installatiescript uit met `pwsh` (PowerShell Core):

```powershell
pwsh ./install_apex.ps1
```

**Wat doet dit script?**
1. Downloadt `apex-latest.zip` als dit lokaal nog ontbreekt.
2. Pakt de bestanden uit en kopieert de `apex` map naar de `apex_db` container.
3. Voert de zware installatie van Oracle APEX uit in de database (dit duurt **10 tot 20 minuten**, even geduld!).
4. Configureert de APEX REST-services.
5. Maakt het initiële ADMIN-account aan.

### Inloggegevens na installatie:
- **Workspace**: INTERNAL
- **Gebruiker**: ADMIN
- **Wachtwoord**: Welkom_APEX_2026!
- **URL**: [http://localhost:8080/ords/](http://localhost:8080/ords/)

---

## 5. De applicatie (SCAFF APP) importeren

Na de succesvolle basisinstallatie van APEX, moet de broncode van de applicatie worden ingeladen. Het project bevat een script om alle APEXlang bestanden (`.apx`) en SQL structuur in te lezen.

Voer in je terminal het volgende commando uit:

```powershell
pwsh scripts/apex-import.ps1
```

*Dit script pusht de lokaal opgeslagen werkruimte en applicatie-configuratie (zoals te vinden in de `apex_app/` en `db/` mappen) naar de zojuist geïnstalleerde APEX omgeving.*

---

## 6. Verifiëren en Gebruik

De omgeving is nu klaar!

1. Open je webbrowser en ga naar [http://localhost:8080/ords/](http://localhost:8080/ords/).
2. Log in op de geïmporteerde workspace (bijv. **APEX_DEV**, of controleer de interne beheeromgeving via de **INTERNAL** workspace).

### De "Golden Loop"
Voor het dagelijks ontwikkelen gebruik je de volgende PowerShell scripts:
- **Exporteer APEX wijzigingen naar disk**: `pwsh scripts/apex-export.ps1`
- **Importeer code vanaf disk naar APEX**: `pwsh scripts/apex-import.ps1`
- **Verifieer code lokaal**: `pwsh scripts/apex-validate.ps1`

### Omgeving beheren
- Starten: `docker compose up -d`
- Stoppen: `docker compose down`

---

## 7. Aanbevolen: VS Code & SQL Developer Extensie

Om optimaal gebruik te maken van AI-assistentie in dit project, maken we gebruik van de **SQLcl MCP Server**. Hierdoor kan de AI direct, snel en veilig met jouw lokale Oracle 23ai database praten zonder Docker-commando's te hoeven genereren.

### Installatiestappen:
1. Installeer [Visual Studio Code](https://code.visualstudio.com/).
2. Zoek in de VS Code extensies naar **Oracle SQL Developer Extension for VS Code** en installeer deze.
3. Open het project in VS Code.
4. Voeg de connecties toe in de SQL Developer extensie, zodat de MCP server deze herkent. Gebruik voor deze applicatie de volgende gegevens:
   - **Naam**: `databeest` (of `apex_dev`)
   - **Gebruiker**: `APP_DATA`
   - **Wachtwoord**: `Welkom_APEX_2026!`
   - **Connectie**: `localhost:2521/FREEPDB1`
5. Zodra de extensie en connecties zijn ingesteld, kan de AI-assistent via MCP direct query's (`sql_run`) en PL/SQL blokken (`sqlcl_run`) voor je testen.

---

## 8. Architectuur: Hoe AI, MCP en de Database samenwerken

Het inrichten van bovenstaande extensie zorgt ervoor dat het **Model Context Protocol (MCP)** actief wordt. Dit is een open standaard die het mogelijk maakt voor AI-assistenten om veilig te communiceren met lokale tools. 

Wat gebeurt er onder de motorkap wanneer jij de AI een vraag stelt over de database?

1. **De MCP Server**: De Oracle SQL Developer extensie fungeert als een onzichtbare "MCP Server". Hij vertelt de AI welke "gereedschappen" (tools) beschikbaar zijn, zoals het uitvoeren van een query (`sql_run`).
2. **Veilige Opslag**: Jouw database-wachtwoord (`Welkom_APEX_2026!`) wordt niet opgeslagen in de projectbestanden. De VS Code extensie slaat dit veilig en versleuteld op in jouw globale Windows-gebruikersprofiel (bijv. in `~/.dbtools/` of de globale VS Code opslag).
3. **De Aanroep**: Wanneer de AI een query wil uitvoeren, roept hij via het beveiligde MCP-kanaal de `sql_run` tool aan en geeft daarbij de gewenste connectienaam (bijv. `databeest`) en de SQL-query door. De AI stuurt géén wachtwoorden over dit kanaal; hij verwijst enkel naar de connectienaam.
4. **De Uitvoering**: De Oracle extensie (gebaseerd op Java JDBC en SQLcl) pakt het signaal op, verbindt lokaal met je Docker container op `localhost:2521`, voert de opdracht uit en verpakt het resultaat in een JSON-formaat.
5. **Het Resultaat**: De AI ontvangt de JSON-data, leest de rijen uit de database en kan direct met jou communiceren of voorstellen doen op basis van de actuele data in jouw applicatie.

Dankzij deze naadloze integratie en het opsplitsen van APEX-applicaties in APEXlang (`.apx`) tekstbestanden, ontstaat de krachtige "Golden Loop" (Export -> AI bewerkt -> Import) waarmee dit project wordt gebouwd.
