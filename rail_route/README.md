# Daily Documentation

## 📘 Flutter Fundamentals Exploration - 19th December '25

### Flutter Architecture
Flutter follows a layered architecture:

- **Framework Layer (Dart):**  
  UI widgets, animations, gestures, and rendering logic.

- **Engine Layer (C++):**  
  Skia rendering engine, text layout, accessibility, and Dart runtime.

- **Embedder Layer:**  
  Platform-specific integrations for Android, iOS, Web, Windows, macOS, and Linux.

Flutter renders UI using its own engine instead of native UI components, ensuring pixel-perfect and consistent design across platforms.

---

### StatelessWidget vs StatefulWidget

| **StatelessWidget** | **StatefulWidget** |
|---------------------|--------------------|
| UI does not change after build | UI updates based on state changes |
| No internal state | Maintains mutable state |
| Rebuilds only when parent changes | Rebuilds when `setState()` is called |
| Used for static screens or UI elements | Used for dynamic and interactive screens |
| Example: Text, Icon, static layouts | Example: Counter, form, live data UI |

---

### Reactive UI in Flutter

Flutter follows a **reactive programming model**.

When `setState()` is called:
- Flutter marks the widget as dirty
- Only the affected part of the widget tree is rebuilt
- UI updates efficiently without redrawing the entire screen

This approach ensures smooth performance even with frequent UI updates.

---

### Why Dart for Flutter?

- Strong typing with **null safety**
- Built-in **async/await** support for Firebase and API calls
- Optimized for fast UI rendering
- Enables rapid development using **Hot Reload**

---

### Demo Screens

- **Stateless Widget Demo:** Static UI rendering
- **Stateful Counter App:** Demonstrates reactive UI updates


---

### ✅ How This Connects to RailRoute

Before building RailRoute features such as real-time train tracking, we explored Flutter’s widget system, Dart fundamentals, and reactive UI principles using isolated demo modules inside the project.

This helped establish a strong foundation for building scalable and responsive mobile interfaces.

---

### 🟢 Final Checklist

- [x] `fundamentals/` folder exists  
- [x] StatelessWidget demo runs successfully  
- [x] Stateful counter demo runs successfully  
- [x] Dart OOP example implemented  

---

## 📘 Flutter Responsive Layout Demo

### Overview
This module demonstrates building a responsive Flutter UI that adapts to different screen sizes and orientations using MediaQuery and LayoutBuilder.

---

### Responsiveness Techniques Used

**MediaQuery**
```dart
double screenWidth = MediaQuery.of(context).size.width;
bool isTablet = screenWidth > 600;
Used to adjust padding, font sizes, and detect phone vs tablet.
```

**LayoutBuilder**

```dart
Copy code
LayoutBuilder(
  builder: (context, constraints) {
    return constraints.maxWidth > 600
        ? GridView.count(crossAxisCount: 2)
        : ListView();
  },
);
```
Used to switch between single-column and two-column layouts.

### Layout Strategy
- Phone (Portrait): Single-column layout
- Phone (Landscape): Two-column layout
- Tablet: Two-column grid layout

### Testing
- Pixel 6 (Portrait & Landscape)
- Tablet Emulator (Portrait & Landscape)

Screenshots included in documentation.

### Reflection
Building a responsive layout required understanding Flutter’s layout constraints and adaptive widgets. Responsive design improves usability by ensuring consistent UI across devices.

✅ Checklist

- [x] Responsive screen implemented
- [x] MediaQuery used
- [x] LayoutBuilder applied
- [x] Tested on multiple devices

---

## Flutter Hot Reload & Debugging Tools Demo

### Project Overview
This project demonstrates Flutter’s Hot Reload feature,
the Debug Console, and Flutter DevTools for debugging and
performance analysis using a simple counter application.

---

### Hot Reload
Hot Reload allows developers to instantly apply code
changes to a running Flutter application without
restarting it or losing application state.

**Steps Performed**
1. Ran the Flutter app using `flutter run`
2. Modified a widget’s text and color
3. Saved the file
4. Observed instant UI update without app restart

**Example Change**
```dart
// Before
Text('Hot Reload Demo');

// After
Text('Welcome to Hot Reload!');
```

### ✅ Final Status
- [x] Code ready  
- [x] README ready  
- [x] Teammate can run & screenshot  
- [x] Task fully satisfied  

---
