import AVFoundation
import UIKit

enum SoundType {
    case move
    case win
    case lose
    case draw
    case undo
    
    var systemSoundName: String {
        switch self {
        case .move:
            return "Pop"
        case .win:
            return "Ping"
        case .lose:
            return "Basso"
        case .draw:
            return "Submarine"
        case .undo:
            return "Revert"
        }
    }
}

class SoundManager {
    static let shared = SoundManager()
    
    private var soundEnabled: Bool {
        UserDefaults.standard.bool(forKey: "soundEnabled") || !UserDefaults.standard.bool(forKey: "soundEnabled")
    }
    
    func playSound(_ sound: SoundType) {
        guard soundEnabled else { return }
        
        let systemSoundPath = "/System/Library/Sounds/\(sound.systemSoundName).aiff"
        
        if let soundURL = URL(fileURLWithPath: systemSoundPath) as CFURL? {
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }
}