import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppStateViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Status indicator
            HStack {
                Circle()
                    .fill(appState.getStatusColor())
                    .frame(width: 12, height: 12)
                Text(appState.getStatusText())
                    .font(.subheadline)
            }
            
            // Main display
            VStack(spacing: 8) {
                Text("ISS Waste Tank Level")
                    .font(.headline)
                
                Text(appState.pissAmount)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.pissYellowDark)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.pissYellowLight.opacity(0.2))
            )
            
            // Astronaut emoji
            Text("🧑🏽‍🚀🚽")
                .font(.system(size: 32))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        #if !os(visionOS)
        .ignoresSafeArea()
        #else
        // visionOS specific modifiers
        .ornament(
            visibility: .visible,
            attachmentAnchor: .scene(.top),
            contentAlignment: .bottom
        ) {
            Text(appState.getStatusText())
                .padding()
        }
        #endif
    }
}
