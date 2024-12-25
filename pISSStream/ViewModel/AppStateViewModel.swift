//
//  AppState.swift
//  pISSStream
//
//  Created by durul dalkanat on 12/25/24.
//

import os
import SwiftUI

@MainActor
class AppStateViewModel: ObservableObject {
    static let shared = AppStateViewModel() // Singleton instance
    @Published var pissAmount: String = "N/A"
    @Published var isConnected: Bool = true
    @Published var hasSignal: Bool = true  // New property for LOS status

    /// Logger for this class.
    private let logger = Logger(
        subsystem: "social.bsky.jaennaet.pISSStream", category: "AppState")
    
    /// Piss actor to handle the piss stream.
    private lazy var pissActor = PissSocket(appState: self)

    /// Initialize the app state.
    init() {
        startPissStream()
    }

    /// Get the status text based on connection and signal state
    func getStatusText() -> String {
        if !isConnected {
            return "Connection Lost"
        }
        return hasSignal ? "Connected" : "Signal Lost (LOS)"
    }
    
    /// Get the status color based on connection and signal state
    func getStatusColor() -> Color {
        if !isConnected {
            return .red
        }
        return hasSignal ? .green : .orange
    }

    /// Start the piss stream.
    private func startPissStream() {
        Task {
            logger.debug("starting pissActor.pissStream() reader")
            for await amount in await pissActor.pissStream() {
                self.pissAmount = amount
                self.isConnected = true
            }
        }
    }
}
