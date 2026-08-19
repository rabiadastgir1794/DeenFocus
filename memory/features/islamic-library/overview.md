# Feature: Islamic Library (Learning Hub)

## Goal

Expand the current **Learning Hub** into a complete **Islamic Library** while
keeping the existing clean, minimal design. The home screen should remain
simple; the premium experience should be inside each module.

**Status:** Feature-complete for v1 modules (hub + 10 modules). **Quran** keeps
its existing reader. All other modules use **searchable list → detail** (nested
modules: category list → item list → detail). Swipeable card pager removed for
non-Quran content. Bookmarks/progress/deep-open still index-based. Hub UI
strings localized for all app languages; bundled educational JSON still English.

---

## Home Screen

Keep the current card-based layout.

Modules:

* Quran *(navigate to existing Quran module only — do not build another Quran reader)*
* Hadith
* Duas & Adhkar
* Prayer & Islamic Methods
* 99 Names of Allah
* Fiqh & Traditions *(Sunni madhabs, Shia, Deobandi, Barelvi, Salafi — educational overview)*
* Pillars of Islam
* Pillars of Iman
* Prophets
* Islamic Occasions

Each card should have:

* Beautiful icon/illustration
* Title
* Short subtitle
* Chevron
* Consistent spacing with current design

---

## Quran

Do **not** create a new Quran feature.

Simply navigate to the existing Quran module while preserving all current
functionality (Surah / Juz / Page, reading settings, translations, audio,
Tajweed, bookmarks).

---

## Hadith

Collections:

* Sahih Bukhari
* Sahih Muslim
* Riyad us Saliheen
* 40 Hadith Nawawi
* Hisnul Muslim

Each collection opens a searchable item list; tap an item for a detail page.

Each detail includes:

* Arabic (if available)
* Translation
* Narrator
* Source
* Bookmark
* Share
* Copy

---

## Duas & Adhkar

Categories:

* Morning
* Evening
* Daily Life
* Sleep
* Food
* Travel
* Illness
* Protection
* Forgiveness
* Parents

Each Dua card:

* Arabic
* Transliteration
* Translation
* Reference
* Bookmark
* Share

---

## Prayer & Islamic Methods

Include guides for:

* Wudu
* Salah
* Ghusl
* Tayammum
* Janazah Prayer
* Umrah
* Hajj
* Fasting
* Zakat
* Tawbah

Each guide opens a searchable step list; tap a step for a detail page with:

* Step title
* Description
* Step X of Y in the app bar

---

## 99 Names of Allah

Searchable list of all 99 names → detail page.

Each detail contains (existing JSON fields only):

* Arabic
* Transliteration
* Meaning
* Short explanation
* Reflection (optional)

Benefits / when-to-recite / references can be added later with verified content.

---

## Pillars of Islam

Include:

* Shahadah
* Salah
* Zakat
* Sawm
* Hajj

Searchable list → detail page per pillar.

---

## Pillars of Iman

Include:

* Allah
* Angels
* Books
* Messengers
* Last Day
* Divine Decree (Qadr)

Searchable list → detail page per pillar.

---

## Prophets

Single focus: **Prophet Muhammad ﷺ** only (not all 25 prophets — keeps data
manageable). Symbolic icon only — no facial depictions.

Each card: story chapter, key lesson, Quran reference.

---

## Islamic Occasions

Include:

* Ramadan
* Eid al-Fitr
* Eid al-Adha
* Hajj
* Ashura
* Laylatul Qadr
* Friday (Jumu'ah)

Each occasion should explain:

* Importance
* Virtues
* Recommended acts

---

## Shared list → detail experience

Non-Quran modules reuse the same navigation shell:

* `LearningSearchableList` — in-module search + item count
* `LearningItemTile` — list row (`HomeActionContainer` language)
* `LearningDetailScaffold` / `LearningItemDetailScreen` — detail chrome
* Existing content cards (`HadithCard`, `DuaCard`, `_NameDetailBody`, etc.) on detail
* `LearningCardActions` — bookmark / copy / share (uses `libraryCopy` /
  `libraryShare` / snackbar keys — not the untranslated `quran*` fallbacks)
* Detail section labels: Translation, Transliteration, Meaning, Narrator,
  Source, Fiqh/Occasion headers — via `AppLocalizations` in all app languages
* Educational JSON body (titles, hadith text, explanations) remains English
* Progress: last opened index via `LibraryProgressService`
* Bookmarks open the list, then auto-push the bookmarked detail

---

## Search

* **Per-module search** is live on each item list.
* **Unified library-wide search** is still future work (Hadith, Duas, Names, etc.
  in one box). Quran keeps its own existing search.

---

## UI

* Maintain the current minimal Learning Hub design.
* Do **not** overcrowd the home screen.
* Use premium illustrations and subtle Islamic patterns throughout the detail pages.
* Keep typography clean and readable.
* Use the existing DeenFocus theme and colors.
* Reuse components wherever possible to keep the implementation maintainable.

**Important:** This module is primarily educational. Prioritize a calm, premium
reading experience with reusable components and smooth interactions rather than
adding unnecessary complexity.

---

## Architecture (when implementing)

Follow existing DeenFocus MVVM:

```
lib/features/islamic_library/
  model/
  view/          # hub, category lists, item lists, detail screens
  data/          # local JSON + repositories + progress/bookmarks
  widgets/       # list/detail shell, content cards, actions
  helpers/       # bookmark opener, list controller mixin
```

Hard constraints:

1. **Quran** = deep-link / navigate into `lib/features/quran/` only.
2. **Prophets** = symbolic art only — no facial depictions.
3. Hub home stays a simple card list; richness lives in module lists + detail.
4. Content licensing must be cleared before shipping each collection (Hadith /
   dua sources especially).
5. Do not invent Islamic content (benefits, citations) without verified sources.

## Next

Confirm open decisions, then start slice 1–3.
