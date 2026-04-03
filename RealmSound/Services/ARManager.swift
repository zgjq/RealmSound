import Foundation
import ARKit
import RealityKit
import SwiftUI

/// Manages AR session, anchor placement, and spirit spawning
@MainActor
class ARManager: ObservableObject {
    @Published var isSessionRunning = false
    @Published var detectedPlanes: Int = 0
    @Published var currentSoundscape: Soundscape?
    @Published var currentHeartRate: Int?
    @Published var spirits: [CapturedSpirit] = []
    @Published var errorMessage: String?
    
    private var arView: ARView?
    private var anchorEntity = AnchorEntity(world: .zero)
    private let soundscapeService = AppleIntelligenceService()
    
    func setupARView(_ view: ARView) {
        arView = view
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if let frame = view.session.currentFrame {
            let lightEstimate = frame.lightEstimate
            // Use light estimate for particle intensity
        }
        
        view.session.run(config)
        isSessionRunning = true
        
        // Add anchor to scene
        view.scene.addAnchor(anchorEntity)
        
        // Start simulating soundscape detection
        startSoundscapeDetection()
    }
    
    func updateARView(_ view: ARView) {
        // Update AR view state if needed
    }
    
    /// Simulate ambient soundscape detection
    private func startSoundscapeDetection() {
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            Task { @MainActor in
                self.currentSoundscape = Soundscape.allCases.randomElement()
            }
        }
    }
    
    /// Place a spirit anchor at a random position in AR space
    func placeSpiritAnchor() {
        let x = Double.random(in: -2...2)
        let y = Double.random(in: 0.5...2.0)
        let z = Double.random(in: -3...(-1))
        
        let spiritAnchor = AnchorEntity(world: SIMD3<Float>(Float(x), Float(y), Float(z)))
        
        // Add visual representation
        let sphere = ModelEntity(
            mesh: .generateSphere(radius: 0.1),
            materials: [SimpleMaterial(color: .purple, isMetallic: false)]
        )
        spiritAnchor.addChild(sphere)
        anchorEntity.addChild(spiritAnchor)
    }
    
    /// Save a captured spirit to local storage
    func saveSpirit(_ spirit: CapturedSpirit) {
        spirits.insert(spirit, at: 0)
        saveSpiritsToDisk()
    }
    
    /// Load saved spirits from disk
    func loadSpirits() {
        guard let url = spiritsFileURL else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        spirits = (try? JSONDecoder().decode([CapturedSpirit].self, from: data)) ?? []
    }
    
    /// Generate a spirit name
    func generateSpiritName() -> String {
        AppleIntelligenceService.shared.generateSpiritName(
            soundscape: currentSoundscape,
            heartRate: currentHeartRate
        )
    }
    
    // MARK: - Persistence
    
    private var spiritsFileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent("spirits.json")
    }
    
    private func saveSpiritsToDisk() {
        guard let url = spiritsFileURL else { return }
        guard let data = try? JSONEncoder().encode(spirits) else { return }
        try? data.write(to: url)
    }
}
