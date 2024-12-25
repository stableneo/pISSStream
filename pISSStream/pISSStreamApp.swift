import BackgroundTasks
import LightstreamerClient
import os
import SwiftUI

@main
struct piSSStreamApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appState = AppStateViewModel()

    var body: some Scene {
        MenuBarExtra {
            VStack {
                // Connection status text
                Text(getStatusText())
                    .foregroundColor(getStatusColor())
                    .font(.caption)
                
                Divider()
                
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
            }
        } label: {
            PissLabel(
                amount: appState.pissAmount,
                isConnected: appState.isConnected && appState.hasSignal
            )
        }
    }
    
    private func getStatusText() -> String {
        if !appState.isConnected {
            return "Connection Lost"
        }
        return appState.hasSignal ? "Connected" : "Signal Lost (LOS)"
    }
    
    private func getStatusColor() -> Color {
        if !appState.isConnected {
            return .red
        }
        return appState.hasSignal ? .green : .orange
    }
}

extension Color {
    static let pissYellowLight = Color(red: 0.95, green: 0.85, blue: 0.2)
    static let pissYellowDark = Color(red: 0.7, green: 0.6, blue: 0.1)
}
