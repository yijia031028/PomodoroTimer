import SwiftUI
import AppKit

struct CustomTimeInputView: View {
    @EnvironmentObject var viewModel: TimerViewModel
    @State private var parsedValue: Int?

    var body: some View {
        HStack(spacing: 8) {
            NativeTextField(placeholder: "Minutes...", onChange: { text in
                let trimmed = text.trimmingCharacters(in: .whitespaces)
                parsedValue = Int(trimmed).flatMap { $0 > 0 && $0 <= 999 ? $0 : nil }
            }, onSubmit: {
                if let minutes = parsedValue {
                    viewModel.setPreset(minutes: minutes)
                }
            })
            .frame(width: 140, height: 26)

            Button("Set") {
                if let minutes = parsedValue {
                    viewModel.setPreset(minutes: minutes)
                }
            }
            .disabled(parsedValue == nil)
        }
    }
}

final class TextFieldController: NSObject, NSTextFieldDelegate {
    var onChange: (String) -> Void
    var onSubmit: () -> Void

    init(onChange: @escaping (String) -> Void, onSubmit: @escaping () -> Void) {
        self.onChange = onChange
        self.onSubmit = onSubmit
    }

    func controlTextDidChange(_ obj: Notification) {
        guard let field = obj.object as? NSTextField else { return }
        onChange(field.stringValue)
    }

    @objc func handleSubmit() {
        onSubmit()
    }
}

struct NativeTextField: NSViewRepresentable {
    let placeholder: String
    let onChange: (String) -> Void
    let onSubmit: () -> Void

    func makeCoordinator() -> TextFieldController {
        TextFieldController(onChange: onChange, onSubmit: onSubmit)
    }

    func makeNSView(context: Context) -> NSTextField {
        let field = NSTextField()
        field.placeholderString = placeholder
        field.bezelStyle = .roundedBezel
        field.font = NSFont.systemFont(ofSize: NSFont.systemFontSize)
        field.focusRingType = .exterior
        field.isEditable = true
        field.isSelectable = true
        field.delegate = context.coordinator
        field.target = context.coordinator
        field.action = #selector(TextFieldController.handleSubmit)
        return field
    }

    func updateNSView(_ nsView: NSTextField, context: Context) {
        context.coordinator.onChange = onChange
        context.coordinator.onSubmit = onSubmit
    }
}
