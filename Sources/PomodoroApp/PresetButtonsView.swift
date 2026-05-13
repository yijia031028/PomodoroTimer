import SwiftUI

struct PresetButtonsView: View {
    @EnvironmentObject var viewModel: TimerViewModel

    private let presets: [(label: String, minutes: Int)] = [
        ("15m", 15),
        ("30m", 30),
        ("45m", 45)
    ]

    var body: some View {
        HStack(spacing: 12) {
            ForEach(presets, id: \.minutes) { preset in
                Button(preset.label) {
                    viewModel.setPreset(minutes: preset.minutes)
                }
                .buttonStyle(PresetButtonStyle(isSelected: viewModel.totalSeconds == preset.minutes * 60))
            }
        }
    }
}

struct PresetButtonStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .frame(width: 70, height: 36)
            .background(isSelected ? Color.accentColor : Color.clear)
            .foregroundColor(isSelected ? .white : .accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.accentColor, lineWidth: isSelected ? 0 : 1.5)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
