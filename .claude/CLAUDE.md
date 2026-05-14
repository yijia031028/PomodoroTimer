# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

```bash
swift build -c release   # release build
swift run                # debug build + run
make build               # release build via Makefile
make run                 # shortcut for swift run
make app                 # build + create .app bundle
make install             # build + copy .app to /Applications
make clean               # clean build artifacts + .app bundle
```

No test target exists yet. No linter/formatter is configured.

## Architecture

macOS Pomodoro timer app (SwiftUI + Combine, minimum macOS 14). Single SPM executable target: `Sources/PomodoroApp/`.

**State flow**: `PomodoroApp` (entry) creates `TimerViewModel` (single `@StateObject`) and injects it as `.environmentObject()` into the whole view tree. All views read/write state through `@EnvironmentObject var viewModel: TimerViewModel`.

**TimerViewModel** is the sole source of truth. It holds `remainingSeconds`, `totalSeconds`, `status` (`TimerStatus` enum: idle/running/paused/completed). Countdown uses `Timer.publish(every: 1, ...)` from Combine. On reaching 0, it calls `NotificationService` for sound + notification, then transitions to `.completed`.

**View tree** (ContentView, vertical stack):
- `ProgressRingView` — circular progress arc (color phases: accent → orange at 75% → green at 100%), centered time display
- `PresetButtonsView` — 15m / 30m / 45m buttons, highlights selected preset
- `CustomTimeInputView` — freeform minute input via `NSTextField` wrapped as `NSViewRepresentable` (manual focus ring / submit handling)
- `ControlButtonsView` — Start/Pause toggle + Reset button, disabled states keyed off `viewModel.status`

**NotificationService** — singleton. On timer completion: plays `/System/Library/Sounds/Glass.aiff` three times (0s, 1.5s, 3.0s staggered via `AVAudioPlayer`), delivers a local `UNNotification`.
