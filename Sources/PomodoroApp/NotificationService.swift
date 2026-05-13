import UserNotifications
import AppKit

final class NotificationService {
    static let shared = NotificationService()

    private let soundURL = URL(fileURLWithPath: "/System/Library/Sounds/Glass.aiff")
    private var sound: NSSound?

    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func playCompletionChime() {
        let chime = NSSound(contentsOf: soundURL, byReference: false) ?? NSSound(named: "Glass")
        sound = chime
        chime?.play()

        // 1.5s later, second chime
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            let chime2 = NSSound(contentsOf: self.soundURL, byReference: false) ?? NSSound(named: "Glass")
            self.sound = chime2
            chime2?.play()
        }

        // 3.0s later, final chime
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self else { return }
            let chime3 = NSSound(contentsOf: self.soundURL, byReference: false) ?? NSSound(named: "Glass")
            self.sound = chime3
            chime3?.play()
        }
    }

    func deliverNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Pomodoro Timer"
        content.body = "Time is up! Your focus session is complete."
        content.sound = nil

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        UNUserNotificationCenter.current().add(request)
    }
}
