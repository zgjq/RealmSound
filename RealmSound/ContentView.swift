import SwiftUI

struct ContentView: View {
    @State private var showARCamera = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ARCameraView()
                .tabItem {
                    Image(systemName: "camera.viewfinder")
                    Text("Capture")
                }
                .tag(0)
            
            HistoryView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }
                .tag(1)
            
            HeartRateView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Heart Rate")
                }
                .tag(2)
        }
        .tint(.purple)
    }
}

#Preview {
    ContentView()
}
