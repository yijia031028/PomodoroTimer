import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: TimerViewModel

    var body: some View {
        VStack(spacing: 24) {
            Text("Pomodoro Timer")
                .font(.title2)
                .fontWeight(.semibold)

            ProgressRingView(
                progress: viewModel.progress,
                displayTime: viewModel.displayTime,
                isActive: viewModel.isRunning || viewModel.isPaused
            )

            PresetButtonsView()

            CustomTimeInputView()

            Spacer(minLength: 8)

            ControlButtonsView()
        }
        .padding(32)
        .frame(minWidth: 340, minHeight: 480)
    }
}
