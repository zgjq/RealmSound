import Foundation

/// Represents a captured spirit entity
struct CapturedSpirit: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let capturedAt: Date
    let soundscape: Soundscape?
    let heartRate: Int?
    let imageUrl: String?
    
    /// Spirit rarity based on capture conditions
    var rarity: Rarity {
        var score = 0.0
        
        if let soundscape = soundscape {
            score += soundscape.intensity
            if soundscape.frequency > 10000 { score += 0.3 }
        }
        
        if let hr = heartRate {
            if hr > 100 { score += 0.2 }
            if hr < 60 { score += 0.3 } // Rare: calm state capture
        }
        
        if score > 1.5 { return .legendary }
        if score > 1.0 { return .epic }
        if score > 0.5 { return .rare }
        return .common
    }
    
    enum Rarity: String, Codable {
        case common = "Common"
        case rare = "Rare"
        case epic = "Epic"
        case legendary = "Legendary"
        
        var color: String {
            switch self {
            case .common: return "gray"
            case .rare: return "blue"
            case .epic: return "purple"
            case .legendary: return "orange"
            }
        }
        
        var icon: String {
            switch self {
            case .common: return "circle"
            case .rare: return "diamond"
            case .epic: return "star"
            case .legendary: return "sparkle"
            }
        }
    }
}
