//
//  pISSSceneConfiguration.swift
//  pISSStream
//
//  Created by durul dalkanat on 12/25/24.
//

import SwiftUI

struct pISSSceneConfiguration: Scene {
    @StateObject private var appState = AppStateViewModel()
    @State private var rotation:Double = 0

    var body: some Scene {
        #if os(visionOS)
            WindowGroup {
                ContentView()
                    .environmentObject(appState)
                    .background(Color.black).opacity(0.8)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }

            .windowStyle(.volumetric)
            .defaultSize(width: 0.6, height: 0.6, depth: 0.4, in: .meters)

            ImmersiveSpace(id: "ISSSpace") {
                SpatialTankMonitorView()
                    .environmentObject(appState)
            }

            .immersionStyle(selection: .constant(.mixed), in: .mixed)
        #endif
    }
}
