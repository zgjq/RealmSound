import SwiftUI

struct ControlPanel: View {
    @Binding var intensity: Double
    @Binding var fusion: Double
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Slider(value: $intensity, in: 0...1) {
                    Text("情绪强度")
                } minimumValueLabel: {
                    Image(systemName: "flame.fill")
                } maximumValueLabel: {
                    Image(systemName: "flame")
                }
                .tint(.pink)
            }
            
            HStack {
                Slider(value: $fusion, in: 0...1) {
                    Text("环境融合")
                } minimumValueLabel: {
                    Image(systemName: "leaf.fill")
                } maximumValueLabel: {
                    Image(systemName: "leaf")
                }
                .tint(.cyan)
            }
            
            HStack(spacing: 40) {
                Button(action: { print("🎵 重新生成音乐") }) {
                    Label("重生", systemImage: "arrow.clockwise.circle.fill")
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: { print("💾 保存记忆胶囊") }) {
                    Label("胶囊", systemImage: "capsule.fill")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal)
    }
}
