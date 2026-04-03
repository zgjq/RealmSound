import CoreData
import Foundation

@Model
final class Soundscape {
    var id: UUID = UUID()
    var title: String
    var timestamp: Date = Date()
    var locationLat: Double?
    var locationLon: Double?
    var prompt: String?
    var audioURL: URL?
    var isPublic: Bool = false
    var moodScore: Double = 0.0
    
    @Relationship(deleteRule: .cascade) var spirits: [CapturedSpirit] = []
    
    init(title: String) {
        self.title = title
    }
}

@Model
final class CapturedSpirit {
    var id: UUID = UUID()
    var type: String = "koi"
    var colorHex: String = "#00FFFF"
    var name: String?
    
    @Relationship var soundscape: Soundscape?
}
