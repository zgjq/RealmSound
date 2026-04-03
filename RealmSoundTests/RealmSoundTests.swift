import XCTest
@testable import RealmSound

final class RealmSoundTests: XCTestCase {
    
    func testSoundscapeCreation() {
        let soundscape = Soundscape(
            id: UUID(),
            name: "Whisper",
            description: "Soft ethereal whispers",
            frequency: 440.0,
            intensity: 0.7,
            category: .whisper
        )
        
        XCTAssertEqual(soundscape.name, "Whisper")
        XCTAssertEqual(soundscape.frequency, 440.0)
        XCTAssertEqual(soundscape.intensity, 0.7)
        XCTAssertEqual(soundscape.category, .whisper)
    }
    
    func testSpiritRarity() {
        // Common spirit
        let commonSpirit = CapturedSpirit(
            id: UUID(),
            name: "Test Spirit",
            capturedAt: Date(),
            soundscape: Soundscape(
                id: UUID(),
                name: "Whisper",
                description: "",
                frequency: 100,
                intensity: 0.1,
                category: .whisper
            ),
            heartRate: 75,
            imageUrl: nil
        )
        
        XCTAssertEqual(commonSpirit.rarity, .common)
    }
    
    func testSpiritCodable() {
        let spirit = CapturedSpirit(
            id: UUID(),
            name: "Lumina",
            capturedAt: Date(),
            soundscape: nil,
            heartRate: 80,
            imageUrl: nil
        )
        
        let encoder = JSONEncoder()
        let data = try? encoder.encode(spirit)
        XCTAssertNotNil(data)
        
        let decoder = JSONDecoder()
        let decoded = try? decoder.decode(CapturedSpirit.self, from: data!)
        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded?.name, "Lumina")
    }
    
    func testARManagerSaveSpirit() {
        let manager = ARManager()
        let spirit = CapturedSpirit(
            id: UUID(),
            name: "Test",
            capturedAt: Date(),
            soundscape: nil,
            heartRate: nil,
            imageUrl: nil
        )
        
        manager.saveSpirit(spirit)
        XCTAssertEqual(manager.spirits.count, 1)
        XCTAssertEqual(manager.spirits.first?.name, "Test")
    }
}
