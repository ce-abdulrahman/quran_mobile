# Changelog

All notable changes to **Quran Mobile** are documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.0.3+4] — 2026-07-04

### Mushaf Experience & Navigation Upgrade

#### Added
- **Split Home Cards**: Home screen now shows two independent entry-point cards:
  - **"موسحەف"** — opens the Mushaf Reader, resuming from the last read page (persisted under `quran.last_mushaf_page`).
  - **"قورئان"** — opens the Quran directory / Surah browser.
- **Page Zoom Controls**: Replaced font-size slider with a dedicated **Page Zoom** slider in the Mushaf settings sheet (1.0x-3.0x, 20 divisions). Value persisted to `quran.page_zoom`.
- **Pinch-to-Zoom**: InteractiveViewer with TransformationController allows fluid pinch-to-zoom inside every Mushaf page.
- **Double-Tap Zoom**: Double-tapping a page toggles between 1.0x and 2.0x zoom.
- **Gesture Conflict Resolution**: When zoom > 1.0 the PageView physics switch to NeverScrollableScrollPhysics, so horizontal swipe pans the page instead of turning it. Page turns resume automatically once zoom returns to 1.0.
- **Namespace Preference Keys**: All Mushaf reading state uses `quran.*` namespace:
  - `quran.last_mushaf_page`
  - `quran.last_surah`
  - `quran.last_surah_number`
  - `quran.last_ayah`
  - `quran.page_zoom`
- **Legacy Key Migration**: On first launch after upgrade, the old `mushaf_last_read_page` key is automatically migrated to `quran.last_mushaf_page` with no data loss.
- **Non-Reflowable Canvas**: MediaQuery inside InteractiveViewer forces TextScaler.noScaling — system font-scale changes no longer alter word positions on a Mushaf page.

#### Changed
- Mushaf page content no longer uses an inner SingleChildScrollView. The InteractiveViewer is the sole pan/zoom surface, giving an authentic fixed-page Mushaf feel.
- Mushaf page padding is now calculated from actual safe-area + toolbar heights, keeping content clear of overlapping bars at default zoom.
- Home page _buildQuranDualCards correctly imports MushafReaderPage and passes initialPage: lastPage for seamless resume.

#### Fixed
- Missing import for MushafReaderPage in home_page.dart (caused build failure when tapping the Mushaf home card).
- PageView and InteractiveViewer gesture conflict on zoomed pages — page turn no longer fires during pan gestures.

---

## [1.0.2+3] — 2026-06-30

### Previous Release

- Initial public feature set: Quran reader, Mushaf reader, Adhkar, Hadith, Prayer times, Tasbih, Memorization quiz, Reading tracker, Bookmarks, Favorites, Notes, Statistics, Khatm tracker, Search, Tajweed engine.
- Riverpod state management, Isar local database, offline-first architecture.
- Kurdish (Sorani), Arabic, and English localisation.
