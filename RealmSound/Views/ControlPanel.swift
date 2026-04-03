import SwiftUI

struct ControlPanel: View {
    @ObservedObject var arManager: ARManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Settings")
                    .font(.headline)
                Spacer()
                Button("Done") { dismiss() }
                    .foregroundColor(.purple)
            }
            .padding()
            
            Divider()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Soundscape detection
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Soundscape Detection", systemImage: "waveform")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        if let soundscape = arManager.currentSoundscape {
                            HStack {
                                Image(systemName: soundscape.category.icon)
                                Text(soundscape.name)
                                Spacer()
                                Text("\(soundscape.intensity * 100, specifier: "%.0f")%")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                        } else {
                            Text("Detecting...")
                                .foregroundColor(.secondary)
                                .padding()
                        }
                    }
                    .padding(.horizontal)
                    
                    // Heart rate
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Heart Rate", systemImage: "heart.fill")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                        
                        if let hr = arManager.currentHeartRate {
                            Text("\(hr) BPM")
                                .font(.title2)
                                .fontWeight(.bold)
                        } else {
                            Text("Not connected")
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Particle intensity
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Particle Intensity", systemImage: "sparkles")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Slider(value: .constant(0.7), in: 0...1)
                            .tint(.purple)
                    }
                    .padding(.horizontal)
                    
                    // Detected planes
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Environment", systemImage: "cube.transparent")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("\(arManager.detectedPlanes) planes detected")
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    ControlPanel(arManager: ARManager())
}
