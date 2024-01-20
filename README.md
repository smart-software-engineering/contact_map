# ContactMap

Eine einfache Erweiterung, welche Adressen aus einem System (zur Zeit Bexio) ausliest, via Geo Decoding von Google zu Koordinaten umwandelt und diese dann auf einer Karte darstellen lässt.

TODO: Beispiel der laufenden Applikation einbinden.

## Technische Details

### Bexio API

- Kontaktgruppen (für Filter): https://docs.bexio.com/#tag/Contact-Groups
- Company Profile (zentriert Karte): https://docs.bexio.com/#tag/Company-Profile
- Permissions (Erläuterung unten): https://docs.bexio.com/#tag/Permissions
- Länder: https://docs.bexio.com/#tag/Countries
- Kontakte: https://docs.bexio.com/#tag/Contacts
  - bei der 1. Synchronisierung wird einfach die paginierte Liste durchgeladen, bis alle Kunden geladen wurden
  - danach wird via mittels search alle 10 Minuten geprüft, ob Veränderungen existieren
  - grundsätzlich werden nur Firmendaten geladen, keine Privatpersonen (Datenschutz)

#### Anmerkung zu den Berechtigungen

Grundsätzlich braucht die App Zugriff auf die obigen Anteile. In Bexio selber kann ein Benutzer folgende Berechtigungen (für Kontakte) haben:

- alles
- nur eigene
- keine

Ein Benutzer ohne Berechtigung wird keine Möglichkeit haben, sich bei der Kartenanwendung überhaupt anzumelden, da dies keinen Sinn ergibt.

Der erste Benutzer einer Firma, der über die Berechtigung "alles" verfügt, wird verwendet, um die Synchronisierung der Kontakte auszuführen. Wurde kein solcher Benutzer registriert,
wird für jeden Anwender einzeln synchronisiert.

## Google Maps

Die App braucht einen Google Maps API Key, um die Synchronisierung auszuführen und einen zweiten, um die Karte darzustellen.

Die momentane Version filtert nichts, sprich: sie lädt alle Kunden auf einen Schlag hoch, verwendet aber Marker Clustering, damit die Karte nicht überladen wird. Es muss noch getestet werden, 
ab wann dies ein Problem ist.

Filtern: alle Kundenkategorien werden geladen und als Filter zur Verfügung gestellt.

## Architektur-Überlegungen

Grundsätzlich wird für jede Firma ein GenServer gestartet. Diese trackt die vorhandenen Benutzer und verwaltet die Zugriffe. Er ist Supervisor für
- Benutzer
- Kontakte (+ Berechtigung)

Es gibt eine Datenbank, in dieser werden ebenfalls folgende Informationen festgehalten:
- Firma (ID + Profil)
- Benutzer (nur ID)
- später: Abrechnungsinformationen

Es werden keine Kontakte in der DB gespeichert, um Problemen mit dem Datenschutz aus dem Weg zu gehen. Dies bedeutet aber auch, dass bei einem Neustart des Servers die Kontakte weg sind und neu 
geladen werden müssen. 

Mögliche Migitation sofern notwendig
* Redis In-Memory-DB für die Kontakte
* Pub/Sub und alle Informationen auf mindestens 2 Servern halten

## Entwicklungsumgebung

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
