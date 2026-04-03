import SwiftUI
import RealityKit
import ReplayKit

struct ARCameraView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var arView = ARView(frame: .zero)
    @State private var intensity: Double = 0.7
    @State private var fusion: Double = 0.8
    @State private var heartRate: Int = 72
    @State private var isRecording = false
    
    var body: some View {
        ZStack {
            ARViewContainer(arView: $arView).ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("境音").font(.largeTitle.bold()).foregroundStyle(.white.shadow(.drop(radius: 10)))
                    Spacer()
                    HeartRateView(heartRate: $heartRate)
                }
                .padding(.horizontal).padding(.top, 50)
                Spacer()
                ControlPanel(intensity: $intensity, fusion: $fusion).padding(.bottom, 40)
            }
            
            CaptureButton { await captureAndExportVideo() }
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 180)
        }
        .onAppear {
            ARManager.shared.startSession(in: arView)
            simulateHealthKit()
            Task { await generateInitialMusic() }
        }
    }
    
    private func simulateHealthKit() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            heartRate = Int.random(in: 65...85)
        }
    }
    
    @MainActor
    private func generateInitialMusic() async {
        let prompt = try? await AppleIntelligenceService.shared.generateMusicPrompt(
            from: "樱花街道", heartRate: heartRate, intensity: intensity
        )
        let audioURL = try? await AppleIntelligenceService.shared.generateSpatialAudio(prompt: prompt ?? "")
        
        let soundscape = Soundscape(title: "AI 樱花梦")
        soundscape.prompt = prompt
        soundscape.audioURL = audioURL
        viewContext.insert(soundscape)
        try? viewContext.save()
    }
    
    @MainActor
    private func captureAndExportVideo() async {
        let exporter = VideoExporter()
        await exporter.start15SecondARRecording(in: arView) { url in
            let soundscape = Soundscape(title: "捕捉音灵 #\(Int.random(in: 100...999))")
            soundscape.audioURL = url
            viewContext.insert(soundscape)
            try? viewContext.save()
        }
    }
}
