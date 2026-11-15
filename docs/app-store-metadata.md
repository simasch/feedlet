# App Store Metadaten

Texte und Angaben für den Eintrag in App Store Connect. Primärsprache Englisch, zusätzlich Deutsch.
Offene Punkte sind mit **TODO** markiert.

## Allgemein

| Feld | Wert |
|---|---|
| Bundle ID | `ch.martinelli.feedlet` |
| SKU | `feedlet` |
| Plattformen | iOS (iPhone, iPad) und macOS, Universal Purchase |
| Version | 1.0 |
| Preis | Gratis, keine In-App-Käufe |
| Primäre Kategorie | News |
| Sekundäre Kategorie | Productivity |
| Altersfreigabe | 4+ (keine eigenen Inhalte; Feeds werden vom Nutzer gewählt). Im Fragebogen „Unrestricted Web Access“ mit **Nein** beantworten, da nur Feed-Inhalte angezeigt und Links im Browser geöffnet werden. |
| Copyright | 2026 Simon Martinelli, Martinelli GmbH |
| App-Name (max. 30 Zeichen) | `Feedlet – RSS Reader` (unter dem Icon: „Feedlet“) |
| Kontakt | simon@martinelli.ch |
| Anbieter (EU-Trader-Status) | Martinelli GmbH, Tulpenweg 1, 2575 Täuffelen, Switzerland, simon@martinelli.ch, +41 32 544 88 88 |
| Support-URL | `https://martinelli.ch/feedlet/support` |
| Datenschutz-URL | `https://martinelli.ch/feedlet/privacy` (Text: [privacy-policy.md](privacy-policy.md)) |
| Marketing-URL (optional) | `https://martinelli.ch/feedlet` |

## App Privacy (Datenschutzangaben)

**Data Not Collected.** Die App hat keinen Server, kein Konto, keine Analyse und keine Werbung.
Abos und Artikel werden nur lokal im Container der App gespeichert. Die App ruft nur die Feeds ab,
die der Nutzer selbst abonniert.

## English (primary)

**Subtitle** (max. 30): `Simple, private feed reading`

**Promotional text** (max. 170):
> Follow your favorite sites without accounts, ads or tracking. RSS and Atom feeds on iPhone, iPad and Mac.

**Description:**
> Feedlet is a small, native feed reader for iPhone, iPad and Mac. It does one thing: show you new
> articles from the sites you follow — without accounts, ads, algorithms or tracking.
>
> • Add a feed by its URL or just by the website address; the feed is found automatically
> • Supports RSS 2.0, RSS 1.0 and Atom
> • Smart lists for Unread, All and Starred articles
> • Read/unread and starred state, unread badges, mark all as read
> • Refreshes on launch and every 30 minutes, efficiently using conditional requests
> • Import and export your subscriptions as OPML
> • Articles render without JavaScript; links open in your browser
> • iPhone and iPad: pull to refresh, swipe to mark read or star, share sheet
> • Mac: three-pane layout and keyboard shortcuts for everything
>
> Your subscriptions and articles stay on your device. Feedlet has no server and collects no data.

**Keywords** (max. 100, kommagetrennt, ohne Leerzeichen):
`rss,atom,feed,reader,news,opml,blog,subscribe,headlines,private,aggregator,newsreader`

**What's New (1.0):** `First release.`

## Deutsch

**Untertitel:** `Feeds lesen, einfach & privat`

**Werbetext:**
> Folge deinen Lieblingsseiten ohne Konto, Werbung oder Tracking. RSS- und Atom-Feeds auf iPhone, iPad und Mac.

**Beschreibung:**
> Feedlet ist ein kleiner, nativer Feed-Reader für iPhone, iPad und Mac. Er macht genau eines: neue
> Artikel der Seiten anzeigen, denen du folgst – ohne Konto, Werbung, Algorithmen oder Tracking.
>
> • Feed per URL oder einfach per Website-Adresse hinzufügen; der Feed wird automatisch gefunden
> • Unterstützt RSS 2.0, RSS 1.0 und Atom
> • Intelligente Listen für Ungelesen, Alle und Markiert
> • Gelesen/ungelesen und Markierungen, Badges für ungelesene Artikel, alle als gelesen markieren
> • Aktualisiert beim Start und alle 30 Minuten, effizient mit bedingten Anfragen
> • Abos als OPML importieren und exportieren
> • Artikel werden ohne JavaScript angezeigt; Links öffnen im Browser
> • iPhone und iPad: Ziehen zum Aktualisieren, Wischen zum Markieren, Teilen
> • Mac: Drei-Spalten-Ansicht und Tastaturkürzel für alles
>
> Deine Abos und Artikel bleiben auf deinem Gerät. Feedlet hat keinen Server und sammelt keine Daten.

**Keywords:**
`rss,atom,feed,reader,news,nachrichten,opml,blog,abonnieren,schlagzeilen,privat,aggregator`

**Neuerungen (1.0):** `Erste Version.`

## Hinweise für das App Review

> Feedlet is a feed reader. Users add any RSS or Atom feed URL. No account or login is required.
>
> NSAllowsArbitraryLoads: users subscribe to arbitrary feeds chosen by themselves, and many feeds and
> the images they reference are still served over plain HTTP only. The app cannot know these domains
> in advance, so per-domain exceptions are not possible. Article HTML is rendered with JavaScript
> disabled.
>
> To test, add e.g. https://www.apple.com/newsroom/rss-feed.rss

Kontakt für das Review (Name, Telefon, E-Mail) wird direkt in App Store Connect eingetragen.

## Screenshots

| Gerät | Größe (Pixel) | Anzahl |
|---|---|---|
| iPhone 6,9″ | 1320 × 2868 (Hochformat) | 3–10 |
| iPad 13″ | 2064 × 2752 (Hochformat) | 3–10 |
| Mac | 2880 × 1800 (oder 2560 × 1600, 1440 × 900, 1280 × 800) | 1–10 |

Vorschlag: Artikelliste, Artikelansicht, Feed hinzufügen, Seitenleiste mit Ungelesen-Badges.
