#!/usr/bin/env python3
"""Writes an invented sample library (library.json) for the App Store screenshots to stdout.

All feeds and articles are fictional, so no third-party content appears in the store images.
Dates are relative to now, encoded like Swift's default JSONEncoder (seconds since 2001-01-01).
"""
import json
import time
import uuid

REFERENCE = 978307200  # 2001-01-01 in Unix time
NOW = time.time() - REFERENCE

FEEDS = [
    ("Brightwater Journal", "brightwater", [
        ("A quiet morning on the lake", "Mist over the water, a heron at the reeds and the first light on the hills: notes from a dawn paddle.", 0.6),
        ("Five easy hikes for late autumn", "Short trails with big views, all under three hours, with tips on what to pack when the days get shorter.", 20),
        ("Why we leave the leaves", "Fallen leaves shelter insects, feed the soil and save you an afternoon of raking. Here is how to use them.", 50),
    ]),
    ("Code & Coffee", "codeandcoffee", [
        ("Small apps, big focus", "Why a tool that does one thing well often beats a platform that does everything. A look at building calm software.", 1.5),
        ("Writing tests from the specification", "Use cases make great test oracles. A practical walk-through from scenario to passing test.", 9),
        ("The joy of plain files", "JSON on disk, no server, no sync service: when the simplest storage is exactly right.", 30),
        ("Keyboard shortcuts everyone should know", "Ten shortcuts that make reading and writing on the Mac noticeably faster.", 70),
    ]),
    ("Field Notes Kitchen", "fieldnotes", [
        ("One-pot pumpkin risotto", "Creamy, golden and ready in 35 minutes. The trick is toasting the rice in brown butter first.", 3),
        ("Sourdough for beginners", "A forgiving schedule for busy weeks, from starter to first loaf, with photos of every step.", 26),
        ("Winter spice syrup", "A jar of cinnamon, clove and orange syrup turns tea, porridge and pancakes into something special.", 80),
    ]),
    ("Northern Lights Photo", "northernlights", [
        ("Chasing the aurora", "How to read the forecast, pick a dark spot and set up your camera for the night sky.", 5),
        ("Golden hour in the old town", "Warm light, long shadows and empty streets: a photo walk just before sunset.", 40),
    ]),
    ("The Indie Maker", "indiemaker", [
        ("Shipping version 1.0", "What we cut, what we kept and why launching small was the best decision we made this year.", 7),
        ("Pricing a small product", "Free, paid or somewhere in between? Lessons from three launches and a lot of spreadsheets.", 33),
        ("A weekly review that sticks", "Fifteen minutes on Friday to close loops, plan the week and actually take the weekend off.", 60),
    ]),
    ("Urban Garden Diary", "urbangarden", [
        ("Balcony herbs that survive winter", "Thyme, sage and chives can keep going through the cold months. Here is how to help them.", 12),
        ("Composting in a small flat", "A tidy, odour-free setup that fits under the sink and turns scraps into soil.", 45),
    ]),
]

READ_AFTER_HOURS = 24   # older articles are mostly read
STARRED = {"Writing tests from the specification", "Sourdough for beginners", "Chasing the aurora"}


BODIES = {
    "A quiet morning on the lake": [
        "We put the canoe in just after six. The lake was perfectly still, and a thin layer of mist "
        "hung over the water, so thick in places that the far shore disappeared completely.",
        "Halfway across, a grey heron stood motionless in the reeds, watching us drift past. Only "
        "when the paddle touched the water did it lift off, slow and unhurried, towards the bay.",
        "By seven the sun reached the top of the hills. The mist turned gold, then thinned and was "
        "gone, and the first fishing boats started their engines on the other side of the lake.",
        "If you go: arrive before sunrise, dress warmly and bring a flask of tea. The best light "
        "lasts about forty minutes, and it is worth every one of them.",
    ],
}


def paragraphs(snippet: str, title: str) -> str:
    body = BODIES.get(title) or [
        snippet,
        "The full article continues with practical tips, a few photos and a short list of further "
        "reading for anyone who wants to go deeper.",
    ]
    return "".join(f"<p>{p}</p>" for p in body)


def main() -> None:
    feeds, articles = [], []
    for title, slug, items in FEEDS:
        feed_id = str(uuid.uuid5(uuid.NAMESPACE_URL, slug)).upper()
        feeds.append({
            "id": feed_id,
            "title": title,
            "url": f"https://{slug}.example/feed.xml",
        })
        for index, (headline, snippet, hours_ago) in enumerate(items):
            published = NOW - hours_ago * 3600
            articles.append({
                "id": f"{slug}-{index}",
                "feedID": feed_id,
                "title": headline,
                "link": f"https://{slug}.example/posts/{index}",
                "author": None,
                "contentHTML": paragraphs(snippet, headline),
                "snippet": snippet,
                "published": published,
                "fetched": published,
                "isRead": hours_ago > READ_AFTER_HOURS and headline not in STARRED,
                "isStarred": headline in STARRED,
            })
    feeds.sort(key=lambda f: f["title"].lower())
    json.dump({"feeds": feeds, "articles": articles}, __import__("sys").stdout, indent=1)


if __name__ == "__main__":
    main()
