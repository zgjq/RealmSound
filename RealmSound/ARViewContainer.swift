import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var arManager: ARManager
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arManager.setupARView(arView)
        return arView
    }
    
    func updateUIView(_ arView: ARView, context: Context) {
        arManager.updateARView(arView)
    }
}
