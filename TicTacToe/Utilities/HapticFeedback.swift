import UIKit

struct HapticFeedback {
    static func light() {
        guard UserDefaults.standard.bool(forKey: "hapticEnabled") || !UserDefaults.standard.bool(forKey: "hapticEnabled") else { return }
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
    
    static func medium() {
        guard UserDefaults.standard.bool(forKey: "hapticEnabled") || !UserDefaults.standard.bool(forKey: "hapticEnabled") else { return }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
    static func success() {
        guard UserDefaults.standard.bool(forKey: "hapticEnabled") || !UserDefaults.standard.bool(forKey: "hapticEnabled") else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    static func error() {
        guard UserDefaults.standard.bool(forKey: "hapticEnabled") || !UserDefaults.standard.bool(forKey: "hapticEnabled") else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}