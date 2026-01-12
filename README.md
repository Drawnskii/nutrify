# Nutrify 🍎📸

**Nutrify** is a Flutter-based mobile application that lets users scan their meals, analyze food images with an LLM, and get ingredient identification and calorie estimates in real time.

## 🚀 About the Project

Nutrify leverages the power of Artificial Intelligence to help users maintain a healthy lifestyle. By simply taking a photo of their meal, the app processes the image to break down ingredients and estimate nutritional value, removing the friction of manual logging.

## 🏗 Architecture

This project follows the **Riverpod Architecture** (also known as "Feature-First Architecture" or "Layered Architecture"), as proposed by [Andrea Bizzotto](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/).

We emphasize a strict separation of concerns divided by **Features**, and within each feature, by **Layers**:

1.  **Data Layer:** Repositories and Data Sources (Talking to APIs/Firebase).
2.  **Domain Layer:** Business models and Entities (Pure Dart classes).
3.  **Application Layer:** Service classes that orchestrate logic (optional, dependent on complexity).
4.  **Presentation Layer:** Widgets (UI) and Controllers (State Management).

### Directory Structure

The code is organized by features inside `lib/src/features`. A typical feature looks like this:

```text
lib/
├── src/
│   ├── features/
│   │   ├── authentication/       <-- Feature: Auth
│   │   │   ├── data/             # Repositories (Firebase implementation)
│   │   │   ├── domain/           # User models
│   │   │   ├── presentation/     # Screens & Controllers (Riverpod)
│   │   │   └── application/      # Services (if needed)
│   │   ├── meal_scanner/         <-- Feature: Scanning & LLM
│   │   │   ├── ...
│   ├── constants/                # App-wide constants
│   ├── utils/                    # Helper functions
│   └── routing/                  # Navigation configuration
└── main.dart

```

## 🛠 Tech Stack

* **Framework:** Flutter (Android & iOS)
* **Backend/Auth:** Firebase Auth, Firebase Core
* **State Management:** Flutter Riverpod (with Code Generation)
* **Code Generation:** Freezed & Riverpod Generator
* **Architecture:** Layered Architecture (Riverpod)

## 🔑 Firebase Configuration (Crucial)

This project uses **Firebase**. The file `firebase_options.dart` contains sensitive credentials and is **NOT** included in the repository (it is in `.gitignore`).

**To run this project, you must generate your own credentials:**

1. Install the Firebase CLI: `npm install -g firebase-tools`
2. Log in: `firebase login`
3. Activate FlutterFire CLI: `dart pub global activate flutterfire_cli`
4. In the root of the project, run:
```bash
flutterfire configure

```

5. Select your Firebase project and the platforms (Android & iOS). This will generate the `lib/firebase_options.dart` file automatically.

## 💻 Getting Started

### Prerequisites

* [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
* [VS Code](https://code.visualstudio.com/) or Android Studio.
* An Android Emulator or iOS Simulator.

### Installation Steps

1. **Clone the repository:**
```bash
git clone https://github.com/Drawnskii/nutrify.git
cd nutrify

```

2. **Install dependencies:**
```bash
flutter pub get

```

3. **Run Code Generator (Important):**
Since we use `riverpod_generator` and `freezed`, you must run the build runner to generate the `.g.dart` and `.freezed.dart` files.
```bash
# Run once
dart run build_runner build -d

# Or keep watching for changes (recommended during development)
dart run build_runner watch -d

```

4. **Configure Firebase:**
(Follow the steps in the "Firebase Configuration" section above).
5. **Run the App:**
Select your device (Android/iOS) and run:
```bash
flutter run

```

---

Made with ❤️ by the Nutrify Team.