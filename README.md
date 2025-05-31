# NegXus

*A Flutter application with native C/C++ integrations and Firebase support.*

---

## Table of Contents
1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Technology Stack](#technology-stack)
4. [Repository Structure](#repository-structure)
5. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Installation](#installation)
   - [Running the App](#running-the-app)
6. [Native/C++ Module](#nativecpp-module)
7. [Firebase Integration](#firebase-integration)
8. [Folder Layout](#folder-layout)
9. [Contribution Guidelines](#contribution-guidelines)
10. [License](#license)

---

## Project Overview
NegXus is a cross-platform Flutter application that leverages both Dart and native C/C++ modules to deliver high-performance features. It integrates with Firebase for backend services (authentication, Firestore, hosting, etc.) and is structured to run on Android, iOS, Web, and desktop platforms (Windows, macOS, Linux).

---

## Features
- ✅ Cross-Platform UI with Material Design
- ⚙️ Native C/C++ Integration via Platform Channels
- 🔥 Firebase Support: Auth, Firestore, Hosting
- 🧩 Modular Code Architecture
- 🗂 Reusable Widgets and Utilities
- 🌐 Multi-platform Support: Android, iOS, Web, Desktop

---

## Technology Stack
- **Flutter & Dart**
- **C/C++** via **CMake**
- **Firebase**: Authentication, Firestore, Hosting
- **Tools**: Android Studio, VS Code, Firebase CLI, Git, Xcode, CMake

---

## Repository Structure
```
NegXus/
├─ android/
│ ├─ app/src/main/cpp/ # Native C/C++ code
│ └─ CMakeLists.txt # CMake build config
├─ ios/
│ ├─ Runner/
│ └─ Podfile
├─ linux/
├─ macos/
├─ windows/
├─ lib/
│ ├─ main.dart
│ ├─ widgets/
│ ├─ screens/
│ ├─ services/
│ └─ utils/
├─ assets/
│ ├─ images/
│ └─ fonts/
├─ test/
├─ firebase.json
├─ pubspec.yaml
├─ README.md
```

---

## Getting Started

### Prerequisites

- Flutter SDK (≥ 3.0)
- Android Studio or Xcode
- CMake (≥ 3.15)
- Firebase CLI
- Git

### Installation

```bash
git clone https://github.com/suyalneeraj19/NegXus.git
cd NegXus
flutter pub get

```
 ---


 ### Build Native Modules (Android)

```bash
cd android
./gradlew assembleDebug
cd ..

```

---

### Running the App
## Android
```bash
flutter run -d android
```
## iOS
```bash
flutter run -d ios
```

### Enable support:

```bash

flutter config --enable-linux-desktop
flutter config --enable-macos-desktop
flutter config --enable-windows-desktop
```

### Run:

```bash
flutter run 
```

### NegXus
```
├─ android/            # Android project & native code
├─ ios/                # iOS/macOS project
├─ linux/
├─ macos/
├─ windows/
├─ lib/                # Flutter source code
├─ assets/
├─ test/
├─ pubspec.yaml
├─ firebase.json
├─ README.md
```

### Contribution Guidelines

```
Fork the repository

Create a new branch: git checkout -b feature/your-feature-name

Commit your changes: git commit -m "Added some feature"

Push to your fork: git push origin feature/your-feature-name

Submit a Pull Request
```


---
## 📄 Project Documents

### 🔹 [Final SE Report (View on GitHub)](https://github.com/suyalneeraj19/NegXus/blob/master/FInal%20SE%20Report.pdf)
👉 [Download Final SE Report (PDF)](https://github.com/suyalneeraj19/NegXus/raw/master/FInal%20SE%20Report.pdf)

---

### 🔹 [SYNOPSIS (View on GitHub)](https://github.com/suyalneeraj19/NegXus/blob/master/SYNOPSIS.pdf)
👉 [Download SYNOPSIS (PDF)](https://github.com/suyalneeraj19/NegXus/raw/master/SYNOPSIS.pdf)

---

## 📲 Get the App

🔹 [⬇️ Download APK](https://github.com/suyalneeraj19/negxus_webb/releases/download/2.0.0/app-armeabi-v7a-release.apk)

🔹 [🌐 Visit App Website](https://suyalneeraj19.github.io/negxus_webb/)

---
