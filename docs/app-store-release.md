# App Store Veröffentlichung

Anleitung, um Feedlet (iOS + macOS, Multiplatform-Target) im App Store zu veröffentlichen.

## 1. Voraussetzungen

- **Apple Developer Program**: Anmeldung unter developer.apple.com/programs. Kostet 99 USD pro Jahr (bzw. den lokalen Preis) und gilt für iOS und macOS zusammen.
- Danach in Xcode unter **Settings → Accounts** die Apple-ID hinzufügen.

## 2. Was im Projekt noch geändert werden muss

| Was | Status |
|---|---|
| Team | **Offen**: braucht die Mitgliedschaft. Im Target unter *Signing & Capabilities* das Team wählen oder `DEVELOPMENT_TEAM` an `Scripts/release.sh` übergeben. |
| Bundle ID | Erledigt: `ch.martinelli.rssreader` (Tests: `ch.martinelli.rssreader.tests`). Nach dem ersten Upload nicht mehr änderbar. |
| Version | Erledigt: `1.0`. Die Build-Nummer setzt `Scripts/release.sh` aus der Anzahl der Git-Commits. |
| Privacy Manifest | Erledigt: `App/PrivacyInfo.xcprivacy` (kein Tracking, keine Daten, keine Required-Reason-APIs). Anpassen, falls z. B. `UserDefaults` oder Dateizeitstempel dazukommen. |
| Export Compliance | Erledigt: `INFOPLIST_KEY_ITSAppUsesNonExemptEncryption = NO` |
| `NSAllowsArbitraryLoads` | Bleibt `true`. Die Begründung für das Review steht in [app-store-metadata.md](app-store-metadata.md). |

Bereits vorhanden: App-Icon (iOS + macOS), App Sandbox, ausgehende Netzwerkverbindungen, Zugriff auf vom Nutzer gewählte Dateien, automatisches Signing, Kategorie News.

## 3. Eintrag in App Store Connect

Auf appstoreconnect.apple.com unter **Apps → + → Neue App**:

- Plattformen **iOS und macOS** auswählen. Da es ein Multiplatform-Target ist, wird es automatisch ein *Universal Purchase*.
- Name: `Feedlet – RSS Reader`
- Bundle ID auswählen, SKU vergeben (frei wählbar).

Alle Texte und Angaben stehen vorbereitet in [app-store-metadata.md](app-store-metadata.md), die Datenschutzerklärung in [privacy-policy.md](privacy-policy.md).

Außerdem nötig:

- **Screenshots**: für das iPhone 6,9″, für das iPad 13″ (weil `TARGETED_DEVICE_FAMILY = 1,2`) und für den Mac (z. B. 2880×1800)
- Beschreibung, Keywords, Support-URL und **Datenschutz-URL** (Pflicht, auch wenn keine Daten gesammelt werden)
- **App Privacy**: vermutlich „Keine Daten erfasst“
- Altersfreigabe-Fragebogen und Preis (gratis oder kostenpflichtig)

## 4. Build hochladen

In Xcode für jede Plattform einmal:

1. Als Ziel **Any iOS Device (arm64)** bzw. **Any Mac** wählen
2. **Product → Archive**
3. Im Organizer **Distribute App → App Store Connect → Upload**

Alternativ über die Kommandozeile mit beiden Plattformen in einem Lauf:

```sh
DEVELOPMENT_TEAM=ABCDE12345 Scripts/release.sh            # Archive + Export nach build/release/
DEVELOPMENT_TEAM=ABCDE12345 Scripts/release.sh --upload   # Archive + Upload zu App Store Connect
```

Die Team-ID steht auf developer.apple.com unter *Membership*. Die Export-Einstellungen liegen in `Scripts/ExportOptions.plist`.

## 5. Testen und einreichen

- Mit **TestFlight** (intern oder extern) auf echten Geräten testen. Das wird vor dem Review empfohlen.
- Danach den Build der Version zuordnen und **Zur Prüfung einreichen**. Das Review dauert meist 1–3 Tage.
