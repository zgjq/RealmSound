import SwiftUI
import HealthKit

struct HeartRateView: View {
    @StateObject private var healthManager = HeartRateHealthManager()
    @State private var heartRateHistory: [HeartRateSample] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Current heart rate
                    VStack(spacing: 8) {
                        if let currentHR = healthManager.currentHeartRate {
                            Text("\(currentHR)")
                                .font(.system(size: 80, weight: .bold, design: .rounded))
                                .foregroundColor(.red)
                            
                            Text("BPM")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        } else {
                            Image(systemName: "heart.slash")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            
                            Text("No heart rate data")
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(16)
                    
                    // Heart rate zone
                    if let hr = healthManager.currentHeartRate {
                        HeartRateZoneView(heartRate: hr)
                    }
                    
                    // History
                    if !heartRateHistory.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recent Readings")
                                .font(.headline)
                            
                            ForEach(heartRateHistory.prefix(10)) { sample in
                                HStack {
                                    Text("\(sample.bpm)")
                                        .fontWeight(.semibold)
                                    Text("BPM")
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(sample.date.formatted(date: .omitted, time: .shortened))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("Heart Rate")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await healthManager.requestAuthorization()
                heartRateHistory = await healthManager.fetchRecentSamples()
            }
        }
    }
}

struct HeartRateZoneView: View {
    let heartRate: Int
    
    var zone: (name: String, color: Color, range: String) {
        switch heartRate {
        case ..<60: return ("Resting", .blue, "< 60")
        case 60..<100: return ("Normal", .green, "60-100")
        case 100..<140: return ("Fat Burn", .yellow, "100-140")
        case 140..<170: return ("Cardio", .orange, "140-170")
        default: return ("Peak", .red, "170+")
        }
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(zone.color)
                .frame(width: 12, height: 12)
            
            Text(zone.name)
                .fontWeight(.semibold)
            
            Spacer()
            
            Text("Zone: \(zone.range)")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct HeartRateSample: Identifiable {
    let id = UUID()
    let bpm: Int
    let date: Date
}

@MainActor
class HeartRateHealthManager: ObservableObject {
    @Published var currentHeartRate: Int?
    private let healthStore = HKHealthStore()
    
    func requestAuthorization() async {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        let typesToRead: Set = [heartRateType]
        
        do {
            try await healthStore.requestAuthorization(toShare: nil, read: typesToRead)
            startObserving()
        } catch {
            print("Health authorization error: \(error)")
        }
    }
    
    private func startObserving() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        
        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { [weak self] _, _, _ in
            Task { @MainActor in
                self?.fetchLatestHeartRate()
            }
        }
        
        healthStore.execute(query)
    }
    
    private func fetchLatestHeartRate() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: nil,
            limit: 1,
            sortDescriptors: [sortDescriptor]
        ) { [weak self] _, samples, _ in
            guard let sample = samples?.first as? HKQuantitySample else { return }
            let bpm = Int(sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())))
            
            Task { @MainActor in
                self?.currentHeartRate = bpm
            }
        }
        
        healthStore.execute(query)
    }
    
    func fetchRecentSamples() async -> [HeartRateSample] {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return [] }
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: nil,
            limit: 20,
            sortDescriptors: [sortDescriptor]
        ) { _, samples, _ in
            // Handle in completion
        }
        
        // Simplified: return empty for now
        return []
    }
}

#Preview {
    HeartRateView()
}
