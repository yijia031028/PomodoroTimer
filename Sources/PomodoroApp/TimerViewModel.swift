import Foundation
import Combine

final class TimerViewModel: ObservableObject {
    @Published var remainingSeconds: Int = 0
    @Published var totalSeconds: Int = 0
    @Published var status: TimerStatus = .idle

    private var cancellable: AnyCancellable?

    var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return Double(totalSeconds - remainingSeconds) / Double(totalSeconds)
    }

    var displayTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var isIdle: Bool { status == .idle }
    var isRunning: Bool { status == .running }
    var isPaused: Bool { status == .paused }
    var isCompleted: Bool { status == .completed }
    var hasTimeSet: Bool { totalSeconds > 0 }

    func setPreset(minutes: Int) {
        cancelTimer()
        totalSeconds = minutes * 60
        remainingSeconds = totalSeconds
        status = .idle
    }

    func start() {
        guard remainingSeconds > 0 else { return }
        status = .running
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    func pause() {
        cancelTimer()
        status = .paused
    }

    func reset() {
        cancelTimer()
        remainingSeconds = totalSeconds
        status = .idle
    }

    private func tick() {
        guard remainingSeconds > 0 else {
            complete()
            return
        }
        remainingSeconds -= 1
        if remainingSeconds == 0 {
            complete()
        }
    }

    private func complete() {
        cancelTimer()
        status = .completed
        NotificationService.shared.playCompletionChime()
        NotificationService.shared.deliverNotification()
    }

    private func cancelTimer() {
        cancellable?.cancel()
        cancellable = nil
    }
}
