import SwiftUI
import ARKit
import RealityKit

struct ARCameraView: View {
    @StateObject private var arManager = ARManager()
    @State private var showControlPanel = false
    @State private var capturedSpirit: CapturedSpirit?
    @State private var isRecording = false
    
    var body: some View {
        ZStack {
            ARViewContainer(arManager: arManager)
                .ignoresSafeArea()
            
            // Particle overlay
            if arManager.isSessionRunning {
                GlowingParticleOverlay()
                    .allowsHitTesting(false)
            }
            
            // Capture button
            VStack {
                Spacer()
                
                CaptureButton(isRecording: $isRecording) {
                    captureSpirit()
                }
                .padding(.bottom, 60)
                
                // Control panel toggle
                Button(action: { showControlPanel.toggle() }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
                .padding(.bottom, 20)
            }
            
            // Control panel sheet
            if showControlPanel {
                ControlPanel(arManager: arManager)
                    .transition(.move(edge: .bottom))
            }
        }
        .sheet(item: $capturedSpirit) { spirit in
            SpiritDetailSheet(spirit: spirit)
        }
    }
    
    private func captureSpirit() {
        isRecording = true
        
        // Simulate spirit capture
        let spirit = CapturedSpirit(
            id: UUID(),
            name: arManager.generateSpiritName(),
            capturedAt: Date(),
            soundscape: arManager.currentSoundscape,
            heartRate: arManager.currentHeartRate,
            imageUrl: nil
        )
        
        capturedSpirit = spirit
        arManager.saveSpirit(spirit)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isRecording = false
        }
    }
}

// MARK: - Particle Overlay (Metal Shader Integration)
struct GlowingParticleOverlay: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        // In production, add MTKView with Metal shader here
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

// MARK: - Spirit Detail Sheet
struct SpiritDetailSheet: View {
    let spirit: CapturedSpirit
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                    .foregroundStyle(.purple)
                
                Text(spirit.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                if let soundscape = spirit.soundscape {
                    Text(soundscape.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let heartRate = spirit.heartRate {
                    Label("\(heartRate) BPM", systemImage: "heart.fill")
                        .foregroundColor(.red)
                }
                
                Text(spirit.capturedAt.formatted(date: .long, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .navigationTitle("Captured Spirit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ARCameraView()
}
