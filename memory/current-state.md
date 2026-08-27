# Current State
> Source of truth for recovery. Last updated: 2026-08-27 — Lock Screen Style picker, persistence, styled reminder.
> Branch: `feature/lock-screen-style`.

## Status: Lock Screen Style (2026-08-27)
Focus (below Child Mode) and Settings (below Live Activity, above Dark Mode)
open the same picker (`LockScreenOptionsPopup` → `LockScreenOptionsScreen`).
One style is always selected: first launch persists Prayer reminder
(`LockScreenStyle.classic`) via `LockScreenStylePreference.ensureSelected`.
Tapping the selected card does not deselect. Classic is free; other styles
go through existing `PremiumGate` / Superwall and are not saved until
access is granted. Preview icon opens the full-screen experience without
Superwall. Choice is stored in `StorageService.lockScreenStyle`.

The in-app “Did you pray?” reminder is a centered `AlertDialog`
(`PrayerReminderPopup` / `showDialog`). Inner content is the selected style
(tasbih, verse, quiz, countdown, hold, type, minimal); unpaid/invalid
falls back to Classic. Yes / Later / hold / type / tasbih-complete return
`true`/`false`/`null` so Home can mark via `_confirmReminderPrayerOnTime`.
Prayer labels come from the current `TrackablePrayer`, not hardcoded Asr.
`HomeTabViewModel` is provided at `DashboardScreen`. Copy is localized in
all `app_*.arb` locales. Tests: `test/lock_screen_options_popup_test.dart`.

## Status: Shared header title centering (2026-08-27)
Screens that already use `AppCenteredNavHeader` (same pattern as My Insights)
keep that shared widget. Title and subtitle are center-aligned in equal side
slots so they stay centered with or without a trailing action, and long
localized copy wraps in the middle instead of clipping into the back control.
`CustomAppBar` screens are unchanged. Branch:
`feature/localize-reading-screens`.

## Status: Insights & Achievements localization (2026-08-27)
My Insights and Achievements are fully localized (all `app_*.arb` locales),
including leftover English chart copy, achievement titles, and 15 level names.
Weekly graph day labels share one-line FittedBox sizing so Wednesday matches
the other days. Header titles stay centered via equal side slots on
`AppCenteredNavHeader`. Branch: `feature/localize-reading-screens`.

## Status: Calendar-style header (Calculation Method) (2026-08-25)
Settings Calculation Method uses `AppCenteredNavHeader` like Calendar (Back
on the left, title centered). List content is unchanged.

## Status: Calendar-style headers (Asr / Tasbih / About / Location) (2026-08-25)
Asr Calculation, Tasbih detail, About Deen Focus, and Settings Location now
use `AppCenteredNavHeader` (same back control and centered title as Calendar).
Tasbih keeps reset and overflow actions in the header trailing slot, with
loop count as the subtitle.

## Status: Learn module Calendar-style headers (2026-08-25)
Prayer & Islamic Methods (plus guide readers), 99 Names of Allah, Fiqh &
Traditions, Pillars of Islam/Iman, Prophet Muhammad, and Islamic Occasions
now use `AppCenteredNavHeader` like Calendar/Hadith/Duas.

## Status: Hadith Calendar-style headers (2026-08-25)
Hadith collections and collection readers now use `AppCenteredNavHeader`.
Subtitle in that shared header is 11px and wraps fully (no ellipsis) so copy
like “Collections from authentic sources” is not clipped. Calendar title-only
layout is unchanged.

## Status: Calendar-style headers (2026-08-25)
Quran, Surah, Reading Settings, Quran Bookmarks, Duas categories/list,
Tajweed practice, and learning detail screens now use `AppCenteredNavHeader`
(same back control, centered title, padding, and min height as Calendar).
Optional subtitle stacks under the title and wraps fully so long copy is
not clipped. Title stays at most 2 lines. Header copy uses l10n, including
`quranSurahHeaderSubtitle` and `tajweedPracticeAyahTitle`. Branch:
`feature/localize-reading-screens`.

## Status: Reading Settings / widgets onboarding localization (2026-08-25)
Reading Settings and the onboarding Widgets/Live Activities page already used
`AppLocalizations` keys, but most locales still fell back to English (Chinese
title vs English labels). Filled translations in all `lib/l10n/app_*.arb`
files (ar, az, de, es, fr, hi, it, nl, pt, ro, ru, zh). Preview ayah 1:1 now
loads from the selected translation pack, with
`readingSettingsTajweedFreePreviewTranslation` as fallback. Translation picker
download error and size label are localized. Branch:
`feature/localize-reading-screens`. Script:
`tool/l10n_reading_settings_onboarding.py`.

## Status: Android Settings download dead-tap (2026-08-25)
Tapping download on **AI Quran Tajweed** (lock visible) did nothing on Android
while iOS worked. Two causes:

1. **PremiumGate `feature()`** only called `onAccess` when Superwall reported
   `isActive`. Superwall invokes `feature()` when the gated code should run
   (subscribed, purchase, holdout, or paywall skipped). Android often hit the
   skip path without `isActive` → silent return, no download. Fixed: always
   `grantAccess()` / `onAccess()` from `feature()` in `premium_gate.dart` and
   `requireActiveSubscriptionOrPresentPaywall`.
2. **Settings used `ensurePrepared`** (ensure + warm-load). After a ~450MB ONNX
   download, Android prepare can fail/OOM and UI snapped back to the download
   icon with no error. Settings now calls **`TajweedService.ensureModel()` only**;
   practice still prepares. Failures show a SnackBar.

Also: Android `AssetDownloadManager` free-space probe prefers an existing
ancestor dir (non-existent staging parent can make `usableSpace` return 0).

## Status: Learning hub search (2026-08-25)
Islamic Library (Learn tab) hub has a **Search Learning…** field that filters
module sections and deep-searches Hadith, duas, Names of Allah, pillars,
prayer guides, fiqh, prophets, and occasions — tapping a hit opens the matching
screen / item.

## Status: AI Tajweed download UI (2026-08-25)
Surah/Juz mic always visible. Practice / mic tap: non-subscriber → paywall;
subscriber → existing Tajweed practice screen (shows model download UI if pack
missing — does **not** redirect to Reading Settings). Settings row label is
**AI Quran Tajweed** (download icon / circular progress / green check). Settings
always shows **See how it works** (free Bismillah preview). Surah reading shows
a single **see how AI Quran Tajweed works** link under the app bar / before the
surah header card (not on each ayah). **Delete AI model** appears in Reading
Settings when the pack is installed (confirm dialog → native wipe). Free
preview (**See how it works**) shows the subscription paywall on **Done** only;
normal subscribed ayah practice does not. Quran home **Tajweed drill**: paywall
if not subscribed; Al-Fatihah 1:1 if never practiced; else last practiced ayah
(no “enable in Settings” snackbar). Download continues in-process via
`TajweedModelSession`. `TajweedService.isAvailable` no longer requires the
enable flag.

## Status: Arabic script across Surah/Juz/Page/Tajweed (2026-08-25)
Reading Settings Script now updates preview font+text; returning to readers
reloads font via `QuranDisplayPrefs` and re-fetches ayahs so Uthmani/IndoPak
orthography applies on Surah, Juz, Mushaf page, and full page. Tajweed opens
with the same script corpus + resolved Arabic font (incl. fallbacks). Guards
that skipped reload while “loading” were loosened so settings return always
refreshes.

## Status: Reading Settings Arabic script (2026-08-25)
Changing Script (Uthmani / IndoPak) only saved the preference — preview kept
the old font and a hardcoded Bismillah, so the style looked unchanged. Fix:
script change now switches to the matching default font (and persists it),
reloads preview ayah 1:1 from `assets/quran/text/<script>.json`, and Segmented
Button ignores empty selection. Files: `reading_settings_screen.dart`,
`quran_arabic_font.dart`.

## Status: Android Digital Balance usage 0m fix (2026-08-25)
Root cause: native `queryUsageStats(INTERVAL_DAILY)` over a multi-day range
bucketed days via `UsageStats.firstTimeStamp`, which on many devices stamps
the query range start — so **today** stayed 0m; that API also lags recent
foreground time. Fix: aggregate `UsageEvents` (`MOVE_TO_FOREGROUND` /
`MOVE_TO_BACKGROUND`) by local calendar day (split at midnight), with a
per-day `INTERVAL_DAILY` fallback that uses the known day key. Refresh on
Digital Balance open + existing resume path. Files:
`AppUsageChannelHandler.kt`, `home_digital_balance_screen.dart`,
`home_insights_screen.dart`, `app_usage_service.dart` comment.

## Status: Debug StoreKit prices updated (2026-08-25)
`Runner` scheme StoreKit config `ios/Runner/Products.storekit` had stale
premium prices ($4.99 / $39.99). Updated to $3.99 monthly / $9.99 yearly for
`com.rnr.deenfocus.premium.monthly` and `.yearly`. Product IDs unchanged.
App Store Connect / Superwall / Liquid untouched. Temporary `[SUPERWALL PRICE
DEBUG]` diagnostics removed after investigation.

## Status: Tajweed enable sync on Surah/Juz (2026-08-25)
Returning from Reading Settings now reloads `tajweedEnabled` in Surah and Juz
readers (`_reloadDisplayPrefs`), so “Recite & check tajweed” / mic appear
immediately without going back to the Quran tab. Legend row is gated on the
same flag.

## Status: Tajweed AI model download l10n + background (2026-08-25)
AI model prepare screen (`TajweedDownloadView`) and practice app bar title are
localized (`tajweedDownload*` / `tajweedPracticeTitle` / error keys). Download
already continues after leaving the screen via process-wide
`TajweedModelSession._inFlight` (native `ensureModel` is not cancelled on
dispose; staging resumes if interrupted). UI hint:
`tajweedDownloadCanLeave`. Not a true OS background URLSession/WorkManager
transfer — app process must stay alive.

## Status: Last-ayah recitation bar (2026-08-25)
Playlist end keeps the bar on the **last ayah** (no jump to previous). UI shows
**play** not pause (`_playbackCompleted` + pause player). `currentIndexStream`
ignored while starting/completed so `stop()` cannot re-highlight an earlier
ayah. Retap/play does stop→seek→play for a fresh start of that ayah.

## Status: Onboarding Widgets + Live Activities (2026-08-25)
New onboarding step (index 2) after **Everything in One App**: **Your prayers,
always within reach** — Widgets + Live Activities sections with phone mockups,
trust banner, Continue via shared flow chrome. 11 total onboarding steps;
`OnboardingViewModel.widgetsLiveStepIndex = 2`; later step indices shifted +1.
Widget asset re-cropped from original screenshot with inset rounded mask (293×286,
transparent corners) to remove dark navy shadow fringe at bottom edges; phone
preview wraps asset in `ClipRRect`.

## Status: Cycle Mode streak preservation (2026-08-25)
Same-day Cycle Mode enable no longer drops Day Streak to 0 (or shrinks Prayer
Streak). Root cause: paused cycle days were skipped entirely in
`DayStreakCalculator`; `PrayerStreakCalculator` skipped today when an older
non-paused tip existed. Fix: when Cycle Mode **starts today** (yesterday not
paused), a fully completed today still counts for day streak; today's counting
prayer marks still count for prayer streak. Mid-cycle paused days still bridge
without inflating streaks. Tests: `cycle_mode_streak_regression_test.dart`,
`prayer_streak_rules_test.dart`, `cycle_mode_lifecycle_test.dart`.

## Status: AI Tajweed default off + free preview (2026-08-24)
`StorageService.tajweedEnabled` defaults to **false** (paid feature). Reading
Settings toggle initial state matches. **See how it works** (underlined) opens
free Al-Fatihah 1:1 (Bismillah) practice without subscription or enabling the
toggle (`TajweedFreePreview` + `freePreview` on `TajweedPracticeArgs`).

## Status: Focus score + checklist Optional label (2026-08-24)
Today's Focus Score is checklist completion % (prayers + habits) — 100 only
when everything is done. Category breakdown (Prayer/Quran/Dhikr/Distraction)
unchanged. Cycle Mode still treats prayers as complete for the score.
Removed the "Optional" label from Daily Checklist rows.

## Status: Home Live Activity promo (2026-08-24)
Home shows a **Live Prayer Updates** card under Today's Prayers until Live
Activity is enabled (or the user dismisses via X). Tap enables Live Activity
directly via `PrayerLiveActivityToggle` (same path as Settings), then shows
a success prompt explaining Lock Screen / Dynamic Island (iOS) or ongoing
notification (Android). Notification permission is only requested if not
already granted.

## Status: Premium Tajweed + translations (2026-08-24)
AI Tajweed Practice (Reading Settings toggle + practice entry) and non-English
Quran translation packs are gated via `PremiumGate` / Superwall paywall.
English translation (`en`) stays free. Subscribed users skip the verifying
loader: disk/session cache checked first; warm taps skip the overlay when
Superwall is already configured. Non-subscribers dismiss the loader before
`registerPlacement` (no 1s minimum hold) so the paywall shows ASAP.
`PremiumGate.presentIfNeeded` also re-hydrates `loadCachedState` on each gate.

## Status: Prayer Alarms settings sync (2026-08-24)
Prayer Alarms settings page no longer shows Snooze Duration (snooze still
used by the full-screen alarm UI via StorageService defaults). Soft
notification and native alarm flags are independent again in
`PrayerSettingsService` (shared Home ↔ Settings source of truth). Alarm
toggles show OFF unless master + permission allow scheduling
(`PrayerAlarmEnablement`). Enabling an alarm from Home or Settings runs
the same permission gate and turns on the master schedule flag; denial
keeps the toggle OFF with the existing permission dialog. Sound /
notification / alarm prefs stay on one JSON blob — no second settings
system.

## Status: Donation purchases (2026-08-24)
Support DeenFocus one-time amounts buy Superwall store consumables
(`com.deenfocus.donation.{10,25,50,100,250}`) through Superwall's direct
purchase API. Android: `android/app/build.gradle.kts` merges repo-root
`dart_defines.json` into Flutter `dart-defines` so
`SUPERWALL_API_KEY_ANDROID` reaches `String.fromEnvironment` even when the
Flutter CLI only passes FLUTTER_* defines (Android Studio / bare
`flutter build apk`). iOS still uses `tool/apply_dart_defines.sh`. Donations
wait for `AppSuperwall.configure` and log keyPresent/keyLength/define name
only. Existing monthly/yearly Superwall subscription placements are unchanged.

## Status: Android startup (2026-08-22)
Second FlutterEngine / `audio_service` Activity error is fixed
(`AudioServiceActivity`). Follow-up: splash still waits 2200ms. Superwall, DailyRefresh/alarms,
and FocusController wait until **Home's first painted frame**, not
`context.go()` — starting them at handoff starved `HomeRouteGate.loadLibrary`.
Gate now logs loadLibrary begin/end and first Dashboard frame.
Detail: `memory/features/android-startup-audio-service-2026-08-22.md`.

## Status: Digital Balance (2026-08-22)
My Insights has a compact **Digital Balance** card after Focus/Prayers and
before My Progress. Tapping it opens `HomeDigitalBalanceScreen` (same
Navigator stack as Achievements/Calendar — Insights itself is not a
go_router route).

UI reads a normalized snapshot from `DigitalBalanceViewModel` →
`AppUsageService` (`com.app.deenly.deenly/app_usage`). **Android** uses
UsageStatsManager when usage access is granted (already in the manifest)
and still shows the Insights card + detail screen. **iOS** hides the card
and does not open Digital Balance — Apple still cannot export per-app
durations on iPhoneOS 26.2. The unused iOS Family Controls bridge,
`AppUsageService`, and ViewModel stay in the tree for a later SDK. Daily
Deen time goal (15/30/45/60/custom minutes) is isolated in
`StorageService`, default 1h.

Insight copy is generated from real totals only (today / vs yesterday /
vs last week). Week-over-week % is hidden when last week is zero.

## Status: Daily Checklist (2026-08-20)
The Home Daily Checklist still uses `DailyChecklistItem` + `DailyChecklistState`
JSON (name-based, additive). New habits are `istighfar`, `salawat`, and
`controlAngerSpeakKindly`. Existing ticks are kept; new rows start unchecked.

The five obligatory prayers are **not** a second tracker. The sheet reads
`statusForToday` / `markPrayerStatus` (same as Home prayer cards). Legacy
`DailyChecklistItem.fajr` stays in the enum for old saves and is mirrored when
Fajr is marked, but it is not shown as its own row. Tahajjud remains a
checklist habit marked **Optional**.

Progress ring = 5 salah + stored habits (excluding mirrored Fajr). Section
heading is Personal discipline. Optional rows (Tahajjud, good deeds, personal
discipline) show a muted trailing Optional label.

## Status: Achievements page (2026-08-20)
My Insights no longer embeds the 2-column achievements grid. The My Progress card has a header icon + title, then two columns split by a
vertical divider: **Level/XP** (badge, name, in-level `n / span` bar) on the
left, a tappable **Achievements** column (trophy, unlocked count, chevron) on
the right that opens `HomeAchievementsScreen` (dark green level hero,
unlocked count, Completed / In Progress lists, and a Keep going footer).
Insights is one screen: streak summary (4 columns + dividers, labels, chips),
weekly chart + prayer rate, focus/prayers, then My Progress — no second
streak row or cycle footer. Empty week bars are grey; filled bars are green;
Cycle days stay pink. Streak `↑` chips only appear when today actually grew
the streak. Cycle protected days is the count of protected calendar days
(not days remaining). XP `n / span` matches the in-level bar, including after
Level 1.

## Status: App typography (2026-08-20)
Readable type scale lives in `lib/core/theme/app_text_theme.dart` and is
applied by light/dark themes. Body/label/titleSmall are +1–2pt with slightly
stronger weight; display/headline/hero numbers stay at Material 2021 sizes.
Home, Focus, Tasbih, Quran chrome, and bottom nav no longer shrink those
roles back to 10–11px. Quran Arabic faces (`UthmanicHafs` / `NooreHuda`) and
large counters are unchanged. TextTheme still respects Dynamic Type;
ScreenUtil `.sp` chrome was bumped only on small UI labels.

## Status: Azan audio (2026-08-20)
Prayer Adhan sound is the new clip from `~/Desktop/azan1.mp3`. Android
`res/raw/azan.mp3` is the full ~2:13 file. iOS `Runner/azan.caf` is the first
28s as CAF/IMA4 so notification/AlarmKit sounds stay under Apple’s 30s limit.
Beep is `~/Downloads/beep1.mp3` (~3s) as `res/raw/beep.mp3` and `Runner/beep.caf`.
Needs a **full rebuild** (not hot reload) to pick up native resources.

## Status: Quran lock-screen Now Playing (2026-08-20)
Debug iOS builds use `TimedPluginRegistrant`, which had not registered
`audio_service` (or `sqflite`) after those pods were added — Lock Screen /
Control Center stayed empty while recitation still played. Registrant is
synced with `GeneratedPluginRegistrant`, AppDelegate calls
`beginReceivingRemoteControlEvents()`, and the handler no longer reports
`idle` between ayahs (that was clearing Now Playing). Now Playing artwork is
the bundled `assets/app_icon.png` (copied to a temp file for
`MPMediaItemArtwork`). Calls / Siri / alarms pause via `just_audio`'s
interruption handling and resume only when iOS sets `shouldResume`; headphone
unplug pauses and stays paused. Needs a **full iOS rebuild** for native
plugin changes; artwork can hot-restart.

## Status: Live Activity settings card (2026-08-20)
Enable Live Activity is its own Settings card (icon + subtitle + switch),
matching Dark Mode chrome — not inside Prayer Calculation. Order: Premium →
profile → Prayer Calculation → Live Activity → Dark Mode → About → App Demo.

## Status: Tajweed App Demo walkthrough (2026-08-20)
Tajweed is the first card in App Demo **home features** (before Widgets and
Live Activity). Interactive walkthrough: Quran drill (arrows on Tajweed drill
and the surah list) → surah (arrow on Recite & check tajweed) → model prep
(arrow on Continue) → mic (full-length arrow above the circle) → word review
(arrow on Done). Walkthrough app bars reserve Skip space so it does not sit
on a settings icon. Callouts and on-screen strings are localized.

## Status: Focus Mode home card names + lock (2026-08-20)
Home Focus Mode subtitle lists enabled short names as a full sentence, e.g.
**Salah and Night Modes are enabled** (localized in every arb). A lock button
appears on the card when any mode is on
(`onPrimary` chip, same as the shield). Tap unlocks / relocks when apps are
locked; otherwise it opens the Focus tab. Dark-mode text still uses
`colorScheme.onPrimary`.

## Status: Focus Mode home card + locked apps (2026-08-20)
Home Focus Mode card uses `colorScheme.onPrimary` (readable in dark mode on the
light mint primary). Subtitle follows enabled modes: default Salah copy, one
mode name via `focusHomeModeEnabled`, or **Multiple modes enabled**. Selected
apps show a lock badge + error-container chip when `isAppsLocked`.

## Status: Onboarding App Lock demo intro (2026-08-20)
"See how App Lock works" no longer shows the top-left back chevron. Skip,
title, Start the demo, and page dots stay. Settings / feature-demo still use
the calendar-style Back + title header (`showCenteredNavHeader`).

## Status: Onboarding subscription CTA (2026-08-20)
Shield divider + "No commitment. Cancel anytime." is back. Feature card uses
remaining space (`Expanded` + scale-down) so it no longer overflows. Trial pill,
Start Trial, and Maybe later stay visible above the page dots.

## Status: Onboarding sect selected state (2026-08-20)
Choose Your Sect selected option uses light green (`primaryContainer`) with dark
green text instead of solid primary fill. Continue stays the filled green CTA.

## Status: Onboarding subscription CTA (2026-08-20)
Invest in Deen no longer shows "Join 10,000+". The trial cluster matches the
mock: free-trial pill, shield divider, "No commitment. Cancel anytime.", filled
**Start My 7-Day Free Trial** pill, then the compact text link **Maybe later —
explore the app first** (outlined second pill was clipping off-screen). Footer
on this step is dots only.

## Status: Onboarding select apps layout (2026-08-20)
Select Apps to Lock now follows the mock stack: lock icon, title, subtitle, app
card (icon + name + trailing square checkbox), privacy banner, Select Apps,
Skip for Now with dividers, then outlined Maybe Later. Footer on this step is
dots only so the actions sit together instead of leaving a gap.

## Status: Onboarding select apps icons (2026-08-20)
Select Apps to Lock mock list now shows Instagram, TikTok, and YouTube brand
icons (with All Apps, Safari, and Podcasts unchanged). Footer Continue on this
step is the same outlined **Maybe Later** pill as Screen Time.

## Status: Onboarding screen time icons (2026-08-20)
Enable Screen Time app-list preview uses brand-style Instagram, TikTok, YouTube,
and Games icons. Footer Continue on this step is an outlined **Maybe Later** pill.
Allow Screen Time, privacy note, and the rest of the step are unchanged.

## Status: Onboarding notifications lock-screen (2026-08-20)
Never Miss a Prayer now matches the lock-screen mock: black iPhone bezel, green/tan
wallpaper, white iOS banners (crescent / heart / flame), and two pill CTAs —
filled **Enable Notifications** plus outlined **Maybe Later**. The flow Continue
button is hidden on this step until permission is granted. Preview copy shortened
to match the mock (e.g. "It's time to pray.", "Daily Dhikr", "2m ago").

## Status: Onboarding location actions (2026-08-20)
Find Your Qibla browse actions now match the filled + "or" + outlined layout:
Allow Location Access, an "or" divider, then outlined **Enter your city manually**
with a city icon. Search-field placeholder stays "Type your city name..".
Dial is ~176pt with standard sm/md/lg gaps so Enter city still fits without
scrolling. Feature chips and disabled Continue use light green instead of beige.

## Status: Live Activity stuck on Fajr (2026-08-20)
Lock-screen Live Activity kept showing "Next prayer Fajr" after Fajr because iOS
stored a frozen snapshot and never recomputed current/next salah in the background.
Android used inexact alarms, so the ongoing notification could also miss the
transition.

Fix:
- iOS widget resolves current/next from stored prayer times at render time
  (`TimelineView` at each salah + `staleDate` + background app-refresh).
- Payload always includes tomorrow's Fajr so Isha → Fajr overnight still works.
- Android schedules exact alarms at every remaining salah (and timezone/date
  changes), matching home-screen widgets.

**Verify:** Enable Live Activity before Fajr, leave the app, wait until Fajr
passes — lock screen should show **Now · Fajr** and the next salah (Dhuhr), not
"Next prayer Fajr".

## Status: Splash branding (2026-08-19)
Flutter splash now shows `assets/app_icon.png` (same mark as onboarding) with
scale/fade on the icon and delayed slide/fade on title + tagline. Native
launch screen unchanged. Splash hold is 2.2s so the sequence can finish.

## Status: Cold start freeze (2026-08-19)
Last run reached Home at ~30s (`GoRouter builder: HomeRouteGate` abs 30636ms).
Mitigations:
- Do not `MediaKit.ensureInitialized()` before `runApp` (video init is lazy).
- Do not await `LoggerService.initialize()` on the launch path.
- Superwall configure + silent English translation start *after* first frame.
- Splash no longer JIT-preloads Home+Onboarding together (froze the isolate).
- Home prayer times use bundled `PlusJakartaSans` (no Google Fonts HTTP).
- Daily verse / Quran Hive seed runs after prayer times have painted.
- Translation channel QoS is `.utility` (was `.userInitiated`).

## Status: iOS translation download priority inversion (2026-08-19)
Thread Performance Checker: User-initiated `QuranTranslationChannelHandler`
waited on `AssetDownloadManager`'s `.utility` hop (`semaphore.wait`). Silent
`en` pack install is the trigger. Download now runs on the caller thread;
`URLSessionAssetTransport` completions use a `userInitiated` queue instead of
`URLSession.shared`.

## Status: Merge feature/Quran into Phase2/HomeUI (2026-08-19)
Conflicts resolved; **merge commit not created yet**. Keep HomeUI product UI;
Quran adds Learn/tajweed/library/startup only.

**Settings (this session):** Removed the App Demo video card and the
`iOS CoreML override (Debug)` row. Interactive App Demo walkthrough row remains.
Android `kDebugMode` Tajweed Asset Debug row remains. `AppDemoVideoManager` is
no longer provided at app start.

## Status: Islamic Library UX (2026-08-08)
Hub module cards back to **colored Material icons** (WebP covers unwired).
**Completed** / mark-section actions removed from list + detail pages (bookmarks
and continue-from progress kept). Hub order after Quran: Hadith → Duas → Prayer →
**99 Names** → Fiqh → Pillars → Prophets → Occasions.

## Status: Islamic Library covers (2026-08-08)
Flat minimal WebP illustrations (~3–4 KB each, ~69 KB total) for **hub module
cards** and **Dua category lists** only. Generated via `tool/generate_library_covers.py`
into `assets/islamic_library/covers/`. Detail pages stay typography-focused
(`LearningDetailScaffold` — no header images). Widgets: `LibraryCoverAssets`,
`LibraryCoverThumb`, `LibraryCoverBanner`.

## Status: Islamic Library (2026-08-07)
All 10 hub modules live on the Learn tab. **Quran** unchanged. All other modules
use searchable **list → detail** (Hadith/Duas/Prayer: category → list → detail).
Swipeable `LearningCardPager` removed. Bookmarks/progress/deep-open kept
(index-based; bookmark opens list then auto-pushes detail). Shared widgets:
`LearningItemTile`, `LearningSearchableList`, `LearningDetailScaffold`,
`LearningItemDetailScreen`. Names detail reuses existing fields only (no
placeholder benefits/references). Unified **Saved learning items** screen still
on hub. Educational JSON body remains English.
See [`memory/features/islamic-library/overview.md`](features/islamic-library/overview.md).

## Status: Quran themes + Tajweed placement (2026-08-06)
- Reading themes differentiated again: Parchment (warm cream/gold), Emerald
  (green-tinted), Midnight (cool slate). Previews show bg + paper + primary bar.
- AI Tajweed Practice moved from App Settings → Reading Settings; **default on**.
  Hint copy points to Reading Settings. Android debug Asset Debug row can stay in Settings; iOS CoreML override row was removed 2026-08-19.

## Status: Quran theme + fonts (2026-08-06)
- Reader palette primaries use `AppColors.primary` / `primaryDark` on all color
  themes (no more off-brand `#3E7C3D`). Default reading theme is **emerald**.
- Reading Settings → **Arabic font**: Uthmanic Hafs, Noore Huda (bundled), or
  System/native (iOS Geeza Pro / Android Noto Naskh + fallbacks). Independent of
  script orthography.

## Status: Home performance (2026-08-06)
Audited Home tab jank (~0.5–1s hitch after navigate). Optimizations (UI/behavior
unchanged): Selector-scoped rebuilds, deferred Superwall/events/review after
first frame, parallel prefs + verse/prayer/streak load, cached qiblaInfo /
weekPrayerCounts, marquee TextPainter once + RepaintBoundary, prayer countdown
isolated to 1 Hz widget, pause minute ticker + countdown when tab inactive,
O(1) calendar event-day keys, daily verse via `getAyahsByKeys` + `getSurah`.


## Status: Mushaf chrome (2026-08-05)
Ornate double-border / diamond-corner frame removed. Mushaf page view again uses
soft paper `QuranMushafPageFrame` (thin accent border + shadow).
`quran_mushaf_ornament_frame.dart` deleted.

## Status: Page view layout prefs (2026-08-05)
Full-page and surah-scoped Mushaf page readers load `quranLayoutTheme`:
Color Quran word bands, Simple (no page frame / plain ayah marks), Mushaf soft
framed page. Reloads after Reading Settings return.

## Status: Quran layouts — Mushaf vs Simple (2026-08-05)
- **Mushaf** (was Classic): soft paper page frame, bordered ayah cards, soft surah header.
- **Simple**: flat list, no page chrome, light dividers.
- **Color Quran**: Mushaf chrome + per-word color bands.
- Settings preview reflects the selected layout.

## Status: Quran reading color themes (2026-08-05)
- **Themes:** Parchment (warm cream), Emerald (app primary/sand), Midnight (deep green).
- Each theme resolves light + dark palettes from app brightness.
- Picker in **Reading Settings → Reading theme**; applies to Surah/Juz/Mushaf
  readers, Continue Reading card, and settings preview.

## Status: Bookmark sync & reading progress (2026-08-05)
- **Bookmarks:** `QuranBookmarkService.revision` notifies listeners; bookmarks
  screen and Quran tab refresh when an ayah bookmark is removed from surah view.
- **Continue reading:** Surah screen flushes `ReadingEngine` before pop; first
  ayah recorded on open via `openSurah`; position persists immediately (no debounce).

## Status: Quran & Tajweed UI redesign (2026-08-05)
Surah detail, Tajweed recording, and scoring screens restyled to match new mocks
**without removing functionality**:

- **Surah view** (`surah_detail_bottom_sheet.dart`, `ayah_card.dart` `surahDetail`
  style): header card + tajweed legend chips, per-ayah cards with speaker/mic/
  bookmark actions, green “Recite & check tajweed” CTA; share button removed.
- **Tajweed recording** (`tajweed_recording_view.dart`, `tajweed_mic_button.dart`,
  `tajweed_waveform.dart`): large mic with pulse rings, animated waveform,
  tap mic to start/stop, listen-to-ayah on page, Cancel + Stop & analyse while
  recording; CoreML debug toggle preserved.
- **Scoring** (`tajweed_result_view.dart`): circular word-accuracy ring, feedback
  text, word-review tiles, stat rows, Try again / Done — same VM hooks.

Also in this branch: page progress grid, bookmarks, continue reading, full-page
mushaf reader, last listened / last Tajweed quick actions on Quran tab.

**Next:** Manual QA on simulator/device for all three flows.

## Status: Quran translation downloads (2026-08-03)
Arabic Quran stays bundled; translations download via native `AIAssetPlugin`
(`translation_pack`) + shared R2 `catalog.json`. **Catalog is source of truth**
(no hardcoded language map). Catalog cached 24h. Quran read uses disk only.
All languages kept on disk.

**UX:** Translation pick/download lives in **Reading Settings** (when Show
Translation is on) — not Settings → Language. App locale ≠ Quran translation.
UI: Current label, Installed group first, Available group with download size
from catalog `approxSizeBytes`, states Selected/Installed/Download/
Downloading/Installing. Instant switch for installed packs; download auto-
selects. Selection persists; missing pack falls back to English → Arabic.
`listAvailableTranslations` force-refreshes catalog (offline → disk cache)
so newly published languages appear without waiting 24h.

**Default English (silent):** Fresh install backgrounds `en` after `runApp`
(no dialog, no startup block). Reading Settings shows Installing → Installed.
Open Quran screens refresh via `installationRevision`. Offline retries on resume.
Detail:
[`memory/features/quran-reader/translation-downloads-2026-08-03.md`](features/quran-reader/translation-downloads-2026-08-03.md)

**R2 live:** translation packs in production `catalog.json` (10 languages):
- `en` Saheeh — `translations/en-saheeh/1.0.0/`
- `ur` Jalandhry — `translations/ur-jalandhry/1.0.0/`
- `es` Cortes — `translations/es-cortes/1.0.0/`
- `hi` Farooq Khan — `translations/hi-farooq/1.0.0/`
- `it` Piccardo — `translations/it-piccardo/1.0.0/`
- `nl` Leemhuis — `translations/nl-leemhuis/1.0.0/`
- `pt` El-Hayek — `translations/pt-elhayek/1.0.0/`
- `ro` Grigore — `translations/ro-grigore/1.0.0/`
- `ru` Kuliev — `translations/ru-kuliev/1.0.0/`
- `zh` Ma Jian — `translations/zh-majian/1.0.0/`
  Catalog-only publish (no app code). Convert via
  `tool/ai_assets/convert_tanzil_translation_txt.py`. Tajweed packs untouched.

## Status: Canonical lexical = production scorer (2026-08-03)
ADR-010 Canonical lexical is always used (Debug/Profile/Release). Settings
“Canonical lexical (M3 debug)” toggle removed. Native
`CanonicalLexicalAuthority.productionEnabled` always returns `true`. Official→DIY
CoreML failover unchanged; both engines use Canonical. Debug-only: CoreML
override, Asset Debug, practice Official↔DIY banner.

## Status: iOS Official → DIY CoreML session failover (2026-08-03)
**Production in all builds** (Debug/Profile/Release): prefer Official CoreML;
on load/init/inference failure silently activate DIY CoreML for the process
lifetime; retry Official next launch; errors only if both fail. Not ONNX.
Canonical lexical is always-on (not a Settings toggle). Detail:
[`memory/features/tajweed/ios-official-diy-session-failover-2026-08-03.md`](features/tajweed/ios-official-diy-session-failover-2026-08-03.md)
See also: [`memory/features/tajweed/canonical-lexical-production-always-on-2026-08-03.md`](features/tajweed/canonical-lexical-production-always-on-2026-08-03.md)

## Status: Official CoreML = production iOS default (2026-08-03)
Live R2 `catalog.json` now points iOS at `v1.2.0` Official HF multifunction
CoreML (~261 MB). DIY `v1.1.0` kept for rollback / Debug override. CoreML was
never removed — DIY was also CoreML; Official was Debug-only until this catalog
flip. Detail:
[`memory/features/tajweed/ios-official-coreml-production-default-2026-08-03.md`](features/tajweed/ios-official-coreml-production-default-2026-08-03.md)

## Status: CoreML production vs debug toggles (2026-08-03)
**Invariant:** Release must download/install/load/run iOS CoreML (Android ONNX)
via production `catalog.json` when AI Tajweed is enabled. `kDebugMode` /
`#if DEBUG` gate **only** developer UIs (Asset Debug, iOS CoreML catalog
override, practice-screen Official↔DIY banner). Canonical lexical is always on.
Do **not** wrap `ensureModel` / `prepareModel` / inference in debug checks.

## Status: Reading Settings live preview (2026-08-03)
Pinned Bismillah preview at top of Reading Settings updates live with Arabic
font size, translation size, line spacing, script, layout, and translation /
transliteration toggles.

## Status: Classic vs Simple Quran layout contrast (2026-08-03)
Classic: bordered soft cards, circle badge, light shadow. Simple: flat list,
muted number, hairline divider, no card fill/border. Color keeps card chrome
+ word bands. Change in `AyahCard`.

## Status: Tajweed practice overflow + listen repeat-off (2026-08-03)
Recording view: ayah card scrolls in `Expanded`/`SingleChildScrollView`; recite
controls stay pinned. Reference audio on complete: pause then seek to zero so
Repeat Off does not restart; loop mode reapplied after `setUrl`.

## Status: Tajweed listen-to-ayah controls (2026-08-03)
Reference audio pauses (keeps position) instead of disposing; tap again resumes.
On completion, icon returns to speaker and seek resets to start. Tune icon opens
the shared Quran audio settings sheet (speed / volume / repeat) on the practice
screen. Prefs persist via StorageService with Surah/Juz/Page readers.

## Status: Quran reading settings — unified launcher (2026-08-03)
Surah popup menu (English/Arabic + font size) removed. All Quran surfaces use
`ReadingSettingsScreen` via `QuranReadingSettingsLauncher` (tune icon): Quran tab,
Surah detail, Juz list, Juz reading, Mushaf page view. Reader screens reload
display prefs when returning from settings.

## Status: runApp → first frame ~31s — instrumenting (2026-08-02)
Native/Hive path healthy (~4.8s to runApp). Detailed `[STARTUP]` markers on
DeenlyApp, createAppRouter, providers, ScreenUtilInit, themes, MaterialApp.router,
GoRouter builders/redirect, NAV observer, SplashScreen. No optimizations.
Cold-launch and compare mark gaps / sync deltas in `StartupProbe.dumpSummary`.

## Status: Hive.initFlutter timeout — root cause (2026-08-02)
Not a Hive bug: `initFlutter` only awaits `path_provider.getApplicationDocumentsDirectory`.
Optimize pass raced Hive with `runApp` + concurrent Logger path_provider, wrapped
Hive in a **5s timeout**, then started Superwall after the skip — storage never
initialized. Restored Binding → MediaKit → Logger → Hive → runApp → background
services; removed Hive timeout; `[STARTUP]` marks restored; path_provider probed
before Hive. Detail:
[`memory/features/hive-initflutter-hang-root-cause-2026-08-02.md`](features/hive-initflutter-hang-root-cause-2026-08-02.md)

## Status: Flutter startup optimized (2026-08-02)
Partially rolled back for Hive/order (above). Bundled Plus Jakarta + deferred
Home/Onboarding routes remain. Do **not** re-defer Hive/Logger past `runApp`.
Detail:
[`memory/features/flutter-startup-optimization-2026-08-02.md`](features/flutter-startup-optimization-2026-08-02.md)

## Status: Flutter startup bottlenecks — instrumented (2026-08-02)
Superseded by optimization above. Prior probe notes:
[`memory/features/flutter-startup-bottleneck-breakdown-2026-08-02.md`](features/flutter-startup-bottleneck-breakdown-2026-08-02.md)

## Status: iOS launch profiling → first-frame bottleneck fixed (2026-08-02)
Native `didFinishLaunching` ~14 ms; no plugin ≥100 ms. Slowest stage was
**runApp → first frame (~21 s)** from `GoogleFonts.plusJakartaSansTextTheme`
HTTP fetch. Fix: bootstrap themes for frame 0; apply Plus Jakarta after first
frame. Detail:
[`memory/features/ios-launch-path-timing-2026-08-02.md`](features/ios-launch-path-timing-2026-08-02.md)

## Status: CoreML modelObtain ~7s every score — fixed (2026-08-02)
**Cause:** (1) specialized `predict_T*` loaded only on first score per bucket;
(2) `ensureModel` always `unload()`’d ASR/head, wiping cache on every practice
entry. **Fix:** unload only when pack version/SHA changes; specialized preload
runs in background **after** `prepareModel` completes; keep cache across
idempotent `load()`. **UI follow-up:** `TajweedModelSession` skips install
chrome when pack is on disk / already prepared this process; leaves download
UI before prepare (never stuck at 100%); no 0% flash between ayahs. CoreML
cache untouched. Detail:
[`memory/features/tajweed/coreml-lifetime-cache-2026-08-02.md`](features/tajweed/coreml-lifetime-cache-2026-08-02.md)

## Status: Tajweed must be lazy until practice opens (2026-08-02)
Audit vs fast baseline `aaf5513`: native engine/lexicon/CoreML/ONNX were already
off the launch path (post 2026-07-31 lexicon ANR fix). Eager bits were Dart
router/settings imports + EventChannel `onListen` constructing the engine.
Fixed: `TajweedPracticeGate` deferred load; Settings deferred Tajweed imports;
`onListen` only stores the sink. Detail:
[`memory/features/tajweed/startup-eager-load-audit-2026-08-02.md`](features/tajweed/startup-eager-load-audit-2026-08-02.md)

## Status: Flutter first-frame ~21s after runApp (2026-08-02)
Native startup healthy (~14 ms). Gap is Flutter: `GoogleFonts.plusJakartaSansTextTheme`
fetches Plus Jakarta Sans over HTTP (not in pubspec fonts); first Text paint waits.
Probes: `[STARTUP] GoogleFonts.pendingFonts done` vs `first Flutter frame`.
Detail: [`memory/features/flutter-first-frame-delay-2026-08-02.md`](features/flutter-first-frame-delay-2026-08-02.md)
(Ignore Google Fonts for the Tajweed laziness work above.)

## Status: Short-ayah ASR deletions (Kawthar-class) — root cause (2026-08-01)
**Not** CTC collapse, audio trim, pad pollution, or normalization. Official
CoreML greedy argmax blanks frames where ONNX still emits letters (e.g. `م`);
iOS hyp matches host Official on the same WAV. Lexical scorer is downstream only.
Detail: [`memory/features/tajweed/short-surah-asr-deletion-root-cause-2026-08-01.md`](features/tajweed/short-surah-asr-deletion-root-cause-2026-08-01.md)

## Status: Scoring pipeline perf (2026-08-01)
Instrumented stages (Android `timingsMs` parity + FA/head split). Optimized
CoreML `NSNumber` I/O (~200× parse / ~1000× fill on host microbench), flat CTC
aligner DP (identical intervals), iOS lexicon NDJSON streaming. Scoring logic
unchanged. Detail:
[`memory/features/tajweed/scoring-pipeline-perf-2026-08-01.md`](features/tajweed/scoring-pipeline-perf-2026-08-01.md)

## Status: iOS white launch screen — root cause fixed (2026-08-01)
**Cause:** `GeneratedPluginRegistrant.register` was commented out → prefs/path
channels hung → Dart never painted → white `LaunchScreen.storyboard` stuck.

**Behavior-preserving follow-up:** Dart init order restored (MediaKit → Logger →
Hive → `runApp` → Superwall/services as before). Only keep plugin registration,
DEBUG timing logs, and deferred FocusIOSDebugLogger I/O.
Detail: [`memory/features/ios-startup-white-screen-2026-08-01.md`](features/ios-startup-white-screen-2026-08-01.md)

**Build slowness (separate):** Superwall `Superscript` pod ~253MB + 12MB lexicon
asset copy dominate install/link — not fixed by commenting out plugins.

## Status: TajweedLiveCompare — per-attempt archive (2026-08-01)
Each score still writes `last.wav` + `last_stages.json`, and also archives
`{surah}_{ayah}_attempt_NNNN.wav` + matching `.json` (never overwrites history).
iOS: Documents/TajweedLiveCompare/; Android: externalFilesDir/TajweedLiveCompare/.

## Status: M3 flag not reaching score — fixed (2026-07-31)
**Bug:** iOS `setCanonicalLexicalProductionEnabled` cast `args["enabled"] as? Bool`
failed when Flutter delivered `NSNumber` → set never persisted. Settings switch
stayed optimistically ON; score still read flag=OFF → `authority=legacy`.

**Fix:** parse Bool|NSNumber; in-memory flag cache; `synchronize`/`commit`; set
echoes confirmed value; Flutter no longer silent-no-ops MissingPlugin.

**Verify:** toggle ON → snackbar says "native confirmed" → log
`[TajweedCanonical] flag set productionEnabled=YES` then score
`authority branch=canonical` / `authority=canonical`.

## Status: Launch hang — root cause + fix (2026-07-31)
**Cause:** Android `TajweedEngine` init (from `configureFlutterEngine`) called
`CanonicalLexiconStore.loadIfNeeded()` and synchronously parsed **~12MB**
`ayahs.ndjson` (6236 ayahs) on the **main thread** → ANR / frozen phone on launch.

**Fix:**
- Lexicon: `bind()` only at engine construct; `loadIfNeeded()` only on score worker.
- `TajweedChannelHandler` lazy-inits engine; flag get/set never constructs engine.
- iOS: flag channel methods skip `TajweedEngine.shared` (Settings can call them).

**Verify:** cold launch; console should reach Flutter `[STARTUP] runApp` quickly with
**no** `[TajweedCanonical] loaded …` until first score.

## Status: ADR-010 M3 — Canonical lexical = production (always on)
**Canonical is always on** (Debug/Profile/Release). Legacy display-string lexical
path is no longer selectable. Settings / CoreML Debug toggles removed.

Pipeline: lexicon expected IDs + Stage-2/rematerialize hyp + canonical DP →
existing `WordAlignOp` / pronunciation head / Flutter JSON. Display Mushaf is
UI-only. Fail closed if ayah missing from pack.

**Doc:** [`memory/features/tajweed/canonical-lexical-production-always-on-2026-08-03.md`](features/tajweed/canonical-lexical-production-always-on-2026-08-03.md)  
**M3 history:** [`memory/features/tajweed/canonical-lexicon-m3.md`](features/tajweed/canonical-lexicon-m3.md)  
**ADR:** [`memory/decisions/ADR-010-canonical-spoken-quran-lexical-evaluator.md`](decisions/ADR-010-canonical-spoken-quran-lexical-evaluator.md)

## Status: iOS launch hang — mitigation (2026-07-31)
**Symptom:** Debug builds on iPhone stuck on native LaunchScreen (Xcode Run logs
~23:44–23:54 showed multi-minute sessions with empty console).

**Mitigations shipped (no scoring/M3 change):**
- Defer `TajweedEngine.shared` until first MethodChannel call (no `AVAudioEngine`
  on AppDelegate launch path); lazy `AVAudioEngine` in recorder.
- `main.dart`: timeouts around Logger/Hive; Superwall configure after first frame.
- Splash: prefs timeout + null-safe l10n; LaunchScreen no longer references
  missing `LaunchImage.png` assets.
- Superwall configure Completer capped at 8s.

**Verify:** Rebuild/run on device; Xcode console should show `[DeenFocus]
didFinishLaunching` then Flutter `[STARTUP] runApp`. If still stuck, capture
console from first paint.

## Status: ADR-010 M2.6 — real-world lab validation (2026-07-31)
**Lab only — no production scoring/UI/M3.** Framework + initial evidence on 5
recordings (3 Arab professional goldens via ONNX ASR + 2 live captures).

**Results:** legacy mean **84.2%** → canonical **95.0%** (+10.8 pp); FP **1→0**;
FN increase **0**; golden/presentation/live regression suites **0 worse**.
Acceptance on seed: **PASS**. Diversity placeholders not yet filled.

**Clitic rematerialization** (M2.5 policy) applied in **lab** `canonical_evaluator`
only — production `TajweedLexicalScoring` untouched.

**Run:** `cd tajweed-lab && PYTHONPATH=. python3 scripts/run_m26_evaluation.py --seed`

**Docs / reports:**
- [`memory/features/tajweed/canonical-lexicon-m26.md`](features/tajweed/canonical-lexicon-m26.md)
- [`memory/features/tajweed/reports/m26-real-world-2026-07-31.md`](features/tajweed/reports/m26-real-world-2026-07-31.md)
- Dataset: `memory/features/tajweed/fixtures/m26_real_world/`

**Next action:** Fill diversity speaker slots + complete `m26_human_review.csv`;
still **no M3** until policy G1–G7 + product sign-off.

## Status: ADR-010 M2.5 — canonical lexical policy freeze (2026-07-31)
**Design only — no code, no M3, no production score change.** M2 showed architecture
is correct; remaining accuracy gap is undefined spoken-word policy (especially
clitic / word boundaries), not more Unicode.

**Frozen policy:** one Madani Uthmani token = one word ID; `و`/`ف` attached when
Uthmani attaches; hyp rematerializes split ASR; Stage-2 closed equivalence set;
align on IDs only; no fuzzy matching.

**Doc:** [`memory/features/tajweed/canonical-lexical-policy-spec-2026-07-31.md`](features/tajweed/canonical-lexical-policy-spec-2026-07-31.md)  
**ADR:** [`memory/decisions/ADR-010-canonical-spoken-quran-lexical-evaluator.md`](decisions/ADR-010-canonical-spoken-quran-lexical-evaluator.md)

**Next action (still pre-M3):** ~~sign off Q1–Q6 → M2.6~~ **M2.6 done** — expand
diversity WAVs + human review; only then consider M3 if G1–G7 still pass.

## Status: ADR-010 M2 — shadow evaluation (2026-07-31)
**M2 measurement complete.** 778-case lab comparison (legacy vs canonical).
Production scoring **unchanged**. Legacy remains authoritative.

**Results:** legacy mean **75.4%** → canonical **76.8%** (+1.4 pp); **78** false subs
removed; **0** live-capture regressions; **5** golden cases where canonical < legacy
(clitic boundary policy — addressed by M2.5 policy, not M3 code).

**Recommendation:** Needs more work before cutover.

**Run:** `cd tajweed-lab && PYTHONPATH=. python3 scripts/run_m2_shadow_evaluation.py`

**Docs:**
- [`memory/features/tajweed/canonical-lexicon-m2.md`](features/tajweed/canonical-lexicon-m2.md)
- [`memory/features/tajweed/reports/m2-shadow-evaluation-2026-07-31.md`](features/tajweed/reports/m2-shadow-evaluation-2026-07-31.md)

## Status: ADR-010 M1 — canonical lexicon + shadow infra (2026-07-31)
**M1 delivered.** Complete spoken-Quran lexicon (6236 ayahs), versioned pack
generation, fail-closed validation, and DEBUG-only shadow evaluator on iOS +
Android. **Zero production scoring/UI/behavior change** — legacy
`TajweedLexicalScoring` path remains authoritative.

**Artifacts:**
- Pack: `memory/features/tajweed/fixtures/canonical_lexicon_v1/` (`1.0.0`)
- Generator: `tajweed-lab/canonical_lexicon/`
- CLI: `tajweed-lab/scripts/generate_lexicon.py`
- Sync: `tajweed-lab/scripts/sync_canonical_lexicon_pack.sh`
- Doc: [`memory/features/tajweed/canonical-lexicon-m1.md`](features/tajweed/canonical-lexicon-m1.md)
- ADR: [`memory/decisions/ADR-010-canonical-spoken-quran-lexical-evaluator.md`](decisions/ADR-010-canonical-spoken-quran-lexical-evaluator.md)

**Shadow:** `[TajweedCanonicalShadow]` + `canonicalShadow` in `last_stages.json`
(DEBUG builds only). Not touched: `normalizeArabic`, `lexicalWords`,
`prepareExpectedWords`, `alignWords`.

**Next action:** M2 — measure shadow vs legacy on golden set (Fatiha, 2:2–2:7,
presentation_space_cases) + live corpus before any cutover.

## Status: Display-script lexical dependency audit (2026-07-31)
Investigation only (no code). Verdict: **ADR-010 via shadow-first; do not purge
display-script from the legacy evaluator first.** Expected tokens still come from
`normalizeArabic(Mushaf)` on every ayah; 25% IndoPak ayahs FALLBACK to display
boundaries. `ذالك`≠`ذلك` is preserved by dagger→ا when next=ل (Phase 1 kaf-drop
never fires). `الصلاوه`/`الصلاه` and `رزقنهم`/`رزقناهم` are orthographic, not ASR.
Doc: [`memory/features/tajweed/display-script-lexical-dependency-audit-2026-07-31.md`](features/tajweed/display-script-lexical-dependency-audit-2026-07-31.md).

**Next action:** M2 shadow measurement (see ADR-010 M1 status above).

## Status: ADR-010 canonical lexical evaluator (2026-07-31)
**M1–M2.6 complete (lab).** Policy freeze + rematerialization + real-audio shadow
evidence. Production scoring unchanged. M3 still blocked.
ADR: [`memory/decisions/ADR-010-canonical-spoken-quran-lexical-evaluator.md`](decisions/ADR-010-canonical-spoken-quran-lexical-evaluator.md).
Policy: [`memory/features/tajweed/canonical-lexical-policy-spec-2026-07-31.md`](features/tajweed/canonical-lexical-policy-spec-2026-07-31.md).
M2.6: [`memory/features/tajweed/canonical-lexicon-m26.md`](features/tajweed/canonical-lexicon-m26.md).

**Next action:** Expand multi-speaker dataset; human-review CSV; do not start M3.

## Status: iOS post-score fatal error fixed (2026-07-31)
**Root cause:** `TajweedLexicalScoring.normalizeArabic` called `UInt32(next)` when
`next == -1` (dagger alif U+0670 at end of token / no following base letter).
Swift traps with `Fatal error: Negative value is not representable`. Kotlin uses
`Int` family checks and was unaffected.

**Fix:** Guard `next >= 0` before `UInt32` conversion; mirror Kotlin sentinel logic.
Regression test: `testNormalizeArabicDaggerAlifAtEndDoesNotTrap`.

**Next action:** Rebuild iOS; confirm scoring completes without crash on ayahs that
previously died at end of pipeline (check `[TajweedLexical]` then result UI).

## Status: ASR foundation feasibility (2026-07-31)
Research-only. `Muno459/fastconformer-quran` is purpose-built Quran-Hafs ASR
(EveryAyah + tlog phone + Muaalem; SOTA offline board) — **not Option C**.
Phone WER ~9% + our live `model_limitation` failures mean 95–98% worldwide
lexical is **not** model-guaranteed → **Option B**: keep model near-term, build
ASR-swappable lexicon architecture, start eval/migration plan (license NPL too).
Doc: [`memory/features/tajweed/asr-foundation-feasibility-2026-07-31.md`](features/tajweed/asr-foundation-feasibility-2026-07-31.md).

**Next action:** Accept Option B; define DeenFocus accent/beginner eval cohort;
ADR-010 only with ASR-swappable requirement — do not implement yet.

## Status: Canonical Spoken-Quran Engine design (2026-07-31)
Engineering design for next-gen scoring: versioned canonical lexicon as sole
lexical authority; separate linguistic normalize; align on canonical tokens;
pronunciation + tajweed as independent layers; three-axis feedback.
Phased migration M0–M7 with effort/risks/rollback. **No implementation yet.**
Doc: [`memory/features/tajweed/canonical-spoken-quran-engine-design-2026-07-31.md`](features/tajweed/canonical-spoken-quran-engine-design-2026-07-31.md).

**Next action:** Accept design → draft ADR-010 (Phase M0); do not add more
Unicode hacks; complete Phase 3 live QA of Phase 1/2 in parallel.

## Status: Recitation evaluation architecture review (2026-07-31)
Design-only (no code). Verdict: layered pipeline (ASR → canonical Quran norm →
linguistic norm → align → pronunciation → tajweed → feedback) is superior to
further `normalizeArabic` patches. Keep Phase 1/2 wins; stop treating Mushaf
glyphs as the path to worldwide correctness. Remaining hard problems are
canonical lexicon + ASR ceiling + real tajweed stage, not more dagger rules.
Doc: [`memory/features/tajweed/recitation-evaluation-architecture-review-2026-07-31.md`](features/tajweed/recitation-evaluation-architecture-review-2026-07-31.md).

**Next action:** Phase 3 manual live QA of Phase 1/2 fixes; then decide Horizon B
(extract layers) vs continue product UI — do not add more orthography hacks.

## Status: Lexical Phase 1/2 + mismatch instrumentation (2026-07-31)
Deterministic lexical fixes only (no ASR/CoreML/CTC/pronunciation changes):
- `prepareHypothesisWords`: peel attached ASR `و` before align
- `filterLexicalExpectedWords`: drop non-lexical marks (e.g. IndoPak `٭`)
- `normalizeArabic`: dagger U+0670 drop before ya/kaf/end-after-ya; `اولائك`→`اولئك`
- Phase 2: strip U+0653–U+065F + U+066D in letterstream
- Every sub/miss/extra logs `reason=` (`attached_waw`, `dagger_alif`, `hamza_variant`,
  `quranic_mark`, `model`) in `[TajweedLexical]`, `last_stages.json`, and tokens.

**Next action (Phase 3):** rebuild; re-run manual live takes (2:5, 2:7, 2:2). Expect
2:5 ≈100% lexical; remaining subs should show `reason=model` only.

## Status: Presentation-token tokenizer (2026-07-31)
`TajweedLexicalScoring.lexicalWords(text, referenceText)` segments any mushaf
onto Uthmani word boundaries via shared letterstream (whitespace/ZW ignored).
Flutter passes `lexicalReferenceArabic` (Uthmani) with display `expectedArabic`.
763 IndoPak presentation-boundary cases regression-tested on Android (+ iOS
mirrors). ASR / `alignWords` DP unchanged.
Doc: [`memory/features/tajweed/presentation-token-tokenizer-2026-07-31.md`](features/tajweed/presentation-token-tokenizer-2026-07-31.md).

**Next action:** rebuild apps; practice IndoPak Fatiha 1:6 — expect `اهدنا` match.

## Status: IndoPak اهْدِنَا presentation space (2026-07-31)
IndoPak 1:6 corpus text contains a real **U+0020** between `اِہۡدِ` and `نَا`.
`splitWords` splits before `normalizeArabic` → `["اهد","نا"]` vs ASR `["اهدنا"]`.
Not a surviving format control inside normalize; Android and iOS tokenize
identically. ~761 ayahs have similar word-count skew vs Uthmani letterstream.
ASR / `alignWords` not changed — fix belongs in tokenizer/normalizer (or
lexical resegmentation) next.
Doc: [`memory/features/tajweed/indopak-presentation-space-ihdina-2026-07-31.md`](features/tajweed/indopak-presentation-space-ihdina-2026-07-31.md).

**Next action:** implement lexical token merge / Uthmani-guided resegmentation
before `alignWords`; do not touch ASR.

## Status: ONNX vs Official decoder divergence (2026-07-31)
Same golden WAVs: first **content** split is encoder/logit numerics on overlapping
frames (cosine ~0.89–0.94, ~7–12% greedy argmax mismatch) — **not** CTC collapse
and **not** `tokens.txt` (byte-identical). Official often drops the final vowel
piece (`ِ` / `ٌ`) vs ONNX. Host Official needs `CPU_AND_NE` (GPU/CPU → NaN).
Script + dumps:
`tajweed-lab/experiments/diy_coreml_poc/compare_onnx_vs_official_decoder.py`,
`…/reports/onnx_vs_official_decoder/`.
Doc: [`memory/features/tajweed/onnx-vs-official-decoder-divergence-2026-07-31.md`](features/tajweed/onnx-vs-official-decoder-divergence-2026-07-31.md).

**Next action:** if product needs word-identical ASR, accept model-graph gap or
revisit Official vs ONNX encoder parity — do not “fix” CTC/tokenizer.

## Status: Heh-family normalizeArabic mushaf parity (2026-07-30)
Verified IndoPak corpus uses ہ (not ه) and `لِلّٰہِ` (dagger + heh goal).
Normalization only: fold heh-family → ه; strip dagger alif when next base is
heh-family so `لله` ≡ `لِلّٰہِ`. Scoring/alignWords unchanged.
Doc: [`memory/features/tajweed/normalize-heh-mushaf-parity-2026-07-30.md`](features/tajweed/normalize-heh-mushaf-parity-2026-07-30.md).

**Next action:** rebuild app; confirm IndoPak Fatiha 1:2 lexical match vs Imlaei ASR.

## Status: E2E Tajweed timing / missing ~7.5 s (2026-07-30)
Prior stage sum (~900 ms) excluded work inside `predict()` that still counted
toward `totalPipelineMs`. New stages: `coremlModelObtainMs`,
`coremlInputCopyMs`, `coremlOutputParseMs`, plus mic stop / validate / WAV dump
/ Flutter callback+first frame. No VAD on iOS (`vadEndOfSpeechWaitMs=0`).
Look for `[TajweedE2E]` / `[TajweedPipeline]`; expect cold
`modelWasColdLoad=true` to dominate first score for a bucket.
Doc: [`memory/features/tajweed/e2e-pipeline-timing-gap-2026-07-30.md`](features/tajweed/e2e-pipeline-timing-gap-2026-07-30.md).

**Next action:** rebuild, score once (cold) then again (warm same bucket); confirm
`modelObtainMs` explains the gap.

## Status: iOS Tajweed pipeline stage timing instrumentation (2026-07-30)
Each recitation logs `[TajweedPipeline]` with mel/pad/encoder/ctc/lexical/pron/total
ms plus active manifest version, encoder SHA, API, function name, compute units.
Superseded/extended by E2E status above.

## Status: iOS dual CoreML + DEBUG Official default (2026-07-30)
Dual-model architecture unchanged (manifest-driven DIY + Official). **Local
DEBUG** builds default to Official (`TajweedDevModelOverride` → R2
`ios/tajweed/v1.2.0/`). Settings → **iOS CoreML model (Debug)** switches
Official / DIY / production catalog without touching live `catalog.json`.
Release/TestFlight ignore the override. Production catalog still DIY
`v1.1.0`. Official is **dev/eval only** until licensing clears.
Doc: [`memory/features/tajweed/ios-dual-coreml-architecture-2026-07-30.md`](features/tajweed/ios-dual-coreml-architecture-2026-07-30.md).

**Next action:** on device, open Debug selector → Ensure Official → switch DIY
→ confirm both load; leave production catalog alone.

## Status: Official HF CoreML vs DIY palette-8 (2026-07-30)
Host golden comparison:
[`memory/features/tajweed/official-vs-diy-coreml-comparison-2026-07-30.md`](features/tajweed/official-vs-diy-coreml-comparison-2026-07-30.md).
Official equal on transcripts/lexical, ~23× faster host latency, larger pack.
Architecture follow-up: dual-model status above.

## Status: Lexical iOS ≡ Android + selected Quran script (2026-07-30)
Verified expected ayah comes from Flutter `StorageService.quranScript` →
`QuranScriptTexts` on both platforms. Aligned `normalizeArabic` /
`splitWords` (added IndoPak keheh/Farsi-yeh folds + drop empty tokens).
Unit tests green on Android + iOS. Report:
[`memory/features/tajweed/lexical-ios-android-parity-2026-07-30.md`](features/tajweed/lexical-ios-android-parity-2026-07-30.md).
ASR/CoreML untouched. Live dumps log raw/norm expected+hyp via `TajweedLexical`.

## Status: Live Android vs iOS recitation divergence (2026-07-30)
Investigation (not a product feature): same live ayah on both devices → dump
WAV + stages → cross-feed Android ONNX vs iOS CoreML. Report:
[`memory/features/tajweed/android-ios-live-recitation-divergence-2026-07-30.md`](features/tajweed/android-ios-live-recitation-divergence-2026-07-30.md).

**Ready:** `TajweedLiveCaptureDump` on both platforms; host
`compare_live_pipelines.py`. **Blocked on:** paired mic captures after rebuild.
On identical WAV, first structural divergence is encoder `T_out` (dynamic vs
fixed 600); CTC hyp still matches — goldens do not explain Android-OK/iOS-fail.

## Status: iOS palette-8 encoder is the production R2 candidate (2026-07-30)
Promoted the validated 8-bit k-means palettized DIY encoder into the existing
runtime pipeline (R2 + `catalog.json` + `model_manifest.json` + `ensureModel()` +
SHA-256). Full report:
[`memory/features/tajweed/ios-palette8-production-promotion-2026-07-30.md`](features/tajweed/ios-palette8-production-promotion-2026-07-30.md).

**R2:** `ios/tajweed/v1.1.0/` **still live** via catalog; official successor
staged at `v1.2.0` (see Official HF status above). Android `android/tajweed/v1/`
URLs/artifacts unchanged. Encoder SHA
`96d36feaefb56a4be7044cda1d5bb825d935b7b0e323fc995c58c6dea92b032a`
(byte-identical to lab `palette_8bit`). Download/install ~158.8 MB artifacts.
No models in IPA.

**Next action:** superseded for production candidate decision by official HF
comparison; keep v1.1.0 until catalog flip.

## Status: DIY CoreML encoder optimization comparison (2026-07-30)
User asked to evaluate architecture-preserving compressions on the self-generated
encoder **without replacing the production candidate** (at the time). Full report:
[`memory/features/tajweed/diy-coreml-encoder-optimization-2026-07-30.md`](features/tajweed/diy-coreml-encoder-optimization-2026-07-30.md)
(lab mirror: `tajweed-lab/experiments/diy_coreml_poc/reports/encoder_optimization_comparison.md`).

**Measured on host (`coremltools` 9.0, `CPU_AND_GPU`, 3 golden clips, same pronunciation head):**

| Technique | Size | Exact transcripts | Mean \|Δpron\| | Verdict |
|---|---:|:---:|---:|---|
| FP32 baseline (superseded on R2) | 587 MB | 3/3 | 0 | replaced by palette-8 on R2 |
| FP16 convert | 294 MB | NaN | — | reject |
| Prune 50% (weight compression) | 240 MB | 0/3 | 0.098 | reject |
| **Palettize 8-bit** | **146 MB** | **3/3** | **0.0034** | **promoted to R2 v1.1.0** |
| Palettize 4-bit | 74 MB | 0/3 | 0.019 | reject |
| **Linear INT8** | **149 MB** | **3/3** | **0.0036** | **runner-up** |
| Linear INT4 | — | — | — | needs iOS18 re-convert |

**Recommendation (executed):** `palette_8bit` published as `ios/tajweed/v1.1.0`
(immutable; FP32 `v1` removed). Harness:
`experiments/diy_coreml_poc/evaluate_encoder_optimizations.py`.

## Status: iOS Tajweed DIY CoreML pack — migrated to production R2 asset distribution (2026-07-30)
Follow-up to the entry directly below. User asked: is the DIY pack bundled or
downloaded like Android? (Answer: neither — it was a manual `Documents/
TajweedImport` debug-copy path, not in the IPA but also not through the real
downloader.) Migrated it to the real pipeline. Full report:
[`memory/features/tajweed/ios-asset-distribution-migration-2026-07-30.md`](features/tajweed/ios-asset-distribution-migration-2026-07-30.md).

**What changed (asset distribution path only — zero inference/scoring changes):**
- Uploaded the verified DIY `device_pack/` artifacts (~592MB: encoder + head
  `.mlpackage`s, tokenizer, tokens) to the **same real Cloudflare R2 bucket**
  Android already uses (`deenfocus-ai-assets`), under `ios/tajweed/v1/`,
  mirroring Android's exact layout. `catalog.json`'s existing `hafs-en-v1` pack
  gained an `"ios"` key (uploaded last, per ADR-009's atomic-go-live ordering).
- `TajweedAssetSync.fileSpecs()` now supports unzipped `.mlpackage` **directory**
  bundles via an opt-in `"<name>Files"` manifest array (3 member files:
  `Manifest.json`, `Data/com.apple.CoreML/model.mlmodel`,
  `.../weights/weight.bin`) — zero changes needed to the generic
  `AssetDownloadManager`/`AIAssetManager` (already directory/nested-path-aware).
  Fully backward-compatible: absent the new key, single-file behavior is
  unchanged (verified by the full pre-existing test suite still passing).
- **`TajweedAssetDistributionConfig.catalogURL` (iOS) is now LIVE** — changed
  `nil` → the real R2 catalog URL, the same "one switch" pattern Android's
  used since 2026-07-29. Made it `var` (was `let`) + added test isolation
  (`RunnerTests`/`TajweedAssetSyncTests` `setUp`/`tearDown` null out both the
  config **and** `AIAssetManager.shared.catalogURL` directly, since the latter
  is set once via `ModelStore`'s lazy registration) so the test suites stay
  fully offline/deterministic.
- **Found + fixed a real bug** (TD-011, now closed): `URLSessionAssetTransport
  .fetchAppending` requested each artifact's entire remaining bytes in **one
  open-ended Range request** under a fixed 30s timeout — invisible with
  Android's smaller files, and never before exercised on iOS since `catalogURL`
  was always `nil`. The very first live fresh-install test against the real
  ~587MB encoder timed out. Fixed by bounding each request to an 8MB chunk;
  `AssetDownloadManager`'s existing multi-chunk resume loop already handled
  this correctly, it just had never been exercised. Generic downloader fix,
  not Tajweed/CoreML-specific.

**Verified real, end-to-end, no simulation:**
- New unit test `testPerformFirstInstallDownloadsMultiFileMlpackageBundle`
  (offline, `FakeAssetTransport`) + full existing suite —
  `xcodebuild test -only-testing:RunnerTests` **all green**, no regressions.
- **Live fresh-install test against production R2** (temporary `XCTestCase`,
  deleted after use): wiped `ModelStore.shared.rootURL`, called the exact
  `AIAssetManager.performFirstInstall` path a real first launch takes against
  the live `catalogURL`. Downloaded catalog → manifest → all 8 real files →
  verified real SHA-256 → activated → `isAvailable()==true` →
  `encoderApi()==.singleFunctionFixedLength(4800)` → confirmed the installed
  model path is **outside** `Bundle.main.bundlePath` (never embedded in the
  IPA). ~104s for ~592MB. Confirmed via `curl` that every uploaded artifact is
  publicly reachable at the expected byte size.
- Untouched: `OfflineAsrModel`, `MelFrontend`, `TajweedEngine`,
  `TajweedLexicalScoring`, `PronunciationHeadModel`, `ModelStore.installFromDirectory
  /verifyStaging/verifySHA`, `AssetDownloadManager`/`AIAssetManager` core logic, Android.

**Still open (unchanged from the entry below — this migration is distribution-path
only, does not re-validate inference):** this is still the DIY non-ANE encoder
(~592MB vs. official ~210MB estimate); real-iPhone cold/warm/inference timing
and an Instruments ANE-dispatch trace are still outstanding.

**Next action:** decide whether to keep `catalogURL` live for broader QA/rollout,
or revert to `nil` pending real-iPhone latency validation (see report's
"Rollback" section — one-line change, no R2 cleanup needed either way).

## Status: DIY functional CoreML from fastconformer-quran.nemo, wired into iOS (2026-07-30)
Follow-up to the entry directly below, after the user explicitly said: ignore parity with
the official ANE package, just get a *working* self-generated model into the real
pipeline. Full report:
[`memory/features/tajweed/diy-coreml-nemo-production-attempt-2026-07-30.md`](features/tajweed/diy-coreml-nemo-production-attempt-2026-07-30.md).

**Verified (real weights, real audio, no simulation):**
- Byte-level tensor diff proves `models/onnx/model_with_encoder.onnx` (used by Android
  production today) *is* an export of this exact `.nemo`'s weights (CTC head
  byte-identical; 188/194 2D encoder tensors match direct-or-transposed; the only 6
  non-matches are RNNT decoder/joint params not present in the CTC-only ONNX at all).
- Regenerated a **functional, non-ANE** CoreML encoder (FP32, fixed `(1,80,4800)` +
  explicit `length` input, single-function, 587 MB) from that ONNX via the existing
  `onnx2torch→coremltools` lab pipeline. Confirmed the `RangeDim` (dynamic-length) export
  *converts* but **fails at runtime** for non-traced lengths — fixed-shape is the only
  option with this pipeline.
- Host `coremltools` e2e on the 3 real golden clips: **3/3 exact transcript match**,
  pronunciation-head scores within tolerance of Android — verdict
  `HOST_PARITY_OK_BUT_NOT_PRODUCTION_DROP_IN`.
- **`ComputeUnit.ALL` fails to build an execution plan for this model on this Mac**
  (partitioner error -6); `CPU_ONLY`/`CPU_AND_GPU`/`CPU_AND_NE` each work individually.
  Production Swift already requests `.cpuAndNeuralEngine`, matching the working
  `CPU_AND_NE` config.
- **Made the minimal Swift changes** so `OfflineAsrModel`/`ModelStore`/`TajweedEngine`
  can load *either* the official multifunction ANE package (unchanged, default) *or* this
  DIY single-function fixed-length package, selected by a new optional manifest field
  (`encoderApi`/`encoderFixedT`) — zero behavior change when the field is absent. Also
  fixed a latent output-layout bug (`encoder_output` channel-first vs. batch-first)
  surfaced while wiring this.
- `xcodebuild build` — **BUILD SUCCEEDED**; `xcodebuild test -only-testing:RunnerTests` —
  **53/53 passing**, no regressions.
- Assembled an install-ready device pack:
  `tajweed-lab/experiments/diy_coreml_poc/device_pack/`.

**Not yet done — needs a real iPhone (handoff instructions in the report):** on-device
cold/warm/inference timing via the existing `TajweedDebugRunner` harness, and an
Instruments Core ML trace to confirm whether the Neural Engine is actually dispatched
(vs. silent CPU/GPU fallback) — `MLModelConfiguration.computeUnits` is a request, not a
guarantee. This dev machine currently has no attached physical iPhone.

**Known cost of this path vs. the official package:** ~587 MB vs. ~210 MB estimated, and
latency scales with the fixed 48s cap regardless of actual clip length (always pays
worst-case cost) — real tradeoffs of skipping ANE windowed-attention optimization, not
implementation bugs.

## Status: fastconformer-quran.nemo vs production iOS CoreML (2026-07-30)
Downloaded checkpoint: `/Users/rabiadastgir/Downloads/fastconformer-quran.nemo`.
Full report:
[`memory/features/tajweed/nemo-checkpoint-coreml-feasibility-2026-07-30.md`](features/tajweed/nemo-checkpoint-coreml-feasibility-2026-07-30.md).

**Verdict: cannot replace HF CoreML dependency from this `.nemo` alone.**

- Tokenizer SHA + encoder YAML (`att_context_size=[-1,-1]`, 17×512, CTC 1025)
  match Android ONNX / lab tokenizer — good SoT for the **Android/full-attn** path.
- Production iOS ANE pack is a **different** windowed fine-tune (`[32,32]` +
  pos-enc clamp + multifunction `predict_T*`) — not in this checkpoint.
- NeMo has **no CoreML exporter** (ONNX/TensorRT only). DIY full-attn→CoreML
  FP16/ANE already failed (prior DIY POC).
- Full `restore_from` not completed here (Python 3.13 / NeMo ASR dep chain);
  structural torch/config evidence is sufficient for the verdict.

No production code or production model assets changed. Scratch only under
`tajweed-lab/experiments/nemo_coreml_investigation/`.

## Status: Tajweed Arabic script parity with settings (2026-07-30)
Recording/result pages were showing wrong Arabic *presentation*: no Quran
font on recording (system default), result hardcoded `UthmanicHafs`.

Fix: `TajweedEntryPoint.open` resolves text + font from Reading Settings
(`QuranScript` → `QuranScriptTexts` + `fontFamily`) so practice matches the
surah listing 100%. Recording + result views use `args.arabicFontFamily`.

## Status: normalizeArabic Uthmani↔Imlaei fix (2026-07-30)
Root cause of all-`sub` on correct recitation was orthographic mismatch between
expected Uthmani (`uthmani.json`) and ASR Imlaei — not Levenshtein/FA/head.

**Fix (canonical normalization only; no architecture change):**
`TajweedLexicalScoring.normalizeArabic` on Android + iOS now:
1. Map U+0670 dagger alif / U+0671 alef wasla → ا
2. Strip tashkeel + Quranic sukun U+06E1 + annotations U+06D6..U+06ED + tatweel
3. Fold أ/إ/آ → ا and ى → ي
Does **not** merge bare `ملك` with `مالك`, or `قل`/`قال`, or `رب`/`ربك`.

Verified: Fatiha 1:4 Uthmani ↔ Imlaei ASR → 3/3 MATCH, wordAccuracy 1.0.
Regression tests in `TajweedAlgorithmTest` + iOS `RunnerTests`.
Untouched: ASR, ONNX, mel, tokenizer, alignWords DP, pronunciation head, Flutter UI, download.

Diagnosis dump retained: `memory/features/tajweed/lexical-match-failure-diagnosis-2026-07-30.md`.

## Status: Lexical-first scoring implemented (2026-07-30)
Approved design from `lexical-first-scoring-design.md` is now in native engines:

- Word-level Levenshtein alignment first (`TajweedLexicalScoring` kt/swift).
- Distinct wire status `sub` (not overloaded `major`).
- Additive token fields `lexical` + `pronunciation`.
- `wordAccuracy` = matched expected words ÷ expected words (pronunciation severity ignored).
- Pronunciation head + FA only on lexically matched hyp words (FA of hypothesis CTC ids).
- Untouched: Mel, ASR/ONNX models, tokenizer, ModelStore, downloader, AI asset manager.
- ADR-006 revised; Dart `TajweedTokenStatus.sub` + result legend colors updated.
- Regression unit tests: wrong-ayah → 0% lexical accuracy; matched+major still counts
  lexically; instrumented `TajweedMismatchDiagnosticTest` asserts accuracy &lt; 0.15.

## Status: Tajweed "wrong ayah still scores high" — root-cause investigation (2026-07-30)
**Investigation only, per explicit instruction — no UI/download-infra/Flutter code
changed.** Full report:
[`memory/features/tajweed/android-ios-scoring-investigation-2026-07-30.md`](features/tajweed/android-ios-scoring-investigation-2026-07-30.md).

**Finding: not an Android-vs-iOS parity bug.** Reproduced with real on-device audio
+ real production ONNX weights (new diagnostic instrumented test, not in CI):
reciting a completely different, zero-shared-word ayah than the one requested still
scores 75–100% `wordAccuracy`. Confirmed the raw ASR transcription (`hypothesis`,
before any scoring) is **accurate** in every case — the ASR/preprocessing/decoding
stack is not at fault. The bug is entirely downstream, in scoring:
1. CTC forced-alignment has no reject state — it always forces *some* alignment of
   the expected text onto the audio, however bad the fit (measured: the DP's own
   internal path likelihood is ~4x worse for wrong-ayah pairings, but this signal
   is computed and then thrown away on both platforms).
2. The pronunciation head is a goodness-of-pronunciation classifier (assumes the
   right word was said, asks "how well?") — it was never trained to detect "wrong
   word entirely," so it defaults to near-ceiling "correct" probabilities for
   content it wasn't trained to reject.
3. `wordAccuracy` is built purely from per-word pronunciation-head statuses; the
   already-computed sentence-level `exactMatch` (hypothesis vs. expected text) is
   never factored in.

Verified this is **not an ONNX-export/conversion defect**: re-ran the exact same
mismatch scenario through the DIY CoreML re-export of the *same* pronunciation-head
weights (`tajweed-lab/experiments/diy_coreml_poc/`) and got the same per-piece
probabilities as ONNX/Android. Also: iOS has never run real-weight CoreML inference
in production (still HF-gated, per `features/tajweed/overview.md`), so there is no
actual iOS baseline to be "at parity with" today — the only real CoreML numbers
available (the DIY re-export) already show the identical bug. No fix was
implemented — see the report's "what this means for fixing it" section for
evidence-backed candidate directions (surfacing the discarded alignment
log-likelihood; folding `exactMatch` into `wordAccuracy`; retraining the head with
wrong-word negatives) left for a follow-up decision.

New artifact (diagnostic only, not wired into CI): `android/app/src/androidTest/
kotlin/com/app/deenly/deenly/tajweed/TajweedMismatchDiagnosticTest.kt`.

## Status: Tajweed word-level scoring + result UI fix (2026-07-29)
Two real bugs found via on-device QA (physical low-RAM Android device, model `V2149`)
and fixed cross-platform (Kotlin + Swift, kept behaviourally identical per ADR-006),
plus a presentation rewrite requested on top:

1. **"Model could not be loaded" after a successful recording.** Root cause: Android's
   `onTrimMemory(TRIM_MEMORY_RUNNING_LOW)` → `TajweedEngine.onMemoryWarning()` can unload
   the ASR/pronunciation-head ONNX sessions *while the user is mid-recording* (confirmed via
   a captured stack trace: `OnnxAsrModel.predict` → "ASR model not loaded."). `stopRecording
   AndScore()` never re-checked this before scoring. Fix: it now re-warms (reloads
   tokenizer/encoder/head) if anything got unloaded before scoring the already-captured
   audio, instead of discarding the user's recording.
   (`android/app/src/main/kotlin/.../tajweed/TajweedEngine.kt`, `OnnxAsrModel.kt` unchanged;
   also added `Log.e`/`Log.d` diagnostics around model load/score failures.)
2. **Result screen showed per-piece "chips" (looked like colored letters/phonemes) and
   could show 0% accuracy while most pieces were "ok".** Investigated per explicit ask:
   - The pronunciation head scores individual **SentencePiece subword pieces** (from CTC
     forced-alignment onto the expected text), not phonemes and not whole words — so the
     old UI was, in effect, "coloring each phoneme/sub-word unit."
   - Word boundaries *were* implicitly known (the tokenizer's `▁` SentencePiece word-start
     marker, produced when `expectedArabic` was encoded) but were discarded before reaching
     the JSON (`piece()` stripped `▁`) and never used for grouping — so this was a data-
     plumbing gap, not a missing-model problem.
   - Fix (native, both platforms): `CtcAligner.TokenInterval` gained a `tokenIndex` (position
     in the encoded sequence — needed since vocab ids repeat); `SentencePieceTokenizer`
     gained `startsNewWord(id)`; `TajweedEngine.score()`/`buildWordLevelTokens` now groups
     per-piece forced-align intervals by word (worst-piece-wins probability) and emits **one
     token per Quran word** (`text` = the literal ayah word, never reconstructed from pieces)
     with a single ok/minor/major/miss status. A word whose pieces the aligner skips entirely
     is now explicitly "miss" instead of silently vanishing.
   - Fix (the 0% bug): `wordAccuracy` was computed from a **separate, disconnected** ASR-
     hypothesis-text-vs-expected-text diff (`TajweedLexicalScoring.wordAccuracyScore`), which
     could disagree with the token statuses shown to the user. Now `TajweedLexicalScoring.
     wordAccuracyFromTokens(tokens, expectedWordCount)` derives the percentage directly from
     the same per-word statuses (ok+minor ÷ expected word count) — the number and the
     word-by-word feedback can no longer contradict each other.
   - Dart: `TajweedResultView` no longer renders boxed per-token chips. It renders the ayah
     as one continuous `Text.rich` paragraph (`UthmanicHafs` font, RTL) with a soft per-word
     background highlight + color for non-"ok" words (no boxes — avoids breaking Arabic
     ligatures/letter connections); tapping a word shows its status via a SnackBar. Any
     "extra" tokens (lexical-fallback-only) are shown as a separate line below rather than
     interleaved into the reference ayah text.
   - Added/updated unit tests both platforms: `TajweedAlgorithmTest.kt` (`startsNewWord`,
     `wordAccuracyFromTokens`, `tokenIndex`) and `RunnerTests.swift` (same, plus a full
     `xcodebuild test` run on iOS Simulator — **TEST SUCCEEDED**, all suites green). Android
     `./gradlew :app:testDebugUnitTest` — green.
   - Not done: no native change to the CTC-aligner's DP itself, no retraining/re-export of
     the pronunciation head — this was purely aggregation/reporting + presentation, per the
     "preserve the native inference and scoring engine" instruction.

## Status: Flutter Tajweed practice UI — Phase 5 started (2026-07-29)
Per explicit instruction, started the production Flutter UI on top of the existing,
**unchanged** native engines (Phases 2-3) and **unchanged** AI Asset Manager/downloader
(ADR-008/009). This supersedes the "wait for FROZEN gate" note below for UI work only —
iOS production model validation is still blocked on the HF CoreML gate (see FROZEN block),
so this UI is exercised for real only on Android today; on iOS `ensureModel()` will
surface `MODEL_MISSING`/download-screen errors gracefully (no catalog provisioned there).

**What was built (Dart only — no native/downloader changes):**
- `lib/features/tajweed/model/tajweed_practice_args.dart` — nav payload (surah, ayah,
  arabic text, optional surah name/translation), passed via go_router `extra`.
- `lib/features/tajweed/viewmodel/tajweed_practice_view_model.dart` — `ChangeNotifier`
  state machine: `checkingModel` → (`isAvailable()` fast path, else `downloadingModel`
  via `ensureModel()` + `downloadProgress()`) → `recordingReady` ⇄ `recording` →
  `scoring` → `result`. Wraps mic permission request, native event stream
  (`interrupted`/`modelUnloaded`), per-`TajweedErrorCode` friendly messages, and saves
  a `TajweedHistoryEntry` via the existing `TajweedHistoryStore` on successful scoring.
- `lib/features/tajweed/view/tajweed_practice_screen.dart` +
  `view/widgets/{tajweed_download_view,tajweed_recording_view,tajweed_result_view}.dart`
  — one screen, body swapped by stage: one-time download-progress view (auto-continues
  to recording on success, Retry/Not-now on failure), record/stop mic UI with live
  elapsed timer and error banners (incl. "Open app settings" for mic-permission-denied),
  and a results view (word-accuracy %, exact-match badge, colored per-token chips using
  the existing ADR-006 `TajweedToken`/`TajweedTokenStatus` schema, Try Again/Done).
- New go_router route `RouteNames.tajweedPractice` (`/tajweed/practice`) registered in
  `app_router.dart`; `lib/features/tajweed/tajweed_entry_point.dart` is a small shared
  helper (`isEnabled()` + `open()`) used by all entry points below.
- **Entry points:** (1) Settings → new "AI Tajweed Practice (Beta)" toggle (production,
  not debug-gated) writing `StorageService.tajweedEnabled` — this is now the real
  rollout switch, separate from the temporary Android debug harness below. (2) A mic
  icon per ayah, shown only when the toggle is on, in `SurahDetailBottomSheet` (inline
  ayah rows) and `AyahCard` (used by `JuzReadingScreen`) — both navigate to
  `TajweedPracticeScreen` with that ayah's surah/ayah/arabic text/translation.
  `MushafPageScreen` has no per-ayah entry (renders whole pages, not ayah rows).
- Audio recording → ONNX inference pipeline itself required **no new native code** —
  it was already fully implemented and validated in Phases 2-3
  (`TajweedService.startRecording`/`stopRecordingAndScore` already drive the complete
  record → mel → ONNX ASR → CTC decode/align → pronunciation head → lexical scoring →
  JSON pipeline on Android, CoreML equivalent on iOS). This session only added the
  Flutter UI/ViewModel layer consuming that existing contract.

**Verified:** `flutter analyze` clean (only pre-existing, unrelated warnings/infos
remain); `flutter build apk --debug` — **BUILD SUCCESSFUL**.

**Not done / explicitly out of scope this pass:**
- No l10n strings added for the new screens (plain English, matching the existing debug
  screen's precedent) — follow-up if this ships broadly.
- `MushafPageScreen` (page-image reading mode) has no Tajweed entry point (no per-ayah
  row to attach it to).
- No on-device/emulator manual QA of the new screens yet (build-verified only this pass).
- iOS: nothing native changed; the UI will only reach `recordingReady` on iOS once its
  `catalogURL` is provisioned (still blocked — see FROZEN block) or a local
  `TajweedImport` debug pack is present.

**Next action:** manual QA on a real Android device/emulator with the model installed
(full record → score → result loop, permission-denied path, interrupted-recording path),
then decide on l10n and the Mushaf-page entry point.

## Status: Temporary Android Tajweed Asset Debug UI (2026-07-29)
Temporary harness for manual download QA — **not** product UI.
- Screen: `lib/features/tajweed/view/tajweed_asset_debug_screen.dart`
- Entry: Settings row, gated `kDebugMode && Platform.isAndroid` in
  `settings_tab_screen.dart`
- Actions: `ensureModel()` (auto-enables `StorageService.tajweedEnabled`), live
  `TajweedService.downloadProgress()` bar, `isAvailable()` status, delete
  `…/files/TajweedModels` after `dispose()` for repeat first-install tests
- **Remove** this screen + Settings row when download QA is done

## Status: Android production AI asset downloading — ENABLED + verified on real Cloudflare R2 (2026-07-29)
`TajweedAssetDistributionConfig.catalogUrl` (Android only) now points at the real,
live bucket: `https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev/catalog.json`
(1 pack: `hafs-en-v1`, kind `tajweed_model`, v1.0.0, ~464MB). iOS is **unchanged** —
`catalogURL` still `nil` there; this activation is Android-only per instruction.

**Critical bug found and fixed:** `HttpUrlConnectionAssetTransport.fetchAppending()`
(`android/.../assetdownload/AssetTransport.kt`) used
`connection.inputStream.use { it.readBytes() }` — buffering the **entire remaining
HTTP response body in one in-memory `ByteArray`**. This OOM-crashed on first real
contact with the real ~464MB/458MB encoder file (confirmed via `am instrument`:
`java.lang.OutOfMemoryError: Failed to allocate a 134217744 byte allocation`). Fixed by
streaming in bounded 8MB chunks (64KB buffer) directly to the destination `RandomAccessFile`,
returning `isComplete=false` between chunks so `AssetDownloadManager`'s existing outer
loop issues a fresh Range request per chunk — same public contract, no caller changes
needed. **This bug would have hit on iOS too if not for CoreML's different (streaming)
transport path being unexercised at this size until now; **confirmed iOS's
`URLSessionAssetTransport.fetchAppending` (`ios/Runner/AssetDownload/AssetTransport.swift`)
has the exact same class of bug** — `session.dataTask(with:)` buffers the whole response
`Data` in memory before the completion handler fires. Not fixed this pass (out of scope —
Android-only activation was requested and iOS's `catalogURL` is still `nil`/inert), but
must be fixed (same bounded-chunk streaming approach, or switch to
`URLSession.downloadTask`) before iOS's catalog is ever activated — logged as new
technical debt, see `memory/technical-debt.md`. Unit tests (`FakeAssetTransport`-based,
both platforms) never caught this because the fake doesn't touch real HTTP/large
payloads — this is now a known test-coverage gap on both platforms.

**Test-isolation fix (also required):** `AIAssetManager.shared` is a process-wide
singleton, and `ModelStore`'s lazy `assetSync` always overwrites
`AIAssetManager.shared.catalogUrl` with `TajweedAssetDistributionConfig.catalogUrl` on
first touch. Once that config pointed at a real URL, `TajweedAssetSyncTest` and
`TajweedEngineRobolectricTest` (which call the real `ModelStore`/`TajweedEngine`, not a
fake) started making **real network calls during `./gradlew testDebugUnitTest`** (one
even OOM'd in the JVM sandbox). Fixed by making `TajweedAssetDistributionConfig.catalogUrl`
a `var` (was `val`) and adding `@Before`/`@After` in both test files to null it out for
the duration of each test — no `AIAssetManager`/`ModelStore` production logic changed,
only test hygiene. **Any new test that calls the real `ModelStore.ensureModel()`/
`TajweedEngine.ensureModel()` must do the same or it will hit real network.**

**Detailed logging added** (additive `Log.i`/`Log.d`/`Log.w`/`Log.e` only, no behavior
changes) across `AIAssetManager.kt`, `AssetDownloadManager.kt`, `AssetTransport.kt`,
`ModelStore.kt`, `TajweedAssetSync.kt` for: catalog fetch, manifest fetch, per-file
download (incl. resume-from-`.part` and retry/backoff), SHA-256 verification (per
artifact), activation, and cache-hit short-circuits. Also added automatic cleanup of a
corrupted/failed staged download in `AIAssetManager.syncFromCatalog` (a real gap: a
failed `plugin.install()` previously left the downloaded-but-unverified files on disk
indefinitely instead of deleting them immediately).

**On-device validation (Pixel_7 emulator, real network to the real R2 bucket, no
mocks):** new `android/app/src/androidTest/kotlin/.../assetdownload/
ProductionCatalogDownloadTest.kt` drives the exact production singletons
(`TajweedEngine`/`ModelStore`/`AIAssetManager.shared`) an eventual Flutter
`ensureModel()` call would reach. **4/4 passing** (`am instrument`, ~121s total):
1. First install with **no local model** + a simulated interrupted prior download
   (pre-seeded 5MB `.part` file) — resumes via HTTP Range from byte 5,242,880 instead of
   restarting, downloads all 4 artifacts, SHA-256-verifies all of them against the real
   manifest hashes, activates. A broken resume would have failed SHA-256 verification
   and failed this test.
2. Cache-hit fully offline (wifi+data disabled via shell) — completed in 7ms, zero
   network.
3. Model survives a fresh `ModelStore` instance (proxy for app-restart persistence) with
   correct SHA-256 still matching.
4. Version re-check against the live catalog (cache window forced stale) — same version
   detected, **no re-download** of the 464MB artifact (0.7s vs. the ~114s full download).

Corrupted-file detection was **not** re-validated on-device this pass (impractical
against an immutable real R2 bucket) — already covered by existing, still-passing JVM/
Robolectric tests exercising the identical `verifyStaging`/`verifySha` code path:
`TajweedAssetSyncTest.checksumMismatch_onFirstInstall_neverActivates`,
`TajweedModelIntegrityTest.tamperedEncoderHashIsRejected`.

**Full test suites re-verified green after all fixes:** `./gradlew :app:testDebugUnitTest`
— BUILD SUCCESSFUL, 0 failures.

**Explicitly NOT done this session (per instruction):** no Flutter Tajweed UI. iOS
`catalogURL` left `nil` (Android-only activation as requested).

**Next action (await explicit approval):** decide whether to activate iOS's catalog too
(after auditing `URLSessionAssetTransport` for the same large-file-buffering risk), or
proceed to Flutter Tajweed UI (Phase 5), or hold per the FROZEN block below.

## 🔒 PROJECT FROZEN: Tajweed AI — resume only when HF CoreML access is granted
**Superseded for Flutter UI work only, 2026-07-29** (explicit instruction to start
Phase 5 — see "Flutter Tajweed practice UI — Phase 5 started" status block above).
The native-engine/model-validation gate below still applies as-is for iOS; do not
change native Tajweed engine code or the downloader based on this override — it
covers Dart/UI work only.
**Do not modify the Tajweed implementation, start the Flutter Tajweed UI, or add
features. Bug fixes only.** Approved-complete checklist:
- ✅ Flutter architecture / shared contracts (`TajweedService`, models, history store)
- ✅ iOS native implementation (`ios/Runner/Tajweed/`)
- ✅ Android native implementation (`android/.../tajweed/`)
- ✅ Android end-to-end validation (Pixel_7 emulator, 3/3 golden clips exact-match)
- ✅ Cross-platform mel preprocessing parity (TD-009 fixed, corr ≥ 0.9998)
- ✅ ADRs (006, 007) and JSON contract frozen
- ⏳ **iOS production validation** — blocked on HF gated download access to
  `Muno459/fastconformer-quran-coreml-offline` (metadata/LICENSE access works;
  `.mlpackage` weight blobs 403 — re-confirmed 2026-07-29, see
  `memory/features/tajweed/ai-readiness-report.md` §8)

**Exact resume steps once HF grants download access** (do these in order, nothing
else, then stop for approval again):
1. Run `tajweed-lab/scripts/download_coreml_offline.py`; install the pack for iOS
   Simulator/device (`Documents/TajweedImport`).
2. Run the existing iOS validation suite (`ios/RunnerTests/RunnerTests.swift`) plus
   `TajweedDebugRunner` against the real weights.
3. Run inference on the same 3 golden clips Android used
   (`tajweed-lab/samples/*.wav`, same set as `tajweed_parity_android.json`).
4. Compare iOS vs Android: transcript, alignment, pronunciation score, confidence,
   JSON schema (reuse `tajweed-lab/scripts/parity_compare_mel.py` pattern / write an
   equivalent e2e comparator like `parity_dump_onnx_e2e.py`).
5. Run validation on a physical iPhone (not Simulator).
6. Record final benchmarks: cold load, warm load, inference time, peak memory, CPU.
7. Produce a final production validation report (extend
   `memory/features/tajweed/ai-readiness-report.md`).

**If and only if all of the above pass:** mark the AI engine **Production Ready**
in this file and `memory/features/tajweed/overview.md`, then begin the full-screen
Flutter Tajweed UI (Phase 5). Do not skip ahead to UI work before this gate clears.

**ADR-008/ADR-009 downloader + AI Asset Manager — now implemented (2026-07-29), but
not yet activated:** `memory/decisions/ADR-008-tajweed-production-model-distribution.md`
(generic native download engine) + `memory/decisions/ADR-009-ai-asset-manager.md`
(generic multi-asset orchestrator — `AIAssetManager`/`AIAssetPlugin`, Tajweed as the
first registered plugin, Cloudflare R2 as the chosen host) document and record the
full implementation on both iOS/`ios/Runner/AssetDownload/` +
`ios/Runner/Tajweed/{TajweedAssetSync,TajweedAssetDistributionConfig}.swift` and
Android/`.../assetdownload/` + `.../tajweed/{TajweedAssetSync,
TajweedAssetDistributionConfig}.kt`. Reuses the existing `ensureModel()` Dart call and
`ModelStore` verify/activate/rollback/SHA-256 code **unchanged** — no Flutter,
MethodChannel, EventChannel, or JSON-schema changes. Full unit test coverage (first
install, update, resume-after-interruption, checksum mismatch, rollback,
offline/catalog-unavailable, insufficient storage, generic multi-plugin isolation)
passes on both platforms with no regressions (iOS 40/40, Android full suite green).
**Still inert in practice:** `TajweedAssetDistributionConfig.catalogURL`/`catalogUrl`
is `nil`/`null` on both platforms (no real Cloudflare R2 bucket/catalog exists yet),
so `ensureModel()` falls straight through to the pre-existing local-import-dir /
`MODEL_MISSING` behavior — this is intentional and safe, and does not unblock the HF
CoreML weight problem above (that's a separate, still-open blocker: even once a
catalog/bucket exists, it can only host the **official** CoreML pack, which this dev
account still cannot download). Next real step for this thread: once HF access is
granted and the official `.mlpackage`/ONNX packs are in hand, provision the real
Cloudflare R2 bucket (ADR-009 §2), use `tool/ai_assets/{generate_manifest,
generate_catalog}.py` to populate `catalog.json` + per-pack manifests, and point
`TajweedAssetDistributionConfig.catalogURL` at it — do not do this before then.

## Status: Tajweed — ADR-009 generic AI Asset Manager implemented & tested (2026-07-29)
Refactored the ADR-008 Tajweed-only downloader into a generic, multi-asset
**AI Asset Manager** per reviewer request ("one system: AI Asset Manager ├── Tajweed
Models ├── Qari Audio Packs ├── Translation Packs ├── Tafsir Packs ├── Future AI
Models" instead of separate downloaders per asset kind). Full design + Cloudflare R2
hosting/release/rollback guide: `memory/decisions/ADR-009-ai-asset-manager.md`.

**What changed (both platforms, symmetric):**
- New generic layer: `AIAssetPlugin` protocol/interface (identity + isAvailable +
  fileSpecs + install) and `AIAssetManager` class (catalog fetch, per-asset 24h
  freshness cache, version comparison, staging lifecycle, exact-`assetId` catalog
  lookup — no fallback-to-default across unrelated assets). Neither file references
  Tajweed, ONNX, or ModelStore.
  - iOS: `ios/Runner/AssetDownload/{AIAssetPlugin,AIAssetManager}.swift`
  - Android: `android/app/src/main/kotlin/.../assetdownload/{AIAssetPlugin,AIAssetManager}.kt`
- `AssetCatalogModels`/`AssetCatalogEntry` gained one optional `kind: String?` field
  (free-form, e.g. `"tajweed_model"`/`"qari_audio"`) on both platforms — additive,
  backward-compatible with the ADR-008 v1 catalog shape.
- `TajweedAssetSync` refactored from a standalone adapter into the first registered
  `AIAssetPlugin` (assetId `"hafs-en-v1"`, kind `"tajweed_model"`); its manifest
  key names, install semantics, and delegation to the **unmodified**
  `ModelStore.installFromDirectory` are unchanged.
  `TajweedAssetDistributionConfig.defaultPackId`/`DEFAULT_PACK_ID` renamed to
  `.assetId`/`.ASSET_ID`. `ModelStore.ensureModel()` on both platforms now lazily
  registers `TajweedAssetSync` with `AIAssetManager.shared` on first use and calls
  through the manager instead of the adapter directly — the `MODEL_MISSING`
  fallback contract and all other observable behavior is byte-for-byte unchanged.
- **Hosting decision finalized: Cloudflare R2** (not Firebase Storage — the user
  corrected this mid-session). Zero native code impact: both platforms' transport
  layers (`URLSessionAssetTransport` / `HttpUrlConnectionAssetTransport`) are plain
  HTTPS GET + `Range`-header clients with no vendor-specific code, confirmed by
  re-reading both. Only docs/tooling reference the host.
- New Phase A release tooling (stdlib-only Python, asset-kind-agnostic):
  `tool/ai_assets/{generate_manifest.py,generate_catalog.py,README.md,specs/*.example.json}`
  — computes SHA-256 per artifact and `approxSizeBytes` per platform automatically;
  manually smoke-tested end-to-end (happy path + duplicate-packId + missing-file
  error paths) outside the app tree.

**Tests (no regressions):**
- iOS: `ios/RunnerTests/AIAssetManagerTests.swift` (new, generic `FakePlugin`-driven:
  unregistered-plugin error, two independent assets sharing one catalog without
  interference, first-install-when-unavailable) + `TajweedAssetSyncTests.swift`
  (updated to drive `TajweedAssetSync` through a real `AIAssetManager` instance;
  added `testCatalogWithUnrelatedAssetEntryIsIgnored`). **40/40 passing**
  (`xcodebuild test`, iPhone 16 Simulator).
- Android: `android/app/src/test/kotlin/.../assetdownload/AIAssetManagerTest.kt` (new,
  Robolectric-backed for real `org.json` behavior — plain JUnit hit the Android SDK's
  stub `org.json` returning nulls) + `TajweedAssetSyncTest.kt` (same update pattern +
  `catalogWithUnrelatedAssetEntry_isIgnored`). `./gradlew :app:testDebugUnitTest` —
  **BUILD SUCCESSFUL**, 0 failures across the full Tajweed + assetdownload suite.
- `ios/Runner.xcodeproj/project.pbxproj` updated for the 2 new Runner sources + 1 new
  RunnerTests file.

**Not activated in production:** same as ADR-008 before it — no real Cloudflare R2
bucket/catalog exists yet, `catalogUrl`/`catalogURL` stays `nil`/`null` on both
platforms, so every plugin's `ensureAsset()` is inert. Only Tajweed is registered
today; Qari audio / translation / tafsir packs are designed-for but not built (no
new plugin implementations were added for them, per instruction to stop after the
downloader + asset manager are complete and tested).

**Explicitly NOT done this session (per instruction):** Flutter Tajweed UI — no
Dart/UI files touched. Qari/translation/tafsir `AIAssetPlugin` implementations —
architecture supports them (proven generic by the `FakePlugin` tests) but none were
built; that's future work once a concrete asset (e.g. a specific Qari's audio pack)
is scoped.

**Next action (await explicit approval):** either (a) provision the real Cloudflare
R2 bucket once official Tajweed model weights are available (still blocked on the HF
gate — see FROZEN block above) and cut the first real release via
`tool/ai_assets/`, or (b) scope and build the first non-Tajweed `AIAssetPlugin`
(e.g. a Qari audio pack) using this same infrastructure.

## Status: Tajweed — ONNX→production CoreML feasibility CLOSED (2026-07-29)
Research-only follow-up to the DIY POC. Question: can
`model_with_encoder.onnx` become a production CoreML pack with variable/bucket
input, `predict_T*` multifunction API, FP16 without NaNs, and ONNX transcript
parity?

**Answer: No.** CT does not export multifunction `predict_T*` from ONNX in one
shot (merge-only via `MultiFunctionDescriptor`). The ONNX graph is full
self-attention with **no** windowed-attention nodes; official ANE packs require
windowed attention + pos-enc clamps. Stock FP16 conversion yields NaN logprobs.
FP32 host parity does not unlock ANE production.

**Action:** Permanently keep official CoreML as production source (ADR-004
reaffirmed). Close DIY productionization track. Report:
`memory/features/tajweed/onnx-to-coreml-production-feasibility.md`.

## Status: Tajweed — DIY ONNX→CoreML research POC (lab-only, 2026-07-29)
Isolated experiment under `tajweed-lab/experiments/diy_coreml_poc/`. **No production
iOS/Flutter/Android code changed.** Converted local ONNX encoder + pronunciation head
via onnx2torch→coremltools; ran 3 golden WAVs; compared to Android parity JSON.

- FLOAT16 encoder: **all-NaN logprobs** → garbage `<unk>` transcripts.
- FLOAT32 fixed-T=480 encoder: **3/3 transcript exact match vs Android**; mean |Δprob|
  ≤ 0.003; alignment ≤ 1 frame (80 ms); token statuses identical.
- Verdict: `HOST_PARITY_OK_BUT_NOT_PRODUCTION_DROP_IN` — do **not** swap into
  `ModelStore` / replace HF ANE packages. Keep ADR-004.
- Report: `memory/features/tajweed/diy-coreml-poc-parity-report.md`

## Status: Tajweed — ADR-008 generic asset-download framework implemented & tested
Implemented the full ADR-008 design: a generic, Tajweed-independent
`AssetDownload` framework on both platforms (download manager with resumable
`.part`-file HTTP Range downloads, retry/backoff, cancellation, pre-flight
insufficient-storage checks, SHA-256 integrity verification, rollback manager, atomic
installer, progress notifier, catalog/manifest models + fetcher, transport
abstraction), plus a thin Tajweed-specific adapter (`TajweedAssetDistributionConfig` +
`TajweedAssetSync`) wired into `ModelStore.ensureModel()` on both iOS and Android. No
Flutter API, MethodChannel, EventChannel, ADR-006 JSON schema, or ADR-007
lifecycle/verify/activate/rollback code was touched — the adapter only supplies a new
**input source** (downloaded staging dir) to the existing `installFromDirectory` flow.

**Files added:**
- iOS framework: `ios/Runner/AssetDownload/*.swift` (9 files)
- iOS adapter: `ios/Runner/Tajweed/{TajweedAssetDistributionConfig,TajweedAssetSync}.swift`
- iOS tests: `ios/RunnerTests/{FakeAssetTransport,AssetDownloadManagerTests,
  TajweedAssetSyncTests}.swift`
- Android framework: `android/app/src/main/kotlin/.../assetdownload/*.kt` (9 files)
- Android adapter: `android/app/src/main/kotlin/.../tajweed/{TajweedAssetDistributionConfig,
  TajweedAssetSync}.kt`
- Android tests: `android/app/src/test/kotlin/.../assetdownload/{FakeAssetTransport,
  AssetDownloadManagerTest}.kt`, `.../tajweed/TajweedAssetSyncTest.kt`
- `ios/Runner.xcodeproj/project.pbxproj` updated to register all new Swift files
  (Runner target for framework/adapter, RunnerTests target for the 3 new test files).

**Files modified:** `ModelStore.swift` (iOS) and `ModelStore.kt` (Android) —
`ensureModel()` now delegates to `TajweedAssetSync` for update-checks and first
installs, with the original `MODEL_MISSING` behavior preserved as the final fallback.

**Test results (no regressions):**
- iOS: `xcodebuild -workspace Runner.xcworkspace -scheme Runner -destination
  'platform=iOS Simulator,name=iPhone 16' -only-testing:RunnerTests test` — **36/36
  passing** (21 pre-existing Tajweed tests + 7 `AssetDownloadManagerTests` +
  8 `TajweedAssetSyncTests` = 15 new). Covers: first install, update detected + activated,
  same-version no-redownload, resumed-after-interruption, transient-network-blip retry,
  checksum-mismatch rejection
  (never activates), failed-update rollback (previous model stays active),
  catalog-unreachable (keeps existing model working), insufficient storage (fails before
  any network call), cancellation.
- Android: full Tajweed + downloader suite — **39/39 passing** (24 pre-existing:
  `TajweedAlgorithmTest` ×11, `TajweedEngineRobolectricTest` ×10,
  `TajweedModelIntegrityTest` ×2, `TajweedMelParityTest` ×1; + 15 new:
  `AssetDownloadManagerTest` ×7, `TajweedAssetSyncTest` ×8) via
  `./gradlew :app:testDebugUnitTest`, JUnit XML reports confirmed 0 failures/errors —
  same scenario coverage as iOS.

**Not activated in production:** `TajweedAssetDistributionConfig.catalogURL`
(iOS)/`catalogUrl` (Android) is still `nil`/`null` — no real object-storage bucket or
catalog has been provisioned. Until that's set, `ensureModel()` behaves exactly as
before this change (local `TajweedImport` import dir, or `MODEL_MISSING`). See
`memory/decisions/ADR-008-tajweed-production-model-distribution.md` "Implementation"
section for full detail.

**Next action:** wait for explicit approval before integrating this with the Flutter
UI (per reviewer instruction) — no Flutter Tajweed UI work has started. The framework
and adapter are otherwise complete and dormant until (a) HF grants CoreML weight
access (separate, still-open blocker) and (b) real object storage + a populated
catalog are provisioned and pointed to by `TajweedAssetDistributionConfig`.

## Status: Tajweed — AI engine "Implementation Complete – Pending Production Model Validation"
Per reviewer instruction: Android AI pipeline is **approved**. The only remaining
blocker for iOS production validation (and therefore for cross-platform parity,
real-device QA, and final benchmarks) is Hugging Face gated-download access to
`Muno459/fastconformer-quran-coreml-offline` — re-verified today by re-running
`tajweed-lab/scripts/download_coreml_offline.py`, still `403 Client Error` on
`Manifest.json`/encoder/head weight blobs (metadata/LICENSE access works; file
download does not). No code, Flutter API, MethodChannel/EventChannel, or ADR was
touched this pass since no further engine work is possible without the weights.

**Blocked downstream of the HF gate (cannot start until it's resolved):**
1. iOS end-to-end inference with production CoreML weights.
2. iOS vs Android parity comparison (transcript, pronunciation score, alignment,
   confidence, JSON schema) using production models on both platforms.
3. Physical iPhone validation (device was reachable wirelessly in a prior session
   but has no CoreML pack to run; not re-checked this pass since it's moot until
   weights exist).
4. Final iOS benchmarks (cold/warm load, inference, peak memory, CPU).

Android's equivalents (2–4, for Android) are already done — see the entry below and
`memory/features/tajweed/ai-readiness-report.md`.

**Next action:** wait for Hugging Face to grant download access to the gated CoreML
repo (not just metadata access) for the token in `tajweed-lab/.env`, then resume at
step 1 above. Do **not** start the Flutter Tajweed UI until iOS production validation
completes or you explicitly waive it.

## Status: Tajweed — Android AI pipeline ready; iOS CoreML still blocked; awaiting UI approval
Full report: `memory/features/tajweed/ai-readiness-report.md`.

**Done this session:**
- TD-010: exported `pronunciation_head.onnx`, wired into Android (int64 tokens, encoder
  transpose, no mel-bucket pad for ONNX, ModelStore rename-activate).
- Host + Pixel_7 emulator e2e on 3 golden clips: all `exactMatch=true`, ADR-006 JSON.
- Benchmarks (emulator): ensureModel ~1s, first warm ~1.2s, inference 130–275ms.
- Flutter API / MethodChannel / JSON schema untouched.

**Still blocked:**
- iOS CoreML weight download (HF 403 on `.mlpackage` blobs).
- Physical Android / iPhone inference QA (no physical Android; iPhone online but no CoreML pack).
- Peak memory / CPU instrumentation not collected.

**Next action (await explicit approval):** Flutter full-screen Tajweed UI (Phase 5), or
pause until HF CoreML access + physical-device QA.

## Status: Tajweed — TD-009 fixed (iOS/Android mel preprocessing now equivalent)
`ios/Runner/Tajweed/MelFrontend.swift`'s Hann window now uses the exact same formula as
Android/Python (see `memory/technical-debt.md` TD-009, now closed) instead of
`vDSP_hann_window(..., vDSP_HANN_NORM)`. Re-ran the Phase 4A mel parity harness on the
same 3 real golden clips: iOS vs Android correlation improved from ≥0.998 to
**≥0.9998** (one sample hits **1.0000**), mean|Δ| dropped from ~0.03 to **~0.002 or
better**, max|Δ| dropped from up to 2.36 to at most 0.16 — and that residual is fully
explained (one numerically-degenerate, near-silent mel bin, constant across all frames,
not a signal-processing bug — detail in TD-009). All 21 iOS XCTests still pass
unmodified; only `MelFrontend.swift` changed — no Flutter, MethodChannel/EventChannel,
JSON schema, or Android/Kotlin changes. **iOS and Android mel preprocessing are now
equivalent for practical purposes.**

Only `MelFrontend.swift` changed for this fix; the rest of the Phase 4A picture from
2026-07-28 (below) is unchanged — full transcript/score/confidence parity and real
model integrity for iOS are still blocked on the HF gate (metadata access ≠ file-
download access — confirmed twice now), Android's pronunciation head still needs a
PyTorch→ONNX export (TD-010), and no physical iPhone/Android device is attached to this
dev machine.

**Next action (await explicit approval):** decide whether to proceed to Phase 4B/5
(Flutter UI) with the remaining known gaps (HF gate, TD-010, no real device) still open
and flagged, or pause further until those are resolved.

## Status: Tajweed — Phase 4A (Golden Parity Testing) partially complete, approved with TD-009 fix required (now done, see above)
Branch `feature/Quran` (uncommitted). Scope actually achievable in this dev environment
was constrained by two hard blockers discovered/reconfirmed during this phase — see
"Blockers" below. Full results, commands to reproduce, and raw data:
`tajweed-lab/parity/reports/` (gitignored — see report doc for a mirror in memory).

**What Phase 4A actually validated (real, on real golden audio, real weights where available):**
1. **Mel spectrogram parity** (`tajweed-lab/scripts/parity_compare_mel.py` diffing
   `tajweed-lab/parity/python/*.json` vs `/tmp/tajweed_parity/{ios,android}/*.json`,
   produced by `RunnerTests.testPhase4AMelParityDumpOnGoldenSamples` and
   `TajweedMelParityTest.dumpMelForGoldenSamples` on the real
   `tajweed-lab/samples/*.wav` clips): **Android matches the Python reference almost
   exactly** (mean|Δ| ≈ 0.005–0.010, corr ≥ 0.996). **iOS shows a real, non-trivial
   divergence** from both Python and Android (max|Δ| up to ~2.4, ~3–4% of values exceed
   a 0.15 tolerance, corr still ≥ 0.992) — this is TD-009 (new), a confirmed, measurable
   version of the mel-windowing-convention risk flagged in Phase 3. **Action needed
   before Phase 4B:** fix `MelFrontend.swift`'s Hann window per TD-009 and re-run this
   comparison.
2. **Model integrity (SHA-256 + manifest)** — Android only, for real:
   `TajweedModelIntegrityTest` (`android/app/src/test/kotlin/.../tajweed/`) ran
   `ModelStore.installFromDirectory`/`verifyStaging` against the **real** ONNX encoder
   already present locally (`tajweed-lab/models/onnx/model_with_encoder.onnx`, 458MB,
   sha256 `417da4c1...`) plus real tokenizer/tokens, confirmed a correct-hash pack
   installs and activates, and confirmed a tampered-hash pack is rejected
   (`MODEL_DOWNLOAD_FAILED`) and never becomes active. iOS-side real integrity check is
   still blocked (no real `.mlpackage` files downloadable — see Blockers).
3. **Python reference transcripts** for the 3 golden clips, using the *same* ONNX
   encoder Android's `OnnxAsrModel.kt` uses (`tajweed-lab/scripts/parity_dump_reference_transcripts.py`
   → `tajweed-lab/parity/reports/python_reference_transcripts.json`): established ground
   truth for future iOS/Android transcript comparison once both native engines can run
   real inference (see Blockers — neither could yet).

**What Phase 4A could NOT complete, and why (hard blockers, not skipped by choice):**
- **iOS real inference (transcript/alignment/pronunciation-score/confidence) — BLOCKED.**
  HF access to `Muno459/fastconformer-quran-coreml-offline` now resolves via
  `HfApi.model_info()` (metadata/file listing succeeds), but `hf_hub_download` for the
  actual `.mlpackage` blobs (`model.mlmodel`, `weight.bin` for both encoder and head)
  still 403s — confirmed by re-running `tajweed-lab/scripts/download_coreml_offline.py`
  in this session. Only `tokenizer.model`/`tokens.txt` (small, ungated-in-practice files)
  are present; no CoreML weights exist on this machine. **Unblock:** the repo owner needs
  to add this HF account to the gate's approved-members list (metadata access ≠ file
  download access on HF for gated repos); then re-run the download script.
- **Android real pronunciation-head inference — BLOCKED.** Only a PyTorch checkpoint
  (`tajweed-lab/models/head/pronunciation_head.pt`) exists; no ONNX export. See TD-010.
  Encoder-only (transcript) inference on-device was not attempted this session either —
  the ONNX Android AAR's native libs only run inside an Android runtime (confirmed by
  the Phase 3 `UnsatisfiedLinkError` fix), so a real on-device/emulator instrumented-test
  run is still open work, not just a code change.
- **Real device testing — NOT MET.** This dev machine has no physical iPhone or Android
  device currently connected (`xcrun xctrace list devices` shows all real iPhones as
  "Offline"; `adb devices` returns empty; `flutter devices` only finds the iOS
  Simulator). All Phase 4A work above ran on iOS Simulator + JVM/Robolectric (Android
  unit tests execute on the host JVM, not an emulator). The mel/integrity code paths
  exercised are the exact same production Swift/Kotlin, so this is strong evidence but
  not a substitute for real-hardware validation (NNAPI/ANE-specific behavior, real mic
  input, thermal/battery conditions are all untested).

**Next action (await explicit approval):** fix TD-009 (iOS Hann window) and re-run
`parity_compare_mel.py`; once the HF gate is actually approved for downloads and/or a
physical device + pronunciation-head ONNX export are available, re-run Phase 4A's
transcript/score/confidence comparisons for real. Do not start Phase 4B/5 (Flutter UI)
until those are resolved or explicitly waived.

## Status: Tajweed — Phase 3 (Android ONNX Runtime) complete, approved
Branch `feature/Quran` (uncommitted). Android debug APK **BUILD SUCCESSFUL**
(`flutter build apk --debug`, `./gradlew :app:assembleDebug`).

Phase 3 delivered — symmetric to `ios/Runner/Tajweed/`:
- Full Kotlin engine under `android/app/src/main/kotlin/com/app/deenly/deenly/tajweed/`
  (AudioRecorder using `AudioRecord`, MelFrontend with a hand-rolled radix-2 FFT,
  CtcDecoder, SentencePieceTokenizer, CtcAligner, OnnxAsrModel, PronunciationHeadModel,
  ModelStore, TajweedEngine, TajweedChannelHandler, TajweedLexicalScoring)
- ONNX Runtime Mobile (`onnxruntime-android:1.19.2`); NNAPI preferred, XNNPACK/CPU
  fallback (no standalone GPU delegate ships in the stock AAR — documented deviation,
  see Risks below)
- `RECORD_AUDIO` permission added to `AndroidManifest.xml`
- Channel wiring replaces Phase 1 placeholders in `MainActivity.kt` (Flutter contract
  unchanged); `onTrimMemory` / `onPause` forward to the engine like iOS's memory-warning
  / background notifications
- Unit tests: `android/app/src/test/kotlin/.../tajweed/` — 21 tests, all passing
  (`TajweedAlgorithmTest` pure-JVM: CTC decode/align, mel bucket shape, tokenizer
  round-trip, **mel golden-vector numeric parity against `tajweed-lab/web/asr/mel.py`**;
  `TajweedEngineRobolectricTest`: functional/error-mapping/threading, mirrors
  `ios/RunnerTests/RunnerTests.swift`)
- Fixed a **pre-existing** `android/app/build.gradle.kts` bug: the release
  `signingConfig` block crashed *any* Gradle invocation (including `assembleDebug`)
  on a fresh checkout with no keystore in `local.properties`. Now guarded by
  `hasReleaseSigning`.

**Blocker for on-device inference QA (same as iOS):** no ONNX encoder/pronunciation-head
weights bundled (no HF token in the app). `ModelStore.ensureModel()` looks for
`getExternalFilesDir(null)/TajweedImport` (adb-push debug path) and otherwise fails with
`MODEL_MISSING` — verified correct via `TajweedEngineRobolectricTest`.

**Next action (await explicit approval):** Phase 4A — Golden Parity Tests (iOS vs
Android, same audio samples vs `tajweed-lab/models/coreml/golden_transcripts.json`) —
**before any Flutter UI (Phase 5) work**, per reviewer's explicit request. Do not start
Phase 5 yet.

### Risks / deviations to review in Phase 4A
- **Mel windowing convention differs by design, not by mistake:** iOS uses
  `vDSP_hann_window(..., vDSP_HANN_NORM)` (power-normalized), Android/Kotlin uses the
  plain symmetric Hann matching `tajweed-lab/web/asr/mel.py` (`np.hanning`) exactly —
  confirmed via a hardcoded golden-vector test comparing Android's mel output to the
  Python reference on a synthetic tone (see `TajweedAlgorithmTest.melFrontendMatchesPythonReferenceOnSyntheticTone`).
  The two conventions differ by a constant per-frame power-scale factor, which the
  shared per-bin mean/var (CMVN) normalization step should cancel out — but this has
  **not** been cross-validated iOS vs Android on the same real audio yet. Do this first
  in Phase 4A.
- **No GPU delegate on Android.** The stock `onnxruntime-android` AAR doesn't ship a
  distinct GPU execution provider (unlike TFLite). Implemented fallback chain is
  NNAPI → XNNPACK → default CPU, not NNAPI → GPU → CPU as literally requested. NNAPI can
  itself route to GPU/DSP on some vendors' devices, but this isn't guaranteed.
- Android's `TajweedAudioRecorder` uses `AudioManager` focus-loss as the
  "interruption" signal (closest Android equivalent of iOS's
  `AVAudioSession.interruptionNotification`); not identically triggered (e.g. a phone
  call is one of several possible causes, not the only one).

## Status: Tajweed — Phase 2 (iOS CoreML) validated
iOS validation pass complete (see `ios/RunnerTests/RunnerTests.swift`, 20 tests, all
passing): functional (`ensureModel`/`prepareModel`/`startRecording`/
`stopRecordingAndScore`/`cancelRecording`/`dispose` state machine incl. `MODEL_MISSING`
/ `NOT_RECORDING` paths without a model pack installed), JSON shape (lexical token
report keys match ADR-006, no platform-specific fields), memory (20x
ensure/dispose cycles stable, `dispose()` idempotent), threading (engine completions
verified off the main thread — `TajweedChannelHandler` hops back to main exactly once
per call via `deliver`/`deliverJSON`, now with `[weak self]` throughout), error mapping
(`TajweedNativeError` → `FlutterError` code preserved, no raw Swift errors leak).
Real on-device transcription accuracy still blocked on the same HF gate as before.

Phase 2 delivered (recap):
- Full Swift engine under `ios/Runner/Tajweed/` (AudioRecorder, Mel, SP tokenizer,
  CTC decode/align, OfflineAsrModel, PronunciationHead, ModelStore, TajweedEngine,
  TajweedChannelHandler)
- DEBUG harness: `ios/Runner/Tajweed/Debug/TajweedDebugRunner.swift`
- Contract doc: `tajweed-lab/docs/COREML_CONTRACT.md`
- Download helper: `tajweed-lab/scripts/download_coreml_offline.py`
- Mic: Info.plist copy + Podfile `PERMISSION_MICROPHONE=1` +
  `PermissionService.requestMicrophone()`

**Blocker for on-device inference QA:** HF gate on
`Muno459/fastconformer-quran-coreml-offline` — current token got 403.
Accept access in browser, run `download_coreml_offline.py`, copy pack to
Simulator `Documents/TajweedImport`, then `ensureModel` / DebugRunner.

## Status: Tajweed Phase 1 — approved
Shared Flutter contract + ADR-006/007 landed previously.

## Status: Quran 2.0 Phase 1 — implemented, pending manual QA
Still in the same working tree.

## Performance measurements (Phases 2–3)
Cold/warm/inference timings are **not yet measurable** on either platform without the
real weight packs installed (same HF-gate blocker for both CoreML and ONNX artifacts).
`TajweedDebugRunner` (iOS) prints `coldSetupMs` / `totalWarmPathMs` / `inferenceMs` once
models are installed; Android's `TajweedEngine.scorePcmForDebug` returns the equivalent
`warmOrReuseMs` / `inferenceMs` map but has no bundled CLI harness yet (candidate for
Phase 4A). Targets remain ADR-007: warm load &lt;500ms, inference &lt;2s.
