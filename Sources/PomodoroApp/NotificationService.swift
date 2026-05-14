import UserNotifications
import AVFoundation

final class NotificationService {
    static let shared = NotificationService()

    private let soundURL = URL(fileURLWithPath: "/System/Library/Sounds/Glass.aiff")
    private var players: [AVAudioPlayer] = []

    private init() {}

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func playCompletionChime() {
        players.removeAll()
        playChime()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.playChime()
        }
    }

    private func playChime() {
        guard let player = try? AVAudioPlayer(contentsOf: soundURL) else { return }
        player.prepareToPlay()
        player.play()
        players.append(player)
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
