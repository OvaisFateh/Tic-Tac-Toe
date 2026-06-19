import Foundation

class StatisticsManager {
    static let shared = StatisticsManager()
    private let statsKey = "gameStats"
    
    func saveStats(_ stats: GameStats) {
        if let encoded = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(encoded, forKey: statsKey)
        }
    }
    
    func loadStats() -> GameStats {
        if let saved = UserDefaults.standard.data(forKey: statsKey),
           let decoded = try? JSONDecoder().decode(GameStats.self, from: saved) {
            return decoded
        }
        return GameStats()
    }
}