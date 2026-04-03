import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var arView: ARView
    
    func makeUIView(context: Context) -> ARView {
        arView.environment.background = .cameraFeed()
        arView.renderOptions = [.disableMotionBlur, .disableGroundingShadows]
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
