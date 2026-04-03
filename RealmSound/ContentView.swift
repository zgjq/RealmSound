import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ARCameraView()
                .tabItem {
                    Label("实时境音", systemImage: "camera.circle.fill")
                }
            
            HistoryView()
                .tabItem {
                    Label("我的音景", systemImage: "music.note.list")
                }
            
            // 后续可替换为 MapKit 地图
            Text("全球音景地图")
                .tabItem {
                    Label("地图", systemImage: "map")
                }
            
            Text("设置")
                .tabItem {
                    Label("设置", systemImage: "gear")
                }
        }
        .tint(.purple)
    }
}
