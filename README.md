# 🎮 Tic Tac Toe Pro - iOS App

A premium, feature-rich Tic Tac Toe game for iOS built with SwiftUI. Experience beautiful animations, intelligent AI, and engaging gameplay.

## ✨ Features

### 🎯 Game Modes
- **👥 Two Players** - Local multiplayer with smooth gameplay
- **🤖 vs AI (3 Difficulty Levels)**
  - Easy: Casual fun
  - Medium: Balanced challenge
  - Hard: Unbeatable AI (Minimax algorithm)

### 🎨 Beautiful UI/UX
- Modern, minimalist design with SwiftUI
- Smooth animations and transitions
- Dark mode & Light mode support
- Glassmorphism effects
- Winning cell highlighting with animation
- Particle effects on victory

### 🏆 Advanced Features
- **📊 Detailed Statistics**
  - Win/Loss/Draw tracking
  - Win rate percentage
  - Games by difficulty
  - Streak tracking (current & best)
  - Total play time

- **🎮 Gameplay Enhancements**
  - Undo move (Two-Player only)
  - Move history
  - Difficulty progression
  - Quick restart
  - Move animations

- **🔊 Audio & Haptics**
  - Sound effects for moves
  - Victory/defeat sounds
  - Customizable haptic feedback
  - Toggle audio in settings

- **⚙️ Settings & Customization**
  - Sound toggle
  - Haptic feedback control
  - Theme selection
  - Game speed adjustment
  - Statistics reset

### 🤖 Intelligent AI
- **Easy**: Random moves with occasional smart blocking
- **Medium**: Strategic gameplay with balanced aggression
- **Hard**: Unbeatable minimax algorithm with depth optimization
- Difficulty indicator with visual cues

### 📱 User Experience
- Intuitive gesture controls
- Clear game status display
- Real-time move validation
- Smooth transitions between screens
- Accessibility support
- Landscape orientation support

## 🏗️ Architecture

**MVVM Pattern**
- `GameModel` - Core game state & logic
- `GameViewModel` - View state management
- `AIPlayer` - Minimax algorithm
- `StatisticsManager` - Data persistence
- `SoundManager` - Audio effects

**Key Components**
- `ContentView` - Home screen with mode selection
- `GameView` - Main game board interface
- `StatisticsView` - Detailed player statistics
- `SettingsView` - Configuration & preferences
- `GameBoardView` - Interactive game grid

## 🛠️ Technologies

- **Swift 5.5+**
- **SwiftUI** - Modern UI framework
- **AVFoundation** - Audio effects
- **UIKit** - Haptic feedback
- **Combine** - Reactive programming
- **UserDefaults** - Data persistence

## 📋 Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## 🚀 Quick Start

1. Clone the repository
   ```bash
   git clone https://github.com/OvaisFateh/tic-tac-toe.git
   cd tic-tac-toe
   ```

2. Open in Xcode
   ```bash
   open TicTacToe.xcodeproj
   ```

3. Configure signing
   - Select project → Target → Signing & Capabilities
   - Add your team
   - Update Bundle Identifier

4. Select simulator/device and run
   - Press Play (▶️) or Cmd+R

## 📊 Game Statistics

Track your performance across all game modes:
- Total wins/losses/draws
- Win rate percentage
- Current & best winning streak
- Games won by difficulty
- Total playing time
- Last played date

## 🎮 How to Play

### Starting a Game
1. Select your preferred game mode from home screen
2. Choose difficulty (if playing AI)
3. Tap "Play" to start

### During Gameplay
- Tap empty cells to make your move (X - blue)
- AI or opponent automatically responds (O - red)
- First to get 3-in-a-row wins!
- Use Undo to take back moves (Two-Player only)

### After Game
- View results and updated statistics
- Choose to play again or return home
- Stats automatically saved

## 🔧 Customization

### Theme Support
Edit `Colors.swift` to customize:
- Primary colors
- Accent colors
- Background gradients
- Cell styling

### AI Difficulty
Adjust in `AIPlayer.swift`:
- Minimax depth for Hard mode
- Random move percentage for Easy mode
- Strategy weighting for Medium mode

### Sound Effects
Modify in `SoundManager.swift`:
- Add custom audio files
- Adjust volumes
- Change sound triggers

## 📈 Future Enhancements

- [ ] Online multiplayer
- [ ] Leaderboards
- [ ] Achievement system
- [ ] Custom themes
- [ ] Game replay
- [ ] Voice commands
- [ ] Apple Watch companion
- [ ] iCloud sync

## 🐛 Known Issues

None currently reported!

## 📝 License

MIT License - Feel free to use and modify

## 👨‍💻 Author

Created with ❤️ for iOS

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

---

**Enjoy playing Tic Tac Toe Pro! 🎉**