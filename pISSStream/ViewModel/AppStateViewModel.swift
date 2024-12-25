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
