import SwiftUI

struct LaunchScreen: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.purple.opacity(0.8), .blue.opacity(0.6), .black],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                    .symbolEffect(.breathe)
                
                Text("RealmSound")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                
                Text("Capture the unseen")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
            }
            
            if isActive {
                ContentView()
                    .transition(.opacity)
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.5)) {
                isActive = true
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
