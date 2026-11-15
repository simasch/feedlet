# Feedlet 1.0: offene Punkte bis zur Veröffentlichung

Stand: 15. November 2026

## 1. Apple Support: Konto umstellen (wartet auf Apple)

- Das Team W6QA33J4VC heisst noch **simas GmbH, Moosentli 7, 3235 Erlach**. Es soll **Martinelli GmbH, Tulpenweg 1, 2575 Täuffelen** heissen.
- Die Anfrage beim Support läuft.
- Wichtig: Auf der Business-Seite in App Store Connect ist die D-U-N-S **86214669** hinterlegt. Für die Martinelli GmbH gilt **485054147**. Der Support muss wahrscheinlich auch die D-U-N-S-Nummer wechseln, nicht nur den Namen.

## 2. EU-Händlerstatus (Digital Services Act), nach Punkt 1

- App Store Connect → Business → „Compliance-Anforderungen einhalten“ → „Ich bin Händler“.
- Die Adresse übernimmt Apple aus dem D-U-N-S-Eintrag; sie lässt sich nicht eingeben. Deshalb erst erfassen, wenn dort Täuffelen steht.
- Eintragen: Telefon +41 32 544 88 88, E-Mail simon@martinelli.ch.
- Die Bestätigungscodes per SMS und E-Mail eingeben.
- Ohne verifizierten Händlerstatus ist Feedlet in der EU nicht erhältlich.

## 3. iOS-Build hochladen

- Das Archivieren scheitert mit „Your team has no devices from which to generate a provisioning profile“.
- Ein iPhone oder iPad im Team registrieren: per Kabel anschliessen, „Vertrauen“ antippen, in Xcode unter Window → Devices and Simulators prüfen. Oder die UDID unter developer.apple.com → Devices eintragen.
- Danach den iOS-Build hochladen (`Scripts/release.sh --upload` lädt iOS und macOS hoch).

## 4. Builds den Versionen zuordnen

- macOS-Build 26 ist hochgeladen. Sobald er verarbeitet ist, in **macOS App 1.0 → Build** auswählen.
- Den iOS-Build ebenso in **iOS App 1.0 → Build** auswählen.

## 5. Vor dem Einreichen prüfen

- **Altersfreigabe**: Fragebogen ausgefüllt? (4+, „Unrestricted Web Access“ = Nein)
- **App Review Information**: Kontaktdaten eingetragen, „Sign-in required“ abgewählt, in den Notes `NSAllowsArbitraryLoads` begründet (Text in [app-store-metadata.md](app-store-metadata.md))
- **Deutsche Lokalisierung**: Untertitel, Beschreibung, Keywords und die deutschen URLs eingetragen?
- **Copyright** in beiden Versionen: `2026 Martinelli GmbH`
- **Release-Art**: „Manually release this version“ empfohlen

## 6. Testen und einreichen

1. Mit TestFlight auf iPhone, iPad und Mac durchklicken.
2. iOS- und macOS-Version: **Add for Review → Submit**. Das Review dauert meist 1–3 Tage.
3. Nach der Freigabe manuell veröffentlichen.

## Erledigt

- Screenshots: iPhone 6,3″ (4), iPad 13″ (2), Mac (2)
- App Privacy: „Data Not Collected“ veröffentlicht
- Content Rights: „Yes, … has the necessary rights to its third-party content“
- Verfügbarkeit: 174 Länder, ohne China (Festland), weil News-Apps dort eine Bewilligung brauchen
- Datenschutz-, Support- und Marketing-URLs (EN und DE) sind online
- Preis: gratis
