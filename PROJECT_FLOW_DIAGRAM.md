# EDU Alumni Connect — Overall Project Flow & Architecture Diagram

> Comprehensive architectural reference detailing the user journey, page navigation routing, feature workflows, and real-time database interactions for the **EDU Alumni Connect** (East Delta University) platform.

---

## 📑 Table of Contents
1. [High-Level System Architecture](#1-high-level-system-architecture)
2. [Master Application Page Routing & Navigation Flow](#2-master-application-page-routing--navigation-flow)
3. [Core Feature Flowcharts & User Journeys](#3-core-feature-flowcharts--user-journeys)
   - [A. Authentication, Registration & Verification Flow](#a-authentication-registration--verification-flow)
   - [B. Home Dashboard & Quick Actions Flow](#b-home-dashboard--quick-actions-flow)
   - [C. Alumni Directory & Algolia Search Flow](#c-alumni-directory--algolia-search-flow)
   - [D. Mentorship Matchmaking & 1-on-1 Request Lifecycle](#d-mentorship-matchmaking--1-on-1-request-lifecycle)
   - [E. Real-Time Chat & Messaging Pipeline](#e-real-time-chat--messaging-pipeline)
   - [F. Campus Events & Workshops Flow](#f-campus-events--workshops-flow)
   - [G. Career Opportunities & Job Board Flow](#g-career-opportunities--job-board-flow)
   - [H. Profile & Credential Management Flow](#h-profile--credential-management-flow)
4. [Page-to-Database Interaction Matrix](#4-page-to-database-interaction-matrix)
5. [End-to-End Sequence Diagrams](#5-end-to-end-sequence-diagrams)
6. [Security Rules & Access Control Matrix](#6-security-rules--access-control-matrix)

---

## 1. High-Level System Architecture

The following diagram illustrates the 4-tier architectural separation of the EDU Alumni Connect mobile application:

![EDU Alumni Connect Project Flow Architecture](./docs/images/project_flow_architecture.jpg)

```mermaid
graph TB
    subgraph Client_Layer ["📱 1. Client Presentation Tier (Flutter 3.x)"]
        UI_Screens["UI Screens (Splash, Onboarding, Auth, Home, Mentors, Chat, Events, Jobs, Profile)"]
        Router["GoRouter 14.x with Auth Guards & ShellRoute"]
        Shared_Widgets["Shared Design System (AppButton, UserAvatar, AppTextField, Cards)"]
    end

    subgraph State_Layer ["⚡ 2. State & Domain Logic Tier (Riverpod 2.x)"]
        Notifiers["AsyncNotifiers & StateNotifiers (Auth, Directory, Mentorship, Chat)"]
        UseCases["Clean Architecture Use Cases (SignIn, Register, SendMessage, RequestMentor)"]
        Either_Pipe["FpDart Either&lt;Failure, Success&gt; Error Handling Pipeline"]
    end

    subgraph BaaS_Layer ["☁️ 3. Backend & Cloud Infrastructure (Firebase)"]
        FirebaseAuth["Firebase Authentication (Email/Password, Tokens, Session Claims)"]
        Firestore["Cloud Firestore (NoSQL Live Realtime Database)"]
        Storage["Firebase Cloud Storage (Avatars, University Certificates)"]
        FCM["Firebase Cloud Messaging (Instant Push Notifications)"]
        Algolia["Algolia Instant Search Engine (Fast Indexing & Search)"]
    end

    subgraph Functions_Layer ["⚙️ 4. Serverless & Cloud Functions Tier"]
        CF_Auth["onUserCreated / onAlumniVerified Trigger"]
        CF_Notif["onMentorshipRequested / onMessageSent Push Notification Dispatcher"]
        CF_Algolia["syncUserToAlgolia Indexing Pipeline"]
    end

    Client_Layer --> State_Layer
    State_Layer --> BaaS_Layer
    BaaS_Layer --> Functions_Layer
```

---

## 2. Master Application Page Routing & Navigation Flow

The mobile application utilizes declarative routing powered by **GoRouter** with an authenticated shell bottom navigation bar:

```mermaid
flowchart TD
    Start([App Launch]) --> Splash["/splash<br/>(Branded Splash Animation)"]
    Splash -->|1800ms Timer| OnboardingCheck{Has Seen Onboarding?}
    
    OnboardingCheck -->|No| Onboarding["/onboarding<br/>(Role Selection & Feature Intro)"]
    OnboardingCheck -->|Yes| AuthCheck{Is User Logged In?}
    Onboarding -->|Get Started Button| Login["/login<br/>(Student/Alumni Sign In)"]
    
    AuthCheck -->|No| Login
    AuthCheck -->|Yes| VerifyCheck{Account Verified?}
    
    Login -->|New User| Register["/register<br/>(Student/Alumni Form + Certificate Upload)"]
    Register -->|Alumni Pending| Pending["/pending<br/>(Verification In Progress Screen)"]
    Register -->|Student Instant / Verified Alumni| Home
    
    VerifyCheck -->|Alumni Status = Pending| Pending
    VerifyCheck -->|Verified| MainShell["Main Shell Navigation Container<br/>(Bottom Navigation Bar)"]
    
    Pending -->|Admin Approves & Refresh| MainShell
    
    subgraph Bottom_Nav_Shell ["📱 Main Shell Navigation Tabs"]
        MainShell --> Tab1["/home<br/>(Home Dashboard & Metrics)"]
        MainShell --> Tab2["/directory<br/>(Alumni Directory & Search)"]
        MainShell --> Tab3["/mentorship<br/>(Mentorship Matchmaker)"]
        MainShell --> Tab4["/chat<br/>(Realtime Conversations List)"]
        MainShell --> Tab5["/profile<br/>(User Profile & Settings)"]
    end
    
    Tab1 -->|Quick Action / Banner| Events["/events<br/>(Campus Events Listing)"]
    Tab1 -->|Quick Action / Banner| Jobs["/jobs<br/>(Career Opportunities)"]
    Tab1 -->|Notification Bell| Notifications["/notifications<br/>(Activity & Alerts)"]
    Tab1 -->|Admin Role Detected| Admin["/admin<br/>(Admin Verification Portal)"]
    
    Tab2 -->|Select Profile| AlumniDetail["/directory/:alumniId<br/>(Detailed Alumni Dossier)"]
    Tab3 -->|Select Request| MentorshipDetail["/mentorship/:requestId<br/>(Mentorship Session Details)"]
    Tab4 -->|Select Conversation| ChatDetail["/chat/:conversationId<br/>(1-on-1 Live Chat Room)"]
    Tab5 -->|Edit Button| ProfileEdit["/profile/edit<br/>(Edit Bio, Skills & Experience)"]
    Events -->|Select Event| EventDetail["/events/:eventId<br/>(Event RSVP & Schedule)"]
    Jobs -->|Select Job| JobDetail["/jobs/:jobId<br/>(Job Description & Direct Apply)"]
```

---

## 3. Core Feature Flowcharts & User Journeys

### A. Authentication, Registration & Verification Flow

```mermaid
flowchart TD
    A[User Opens App] --> B[Enter Credentials on /login]
    B --> C{Account Type}
    
    C -->|Existing User| D[Call FirebaseAuth.signInWithEmailAndPassword]
    D -->|Success| E[Fetch User Document from Firestore: users/{uid}]
    E --> F{Role & Verification Status}
    F -->|Alumni & Pending| G[Redirect to /pending Screen]
    F -->|Student / Verified Alumni| H[Redirect to /home Dashboard]
    D -->|Failure| I[Display Branded Error Dialog / Toast]
    
    C -->|New Account| J[Navigate to /register]
    J --> K{Selected Role}
    K -->|Student| L[Enter EDU Email: @eastdelta.edu.bd & Student ID]
    K -->|Alumni| M[Enter Alumni Details, Batch Year, Graduation Certificate PDF/Image]
    
    L --> N[Call FirebaseAuth.createUserWithEmailAndPassword]
    M --> O[Upload Certificate to Firebase Storage: certificates/{uid}]
    O --> N
    
    N --> P[Create Firestore Record: users/{uid} & alumni_directory/{uid}]
    P --> Q{Is Alumni?}
    Q -->|Yes| R[Set verification_status = 'pending'] --> G
    Q -->|No| S[Set verification_status = 'verified'] --> H
```

---

### B. Home Dashboard & Quick Actions Flow

```mermaid
flowchart LR
    Home["/home (Dashboard)"] --> Header["Hero Header with User Greeting & Role Badge"]
    Home --> Metrics["Live Metrics Deck (Profile Views, Connections, Mentor Calls)"]
    Home --> QuickActions["Quick Action Buttons (Directory, Mentors, Events, Jobs)"]
    Home --> Spotlight["Alumni Mentor Spotlight Carousel"]
    Home --> UpcomingEvents["Upcoming Campus Events Horizon"]
    Home --> JobRecs["Recommended Opportunities List"]
    
    Header -->|Tap Notifications| NotifsPage["/notifications"]
    QuickActions -->|Tap Mentors| MentorsPage["/mentorship"]
    QuickActions -->|Tap Directory| DirPage["/directory"]
    QuickActions -->|Tap Events| EventsPage["/events"]
    QuickActions -->|Tap Jobs| JobsPage["/jobs"]
```

---

### C. Alumni Directory & Algolia Search Flow

```mermaid
sequenceDiagram
    autonumber
    actor User as Student / Alumni User
    participant UI as DirectoryPage (/directory)
    participant Provider as DirectoryNotifier (Riverpod)
    participant Algolia as Algolia Search API
    participant Firestore as Cloud Firestore (users collection)

    User->>UI: Types query (e.g. "Senior Flutter Engineer", "Batch 2020")
    UI->>Provider: searchAlumni(query, departmentFilter, batchFilter)
    
    alt Online & Algolia Active
        Provider->>Algolia: query index 'edu_alumni_directory'
        Algolia-->>Provider: Returns ranked JSON hit list with highlights
    else Fallback / Algolia Idle
        Provider->>Firestore: collection('users').where('role', '==', 'alumni').where('department', '==', dept)
        Firestore-->>Provider: QuerySnapshot Stream
    end

    Provider-->>UI: Emits AsyncData(List<AlumniDirectoryModel>)
    UI->>User: Renders Filtered Alumni Dossier Cards with Badges
    User->>UI: Taps on Alumni Card
    UI->>User: Navigates to /directory/:alumniId
```

---

### D. Mentorship Matchmaking & 1-on-1 Request Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Discovered: Student browses MentorsPage (/mentorship)
    Discovered --> RequestDialog: Student taps "Request Mentorship"
    RequestDialog --> Pending: Selects Goal (Career, Resume, Mock Interview) + Message
    
    state Pending {
        [*] --> NotificationSent: Cloud Function triggers FCM Push to Mentor
        NotificationSent --> MentorReview: Mentor views request in their Inbox
    }
    
    Pending --> Accepted: Mentor taps "Accept Request"
    Pending --> Declined: Mentor taps "Decline" (with optional reason)
    
    state Accepted {
        [*] --> ChatRoomCreated: Cloud Function creates 1-on-1 chat in /chats
        ChatRoomCreated --> SessionScheduled: Calendar invite & meeting link shared
    }
    
    Accepted --> Completed: Mentorship session concluded
    Declined --> [*]
    Completed --> FeedbackGiven: Student rates mentor 5.0 ★ & writes review
    FeedbackGiven --> [*]
```

---

### E. Real-Time Chat & Messaging Pipeline

```mermaid
sequenceDiagram
    autonumber
    actor Alice as Student (Alice)
    participant ChatUI as ChatDetailPage (/chat/:id)
    participant ChatNotifier as ChatNotifier (Riverpod)
    participant Firestore as Cloud Firestore
    participant CloudFn as Cloud Functions Push Dispatcher
    actor Bob as Alumni Mentor (Bob)

    Alice->>ChatUI: Types message & taps Send
    ChatUI->>ChatNotifier: sendMessage(conversationId, text, senderId)
    ChatNotifier->>Firestore: collection('chats').doc(id).collection('messages').add({text, senderId, timestamp, isRead: false})
    ChatNotifier->>Firestore: collection('chats').doc(id).update({lastMessage: text, lastMessageAt: now})
    
    Firestore-->>ChatUI: Stream updates Alice's UI instantaneously (Optimistic)
    Firestore->>CloudFn: onCreate trigger fires on new message document
    CloudFn->>Bob: Dispatches FCM Push Notification: "New message from Alice"
    
    Firestore-->>Bob: Live Firestore Snapshot updates Bob's chat room in real-time
    Bob->>ChatUI: Opens chat room
    ChatUI->>Firestore: Updates message docs: {isRead: true}
    Firestore-->>Alice: Read receipt ticks (Double Checkmarks) update on Alice's screen
```

---

### F. Campus Events & Workshops Flow

```mermaid
flowchart TD
    A[EventsPage /events] --> B[Fetch Firestore: collection('events')]
    B --> C[Display Featured Event Banner & Date Filter Bar]
    C --> D[User Taps Event Card]
    D --> E[Navigate to /events/:eventId]
    
    E --> F{User RSVP Status}
    F -->|Not Registered| G[Show 'RSVP Now' Button]
    F -->|Already Registered| H[Show 'Registered' Badge + Add to Calendar Button]
    
    G -->|Tap RSVP| I[Update Firestore: events/{id}.attendees.add(uid)]
    I --> J[Add to User Record: users/{uid}.rsvp_events.add(eventId)]
    J --> K[Trigger Local Calendar Event via Device API]
    K --> H
```

---

### G. Career Opportunities & Job Board Flow

```mermaid
flowchart LR
    JobsPage["/jobs (Job Board)"] --> Filters["Filter by: Full-Time, Remote, Internship, Department"]
    Filters --> Query["Firestore: collection('jobs').where('isActive', '==', true)"]
    Query --> JobList["Display Job Cards (Company, Stipend/Salary, Location)"]
    
    JobList -->|Tap Job| JobDetail["/jobs/:jobId"]
    JobDetail --> Actions{"User Action"}
    Actions -->|Direct Apply| ExtURL["Open External Career Link / In-App Apply"]
    Actions -->|Alumni Referral| ChatMentor["Tap 'Ask Alumni for Referral' -> Open /chat"]
    Actions -->|Bookmark| Bookmark["Toggle Bookmark in users/{uid}/saved_jobs"]
```

---

### H. Profile & Credential Management Flow

```mermaid
flowchart TD
    ProfilePage["/profile (User Dossier)"] --> DataFetch["Stream: users/{uid} & alumni_directory/{uid}"]
    DataFetch --> Render["Render Avatar, Bio, Skills, Experience, Education, Social Links"]
    
    Render --> EditBtn["User Taps 'Edit Profile'"]
    EditBtn --> EditPage["/profile/edit"]
    
    EditPage --> Changes{"User Updates"}
    Changes -->|Change Avatar| PickImage["Pick Image from Camera/Gallery"]
    PickImage --> UploadStorage["Upload to Firebase Storage: avatars/{uid}.jpg"]
    UploadStorage --> GetURL["Get Download URL"]
    
    Changes -->|Update Info| Fields["Edit Bio, Job Title, Company, Skills Tag List"]
    
    GetURL --> Save["Save Updates"]
    Fields --> Save
    
    Save --> FirestoreUpdate["Firestore: users/{uid}.update(...)"]
    FirestoreUpdate --> SyncAlgolia["Cloud Function triggers Algolia Index Sync"]
    SyncAlgolia --> Return["Return to /profile with updated data"]
```

---

## 4. Page-to-Database Interaction Matrix

The table below provides a granular mapping between every application route, Flutter screen widget, state provider, and Cloud Firestore / Firebase Storage operations:

| Route Path | Screen / Widget | Riverpod Provider | Firebase / Storage Operation | CRUD Type | Trigger / Push |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `/splash` | `SplashScreen` | `authStateProvider` | `FirebaseAuth.instance.authStateChanges()` | **Read** | Transitions to `/onboarding` or `/home` |
| `/onboarding` | `OnboardingScreen` | Local State / `SharedPreferences` | Sets local flag `onboarding_seen = true` | **Local Write** | Routes to `/login` |
| `/login` | `LoginScreen` | `signInNotifierProvider` | `FirebaseAuth.signInWithEmailAndPassword()` | **Auth Read** | Auth state stream updates router |
| `/register` | `RegisterScreen` | `registerNotifierProvider` | `FirebaseAuth.createUser()` + Storage `certificates/{uid}` + Firestore `users/{uid}` | **Create** | Sets verification status (`verified` or `pending`) |
| `/pending` | `VerificationPendingScreen` | `currentUserProvider` | `Firestore.collection('users').doc(uid).snapshots()` | **Live Stream** | Realtime transition to `/home` once admin approves |
| `/home` | `HomePage` | `currentUserProvider`, `directoryProvider` | `users/{uid}`, `events (limit 5)`, `jobs (limit 5)`, `alumni_directory` | **Live Stream** | Live metrics, spotlight carousel, quick tools |
| `/directory` | `DirectoryPage` | `directoryProvider` | Algolia Index `edu_alumni_directory` + Firestore `users` query | **Search / Read** | Dynamic filtering by batch year & department |
| `/directory/:id` | `AlumniProfilePage` | `alumniDetailProvider(id)` | `Firestore.collection('users').doc(id).snapshots()` | **Read** | Loads verified badges, work history, skills |
| `/mentorship` | `MentorsPage` | `mentorshipProvider` | `Firestore.collection('alumni_directory')` + `mentorship_requests` | **Read / Write** | "Request Mentorship" modal creates request record |
| `/mentorship/:id`| `MentorshipDetailPage` | `mentorshipDetailProvider(id)`| `Firestore.collection('mentorship_requests').doc(id)` | **Read / Update** | Accept / Reject mentorship session |
| `/chat` | `ChatPage` | `conversationsStreamProvider` | `Firestore.collection('chats').where('participants', 'array-contains', uid)` | **Live Stream** | Unread message counts, last message preview |
| `/chat/:id` | `ChatDetailPage` | `chatMessagesProvider(id)` | `Firestore.collection('chats').doc(id).collection('messages').orderBy('timestamp')` | **Stream / Create** | Sends message, updates read receipt, triggers FCM |
| `/events` | `EventsPage` | `eventsProvider` | `Firestore.collection('events').orderBy('date')` | **Live Stream** | Event category filter, RSVP status check |
| `/events/:id` | `EventDetailsPage` | `eventDetailProvider(id)` | `Firestore.collection('events').doc(id)` | **Read / Update** | RSVP toggles user UID in `attendees` array |
| `/jobs` | `OpportunitiesPage` | `jobsProvider` | `Firestore.collection('jobs').where('isActive', '==', true)` | **Live Stream** | Filters by full-time, part-time, internship |
| `/jobs/:id` | `JobDetailsPage` | `jobDetailProvider(id)` | `Firestore.collection('jobs').doc(id)` | **Read** | Job description, requirements, referral button |
| `/profile` | `ProfileScreen` | `currentUserProvider` | `Firestore.collection('users').doc(uid).snapshots()` | **Live Stream** | Displays profile completion meter & stats |
| `/profile/edit` | `EditProfileScreen` | `profileEditNotifierProvider` | Storage `avatars/{uid}` + Firestore `users/{uid}.update()` | **Update** | Syncs new bio, company, skills to Algolia |
| `/notifications`| `NotificationsPage` | `notificationsProvider` | `Firestore.collection('users').doc(uid).collection('notifications')` | **Live Stream** | Mark notifications read, direct route links |
| `/admin` | `AdminPortalPage` | `adminVerificationProvider` | `Firestore.collection('users').where('verification_status', '==', 'pending')` | **Read / Update** | Admin verifies/rejects alumni certificates |

---

## 5. End-to-End Sequence Diagrams

### Complete Mentorship Match to Real-Time Chat Lifecycle

```mermaid
sequenceDiagram
    autonumber
    actor Student as EDU Student (Alice)
    participant MentorsUI as MentorsPage (/mentorship)
    participant RequestProv as MentorshipProvider
    participant Firestore as Cloud Firestore
    participant CloudFn as Cloud Functions (FCM Dispatcher)
    actor Alumni as EDU Alumni (Bob)
    participant ChatUI as ChatDetailPage (/chat/:id)

    Student->>MentorsUI: Taps "Request Mentorship" on Bob's card
    MentorsUI->>Student: Displays Modal (Goal: Career Guidance, Message: "Hi Bob...")
    Student->>MentorsUI: Confirms and Taps "Send Request"
    MentorsUI->>RequestProv: submitRequest(mentorId: Bob, studentId: Alice, goal, msg)
    RequestProv->>Firestore: collection('mentorship_requests').add({studentId: Alice, mentorId: Bob, status: 'pending'})
    
    Firestore->>CloudFn: onCreate trigger on mentorship_requests
    CloudFn->>Alumni: FCM Push Notification: "Alice requested mentorship with you!"
    
    Alumni->>MentorsUI: Opens notification / Mentorship Tab
    Alumni->>MentorsUI: Taps "Accept Request"
    MentorsUI->>Firestore: mentorship_requests/{id}.update({status: 'accepted'})
    
    Firestore->>CloudFn: onUpdate (status == 'accepted') trigger
    CloudFn->>Firestore: collection('chats').add({participants: [Alice, Bob], createdAt: now, lastMessage: 'Mentorship started!'})
    CloudFn->>Student: FCM Push: "Bob accepted your mentorship request!"
    
    Student->>ChatUI: Opens /chat/:newChatId
    Student->>ChatUI: Sends "Thank you Bob! When is a good time to talk?"
    ChatUI->>Firestore: chats/{newChatId}/messages.add({text: "...", senderId: Alice})
    Firestore-->>Alumni: Live Snapshot updates Bob's chat room in real-time
```

---

## 6. Security Rules & Access Control Matrix

```mermaid
graph TD
    subgraph Roles ["👥 Role-Based Access Control (RBAC)"]
        StudentRole["Student (@eastdelta.edu.bd)"]
        AlumniRole["Alumni (Verified Certificate)"]
        PendingAlumni["Alumni (Pending Verification)"]
        AdminRole["University Admin"]
    end

    subgraph Collections ["🔒 Cloud Firestore Security Enforcements"]
        UsersCol["users/{uid}<br/>• Public read for basic info<br/>• Self write only"]
        RequestsCol["mentorship_requests/{id}<br/>• Read/Write if participant in request<br/>• Admin read-all"]
        ChatsCol["chats/{id}/messages/{msgId}<br/>• Read/Write only if UID in participants array"]
        EventsCol["events/{id}<br/>• Public read<br/>• Admin write only<br/>• Users can update attendees array"]
        JobsCol["jobs/{id}<br/>• Public read<br/>• Verified Alumni & Admin write"]
        AdminCol["admin_logs & verifications<br/>• Admin role only (Custom Claims)"]
    end

    StudentRole -->|Read/Write Self| UsersCol
    StudentRole -->|Create & View Own| RequestsCol
    StudentRole -->|Read & Send if Participant| ChatsCol
    StudentRole -->|Read & RSVP| EventsCol
    StudentRole -->|Read & Apply| JobsCol

    AlumniRole -->|Read/Write Self| UsersCol
    AlumniRole -->|Accept/Decline Own| RequestsCol
    AlumniRole -->|Read & Send if Participant| ChatsCol
    AlumniRole -->|Read & RSVP| EventsCol
    AlumniRole -->|Post Opportunities| JobsCol

    PendingAlumni -->|Read Self Only| UsersCol
    PendingAlumni -->|Blocked from Directory/Chat| ChatsCol

    AdminRole -->|Full Read/Write Access| UsersCol
    AdminRole -->|Verify/Reject| AdminCol
    AdminRole -->|Manage Events| EventsCol
    AdminRole -->|Manage Jobs| JobsCol
```

---

## 7. Summary & Best Practices

1. **Clean Architecture Separation**: Presentation (Widgets) is strictly decoupled from Data Sources via Riverpod Notifiers and Use Cases.
2. **Offline-First & Resilience**: App gracefully falls back to local cached snapshots when network connectivity is interrupted.
3. **Reactive UI Updates**: All active lists (Chat messages, Notifications, Requests) consume reactive Firestore Streams for instantaneous state syncing.
4. **Declarative Navigation**: GoRouter provides URL-based deep linking and route protection via unified auth guards.
