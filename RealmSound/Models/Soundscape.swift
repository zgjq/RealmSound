import Foundation

/// Represents an ambient soundscape detected in the environment
struct Soundscape: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let description: String
    let frequency: Double  // Hz
    let intensity: Double  // 0.0 - 1.0
    let category: Category
    
    enum Category: String, Codable, CaseIterable {
        case whisper = "Whisper"
        case chime = "Chime"
        case hum = "Hum"
        case resonance = "Resonance"
        case echo = "Echo"
        case silence = "Silence"
        
        var icon: String {
            switch self {
            case .whisper: return "wind"
            case .chime: return "bell"
            case .hum: return "waveform"
            case .resonance: return "speaker.wave.3"
            case .echo: return "sparkle"
            case .silence: return "moon.stars"
            }
        }
        
        var color: String {
            switch self {
            case .whisper: return "blue"
            case .chime: return "yellow"
            case .hum: return "green"
            case .resonance: return "purple"
            case .echo: return "orange"
            case .silence: return "indigo"
            }
        }
    }
    
    static let allCases: [Soundscape] = Category.allCases.map { category in
        Soundscape(
            id: UUID(),
            name: category.rawValue,
            description: category.description,
            frequency: Double.random(in: 20...20000),
            intensity: Double.random(in: 0.1...1.0),
            category: category
        )
    }
}

extension Soundscape.Category {
    var description: String {
        switch self {
        case .whisper: return "Soft ethereal whispers in the air"
        case .chime: return "Crystal-clear chime-like tones"
        case .hum: return "Deep resonant humming vibration"
        case .resonance: return "Rich harmonic resonance patterns"
        case .echo: return "Mysterious echoing soundscapes"
        case .silence: return "Profound silence that speaks volumes"
        }
    }
}
