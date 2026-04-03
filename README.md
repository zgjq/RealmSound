# RealmSound

This is a creative app that **transforms your real-world surroundings into an immersive, generative music and AR visual experience in real time**. Wherever you go, simply point your phone’s camera, and the AI will “weave” a song unique to your current moment based on the objects around you, the weather, the time of day, the lighting, and your real-time physiological data (heart rate, step count, mood)—bringing the entire world to life —Singing light particles drift from cherry blossom trees, street cats transform into musical spirits dancing to the beat, and rainy days become a deep, cyber-forest atmosphere…

It’s not just an AR filter, nor is it merely background music; it’s an app that **turns everyday life into a personal music video and interactive dreamscape**, offering an incredibly immersive experience that you’ll want to share.

## Features
1. **Real-Time Ambient Sound Generation**  
   Open the camera → Vision recognizes the environment (trees, buildings, people, animals, weather) → Apple Intelligence generates prompts based on your HealthKit data (heart rate, steps, sleep) → Instantly generates spatial audio music using an on-device model (supports exporting as a full song).

2. **AR Sound Spirit Interaction**  
   Use ARKit to visualize music as 3D particles, creatures, and light effects. Users can “capture” Sound Spirits with their fingers, feed them, change their colors, and even collaborate with friends to perform together in the same space (multi-device AR anchor sharing).

3. **Mood Memory Capsules**  
   Automatically saves each soundscape along with the location and mood tags. When you return to the same place, the app will “remember” the music generated there previously, creating an emotional connection.

4. **Global Soundscape Map** (Social Feature)  
   Use MapKit to display the coordinates of soundscapes publicly shared by others. You can “teleport” there to experience the dreamlike versions they’ve left behind (similar to Pokémon GO, but entirely artistic).

5. **One-Click Export**  
   Directly generate vertical AR videos for TikTok/Xiaohongshu, Live Photos, or spatial audio files.

## Requirements
- **UI**: SwiftUI + RealityKit
- **AR & Vision**: ARKit + Vision Framework (object/scene recognition)
- **AI**: Apple Intelligence (writing + image/music prompt generation) + Core ML (on-device model fine-tuning)
- **Audio**: AVAudioEngine + Spatial Audio + MusicKit (if you want to integrate Apple Music-style features)
- **Data**: HealthKit + WeatherKit + Core Location
- **Backend**: CloudKit (for free soundscape sharing) or Supabase (for more social features)
- **Icons/Design**: Quickly create 3D sound spirit assets using Reality Composer Pro
 

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
