import SwiftUI

struct HeartRateView: View {
    @Binding var heartRate: Int
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "heart.fill")
                .foregroundStyle(.red)
            Text("\(heartRate)")
                .font(.title2.bold())
                .foregroundStyle(.white)
            Text("bpm")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
