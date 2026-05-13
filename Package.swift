// swift-tools-version:5.10
import PackageDescription

let package = Package(
    name: "PomodoroApp",
    platforms: [
        .macOS(.v14)
    ],
    targets: [
        .executableTarget(
            name: "PomodoroApp",
            path: "Sources/PomodoroApp"
        )
    ]
)
