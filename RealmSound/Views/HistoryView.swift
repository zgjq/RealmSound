import SwiftUI

struct HistoryView: View {
    @StateObject private var arManager = ARManager()
    @State private var selectedSpirit: CapturedSpirit?
    @State private var filterRarity: CapturedSpirit.Rarity?
    
    var filteredSpirits: [CapturedSpirit] {
        if let rarity = filterRarity {
            return arManager.spirits.filter { $0.rarity == rarity }
        }
        return arManager.spirits
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if arManager.spirits.isEmpty {
                    ContentUnavailableView(
                        "No Spirits Captured",
                        systemImage: "sparkles",
                        description: Text("Use the Capture tab to find and capture spirits in augmented reality.")
                    )
                } else {
                    ScrollView {
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 16
                        ) {
                            ForEach(filteredSpirits) { spirit in
                                SpiritCard(spirit: spirit)
                                    .onTapGesture {
                                        selectedSpirit = spirit
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Spirit Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Rarity filter
                Menu {
                    Button("All") { filterRarity = nil }
                    ForEach(CapturedSpirit.Rarity.allCases, id: \.self) { rarity in
                        Button(rarity.rawValue) { filterRarity = rarity }
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
            }
            .sheet(item: $selectedSpirit) { spirit in
                SpiritDetailSheet(spirit: spirit)
            }
            .task {
                arManager.loadSpirits()
            }
        }
    }
}

struct SpiritCard: View {
    let spirit: CapturedSpirit
    
    var body: some View {
        VStack(spacing: 8) {
            // Spirit icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(spirit.rarity.color).opacity(0.3),
                                Color(spirit.rarity.color).opacity(0.1)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: spirit.rarity.icon)
                    .font(.system(size: 36))
                    .foregroundStyle(Color(spirit.rarity.color))
            }
            
            // Spirit name
            Text(spirit.name)
                .font(.caption)
                .fontWeight(.semibold)
                .lineLimit(1)
            
            // Rarity badge
            Label(spirit.rarity.rawValue, systemImage: spirit.rarity.icon)
                .font(.caption2)
                .foregroundColor(Color(spirit.rarity.color))
            
            // Capture date
            Text(spirit.capturedAt.formatted(date: .abbreviated, time: .omitted))
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(16)
    }
}

extension CapturedSpirit.Rarity: CaseIterable {
    public static var allCases: [CapturedSpirit.Rarity] {
        [.common, .rare, .epic, .legendary]
    }
}

#Preview {
    HistoryView()
}
