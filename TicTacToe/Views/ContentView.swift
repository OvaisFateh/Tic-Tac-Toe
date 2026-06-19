import SwiftUI

struct ContentView: View {
    @StateObject private var gameModel = GameModel()
    @State private var showSettings = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Animated Background
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
                // Header with Settings
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tic Tac Toe")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.primary)
                        Text("Pro")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Button(action: { showSettings.toggle() }) {
                        Image(systemName: "gear")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.blue.opacity(0.8))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                
                Divider()
                    .opacity(0.1)
                
                // Main Content
                ScrollView {
                    VStack(spacing: 24) {
                        // Game Mode Selection
                        VStack(spacing: 12) {
                            Text("Select Game Mode")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 24)
                            
                            VStack(spacing: 10) {
                                GameModeCard(
                                    title: "👥 Two Players",
                                    subtitle: "Play with a friend",
                                    gradient: [Color.blue.opacity(0.8), Color.cyan.opacity(0.8)]
                                ) {
                                    gameModel.startNewGame(mode: .twoPlayer)
                                }
                                
                                GameModeCard(
                                    title: "🤖 vs AI (Easy)",
                                    subtitle: "Casual gameplay",
                                    gradient: [Color.green.opacity(0.8), Color.mint.opacity(0.8)]
                                ) {
                                    gameModel.startNewGame(mode: .aiEasy)
                                }
                                
                                GameModeCard(
                                    title: "🎯 vs AI (Medium)",
                                    subtitle: "Balanced challenge",
                                    gradient: [Color.orange.opacity(0.8), Color.yellow.opacity(0.8)]
                                ) {
                                    gameModel.startNewGame(mode: .aiMedium)
                                }
                                
                                GameModeCard(
                                    title: "⚡ vs AI (Hard)",
                                    subtitle: "Unbeatable AI",
                                    gradient: [Color.red.opacity(0.8), Color.pink.opacity(0.8)]
                                ) {
                                    gameModel.startNewGame(mode: .aiHard)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        // Statistics Dashboard
                        VStack(spacing: 16) {
                            Text("Your Statistics")
                                .font(.system(size: 18, weight: .semibold))
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 12) {
                                StatCard(
                                    label: "Wins",
                                    value: "\(gameModel.stats.totalWins)",
                                    color: .green,
                                    icon: "checkmark.circle.fill"
                                )
                                
                                StatCard(
                                    label: "Losses",
                                    value: "\(gameModel.stats.totalLosses)",
                                    color: .red,
                                    icon: "xmark.circle.fill"
                                )
                                
                                StatCard(
                                    label: "Draws",
                                    value: "\(gameModel.stats.totalDraws)",
                                    color: .orange,
                                    icon: "minus.circle.fill"
                                )
                            }
                            
                            // Win Rate
                            if gameModel.stats.totalGames > 0 {
                                VStack(spacing: 8) {
                                    HStack {
                                        Text("Win Rate")
                                            .font(.system(size: 14, weight: .medium))
                                        Spacer()
                                        Text(String(format: "%.1f%%", gameModel.stats.winRate))
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.blue)
                                    }
                                    
                                    ProgressView(value: gameModel.stats.winRate / 100)
                                        .tint(.blue)
                                }
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                        .padding(16)
                        .background(Color(.systemBackground).opacity(0.6))
                        .cornerRadius(16)
                        .padding(.horizontal, 24)
                        
                        // Reset Button
                        if gameModel.stats.totalGames > 0 {
                            Button(action: { gameModel.resetStats() }) {
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                    Text("Reset Statistics")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        Spacer(minLength: 32)
                    }
                    .padding(.vertical, 24)
                }
            }
        }
        .sheet(isPresented: $gameModel.isGameActive) {
            GameView(gameModel: gameModel)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct GameModeCard: View {
    let title: String
    let subtitle: String
    let gradient: [Color]
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding(16)
            .background(LinearGradient(gradient: Gradient(colors: gradient), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(12)
        }
    }
}

struct StatCard: View {
    let label: String
    let value: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var soundEnabled = UserDefaults.standard.bool(forKey: "soundEnabled") || true
    @State private var hapticEnabled = UserDefaults.standard.bool(forKey: "hapticEnabled") || true
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Audio & Haptics")) {
                    Toggle("Sound Effects", isOn: $soundEnabled)
                        .onChange(of: soundEnabled) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "soundEnabled")
                        }
                    
                    Toggle("Haptic Feedback", isOn: $hapticEnabled)
                        .onChange(of: hapticEnabled) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "hapticEnabled")
                        }
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text("Game Type")
                        Spacer()
                        Text("Tic Tac Toe")
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}