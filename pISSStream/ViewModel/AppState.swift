//
//  AppState.swift
//  pISSStream
//
//  Created by durul dalkanat on 12/25/24.
//

import os
import SwiftUI

@MainActor
class AppState: ObservableObject {
    @Published var pissAmount: String = "N/A"
    private let logger = Logger(
        subsystem: "social.bsky.jaennaet.pISSStream", category: "AppState")
    private let pissActor = PissActor()

    init() {
        startPissStream()
    }

    private func startPissStream() {
        Task {
            logger.debug("starting pissActor.pissStream() reader")
            for await amount in await pissActor.pissStream() {
                self.pissAmount = amount
            }
        }
    }
}
