import BackgroundTasks
import LightstreamerClient
import os
import SwiftUI

@main
struct piSSStreamApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppState()

    var body: some Scene {
        MenuBarExtra {
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            PissLabel(amount: appState.pissAmount)
        }
    }
}

extension Color {
    static let pissYellowLight = Color(red: 0.95, green: 0.85, blue: 0.2)
    static let pissYellowDark = Color(red: 0.7, green: 0.6, blue: 0.1)
}
