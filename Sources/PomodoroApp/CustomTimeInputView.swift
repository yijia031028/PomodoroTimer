import SwiftUI

struct CustomTimeInputView: View {
    @EnvironmentObject var viewModel: TimerViewModel
    @State private var inputText: String = ""

    private var parsedMinutes: Int? {
        guard let value = Int(inputText), value > 0, value <= 999 else { return nil }
        return value
    }

    var body: some View {
        HStack(spacing: 8) {
            TextField("Enter minutes...", text: $inputText)
                .textFieldStyle(.roundedBorder)
                .frame(width: 150)
                .onSubmit {
                    setTime()
                }

            Button("Set") {
                setTime()
            }
            .disabled(parsedMinutes == nil)
        }
    }

    private func setTime() {
        guard let minutes = parsedMinutes else { return }
        viewModel.setPreset(minutes: minutes)
        inputText = ""
    }
}
