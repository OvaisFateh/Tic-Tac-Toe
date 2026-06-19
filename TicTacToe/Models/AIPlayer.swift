import Foundation

enum Difficulty {
    case easy
    case medium
    case hard
}

class AIPlayer {
    func getBestMove(board: [Player?], difficulty: Difficulty) -> Int {
        switch difficulty {
        case .easy:
            return getEasyMove(board: board)
        case .medium:
            return getMediumMove(board: board)
        case .hard:
            return getHardMove(board: board)
        }
    }
    
    // Easy: Random moves with some blocking
    private func getEasyMove(board: [Player?]) -> Int {
        let availableMoves = getAvailableMoves(board: board)
        
        // 60% random, 40% smart
        if Int.random(in: 0..<10) < 6 {
            return availableMoves.randomElement() ?? 0
        }
        
        // Try to win
        if let winningMove = findWinningMove(board: board, player: .ai) {
            return winningMove
        }
        
        // Try to block
        if let blockingMove = findWinningMove(board: board, player: .human) {
            return blockingMove
        }
        
        return availableMoves.randomElement() ?? 0
    }
    
    // Medium: Balanced strategy
    private func getMediumMove(board: [Player?]) -> Int {
        let availableMoves = getAvailableMoves(board: board)
        
        // Try to win
        if let winningMove = findWinningMove(board: board, player: .ai) {
            return winningMove
        }
        
        // Block player from winning
        if let blockingMove = findWinningMove(board: board, player: .human) {
            return blockingMove
        }
        
        // Take center if available
        if board[4] == nil {
            return 4
        }
        
        // Take corners if available
        let corners = [0, 2, 6, 8].filter { board[$0] == nil }
        if !corners.isEmpty {
            return corners.randomElement() ?? availableMoves.randomElement() ?? 0
        }
        
        return availableMoves.randomElement() ?? 0
    }
    
    // Hard: Unbeatable Minimax algorithm
    private func getHardMove(board: [Player?]) -> Int {
        let availableMoves = getAvailableMoves(board: board)
        var bestScore = Int.min
        var bestMove = availableMoves.first ?? 0
        
        for move in availableMoves {
            var testBoard = board
            testBoard[move] = .ai
            let score = minimax(board: testBoard, depth: 0, isMaximizing: false)
            
            if score > bestScore {
                bestScore = score
                bestMove = move
            }
        }
        
        return bestMove
    }
    
    private func minimax(board: [Player?], depth: Int, isMaximizing: Bool) -> Int {
        // Check terminal states
        if let winner = getWinner(board: board) {
            if winner == .ai {
                return 10 - depth
            } else if winner == .human {
                return depth - 10
            }
        }
        
        let availableMoves = getAvailableMoves(board: board)
        if availableMoves.isEmpty {
            return 0 // Draw
        }
        
        if isMaximizing {
            var bestScore = Int.min
            for move in availableMoves {
                var testBoard = board
                testBoard[move] = .ai
                let score = minimax(board: testBoard, depth: depth + 1, isMaximizing: false)
                bestScore = max(score, bestScore)
            }
            return bestScore
        } else {
            var bestScore = Int.max
            for move in availableMoves {
                var testBoard = board
                testBoard[move] = .human
                let score = minimax(board: testBoard, depth: depth + 1, isMaximizing: true)
                bestScore = min(score, bestScore)
            }
            return bestScore
        }
    }
    
    private func findWinningMove(board: [Player?], player: Player) -> Int? {
        let availableMoves = getAvailableMoves(board: board)
        
        for move in availableMoves {
            var testBoard = board
            testBoard[move] = player
            if isWinner(board: testBoard, player: player) {
                return move
            }
        }
        
        return nil
    }
    
    private func getAvailableMoves(board: [Player?]) -> [Int] {
        (0..<9).filter { board[$0] == nil }
    }
    
    private func getWinner(board: [Player?]) -> Player? {
        if isWinner(board: board, player: .ai) {
            return .ai
        }
        if isWinner(board: board, player: .human) {
            return .human
        }
        return nil
    }
    
    private func isWinner(board: [Player?], player: Player) -> Bool {
        let winPatterns = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
            [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
            [0, 4, 8], [2, 4, 6]              // Diagonals
        ]
        
        return winPatterns.contains { pattern in
            pattern.allSatisfy { board[$0] == player }
        }
    }
}