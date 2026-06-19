import SwiftUI

struct GameView: View {
    @ObservedObject var gameModel: GameModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                gradient: Gradient(colors: [
                    colorScheme == .dark ? Color(#colorLiteral(red: 0.06, green: 0.06, blue: 0.09, alpha: 1)) : Color(#colorLiteral(red: 0.96, green: 0.97, blue: 0.99, alpha: 1)),
                    colorScheme == .dark ? Color(#colorLiteral(red: 0.08, green: 0.08, blue: 0.11, alpha: 1)) : Color(#colorLiteral(red: 0.93, green: 0.95, blue: 0.98, alpha: 1))
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 2) {
                        Text(gameModel.gameStatus)
                            .font(.system(size: 16, weight: .semibold))
                        if !gameModel.isGameOver {
                            Text(gameModel.currentPlayerDisplay)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: { gameModel.undoLastMove() }) {
                        Image(systemName: "arrow.uturn.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.blue)
                            .opacity(gameModel.canUndo ? 1 : 0.3)
                    }
                    .disabled(!gameModel.canUndo)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                Divider()
                    .opacity(0.1)
                
                // Game Board
                VStack(spacing: 12) {
                    Spacer()
                    
                    GameBoardView(gameModel: gameModel)
                    
                    if gameModel.isAIThinking {
                        HStack(spacing: 4) {
                            Text("AI Thinking")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.gray)
                            ProgressView()
                                .scaleEffect(0.8, anchor: .center)
                        }
                    }
                    
                    Spacer()
                }
                .padding(20)
                
                Divider()
                    .opacity(0.1)
                
                // Action Buttons
                HStack(spacing: 12) {
                    Button(action: { gameModel.resetGame() }) {
                        Text("New Game")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                    if gameModel.isGameOver {
                        Button(action: { dismiss() }) {
                            Text("Home")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(20)
            }
        }
    }
}

struct GameBoardView: View {
    @ObservedObject var gameModel: GameModel
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<9, id: \.self) { index in
                GameCellView(
                    cell: gameModel.board[index],
                    isWinningCell: gameModel.winningCells.contains(index),
                    action: {
                        gameModel.makeMove(at: index)
                    }
                )
            }
        }
    }
}

struct GameCellView: View {
    let cell: Player?
    let isWinningCell: Bool
    let action: () -> Void
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0
    @Environment(\.colorScheme) var colorScheme
    
    var cellContent: String {
        switch cell {
        case .human:
            return "X"
        case .ai:
            return "O"
        case nil:
            return ""
        }
    }
    
    var cellColor: Color {
        if isWinningCell {
            return Color.yellow.opacity(0.3)
        }
        return Color(.systemGray6)
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 0.95
                action()
            }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 1.0
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(cellColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                
                if isWinningCell && cell != nil {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.yellow, lineWidth: 2)
                }
                
                Text(cellContent)
                    .font(.system(size: 44, weight: .bold))
                    .foregroundColor(cell == .human ? .blue : .red)
                    .rotation3DEffect(
                        .degrees(rotation),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .onAppear {
                        if cell != nil {
                            withAnimation(.easeOut(duration: 0.3)) {
                                rotation = 360
                            }
                            rotation = 0
                        }
                    }
            }
            .frame(height: 100)
            .scaleEffect(scale)
        }
        .disabled(cell != nil)
    }
}

#Preview {
    GameView(gameModel: GameModel())
}