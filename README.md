# RealmSound

A magical AR experience app that captures ethereal "spirits" through your camera. Built with SwiftUI, ARKit, and Metal shaders.

## Features
- 🎥 AR Camera with real-time particle effects
- ✨ Custom Metal Shader for glowing particles
- 💓 Heart rate integration (Apple Watch)
- 🧠 Apple Intelligence API integration
- 📸 Capture & export spirit videos
- 📜 History of captured spirits

## Requirements
- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- Apple Silicon Mac for development

## Setup
1. Clone the repository
2. Open `RealmSound.xcodeproj` in Xcode
3. Select your development team
4. Build and run on a physical iOS device (AR requires camera)

## Architecture
```
RealmSound/
├── Models/          # Data models (Soundscape, CapturedSpirit)
├── Services/        # Business logic (AR, AI, Video)
├── Views/           # SwiftUI views
├── Shaders/         # Metal shader files
└── Assets.xcassets/ # Images & icons
```
