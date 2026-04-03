import RealityKit
import ARKit

class ARManager {
    static let shared = ARManager()
    private init() {}
    
    func startSession(in arView: ARView) {
        let config = ARWorldTrackingConfiguration()
        config.sceneReconstruction = .mesh
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config)
        
        createGlowingSpirit(in: arView)
    }
    
    private func createGlowingSpirit(in arView: ARView) {
        let anchor = AnchorEntity(.plane(.horizontal, classification: .floor))
        
        // 加载自定义 Metal Shader
        guard let metalLib = try? Device.default.makeDefaultLibrary(),
              let fragmentFunc = metalLib.makeFunction(name: "glowingParticleFragment"),
              let vertexFunc = metalLib.makeFunction(name: "glowingParticleVertex") else { return }
        
        var material = CustomMaterial(from: SimpleMaterial(color: .white, isMetallic: false))
        material.customFragmentShader = fragmentFunc
        material.customVertexShader = vertexFunc
        
        let mesh = MeshResource.generateSphere(radius: 0.25)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        // 实时 uniform（时间 + 强度）
        let timeParam = entity.playAnimation(for: .custom { time, _ in
            entity.components[CustomMaterialComponent.self]?.setParameter("time", value: Float(time))
            entity.components[CustomMaterialComponent.self]?.setParameter("intensity", value: Float(1.0))
        })
        
        anchor.addChild(entity)
        arView.scene.addAnchor(anchor)
    }
}
