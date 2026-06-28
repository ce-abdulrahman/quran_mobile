# V2 Deferred Features Registry & Roadmap

This document serves as the official registry of all features and architectural modules postponed from Version 1 (V1) to Version 2 (V2). This ensures that while V1 behaves as a complete standalone Offline-First Quran application, the foundation remains clean and ready for eventual cloud-synchronization integration.

---

## 1. Authentication Modules
### Login & Onboarding
* **V2 Target**: Standard credential-based login, Google Sign-In, Apple Sign-In, and full onboarding flow (`WelcomePage`).
* **V1 Behavioral State**: Hidden completely. Users enter immediately as guests.
* **Preserved Code**: 
  - [login_page.dart](file:///c:/Users/kurdn/Desktop/my-quran/quran_mobile/lib/features/auth/login_page.dart)
  - [welcome_page.dart](file:///c:/Users/kurdn/Desktop/my-quran/quran_mobile/lib/features/auth/welcome_page.dart)

### Registration
* **V2 Target**: Standard sign-up forms, username/email validations, and password resets.
* **V1 Behavioral State**: Hidden completely.
* **Preserved Code**: 
  - [register_page.dart](file:///c:/Users/kurdn/Desktop/my-quran/quran_mobile/lib/features/auth/register_page.dart)

---

## 2. Cloud Synchronization
### Database Synchronization
* **V2 Target**: Background data synchronization of Isar collections (Memorization progress, Tasbih session logs, bookmarks, and personal notes) via a background sync loop.
* **V1 Behavioral State**: Idle. Synchronization tasks are not invoked. Data is stored exclusively in local Isar collections on-device.
* **Preserved Code**:
  - [sync_engine.dart](file:///c:/Users/kurdn/Desktop/my-quran/quran_mobile/lib/core/services/sync_engine.dart)
  - [guest_memo_migration_service.dart](file:///c:/Users/kurdn/Desktop/my-quran/quran_mobile/lib/core/services/guest_memo_migration_service.dart)

### Conflict Resolution
* **V2 Target**: Server-mediated Last Write Wins (LWW) conflict resolution policy utilizing `updated_at` timestamps to merge changes across multiple active user devices.
* **V1 Behavioral State**: Bypassed. Single-device write operations.

---

## 3. Social & Leaderboard
### Global User Rankings (Leaderboard)
* **V2 Target**: Community dashboard displaying rankings of users based on daily tasbih sessions and memorization metrics.
* **V1 Behavioral State**: Hidden completely from home page quick actions.
* **Preserved Code**:
  - [leaderboard_page.dart](file:///c:/Users/kurdn/Desktop/my-quran/quran_mobile/lib/features/leaderboard/leaderboard_page.dart)
  - [leaderboard_provider.dart](file:///c:/Users/kurdn/Desktop/my-quran/quran_mobile/lib/core/providers/leaderboard_provider.dart)

---

## 4. User Profiles & Social Achievements
### Public Profiles
* **V2 Target**: Public user profiles where users can edit bios, nicknames, custom avatars, public titles, and public quotes.
* **V1 Behavioral State**: Bypassed. Users are given a local guest layout ("Quran Reader" / "Offline Mode") without editing options.
* **Preserved Code**:
  - [profile_page.dart](file:///c:/Users/kurdn/Desktop/my-quran/quran_mobile/lib/features/auth/profile_page.dart)
  - [profile_settings_page.dart](file:///c:/Users/kurdn/Desktop/my-quran/quran_mobile/lib/features/auth/profile_settings_page.dart)

### Achievements Sync
* **V2 Target**: Synchronizing unlocked user badges and streaks to cloud servers to prevent progress loss when switching or wiping devices.
* **V1 Behavioral State**: Handled local-only. Badges and streaks are saved in the local Isar database.

---

## V2 Integration Steps
1. **Security & Session Checking**: Re-enable `checkAuthState()` on application launch to restore secure token verification.
2. **UI Navigation**: Re-expose buttons and icons on the Home profile banner and settings list to route users to welcome, authentication, and ranks/leaderboard screens.
3. **Sync Triggers**: Re-bind Isar repository changes to write to the Hive outbox sync log (`sync_queue_box`) and call background uploads.
4. **Contextual Gates**: Re-enable `AuthGateCard` modal sheet prompts on pages like Memorization and Dhikr Goals.
