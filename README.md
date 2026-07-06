# EDU Alumni Connect

> Alumni and student mentorship and networking platform for East Delta University.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Integrated-FFCA28?logo=firebase)](https://firebase.google.com/)
[![Riverpod](https://img.shields.io/badge/State_Management-Riverpod-blue)](https://riverpod.dev/)

EDU Alumni Connect is a mobile application designed to bridge the gap between current students and alumni of East Delta University. It facilitates mentorship, networking, and professional growth through an intuitive and feature-rich Flutter interface.

## 🚀 Features

*   **User Authentication:** Secure login and registration for students and alumni via Firebase Auth.
*   **Mentorship Matching:** Connect with experienced alumni in your field of interest.
*   **Real-time Messaging:** Communicate seamlessly using Firebase Firestore.
*   **Advanced Search:** Fast and relevant user search powered by Algolia.
*   **Push Notifications:** Stay updated with important events and messages via Firebase Cloud Messaging.
*   **Profile Management:** Customizable user profiles with avatars stored in Firebase Storage.

## 🛠 Tech Stack & Architecture

This project is built with scalability, maintainability, and testing in mind, adhering to modern Flutter best practices.

*   **Framework:** [Flutter](https://flutter.dev/)
*   **State Management & Dependency Injection:** [Riverpod](https://riverpod.dev/) (`riverpod_annotation`, `flutter_riverpod`)
*   **Routing:** [GoRouter](https://pub.dev/packages/go_router) for declarative routing.
*   **Backend & BaaS:** Firebase (Auth, Firestore, Storage, Cloud Functions, Messaging)
*   **Search Engine:** Algolia
*   **Code Generation:** `freezed`, `json_serializable`, `riverpod_generator`
*   **Functional Programming:** `fpdart` for error handling and functional paradigms.
*   **Architecture:** Feature-first modular architecture (Clean Architecture principles).

## 📁 Project Structure

```text
lib/
├── core/         # Core utilities, configuration, di, routing, themes
├── features/     # Feature modules (e.g., auth, profile, mentorship)
│   └── feature_name/
│       ├── domain/       # Entities, use cases, repository interfaces
│       ├── data/         # Models, repositories implementations, remote/local sources
│       └── presentation/ # Pages, widgets, controllers/providers
├── shared/       # Shared widgets, utilities across features
├── app.dart      # Main app widget and configuration
└── main.dart     # Entry point
```

## ⚙️ Getting Started

### Prerequisites

*   Flutter SDK (>=3.0.0 <4.0.0)
*   Dart SDK
*   Firebase CLI (for Firebase initialization if needed)

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-org/edu_alumni_connect.git
    cd edu_alumni_connect
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Code Generation:**
    Since the project uses `freezed`, `json_serializable`, and `riverpod_generator`, you must run the build runner to generate the necessary files:
    ```bash
    # Run once
    dart run build_runner build -d
    
    # Or watch for changes during development
    dart run build_runner watch -d
    ```

4.  **Run the application:**
    ```bash
    flutter run
    ```

## 🧪 Testing

The project is configured for comprehensive testing.

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/
```

## 📝 Guidelines

*   **State Management:** Avoid `setState` where possible; leverage Riverpod for reactive state management.
*   **Immutable State:** Use `freezed` for all data models and state classes to ensure immutability.
*   **Error Handling:** Use `fpdart`'s `Either` type to explicitly handle success and failure cases in repositories and use cases.
*   **UI Components:** Build reusable, dumb UI components in the `shared` folder and keep business logic inside Riverpod controllers.
