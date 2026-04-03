import SwiftUI

struct CaptureButton: View {
    @Binding var isRecording: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Outer ring
                Circle()
                    .stroke(isRecording ? Color.red : Color.white, lineWidth: 4)
                    .frame(width: 80, height: 80)
                
                // Inner button
                Circle()
                    .fill(isRecording ? Color.red : Color.white.opacity(0.9))
                    .frame(width: isRecording ? 30 : 65, height: isRecording ? 30 : 65)
                    .animation(.spring(response: 0.3), value: isRecording)
                
                // Glow effect
                if isRecording {
                    Circle()
                        .stroke(Color.red.opacity(0.3), lineWidth: 8)
                        .frame(width: 90, height: 90)
                        .scaleEffect(1.2)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isRecording)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        CaptureButton(isRecording: .constant(false)) {}
    }
}
