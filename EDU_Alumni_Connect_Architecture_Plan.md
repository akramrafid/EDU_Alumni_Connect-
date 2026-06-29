# EDU Alumni Connect — Architecture & Planning Document

**Project:** EDU Alumni Connect — alumni/student mentorship & networking platform for East Delta University
**Platforms:** Flutter mobile (iOS/Android) + Flutter Web admin dashboard
**Backend:** Firebase (Auth, Firestore, Cloud Functions, Storage, FCM) + Algolia for search
**Team:** 4 contributors

---

## 1. Scope & user roles

Three roles, enforced via Firebase Auth custom claims, not just hidden UI:

| Role | Who | Core capabilities |
|---|---|---|
| Student | Current EDU students (verified via university email) | Browse directory, request mentorship, message, RSVP events |
| Alumni | Graduates (manually verified by admin) | All student actions + accept/decline mentorship, post jobs |
| Admin | Faculty/team-designated moderators | Verify accounts, moderate content, manage events, view reports |

Core feature modules: **Auth & Verification, Profile, Alumni Directory, Mentorship, Chat, Events, Job Board, Admin Panel, Notifications.**

---

## 2. Architecture decision — Clean Architecture + feature-first + Riverpod

**Why Clean Architecture (Presentation → Domain → Data):**
- Four people need clear ownership boundaries without stepping on each other's code.
- Firebase is a *detail*. Business rules (who can mentor whom, what counts as a "verified" alumni) should be testable without spinning up Firebase.
- Swapping a data source later (e.g. Firestore → Postgres for one feature) becomes a new `Repository` implementation, not a rewrite.

**Why feature-first folders, not layer-first at the root:** each feature (`auth`, `directory`, `mentorship`, `chat`, `events`, `jobs`, `admin`) is self-contained with its own `data/domain/presentation`, so it can be assigned, reviewed, and even deleted independently.

**Why Riverpod (with code generation) over BLoC/Provider:** least boilerplate for the testability guarantee you get in return, strong compile-time safety, and it's the state management approach used in Flutter's own official recommended app-architecture sample. BLoC is an equally valid production choice — switch only if someone already has strong BLoC instincts.

**Supporting libraries:** `go_router` (declarative routing + auth guards), `freezed` (immutable models/unions), `fpdart` (`Either<Failure, Success>` instead of try/catch sprawl).

---

## 3. Frontend (Flutter)

### 3.1 Folder structure
```
lib/
  core/
    constants/          # API keys refs, route names, enums
    theme/               # design tokens, light/dark, Material 3
    router/              # go_router config + auth guards
    di/                  # Riverpod provider wiring
    errors/              # Failure types
    network/             # connectivity checks
  features/
    auth/                {data, domain, presentation}
    profile/             {data, domain, presentation}
    directory/           # alumni search & filters
    mentorship/          # request / accept / track
    chat/
    events/
    jobs/
    admin/               # role-gated, can compile to Flutter Web
    notifications/
  shared/                # reusable widgets, extensions, validators
  main.dart
  app.dart               # MaterialApp.router + theme + locale
```

### 3.2 State management pattern
- `AsyncNotifier` / `FutureProvider` for read flows (fetching directory, profile, events).
- `Notifier` for forms and mutations (mentorship request submission, profile edits).
- Every repository call returns `Either<Failure, T>` — UI never catches raw exceptions, it pattern-matches on `Failure` types (`NetworkFailure`, `AuthFailure`, `ValidationFailure`, `NotFoundFailure`).

### 3.3 Localization
Plan for **English + Bangla** from day one using `intl` + ARB files. Retrofitting this after 50 hardcoded screens is one of the most common avoidable rewrites on regional apps.

### 3.4 Testing pyramid
- **Unit tests** (mocktail) — use cases and repositories. This is where mentorship-matching logic, verification rules, and RBAC checks get proven correct.
- **Widget tests** — critical screens (login, directory list, chat thread).
- **Integration tests** — the 2–3 journeys that must never break: signup → verification, mentorship request → accept, send/receive a chat message.

### 3.5 Admin dashboard
Build as **Flutter Web**, reusing the same `domain`/`data` layers as mobile — do not start a second codebase in React/Next.js for this. Responsive layout (e.g. `LayoutBuilder`) handles the desktop-first admin UX.

---

## 4. Backend (Firebase)

### 4.1 Firebase Auth
- Email/password (and optionally Google sign-in) for students using university email domain.
- **Alumni verification flow** (the single most important backend workflow in this app): alumni self-register with batch/department/roll number → upload a degree certificate or ID to Cloud Storage → status = `pending` → admin reviews in the admin panel → Cloud Function sets `verificationStatus: verified` and assigns the `alumni` custom claim. Until verified, an alumni account can log in but cannot appear in the directory or accept mentorship requests.
- Custom claims (`role: student|alumni|admin`) are the single source of truth for permissions — never trust a Firestore field alone for security-critical checks, since claims are tamper-proof in the token while a document field is just data.

### 4.2 Cloud Firestore — schema sketch
```
users/{uid}
  role, verificationStatus, fullName, email, photoUrl,
  department, batchYear,
  alumni-only: currentCompany, jobTitle, certificateUrl
  createdAt, updatedAt

alumniDirectory/{uid}          # denormalized, public-readable search subset
  fullName, department, batchYear, currentCompany,
  skills[], location, photoUrl, verified: true

mentorshipRequests/{requestId}
  studentId, alumniId, status: pending|accepted|declined|completed
  message, createdAt

conversations/{conversationId}
  participantIds[], lastMessage, lastMessageAt
  /messages/{messageId}
    senderId, text, sentAt, readBy[]

events/{eventId}
  title, description, dateTime, location, bannerUrl, rsvpCount

jobPostings/{jobId}
  postedByAlumniId, title, company, description, applyLink, status

notifications/{uid}/items/{notificationId}
  type, title, body, read, createdAt
```
`alumniDirectory` is intentionally a separate, flattened collection — never query the full `users` collection for directory browsing. This keeps reads cheap and keeps sensitive fields (email, certificate URL) out of a publicly-listable collection.

### 4.3 Cloud Functions (the security gateway)
Nothing security-sensitive should be writable directly from the client. Functions own:
- Alumni verification approval (sets custom claim + writes to `alumniDirectory`)
- Mentorship request notifications (triggers FCM on new request / status change)
- Firestore → Algolia sync on every write to `alumniDirectory`
- Scheduled functions: event reminders, stale-request cleanup
- Basic rate limiting on chat/job-post writes to deter spam

### 4.4 Cloud Storage
Folders: `profile_photos/{uid}`, `certificates/{uid}` (admin-only read), `event_banners/{eventId}`. Storage security rules mirror Firestore role checks.

### 4.5 Search — Algolia
Sync a denormalized subset of `alumniDirectory` into Algolia via the Cloud Function trigger above. Firestore's standard edition still has no native full-text/multi-field search (only exact-match and prefix queries), so this bolt-on is the proven path — don't try to brute-force multi-field filtering with composite indexes alone.

### 4.6 Security rules — RBAC matrix
| Action | Student | Alumni | Admin |
|---|---|---|---|
| View own profile | ✓ | ✓ | ✓ |
| Browse alumni directory | ✓ (verified entries only) | ✓ | ✓ |
| Send mentorship request | ✓ | ✗ | ✓ |
| Accept/decline mentorship | ✗ | ✓ | ✓ |
| Post job listing | ✗ | ✓ | ✓ |
| Verify alumni accounts | ✗ | ✗ | ✓ |
| Moderate reports/content | ✗ | ✗ | ✓ |

### 4.7 Firebase App Check
Enable on Firestore, Functions, and Storage so requests must come from your real registered app — blocks scripted abuse that bypasses the UI entirely.

### 4.8 Worth knowing, not part of the MVP plan
Firebase shipped two relevant things in 2026: **Firestore Enterprise edition** now supports native full-text search and JOINs (still in preview), and **Firebase SQL Connect** (a managed Postgres option with Flutter SDK support) evolved from Data Connect. Both are promising for a future rewrite of the directory/reporting layer, but both are new enough — smaller community, separate cost models — that they're not where I'd bet a deadline-driven academic build. Revisit post-launch.

---

## 5. System design — key data flows

**Alumni signup & verification:**
`Client → Firebase Auth (create account) → Firestore users/{uid} (status: pending) → Storage (certificate upload) → Admin panel review → Cloud Function (approve) → custom claim set + alumniDirectory entry created → Algolia sync`

**Mentorship request:**
`Student taps "Request" → Cloud Function validates eligibility → mentorshipRequests doc created → FCM push to alumni → Alumni accepts/declines → Function updates status → both parties notified`

**Chat message:**
`Client writes to conversations/{id}/messages → Firestore realtime listener delivers to recipient if app open → Cloud Function triggers FCM push if recipient is offline`

**Component map** (already shared earlier in this conversation): Flutter clients → Firebase Auth → Cloud Functions (gateway) → Firestore/Storage → fan-out to Algolia (search) and FCM (push).

---

## 6. Deployment setup

### 6.1 Environments
Three **separate Firebase projects** — `edu-alumni-dev`, `edu-alumni-staging`, `edu-alumni-prod` — wired to three Flutter **flavors** (`flutter run --flavor dev`, etc.), each with its own `google-services.json` / `GoogleService-Info.plist`. Never develop or test mentorship-matching logic against the production database.

### 6.2 Secrets & config
- No API keys committed to git. Use `--dart-define-from-file` with per-environment `.env` files excluded via `.gitignore`.
- Algolia admin key lives only in Cloud Functions config, never shipped to the client (client uses the search-only key).

### 6.3 CI/CD
- **GitHub Actions**: on every PR — `flutter analyze`, `dart format --check`, `flutter test`. Required check before merge to `main`.
- **Codemagic** (Flutter-native CI): on merge to `main` — build signed APK/AAB and IPA, deploy to **Firebase App Distribution** for internal testers automatically.
- **App signing**: Android keystore and iOS certificates/provisioning profiles stored as encrypted CI secrets, never in the repo.

### 6.4 Release pipeline
`Feature branch → PR review → main → Firebase App Distribution (team + faculty testers) → Play Store Internal Testing / TestFlight (closed beta) → Production release`

### 6.5 Admin web hosting
Deploy the Flutter Web admin dashboard to **Firebase Hosting** — same project family, simple `firebase deploy`, free SSL.

### 6.6 Post-launch monitoring
Crashlytics (crash reporting), Performance Monitoring (slow screens/network calls), Analytics (engagement — who's actually using mentorship vs. just browsing), and a **Firebase budget alert** on the Blaze plan so a runaway Cloud Function loop doesn't quietly rack up a bill nobody notices until it's large.

### 6.7 Git workflow (4-person team)
Protected `main` branch, required PR review before merge, conventional commit messages, one feature branch per module owner. With four people in one repo, this is the difference between parallel progress and merge hell.

---

## 7. What this plan was missing — added in

A few things that don't show up until you're mid-build if they're not planned for now:

1. **Content moderation policy** — who handles a reported user/message, and what the escalation path looks like, before the first report comes in, not after.
2. **Data privacy & retention policy** — you're holding real students' and alumni's personal data; a short, plain-language privacy policy page is also a hard requirement for Play Store/App Store submission.
3. **Disaster recovery** — scheduled Firestore exports to Cloud Storage. "We accidentally deleted the alumni collection" is a one-line Cloud Function bug away from happening to any team.
4. **App store compliance prep** — Play Store Data Safety form and age rating questionnaire take real time to fill out accurately; budget for it, don't leave it for submission day.
5. **Accessibility pass** — semantic labels, sufficient contrast, scalable text — easy to retrofit early, expensive to retrofit after 9 screens are built.
6. **Team documentation** — a `README` with setup steps and a short architecture decision log (why Riverpod, why Firestore) so a new contributor — or your supervising lecturer reviewing the codebase — can get oriented without asking you directly.
7. **Bus-factor risk** — with four people each owning a module, document each feature's domain logic in its own short `README.md` inside the feature folder. If one teammate is unavailable before a deadline, the others shouldn't be blocked figuring out how `mentorship/` works.

---

## 8. Suggested build order

| Phase | Focus |
|---|---|
| 0 | Repo, flavors, CI skeleton, theming, router, Firebase projects provisioned |
| 1 | Auth + onboarding + alumni verification |
| 2 | Profile + directory + Algolia search |
| 3 | Mentorship request/matching |
| 4 | Chat |
| 5 | Events + job board |
| 6 | Admin web dashboard |
| 7 | Notifications, analytics, crash reporting |
| 8 | Testing pass + security rule hardening |
| 9 | Store listing, privacy policy, closed beta |
| 10 | Launch + monitor + iterate |


## 9. Color Pallete Mulled Wine #670627, Matcha #BAD797 