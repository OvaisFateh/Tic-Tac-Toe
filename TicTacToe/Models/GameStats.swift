import Foundation

struct GameStats: Codable {
    var totalWins: Int = 0
    var totalLosses: Int = 0
    var totalDraws: Int = 0
    var winsBy: [String: Int] = [:]
    var currentStreak: Int = 0
    var bestStreak: Int = 0
    var lastPlayedDate: Date = Date()
    
    var totalGames: Int {
        totalWins + totalLosses + totalDraws
    }
    
    var winRate: Double {
        guard totalGames > 0 else { return 0 }
        return Double(totalWins) / Double(totalGames) * 100
    }
    
    var lossRate: Double {
        guard totalGames > 0 else { return 0 }
        return Double(totalLosses) / Double(totalGames) * 100
    }
}