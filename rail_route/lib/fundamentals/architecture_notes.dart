/*
Flutter Architecture Summary (For Understanding)

Framework Layer (Dart):
- Material & Cupertino widgets
- Animations, gestures, rendering logic
- This is where we write our UI code

Engine Layer (C++):
- Skia for rendering
- Text layout, accessibility
- Dart runtime

Embedder Layer:
- Platform-specific (Android, iOS, Web)
- Handles input, lifecycle, OS APIs

Key Insight:
Flutter does NOT use native UI widgets.
Everything is drawn using Skia → pixel-perfect UI.
*/
