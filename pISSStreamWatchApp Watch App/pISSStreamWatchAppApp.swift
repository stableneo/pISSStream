//
//  pISSStreamWatchAppApp.swift
//  pISSStreamWatchApp Watch App
//
//  Created by durul dalkanat on 5/20/25.
//

import SwiftUI

@main
struct pISSStreamWatchApp_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            pISSStreamWatchAppView()
                .environmentObject(AppStateViewModel())

        }
    }
}
