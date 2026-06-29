# EDU Alumni Connect — Master Flutter Build Prompt
**Authored by:** Senior Prompt Engineer (10 YOE)
**Target AI:** Cursor / Windsurf / GitHub Copilot Agent / Claude Code
**Usage:** Feed each Phase Prompt sequentially. Never skip Phase 0.

---

## HOW TO USE THIS DOCUMENT

Each section below is a **self-contained prompt** to paste into your AI coding tool.
Always include the **GLOBAL CONTEXT BLOCK** (Section A) at the top of every session.
Then paste the relevant **Phase Prompt** (Section B onwards) for what you are building today.
The AI will output production-ready, error-free Flutter code following Clean Architecture.

---

## SECTION A — GLOBAL CONTEXT BLOCK
> ⚠️ Paste this at the start of EVERY session before any Phase Prompt.

```
You are a senior Flutter engineer with deep expertise in Clean Architecture,
Riverpod state management, Firebase backend, and production-grade mobile development.

PROJECT: EDU Alumni Connect
PURPOSE: Alumni/student mentorship and networking platform for East Delta University.
PLATFORMS: Flutter mobile (iOS + Android) + Flutter Web (admin dashboard only).
FLUTTER VERSION: Latest stable (3.x+)
DART VERSION: Latest stable (3.x+)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DESIGN SYSTEM (NON-NEGOTIABLE)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Primary Color    : Mulled Wine   #670627   (deep burgundy — authority, trust)
Accent Color     : Matcha        #BAD797   (soft green — growth, community)
Background Light : #FDFAF7       (warm off-white, never pure white)
Background Dark  : #1A0A0E       (near-black with burgundy undertone)
Surface Light    : #FFFFFF
Surface Dark     : #2C1018
On-Primary       : #FFFFFF
On-Accent        : #1C2B15
Error Color      : #D32F2F
Text Primary     : #1A0A0E  (light) / #F5EEF0  (dark)
Text Secondary   : #6B4A52  (light) / #A88A90  (dark)

TYPOGRAPHY (Material 3):
  Display / Headline : "Playfair Display" (Google Fonts) — used sparingly for hero moments
  Body / Label       : "Inter" (Google Fonts) — all UI text, forms, data
  Mono               : "JetBrains Mono" — code snippets, IDs only

DESIGN LANGUAGE:
  - Material 3 (M3) with custom ColorScheme derived from the palette above
  - Border radius tokens: xs=4, sm=8, md=12, lg=16, xl=24, pill=100
  - Elevation: use M3 surface tones, not drop shadows
  - Spacing scale: 4, 8, 12, 16, 20, 24, 32, 40, 48, 64 (always multiples of 4)
  - Cards: rounded corners (lg=16), subtle surface tint, no hard borders
  - Buttons: FilledButton (primary CTA), OutlinedButton (secondary), TextButton (tertiary)
  - Always implement dark mode. Use ThemeData.from(colorScheme: ...) pattern.
  - Minimum tap target: 48×48 dp (accessibility)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ARCHITECTURE (NON-NEGOTIABLE)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Pattern          : Clean Architecture (Presentation → Domain → Data)
State Management : Riverpod with code generation (@riverpod annotations)
Routing          : go_router with ShellRoute and auth guards
Immutable Models : freezed + json_serializable
Functional Errors: fpdart — every repository method returns Either<Failure, T>
DI               : Riverpod providers in core/di/

Never use:
  - setState() outside of test scaffolds
  - direct Firebase SDK calls from UI layer (widget files)
  - dynamic as a type — always use proper generics
  - print() — use a logger (logger package)
  - hardcoded strings in UI — use AppStrings constants

Always:
  - Handle loading, error, and empty states for every async operation
  - Use const constructors wherever possible
  - Add // TODO: l10n comment on every hardcoded user-facing string
  - Follow the folder structure defined in the architecture doc
  - Name files in snake_case, classes in PascalCase

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
USER ROLES (enforce via Firebase custom claims)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  student : browse directory, request mentorship, message, RSVP events
  alumni  : all student actions + accept/decline mentorship, post jobs
  admin   : full access — verify accounts, moderate, manage events, view reports

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
FOLDER STRUCTURE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
lib/
  core/
    constants/     # AppStrings, AppRoutes, AppEnums
    theme/         # AppTheme, AppColors, AppTextStyles, AppSpacing
    router/        # AppRouter (go_router), AuthGuard
    di/            # providers.dart (top-level provider wiring)
    errors/        # Failure sealed class hierarchy
    network/       # ConnectivityService
  features/
    auth/          # {data/, domain/, presentation/}
    profile/       # {data/, domain/, presentation/}
    directory/     # {data/, domain/, presentation/}
    mentorship/    # {data/, domain/, presentation/}
    chat/          # {data/, domain/, presentation/}
    events/        # {data/, domain/, presentation/}
    jobs/          # {data/, domain/, presentation/}
    admin/         # {data/, domain/, presentation/} — Flutter Web route-gated
    notifications/ # {data/, domain/, presentation/}
  shared/
    widgets/       # AppButton, AppCard, AppTextField, EmptyState, ErrorState, LoadingShimmer
    extensions/    # BuildContext extensions, String extensions
    validators/    # FormValidators
  main.dart
  app.dart         # MaterialApp.router + ProviderScope

Each feature/xxx/data/    contains: models/, sources/, repositories/
Each feature/xxx/domain/  contains: entities/, repositories/ (abstract), usecases/
Each feature/xxx/presentation/ contains: pages/, widgets/, providers/
```

---

## SECTION B — PHASE 0: PROJECT SCAFFOLD & DESIGN SYSTEM

```
Using the GLOBAL CONTEXT BLOCK above, scaffold the complete EDU Alumni Connect
Flutter project from scratch.

TASK LIST (complete all, in order):

1. PUBSPEC.YAML
   Generate a complete pubspec.yaml including:
   - flutter_riverpod: ^2.x + riverpod_annotation + riverpod_generator
   - go_router: ^14.x
   - freezed: ^2.x + freezed_annotation + json_serializable + build_runner
   - fpdart: ^1.x
   - firebase_core, firebase_auth, cloud_firestore, firebase_storage,
     firebase_messaging, firebase_app_check, cloud_functions
   - algolia_helper_flutter (or algolia: latest)
   - google_fonts
   - cached_network_image
   - shimmer (loading states)
   - logger
   - flutter_localizations + intl
   - image_picker
   - connectivity_plus
   - flutter_launcher_icons + flutter_native_splash
   - Dev: mocktail, flutter_test, integration_test, go_router_builder

2. FOLDER STRUCTURE
   Create every folder and an empty .gitkeep inside so the tree is navigable
   from day one (follow the tree in the Global Context Block exactly).

3. THEME SYSTEM — lib/core/theme/
   Create four files:
   a) app_colors.dart — every color token from the design system as static const,
      with both light and dark variants. Include ColorScheme.fromSeed approach
      using seedColor: Color(0xFF670627) as the base, then override specific slots
      to match the palette exactly.
   b) app_text_styles.dart — TextTheme using Playfair Display (display/headline)
      and Inter (body/label). Use GoogleFonts.playfairDisplayTextTheme() and
      GoogleFonts.interTextTheme() merged correctly.
   c) app_spacing.dart — spacing constants (xs:4, sm:8, md:12, lg:16, xl:24,
      xxl:32, xxxl:48) and border radius tokens.
   d) app_theme.dart — exports AppThemeData.light() and AppThemeData.dark(),
      both returning ThemeData configured for Material 3 with the custom
      ColorScheme, TextTheme, and the following component themes pre-configured:
      FilledButtonTheme, OutlinedButtonTheme, CardTheme, AppBarTheme,
      InputDecorationTheme (outlined style, rounded md=12), SnackBarTheme,
      BottomNavigationBarTheme.

4. FAILURE TYPES — lib/core/errors/failures.dart
   Create a sealed class Failure with these subtypes (freezed unions):
   NetworkFailure, AuthFailure, ValidationFailure, NotFoundFailure,
   PermissionFailure, ServerFailure, CacheFailure, UnknownFailure.
   Each carries a String message and optional Object? cause.

5. SHARED WIDGETS — lib/shared/widgets/
   Create these five production-quality widgets:
   a) app_button.dart — AppButton wrapping FilledButton with a loading state
      (shows CircularProgressIndicator instead of label when isLoading: true),
      accepts onPressed, label, icon?, isLoading, isFullWidth.
   b) app_text_field.dart — AppTextField wrapping TextFormField with consistent
      styling from InputDecorationTheme. Accepts controller, label, hint, validator,
      obscureText, prefixIcon, suffixIcon, keyboardType, onChanged.
   c) app_card.dart — AppCard wrapping Card with M3 surface tones, lg border radius,
      optional onTap, padding slot, and child.
   d) loading_shimmer.dart — LoadingShimmer using the shimmer package.
      Provide shimmer variants: ShimmerCard (mimics AppCard skeleton),
      ShimmerListTile, ShimmerAvatar.
   e) empty_state.dart — EmptyState widget: centered column with an SVG/icon slot,
      title Text (headline small), subtitle Text (body medium), optional CTA button.
      Provide factory constructors: EmptyState.noResults(), EmptyState.noConnections(),
      EmptyState.noMessages(), EmptyState.noEvents().

6. ROUTER — lib/core/router/app_router.dart
   Implement the full go_router configuration with:
   - A top-level redirect that checks Firebase Auth state (stream-based via ref.watch)
     and user's custom claim role from a currentUserProvider.
   - ShellRoute with a bottom navigation bar for authenticated users (4 tabs:
     Home/Directory, Mentorship, Chat, Profile).
   - Named routes for every feature screen using AppRoutes constants.
   - Role-based redirect: if an admin tries to access /admin/* without the admin claim,
     redirect to /home. If unauthenticated user hits any protected route, redirect to /login.
   - Routes to scaffold (create placeholder screens now, implement in later phases):
     /splash, /onboarding, /login, /register, /verify-email,
     /home, /directory, /directory/:alumniId,
     /mentorship, /mentorship/:requestId,
     /chat, /chat/:conversationId,
     /events, /events/:eventId,
     /jobs, /jobs/:jobId,
     /profile, /profile/edit,
     /notifications,
     /admin (Flutter Web only — role guard)

7. MAIN ENTRY POINT
   Generate main.dart (3 flavors: dev, staging, prod via --dart-define)
   and app.dart (ProviderScope wrapping MaterialApp.router with theme toggle support
   via a ThemeMode provider).

8. FIREBASE INITIALIZATION
   Create lib/core/di/firebase_initializer.dart that:
   - Calls Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
   - Activates FirebaseAppCheck with PlayIntegrityProvider (Android) and
     AppAttestProvider (iOS), DeviceCheckProvider (Web).
   - Awaited in main.dart before runApp.

Output every file in full — no placeholders, no "// implement later" comments,
no omitted imports. Every file must be immediately runnable with `flutter run`.
```

---

## SECTION C — PHASE 1: AUTH & ONBOARDING

```
Using the GLOBAL CONTEXT BLOCK, implement the complete AUTH feature module
for EDU Alumni Connect. The scaffold from Phase 0 already exists.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DATA LAYER — features/auth/data/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. models/user_model.dart
   Freezed + json_serializable model mapping to Firestore users/{uid}.
   Fields: uid, email, fullName, role (enum: student/alumni/admin),
   verificationStatus (enum: pending/verified/rejected), photoUrl?,
   department, batchYear, currentCompany?, jobTitle?,
   certificateUrl? (alumni only), createdAt, updatedAt.
   Include fromFirestore(DocumentSnapshot) and toFirestore() methods.

2. sources/auth_remote_source.dart (abstract + impl)
   Abstract interface IAuthRemoteSource with methods:
     signInWithEmail(email, password) → Future<UserCredential>
     registerWithEmail(email, password) → Future<UserCredential>
     signOut() → Future<void>
     sendVerificationEmail() → Future<void>
     getCurrentUser() → User?
     authStateChanges() → Stream<User?>
     getIdTokenResult() → Future<IdTokenResult>  // for custom claims

   FirebaseAuthRemoteSource implements IAuthRemoteSource.
   Never expose Firebase types past this layer.

3. sources/user_remote_source.dart (abstract + impl)
   Abstract IUserRemoteSource:
     createUserDocument(UserModel) → Future<void>
     getUserDocument(uid) → Future<DocumentSnapshot>
     updateUserDocument(uid, Map<String,dynamic> data) → Future<void>
     uploadCertificate(uid, File) → Future<String>  // returns download URL

4. repositories/auth_repository_impl.dart
   Implements domain/repositories/i_auth_repository.dart.
   All methods return Either<Failure, T> using fpdart TaskEither pattern.
   Map FirebaseAuthException codes to specific AuthFailure messages.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DOMAIN LAYER — features/auth/domain/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
5. entities/auth_user.dart
   Pure Dart entity (no Firebase imports): uid, email, role, verificationStatus,
   fullName, isEmailVerified. No json methods needed.

6. repositories/i_auth_repository.dart
   Abstract class with:
     signIn(email, password) → Future<Either<Failure, AuthUser>>
     registerStudent(email, password, fullName, department, batchYear)
       → Future<Either<Failure, AuthUser>>
     registerAlumni(email, password, fullName, department, batchYear,
       currentCompany?, jobTitle?) → Future<Either<Failure, AuthUser>>
     signOut() → Future<Either<Failure, Unit>>
     authStateChanges() → Stream<Either<Failure, AuthUser?>>
     getCurrentUserClaims() → Future<Either<Failure, Map<String, dynamic>>>

7. usecases/ — one file per use case, each a callable class:
   SignInUseCase, RegisterStudentUseCase, RegisterAlumniUseCase,
   SignOutUseCase, GetCurrentUserUseCase, WatchAuthStateUseCase.
   Each takes the repository via constructor injection.
   Each returns the exact Either<Failure, T> from the repository.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PRESENTATION LAYER — features/auth/presentation/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
8. providers/auth_provider.dart
   Using @riverpod annotation:
   - authStateProvider: StreamProvider<AuthUser?> watching authStateChanges
   - currentUserProvider: derived from authStateProvider, exposes AsyncValue<AuthUser?>
   - signInProvider: AsyncNotifier with signIn(email, password) method
   - registerProvider: AsyncNotifier with registerStudent() and registerAlumni() methods

9. pages/splash_screen.dart
   Full-screen branded splash. Mulled Wine (#670627) background, centered EDU logo
   (use a Text widget styled as "EDU" in Playfair Display 48sp + "Alumni Connect" subtitle
   in Inter 16sp, color Matcha #BAD797). Watch authStateProvider — navigate to /home if
   authenticated, /login if not, after a 1.5s minimum display with FadeTransition.

10. pages/onboarding_screen.dart
    3-page PageView onboarding with PageIndicator dots.
    Page 1: "Connect with Alumni" — icon + description
    Page 2: "Find a Mentor" — icon + description
    Page 3: "Grow Together" — icon + description
    Use the Mulled Wine / Matcha palette. Last page shows "Get Started" AppButton.
    Store onboarding-seen flag in SharedPreferences to skip on subsequent launches.

11. pages/login_screen.dart
    Design: white card centered on a soft #FDFAF7 background, AppBar transparent.
    EDU Alumni Connect logo at top (same as splash, smaller).
    AppTextField for email + password (obscureText toggle).
    "Sign In" AppButton (full width, isLoading driven by signInProvider state).
    "Forgot password?" TextButton.
    Divider with "or" — not implemented in MVP (placeholder only).
    "New here? Register" TextButton → /register.
    Validation: email format, password minimum 8 chars.
    On AuthFailure: show SnackBar with the Failure.message.

12. pages/register_screen.dart
    Two-tab layout within one screen using a SegmentedButton:
      Tab "Student" | Tab "Alumni"

    Student fields: fullName, email (@eastdelta.edu.bd enforced via validator),
      department (dropdown: CSE/EEE/BBA/English/...), batchYear (int, 4 digits).

    Alumni fields: fullName, email (any), department (same dropdown), batchYear,
      currentCompany (optional), jobTitle (optional).
    Below alumni form: a dashed-border upload box "Upload your degree certificate
      or ID (required for verification)". Use image_picker. Show picked file name
      and a remove button. This certificate is uploaded during registration.

    "Create Account" AppButton at bottom.
    Show a bottom sheet on success explaining the verification process for alumni.

13. pages/verification_pending_screen.dart
    Shown to alumni after registration while status = pending.
    Centered illustration (use an icon + styled text as placeholder),
    title "Verification in Progress",
    body text explaining that admin will review within 24–48 hours,
    "Refresh Status" outlined button that re-checks verificationStatus from Firestore,
    "Sign Out" text button.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CLOUD FUNCTION SPEC (document only — do not write Node.js here)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
14. Add a dart comment block in auth_repository_impl.dart describing the expected
    Cloud Function: `approveAlumni(uid)` — sets custom claim {role:'alumni'} on the
    user token, writes verified:true to users/{uid} and creates alumniDirectory/{uid}.
    The Flutter app calls this via FirebaseFunctions.instance.httpsCallable('approveAlumni').

Output every file in full with all imports. Zero placeholder comments.
```

---

## SECTION D — PHASE 2: PROFILE & ALUMNI DIRECTORY

```
Using the GLOBAL CONTEXT BLOCK, implement the PROFILE and DIRECTORY feature
modules. Auth from Phase 1 already exists.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PROFILE FEATURE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. Reuse UserModel from auth/data/models/ (do not duplicate).

2. features/profile/domain/usecases/:
   GetProfileUseCase(uid) → Either<Failure, UserModel>
   UpdateProfileUseCase(uid, UpdateProfileParams) → Either<Failure, UserModel>
   UploadProfilePhotoUseCase(uid, File) → Either<Failure, String>

3. features/profile/presentation/pages/profile_screen.dart
   Layout: ScrollView with:
   - Hero section: circular avatar (CachedNetworkImage, fallback initials avatar
     in Mulled Wine background), fullName in Playfair Display headline, role chip
     (Student/Alumni badge styled with Matcha background), department + batch year.
   - For Alumni: "Open to Mentorship" toggle switch (updates Firestore).
   - Stats row: 3 AppCard chips — connections, mentorships, events attended
     (placeholder zeros for now, wired in later phases).
   - "About" section: editable bio text.
   - For Alumni: "Experience" section showing currentCompany + jobTitle.
   - "Edit Profile" FilledButton → /profile/edit.

4. features/profile/presentation/pages/edit_profile_screen.dart
   Full form to edit: photoUrl (image_picker), fullName, bio, department,
   currentCompany (alumni only), jobTitle (alumni only), skills (alumni only —
   chip-based input: type to add, tap chip to remove).
   "Save Changes" AppButton with loading state.
   Unsaved-changes guard: show dialog if user pops with unsaved changes.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DIRECTORY FEATURE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
5. features/directory/data/models/alumni_directory_model.dart
   Maps to Firestore alumniDirectory/{uid}.
   Fields: uid, fullName, department, batchYear, currentCompany?, jobTitle?,
   skills[], location?, photoUrl, verified (always true in this collection).
   fromFirestore + toFirestore.

6. features/directory/data/sources/directory_remote_source.dart
   IDirectoryRemoteSource:
     searchAlumni(AlgoliaSearchParams) → Future<List<AlumniDirectoryModel>>
     getAlumniById(uid) → Future<AlumniDirectoryModel>
     getAlumniByDepartment(dept, {limit, lastDoc}) → Future<List<AlumniDirectoryModel>>
   
   Implementation uses Algolia for search (algolia_helper_flutter) and Firestore
   for direct lookups. Algolia client initialized with appId + searchOnlyApiKey
   from dart-define env vars (never the admin key).

7. features/directory/domain/ — entities, repository interface, usecases:
   SearchAlumniUseCase(query, filters) → Either<Failure, List<AlumniDirectoryModel>>
   GetAlumniProfileUseCase(uid) → Either<Failure, AlumniDirectoryModel>
   GetAlumniByDepartmentUseCase(dept) → Either<Failure, List<AlumniDirectoryModel>>

8. features/directory/presentation/providers/directory_provider.dart
   - alumniSearchProvider: StateNotifierProvider holding SearchState
     (query, filters, results, isLoading, hasMore, error).
   - alumniDetailProvider(uid): FutureProvider<AlumniDirectoryModel>.
   - Implement debounced search: 350ms debounce on query changes.
   - Filter state: DepartmentFilter, BatchYearFilter, SkillsFilter (multi-select).

9. features/directory/presentation/pages/directory_screen.dart
   Layout: CustomScrollView with:
   - SliverAppBar (floating, snap) containing the search bar (AppTextField styled
     as a search field with a search icon prefix and clear button suffix).
   - Filter chips row (scrollable horizontal): "All Departments" + department names.
     Active filter chip uses Matcha (#BAD797) background.
   - SliverList of AlumniDirectoryCard widgets.
   - Loading: show 6× ShimmerCard while results load.
   - Empty state: EmptyState.noResults() with "Try a different search or filter".
   - Pagination: load more on scroll to bottom (detect via ScrollController).

10. shared/widgets/alumni_directory_card.dart
    AppCard with:
    - Leading: circular CachedNetworkImage avatar (48dp), fallback initials.
    - Title: fullName (body large, semi-bold).
    - Subtitle: jobTitle @ currentCompany (body small, secondary text color).
    - Trailing: department chip (small, outlined, Mulled Wine border).
    - Bottom row: skills chips (up to 3, then "+N more" chip).
    - Tap → /directory/:uid.

11. features/directory/presentation/pages/alumni_detail_screen.dart
    CustomScrollView with SliverAppBar (expandedHeight: 280).
    - Collapsed: name + back button on Mulled Wine background.
    - Expanded: gradient overlay (Mulled Wine → transparent) over profile photo,
      name + role at bottom of expanded area.
    - Body sections: About, Experience, Skills chips, Education (department + batch).
    - Sticky bottom bar: "Request Mentorship" FilledButton (disabled if already
      requested or if viewer is alumni, shown only to students).
    - "Connect" OutlinedButton (placeholder, future feature).

Output every file in full with all imports. All providers use @riverpod annotation.
```

---

## SECTION E — PHASE 3: MENTORSHIP

```
Using the GLOBAL CONTEXT BLOCK, implement the complete MENTORSHIP feature.
Phases 0–2 already exist. This is the core value-driver of the app.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DATA & DOMAIN
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. features/mentorship/data/models/mentorship_request_model.dart
   Freezed model mapping Firestore mentorshipRequests/{requestId}.
   Fields: requestId, studentId, alumniId, status (enum: pending/accepted/declined/completed),
   message, createdAt, updatedAt.
   Include MentorshipStatus enum with display label and color accessors.

2. Repository + source:
   IMentorshipRemoteSource:
     sendRequest(studentId, alumniId, message) → Future<MentorshipRequestModel>
     getRequestsForStudent(studentId) → Stream<List<MentorshipRequestModel>>
     getRequestsForAlumni(alumniId) → Stream<List<MentorshipRequestModel>>
     updateRequestStatus(requestId, MentorshipStatus) → Future<void>
     canStudentRequest(studentId, alumniId) → Future<bool>
       // returns false if a pending/active request already exists between the pair

3. Usecases:
   SendMentorshipRequestUseCase — validates eligibility via canStudentRequest first,
     then calls CloudFunction (not direct Firestore write) for rate-limiting.
   WatchStudentRequestsUseCase(studentId) → Stream of Either<Failure, List<...>>
   WatchAlumniRequestsUseCase(alumniId) → Stream of Either<Failure, List<...>>
   RespondToRequestUseCase(requestId, status) → Either<Failure, Unit>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PRESENTATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
4. providers/mentorship_provider.dart
   - studentRequestsProvider: StreamProvider watching student's requests.
   - alumniRequestsProvider: StreamProvider watching alumni's incoming requests.
   - sendRequestProvider: AsyncNotifier<Unit>.
   - respondToRequestProvider: AsyncNotifier<Unit>.

5. pages/mentorship_screen.dart
   Adaptive screen: content shown depends on the viewer's role.

   STUDENT VIEW:
   - If no active mentorship: EmptyState with "Find an Alumni Mentor" CTA → /directory.
   - List of their own requests: MentorshipRequestCard each showing status chip
     (pending = amber, accepted = Matcha, declined = error red, completed = grey).
   - "Pending" tab | "Active" tab | "Completed" tab using TabBar.

   ALUMNI VIEW:
   - "Incoming Requests" section: list of MentorshipRequestCard with accept/decline
     action buttons inline (only on pending items).
   - "Active Mentorships" section below.
   - Accept/Decline triggers a confirmation BottomSheet, then RespondToRequestUseCase.

6. shared/widgets/mentorship_request_card.dart
   AppCard displaying: student/alumni avatar + name, request message (truncated to 2 lines),
   date sent, status chip. For alumni view: inline Accept (FilledButton) + Decline
   (OutlinedButton, destructive) when status=pending. Loading state per button.

7. pages/send_mentorship_request_sheet.dart (BottomSheet)
   Shown from alumni_detail_screen when student taps "Request Mentorship".
   Fields: pre-filled alumni name (read-only chip), multiline message TextField
   (min 3 lines, max 500 chars, char counter shown).
   "Send Request" AppButton. Dismiss on success with a SnackBar.
   Validate: message required, not empty.

Output every file completely. All streams must handle the empty/loading/error states.
```

---

## SECTION F — PHASE 4: REAL-TIME CHAT

```
Using the GLOBAL CONTEXT BLOCK, implement the CHAT feature.
This must feel like a native messaging experience.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DATA LAYER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. models:
   ConversationModel: id, participantIds[], lastMessage, lastMessageAt,
     unreadCount (map per uid), participantDetails (cached name+photoUrl per uid).
   MessageModel: id, senderId, text, sentAt, readBy[].

2. IChatRemoteSource:
     watchConversations(uid) → Stream<List<ConversationModel>>
     watchMessages(conversationId) → Stream<List<MessageModel>>
     sendMessage(conversationId, senderId, text) → Future<MessageModel>
     markAsRead(conversationId, uid) → Future<void>
     getOrCreateConversation(uid1, uid2) → Future<ConversationModel>

   IMPORTANT: sendMessage writes ONLY to the subcollection. A Cloud Function
   handles the denormalized lastMessage update on the parent conversation doc.
   Document this constraint with a comment.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PRESENTATION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
3. providers/chat_provider.dart
   - conversationsProvider: StreamProvider<List<ConversationModel>>
   - messagesProvider(conversationId): StreamProvider<List<MessageModel>>
   - sendMessageProvider: AsyncNotifier

4. pages/conversations_screen.dart
   AppBar: "Messages" + unread badge on the bottom nav icon (derived from
   conversationsProvider by summing unreadCount for currentUser).
   List of ConversationListTile (custom widget):
   - Avatar (CachedNetworkImage), other participant name, lastMessage snippet,
     lastMessageAt (formatted: "just now", "2m", "Yesterday", date).
   - Bold name + message when unread. Matcha left-border accent on unread items.
   Loading: ShimmerListTile × 5.
   Tap → /chat/:conversationId.

5. pages/chat_screen.dart
   The single most important screen for perceived app quality — implement carefully.

   Structure: Scaffold with:
   - AppBar: avatar + name of other participant + "Active" status dot (static for now).
   - Body: ListView.builder (reverse: true) for messages.
   - Bottom: message input row.

   Message Bubble rules:
   - Sent (current user): Mulled Wine (#670627) bubble, right-aligned, white text,
     border radius (lg, lg, xs, lg) = rounded except bottom-right.
   - Received: Surface color bubble (#F5F5F5 light / #2C1018 dark), left-aligned,
     primary text color, border radius (lg, lg, lg, xs) = rounded except bottom-left.
   - Show sender avatar only for received messages and only when the previous message
     was from a different sender (group avatar display logic).
   - Timestamps: show once per minute-group, centered, in caption style.
   - Read receipts: small double-tick icon in Matcha color on sent messages when
     readBy contains the recipient's uid.

   Input Row:
   - TextField (multi-line capable, maxLines: 5, minLines: 1) with hint "Message...".
   - Send IconButton (Mulled Wine filled circle) — disabled and greyed when text empty.
   - Tapping Send calls sendMessage, clears the field, scrolls to bottom.
   - Optimistic update: append message to local list immediately, show sending indicator,
     update to confirmed on Firestore write success.

   Mark conversation as read when screen is opened (markAsRead called in initState).

Output every file completely. Chat must be smooth — use AutomaticKeepAliveClientMixin
on the chat screen to preserve scroll state.
```

---

## SECTION G — PHASE 5: EVENTS & JOB BOARD

```
Using the GLOBAL CONTEXT BLOCK, implement EVENTS and JOBS features.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EVENTS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. EventModel: id, title, description, dateTime, location, bannerUrl?,
   rsvpCount, rsvpUserIds[], isOnline (bool), postedByAdminId.

2. Usecases: GetUpcomingEventsUseCase, GetPastEventsUseCase, RsvpEventUseCase,
   CancelRsvpUseCase, GetEventDetailUseCase.

3. events_screen.dart:
   - Horizontal scroll of upcoming EventBannerCard (use CachedNetworkImage
     for banner, Mulled Wine gradient overlay with event title + date on bottom).
   - Below: "All Events" section with vertical list (upcoming + past, tab-separated).
   - EventListTile: date chip (Matcha), title, location icon + text, RSVP count.

4. event_detail_screen.dart:
   - SliverAppBar with banner image.
   - Title, date/time formatted clearly, location row, description (expanded/collapsed),
     RSVP count with avatar stack (up to 5 avatars).
   - "RSVP Now" FilledButton / "Cancel RSVP" OutlinedButton (toggle based on rsvpUserIds).
   - Share button in AppBar (placeholder).

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
JOB BOARD
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
5. JobPostingModel: id, postedByAlumniId, posterName, posterPhotoUrl, title,
   company, location, jobType (full-time/part-time/internship/remote), description,
   applyLink, status (active/closed), postedAt.

6. Usecases: GetActiveJobsUseCase, PostJobUseCase (alumni only), CloseJobUseCase.
   Role check: PostJobUseCase must verify current user has alumni or admin claim.

7. jobs_screen.dart:
   - Filter chips row: All | Full-time | Internship | Remote.
   - JobPostingCard: company logo placeholder (initials-based avatar with company
     initial, Matcha background), title, company + location, job type chip, posted date.
   - Alumni/Admin only: FAB "Post a Job" → job_post_form_sheet.dart.

8. job_post_form_sheet.dart (modal bottom sheet, DraggableScrollableSheet):
   Fields: title, company, location, jobType (SegmentedButton), description (multiline),
   applyLink (URL validated). "Post Job" AppButton.

9. job_detail_screen.dart:
   Full description, company info, job type + location chips.
   "Apply Now" FilledButton (opens applyLink in browser via url_launcher).
   "Share" icon in AppBar (placeholder).
   Alumni who posted: see "Close Listing" option.

Output all files completely.
```

---

## SECTION H — PHASE 6: ADMIN DASHBOARD (Flutter Web)

```
Using the GLOBAL CONTEXT BLOCK, implement the ADMIN feature.
This runs as Flutter Web only, accessed via /admin route (role-gated).
The same domain and data layers are reused from mobile.

LAYOUT ARCHITECTURE:
  AdminShell: Scaffold with a fixed left NavigationRail (desktop) or
  BottomNavigationBar (tablet/mobile web). Rail items: Dashboard, Verify Accounts,
  Users, Events, Reports, Moderation. Use LayoutBuilder to switch at 600dp.
  AppBar shows "EDU Alumni Connect — Admin" + current admin name + sign out.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SCREENS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. admin_dashboard_screen.dart
   4-column stat card row (responsive: 2-col on tablet, 1-col on mobile):
   - Total Users, Pending Verifications, Active Mentorships, Upcoming Events.
   Each stat card: large number in Playfair Display 40sp, label below, icon.
   Recent Pending Verifications list below (top 5, with "View All" link).

2. verify_accounts_screen.dart
   DataTable (or equivalent scrollable table) of users with verificationStatus=pending.
   Columns: name, email, department, batch, submitted date, certificate (View link
   that opens certificateUrl in a new tab), Actions (Approve | Reject buttons).
   Approve calls the Cloud Function approveAlumni(uid).
   Reject opens a dialog asking for a rejection reason, then calls rejectAlumni(uid, reason).
   Show a Snackbar confirmation after each action.
   Implement real-time updates (StreamBuilder on Firestore query).
   Pagination: show 20 per page.

3. user_management_screen.dart
   Search + filter (by role, department, verificationStatus).
   Table: name, email, role chip, status, joined date, Actions (View Profile, Suspend).

4. event_management_screen.dart
   List of events with Edit / Delete / Archive actions.
   "Create Event" button opens CreateEventDialog:
   Fields: title, description, dateTime (DateTimePicker), location, isOnline toggle,
   banner image upload (Flutter Web: use universal_io or file_picker_web).

5. reports_screen.dart (placeholder)
   Static stub with "Analytics dashboard coming soon" and placeholder charts
   (use fl_chart to show mock data as bar charts: events by month, new users by week).

Output all files. Use Responsive layout patterns (LayoutBuilder + breakpoints).
Admin pages use the same Mulled Wine / Matcha palette in a sidebar-first layout.
```

---

## SECTION I — PHASE 7: NOTIFICATIONS

```
Using the GLOBAL CONTEXT BLOCK, implement the NOTIFICATIONS feature.
FCM push + in-app notification center.

1. NotificationModel: id, type (enum: mentorship_request/mentorship_accepted/
   mentorship_declined/new_message/event_reminder/job_posted/system),
   title, body, read (bool), createdAt, payload (Map for deep-linking).

2. NotificationService (singleton, initialized in main.dart):
   - Request FCM permissions (firebase_messaging).
   - Save FCM token to users/{uid}/fcmToken on login and token refresh.
   - Handle foreground messages: show local notification using flutter_local_notifications.
   - Handle background/terminated: configure onBackgroundMessage handler.
   - On notification tap: extract payload and use go_router to navigate to the correct
     screen (mentorship request, chat thread, event detail, etc).

3. features/notifications/presentation/pages/notifications_screen.dart
   StreamProvider watching notifications/{uid}/items ordered by createdAt desc.
   List of NotificationTile:
   - Leading: icon based on type (person_add, check_circle, cancel, message, event,
     work, info) colored with Mulled Wine or Matcha.
   - Title + body, relative timestamp.
   - Unread items: slightly tinted background (Matcha at 10% opacity).
   - Tap: mark as read + navigate via payload.
   - Swipe-to-dismiss: deletes notification.
   - "Mark all as read" action in AppBar.

4. Notification badge: derive unread count from notifications provider and
   display as a red badge on the notifications icon in the BottomNavigationBar.
   Implement using a Stack + Positioned Container (not a third-party badge package).

Output all files completely.
```

---

## SECTION J — PHASE 8: TESTING, SECURITY RULES & HARDENING

```
Using the GLOBAL CONTEXT BLOCK, implement the final hardening phase.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
1. UNIT TESTS — test/features/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Write unit tests using mocktail for these critical use cases:
- SignInUseCase: success path, wrong password (AuthFailure), user not found (NotFoundFailure).
- RegisterAlumniUseCase: success path, email already exists, non-EDU email rejected for students.
- SendMentorshipRequestUseCase: success path, duplicate request blocked, alumni cannot send.
- RespondToRequestUseCase: accept path, decline path, invalid status transition rejected.
- SearchAlumniUseCase: returns filtered results, empty results → EmptyState not error.

Each test file: arrange (mock setup), act (call use case), assert (Either fold).

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
2. WIDGET TESTS — test/shared/widgets/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- AppButton: renders label, shows CircularProgressIndicator when isLoading=true,
  is non-tappable when isLoading=true.
- AppTextField: shows validation error on empty submit, obscures text when obscureText=true.
- AlumniDirectoryCard: renders name, department chip, taps navigate to correct route.
- MentorshipRequestCard: shows correct status chip color per MentorshipStatus value.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
3. INTEGRATION TESTS — integration_test/
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Three critical journeys (use firebase_emulators for local test environment):
- Journey 1: student_signup_verification_test.dart
  Open app → onboarding → register as student → verify email → land on home screen.
- Journey 2: mentorship_request_flow_test.dart
  Student logs in → opens directory → taps an alumni → requests mentorship →
  alumni receives notification → alumni accepts → both see Active status.
- Journey 3: chat_send_receive_test.dart
  User A sends a message → User B (separate ProviderScope) receives it in real-time →
  read receipts update for User A.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
4. FIRESTORE SECURITY RULES — firestore.rules
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Write the complete firestore.rules file enforcing the RBAC matrix:
- users/{uid}: read own only; write via Cloud Functions only for sensitive fields
  (role, verificationStatus, certificateUrl); user can write own non-sensitive fields.
- alumniDirectory/{uid}: any authenticated user can read; writes only via admin
  custom claim or Cloud Function service account.
- mentorshipRequests/{requestId}: student can create (own studentId only);
  alumni can update status (own alumniId only); both can read own requests.
- conversations/{conversationId}: only participantIds[] members can read/write.
- conversations/{id}/messages/{msgId}: only participants can create (senderId must = auth.uid).
- events/{eventId}: any authenticated user can read; only admin can write.
- jobPostings/{jobId}: any authenticated user can read; alumni or admin can create;
  only poster or admin can update/delete.
- notifications/{uid}/items/{id}: only uid owner can read/delete; write via Functions only.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
5. STORAGE RULES — storage.rules
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- profile_photos/{uid}: owner can write (max 5MB, image only); any authenticated user can read.
- certificates/{uid}: owner can write (max 20MB, image or PDF); only admin custom claim can read.
- event_banners/{eventId}: only admin can write; any authenticated user can read.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
6. ACCESSIBILITY CHECKLIST — implement in code
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- Every interactive element has a Semantics widget with a meaningful label.
- All images: semanticLabel parameter set.
- Minimum contrast ratio 4.5:1 for body text (verify Matcha on white meets this —
  if not, use a darker tint for text on light backgrounds).
- Support system font scaling: no hardcoded font sizes in dp that would break at 200% scale.
- MediaQuery.textScaleFactor usage: clamp to max 1.3 only for UI chrome (buttons, chips),
  never for body/article content.
- Add ExcludeSemantics around decorative shimmer loaders.

Output all test files and rule files completely. No placeholder tests.
```

---

## SECTION K — PHASE 9: CI/CD, FLAVORS & RELEASE

```
Using the GLOBAL CONTEXT BLOCK, set up the complete DevOps infrastructure.

1. FLUTTER FLAVORS
   Configure 3 flavors: dev, staging, prod.
   Create:
   - lib/core/constants/app_config.dart: AppConfig class with factory constructors
     AppConfig.dev(), AppConfig.staging(), AppConfig.prod() containing firebaseProjectId,
     algoliaAppId, algoliaSearchKey, environment enum.
   - 3 main entry points: main_dev.dart, main_staging.dart, main_prod.dart each calling
     runApp(App(config: AppConfig.dev())) etc.
   - Android: create 3 productFlavors in android/app/build.gradle (dev/staging/prod)
     with applicationIdSuffix .dev and .staging.
   - iOS: Xcode scheme and xcconfig instructions (document as comments, do not generate
     Xcode files directly).
   - Each flavor uses a separate google-services.json / GoogleService-Info.plist stored in
     the flavor-specific directory. Document the folder paths in a comment.

2. GITHUB ACTIONS — .github/workflows/
   a) pr_check.yml: triggers on pull_request to main.
      Steps: checkout, setup Flutter (latest stable), flutter pub get,
      dart format --check lib test, flutter analyze --fatal-infos,
      flutter test --coverage.
      Fail the PR if any step fails.

   b) build_and_distribute.yml: triggers on push to main.
      Steps: build signed APK (--flavor staging --dart-define-from-file .env.staging),
      build IPA, upload both to Firebase App Distribution with tester group "internal".
      Signing keys read from GitHub Secrets (ANDROID_KEYSTORE_BASE64, KEY_ALIAS,
      KEY_PASSWORD, STORE_PASSWORD; IOS_CERTIFICATE_BASE64, IOS_PROFILE_BASE64).

3. ENV FILES — document structure only (never commit these):
   .env.dev, .env.staging, .env.prod each containing:
   ALGOLIA_APP_ID=, ALGOLIA_SEARCH_KEY=, FIREBASE_PROJECT_ID=, SENTRY_DSN= (future).
   Add all three to .gitignore.

4. CRASHLYTICS + PERFORMANCE MONITORING
   Add to firebase_initializer.dart:
   - FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode)
   - FlutterError.onError → Crashlytics
   - PlatformDispatcher.instance.onError → Crashlytics
   - FirebasePerformance.instance.setPerformanceCollectionEnabled(!kDebugMode)

5. README.md — generate a complete project README:
   - Project overview + screenshots placeholder
   - Architecture diagram (ASCII)
   - Setup instructions (clone, flutter pub get, firebase login, flutterfire configure,
     run with flavor)
   - Flavor commands
   - Running tests
   - Deployment instructions
   - Team module ownership table
   - Architecture decision log (Riverpod over BLoC, Algolia over Firestore search,
     Flutter Web for admin over React)

Output all workflow YAML files and README in full.
```

---

## QUICK-REFERENCE CHEAT SHEET

| Component | Library | Key Rule |
|---|---|---|
| State | riverpod + @riverpod | AsyncNotifier for mutations, StreamProvider for realtime |
| Routing | go_router | Named routes only, auth redirect in top-level redirect |
| Models | freezed + json_serializable | Every model has fromFirestore/toFirestore |
| Errors | fpdart Either | Never try/catch in UI; fold on Either |
| Images | cached_network_image | Always provide placeholder + errorWidget |
| Loading | shimmer | Match shimmer shape to real content shape |
| Forms | AppTextField | Always validate before submit; show inline errors |
| Buttons | AppButton | Always show loading state during async action |
| Theme | AppColors / AppTextStyles | Never use hex literals in widget files |
| Fonts | google_fonts | Playfair Display for headlines, Inter for body |
| Colors | Mulled Wine #670627 / Matcha #BAD797 | Primary CTA = Mulled Wine; success/active = Matcha |

---

*End of Master Prompt Document — EDU Alumni Connect*
*Authored for East Delta University capstone project build*
