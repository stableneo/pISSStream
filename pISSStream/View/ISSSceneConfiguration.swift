import SwiftUI

struct ISSSceneConfiguration: Scene {
    @StateObject private var appState = AppStateViewModel()

    var body: some Scene {
    #if os(visionOS)
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }

        .windowStyle(.plain)
        .defaultSize(width: 400, height: 300)

        ImmersiveSpace(id: "ISSSpace") {
            ISSImmersiveView()
                .environmentObject(appState)
        }

        .immersionStyle(selection: .constant(.full), in: .full)
    #endif
    }
}
