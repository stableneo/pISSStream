//
//  pISSSceneConfiguration.swift
//  pISSStream
//
//  Created by durul dalkanat on 12/25/24.
//

import SwiftUI

struct pISSSceneConfiguration: Scene {
    @StateObject private var appState = AppStateViewModel()

    var body: some Scene {
        #if os(visionOS)
            WindowGroup {
                ContentView()
                    .environmentObject(appState)
            }

            .windowStyle(.automatic)
            .defaultSize(width: 800, height: 500)

            ImmersiveSpace(id: "ISSSpace") {
                pISSImmersiveView()
                    .environmentObject(appState)
            }

            .immersionStyle(selection: .constant(.full), in: .full)
        #endif
    }
}
