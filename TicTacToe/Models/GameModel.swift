import Foundation
import Combine

enum Player: Equatable {
    case human
    case ai
}

enum GameMode: Equatable {
    case twoPlayer
    case aiEasy
    case aiMedium
    case aiHard
    
    var displayName: String {
        switch self {
        case .twoPlayer:
            return "Two Players"
        case .aiEasy:
            return "vs AI (Easy)"
        case .aiMedium:
            return "vs AI (Medium)"
        case .aiHard:
            return "vs AI (Hard)"
        }
    }
}

class GameModel: ObservableObject {
    @Published var board: [Player?] = Array(repeating: nil, count: 9)
    @Published var currentPlayer: Player = .human
    @Published var gameMode: GameMode = .twoPlayer
    @Published var isGameActive = false
    @Published var isGameOver = false
    @Published var gameResult: String = ""
    @Published var moveHistory: [(index: Int, player: Player)] = []
    @Published var winningCells: [Int] = []
    @Published var stats = GameStats()
    @Published var isAIThinking = false
    
    private let aiPlayer = AIPlayer()
    private let soundManager = SoundManager.shared
    private let statsManager = StatisticsManager.shared
    
    init() {
        loadStats()
    }
    
    var canUndo: Bool {
        !moveHistory.isEmpty && gameMode == .twoPlayer && !isGameOver
    }
    
    var gameStatus: String {
        if isGameOver {
            return gameResult
        }
        return gameMode.displayName
    }
    
    var currentPlayerDisplay: String {
        if isGameOver {
            return ""
        }
        if gameMode == .twoPlayer {
            return currentPlayer == .human ? "Player 1 (X)" : "Player 2 (O)"
        } else {
            return currentPlayer == .human ? "Your Turn" : "AI Thinking..."
        }
    }
    
    var isBoardFull: Bool {
        board.allSatisfy { $0 != nil }
    }
    
    func startNewGame(mode: GameMode) {
        self.gameMode = mode
        self.board = Array(repeating: nil, count: 9)
        self.currentPlayer = .human
        self.isGameOver = false
        self.gameResult = ""
        self.moveHistory = []
        self.winningCells = []
        self.isGameActive = true
        self.isAIThinking = false
    }
    
    func makeMove(at index: Int) {
        guard index >= 0 && index < 9 else { return }
        guard board[index] == nil else { return }
        guard !isGameOver else { return }
        guard currentPlayer == .human else { return }
        guard !isAIThinking else { return }
        
        board[index] = .human
        moveHistory.append((index: index, player: .human))
        soundManager.playSound(.move)
        HapticFeedback.light()
        
        if checkWinner(for: .human) {
            endGame(winner: .human)
            return
        }
        
        if isBoardFull {
            endGame(winner: nil)
            return
        }
        
        currentPlayer = .ai
        
        if gameMode == .twoPlayer {
            // Wait for player 2 input
        } else {
            // AI makes move
            isAIThinking = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.makeAIMove()
            }
        }
    }
    
    private func makeAIMove() {
        guard currentPlayer == .ai else { return }
        guard !isGameOver else { return }
        
        let move = aiPlayer.getBestMove(
            board: board,
            difficulty: getDifficulty()
        )
        
        guard move >= 0 && move < 9 else { return }
        guard board[move] == nil else { return }
        
        board[move] = .ai
        moveHistory.append((index: move, player: .ai))
        soundManager.playSound(.move)
        HapticFeedback.medium()
        isAIThinking = false
        
        if checkWinner(for: .ai) {
            endGame(winner: .ai)
            return
        }
        
        if isBoardFull {
            endGame(winner: nil)
            return
        }
        
        currentPlayer = .human
    }
    
    func undoLastMove() {
        guard canUndo else { return }
        guard moveHistory.count >= 2 else { return }
        
        // Remove last two moves
        let lastAIIndex = moveHistory.removeLast().index
        let lastPlayerIndex = moveHistory.removeLast().index
        
        board[lastAIIndex] = nil
        board[lastPlayerIndex] = nil
        
        currentPlayer = .human
        isGameOver = false
        gameResult = ""
        winningCells = []
        soundManager.playSound(.undo)
        HapticFeedback.light()
    }
    
    func resetGame() {
        startNewGame(mode: gameMode)
    }
    
    private func endGame(winner: Player?) {
        isGameOver = true
        isAIThinking = false
        
        if let winner = winner {
            if winner == .human {
                gameResult = "🎉 You Win!"
                stats.totalWins += 1
                if gameMode != .twoPlayer {
                    stats.winsBy[gameMode.displayName, default: 0] += 1
                }
                soundManager.playSound(.win)
                HapticFeedback.success()
            } else {
                gameResult = "😔 You Lost"
                stats.totalLosses += 1
                soundManager.playSound(.lose)
                HapticFeedback.error()
            }
        } else {
            gameResult = "🤝 It's a Draw"
            stats.totalDraws += 1
            soundManager.playSound(.draw)
            HapticFeedback.medium()
        }
        
        saveStats()
    }
    
    private func checkWinner(for player: Player) -> Bool {
        let winPatterns = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6]              // Diagonals
        ]
        
        for pattern in winPatterns {
            if pattern.allSatisfy({ board[$0] == player }) {
                winningCells = pattern
                return true
            }
        }
        
        return false
    }
    
    private func getDifficulty() -> Difficulty {
        switch gameMode {
        case .aiEasy:
            return .easy
        case .aiMedium:
            return .medium
        case .aiHard:
            return .hard
        case .twoPlayer:
            return .hard
        }
    }
    
    func resetStats() {
        stats = GameStats()
        saveStats()
    }
    
    private func saveStats() {
        statsManager.saveStats(stats)
    }
    
    private func loadStats() {
        stats = statsManager.loadStats()
    }
}