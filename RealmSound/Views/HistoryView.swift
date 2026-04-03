import SwiftUI

struct HistoryView: View {
    @State private var soundscapes: [Soundscape] = [
        Soundscape(title: "樱花夜曲"),
        Soundscape(title: "雨巷回响")
    ]
    
    var body: some View {
        NavigationStack {
            List(soundscapes) { item in
                HStack {
                    Image(systemName: "music.note")
                    Text(item.title)
                }
            }
            .navigationTitle("我的音景")
        }
    }
}
