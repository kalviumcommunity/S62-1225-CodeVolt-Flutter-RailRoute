# Flutter Project Structure Documentation

## Introduction
Flutter follows a well-defined and organized project structure that separates application logic, platform-specific code, assets, configuration files, and testing utilities. This structure helps developers build scalable, maintainable, and cross-platform applications efficiently.

This document explains the purpose of each major folder and file in a Flutter project.

---

## Core Project Folders

### `lib/`
The `lib` folder contains all the Dart source code for the Flutter application.

- `main.dart` is the entry point of the application.
- This file initializes the app and runs the root widget.

As the application grows, the `lib` folder can be organized into subfolders for better modularity:

```
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   ├── profile_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── custom_button.dart
│   ├── header_widget.dart
│   └── card_widget.dart
├── services/
│   ├── api_service.dart
│   ├── database_service.dart
│   └── auth_service.dart
├── models/
│   ├── user.dart
│   ├── product.dart
│   └── order.dart
├── utils/
│   ├── constants.dart
│   └── helpers.dart
└── state/
    ├── providers/
    └── bloc/
```

This modular structure improves readability, reusability, and maintainability.

### `android/`
The `android` folder contains all Android-specific configuration and build files.

- Uses Gradle for build management.
- Allows the Flutter app to run as a native Android application.
- Contains Android Manifest, resources, and native Java/Kotlin code.

**Key files:**
- `android/app/build.gradle` – Manages app ID, version, build settings, and dependencies
- `android/app/src/main/AndroidManifest.xml` – Defines app permissions, activities, and metadata
- `android/app/src/main/res/` – Contains Android resources (layouts, strings, drawables)

### `ios/`
The `ios` folder contains iOS-specific files and configurations.

- Used when building and running the app on iOS devices using Xcode.
- Manages permissions, app metadata, and build settings.
- Contains native Swift/Objective-C code.

**Key files:**
- `ios/Runner/Info.plist` – Defines app name, permissions, and configuration details
- `ios/Runner/Assets.xcassets/` – Contains iOS app icons and images
- `ios/Podfile` – Manages iOS dependencies (CocoaPods)

### `assets/`
The `assets` folder stores static resources such as images, fonts, and JSON files.

- This folder is created manually.
- Assets must be declared in `pubspec.yaml` before use.
- Organized subfolders improve asset management.

**Example structure:**
```
assets/
├── images/
│   ├── logos/
│   ├── icons/
│   └── backgrounds/
├── fonts/
│   ├── Roboto-Regular.ttf
│   └── Montserrat-Bold.ttf
├── json/
│   ├── config.json
│   └── translations/
└── lottie/
    └── animations/
```

**Example configuration in `pubspec.yaml`:**
```yaml
flutter:
  assets:
    - assets/images/logos/
    - assets/images/icons/
    - assets/fonts/
    - assets/json/config.json
```

### `test/`
The `test` folder contains testing-related files.

- Used for unit tests, widget tests, and integration tests.
- The default `widget_test.dart` verifies that the sample app behaves correctly.
- This folder supports test-driven development and improves application reliability.

**Example structure:**
```
test/
├── unit/
│   ├── calculator_test.dart
│   └── utils_test.dart
├── widget/
│   ├── button_test.dart
│   └── card_test.dart
├── integration/
│   └── app_test.dart
└── mocks/
    └── mock_services.dart
```

---

## Key Configuration Files

### `pubspec.yaml`
The `pubspec.yaml` file is the main configuration file of a Flutter project.

**Sections included:**
1. **Project metadata** (name, description, version, environment)
2. **Dependencies** (packages from pub.dev, Git, or local)
3. **Dev dependencies** (testing and development tools)
4. **Flutter configuration** (assets, fonts, manifest)

**Complete example:**
```yaml
name: my_flutter_app
description: A beautiful Flutter application
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: '>=3.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  http: ^1.1.0
  provider: ^6.1.0
  shared_preferences: ^2.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  integration_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
  fonts:
    - family: Roboto
      fonts:
        - asset: assets/fonts/Roboto-Regular.ttf
        - asset: assets/fonts/Roboto-Bold.ttf
          weight: 700
```

### `.gitignore`
Specifies files and folders that should be excluded from version control.

**Standard Flutter `.gitignore`:**
```
# Flutter
.flutter-plugins
.flutter-plugins-dependencies
.packages
.dart_tool/
.flutter/

# Android
android/.gradle/
android/build/
android/local.properties
android/key.properties

# iOS
ios/.symlinks/
ios/Flutter/App.framework/
ios/Flutter/Flutter.framework/
ios/Flutter/Flutter.podspec
ios/Pods/
ios/Runner/GeneratedPluginRegistrant.*

# Build
build/
*.apk
*.ipa
*.aab

# IDE
.vscode/
.idea/
*.iml
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
```

### `README.md`
Provides an overview of the project.

**Typical sections:**
- Project title and description
- Features
- Installation instructions
- Build instructions
- Testing instructions
- Contributing guidelines
- License information

### `analysis_options.yaml`
Configures the Dart analyzer for code quality and linting.

**Example:**
```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - build/**
    - lib/generated_plugin_registrant.dart
  language:
    strict-casts: true
    strict-raw-types: true

linter:
  rules:
    - always_declare_return_types
    - avoid_empty_else
    - avoid_print
    - camel_case_types
    - constant_identifier_names
    - empty_statements
```

---

## Auto-Generated & Supporting Folders

### `build/`
- Auto-generated folder containing compiled output files.
- Created during build and run processes.
- Contains platform-specific build artifacts.
- Should not be edited manually or committed to version control.

### `.dart_tool/`
- Contains Dart-specific configuration and cache files.
- Managed by Dart and Flutter tools.
- Includes package configuration and build information.

### `.idea/` or `.vscode/`
- IDE-specific configuration files.
- Contains workspace settings, launch configurations, and code style.
- Helps maintain consistent development environment.

### `web/` (for web projects)
- Contains web-specific configuration when targeting web platform.
- Includes index.html, favicon, and web-specific assets.

### `windows/`, `linux/`, `macos/` (for desktop projects)
- Platform-specific folders for desktop targets.
- Contain native build configurations for respective platforms.

---

## Complete Project Structure Overview
```
my_flutter_app/
├── lib/                          # Dart source code
│   ├── main.dart                 # Application entry point
│   ├── screens/                  # All application screens
│   ├── widgets/                  # Reusable UI components
│   ├── models/                   # Data models/classes
│   ├── services/                 # Business logic and API calls
│   ├── utils/                    # Helper functions and constants
│   └── state/                    # State management
├── android/                      # Android-specific files
│   ├── app/
│   │   ├── build.gradle
│   │   └── src/main/
│   │       ├── AndroidManifest.xml
│   │       ├── java/
│   │       └── res/
│   └── gradle/
├── ios/                          # iOS-specific files
│   ├── Runner/
│   │   ├── Info.plist
│   │   ├── Assets.xcassets/
│   │   └── Base.lproj/
│   └── Podfile
├── assets/                       # Static resources
│   ├── images/
│   ├── fonts/
│   └── json/
├── test/                         # Test files
│   ├── unit/
│   ├── widget/
│   └── integration/
├── web/                          # Web-specific files
│   ├── index.html
│   └── favicon.png
├── pubspec.yaml                  # Project configuration
├── pubspec.lock                  # Dependency lock file
├── README.md                     # Project documentation
├── .gitignore                    # Git ignore rules
├── analysis_options.yaml         # Code analysis rules
├── LICENSE                       # License file
├── build/                        # Build outputs (generated)
├── .dart_tool/                   # Dart tool files (generated)
└── .idea/                        # IDE files (generated)
```
