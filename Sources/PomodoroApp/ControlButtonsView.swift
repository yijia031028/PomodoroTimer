import SwiftUI

struct ControlButtonsView: View {
    @EnvironmentObject var viewModel: TimerViewModel

    var body: some View {
        HStack(spacing: 16) {
            Button {
                if viewModel.isRunning {
                    viewModel.pause()
                } else {
                    viewModel.start()
                }
            } label: {
                Label(
                    viewModel.isRunning ? "Pause" : "Start",
                    systemImage: viewModel.isRunning ? "pause.fill" : "play.fill"
                )
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isCompleted || !viewModel.hasTimeSet)
            .controlSize(.large)

            Button("Reset") {
                viewModel.reset()
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.isIdle)
            .controlSize(.large)
        }
    }
}
