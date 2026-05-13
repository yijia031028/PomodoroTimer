import SwiftUI

struct ProgressRingView: View {
    let progress: Double
    let displayTime: String
    let isActive: Bool

    private var ringColor: Color {
        if progress >= 1.0 { return .green }
        if progress >= 0.75 { return .orange }
        return .accentColor
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 12)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(ringColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)

            Text(displayTime)
                .font(.system(size: 48, weight: .medium, design: .monospaced))
                .foregroundColor(isActive ? .primary : .secondary)
        }
        .frame(width: 200, height: 200)
        .padding(.vertical, 8)
    }
}
