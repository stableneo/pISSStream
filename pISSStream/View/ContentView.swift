//
//  ContentView.swift
//  pISSStream
//
//  Created by durul dalkanat on 12/25/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppStateViewModel
    
    #if os(visionOS)
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @State private var isImmersive = false
    #endif
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * 0.05) { // Dynamic spacing
                #if os(visionOS)
                // 3D View Toggle Button at the top
                Button(action: {
                    Task {
                        if isImmersive {
                            await dismissImmersiveSpace()
                            isImmersive = false
                        } else {
                            await openImmersiveSpace(id: "ISSSpace")
                            isImmersive = true
                        }
                    }
                }) {
                    Label(
                        isImmersive ? "Exit 3D View" : "View in 3D",
                        systemImage: isImmersive ? "arrow.down.right.and.arrow.up.left" : "view.3d"
                    )
                    .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.03))
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, geometry.size.height * 0.03)
                #endif
                
                // Status indicator
                HStack {
                    Circle()
                        .fill(appState.getStatusColor())
                        .frame(width: geometry.size.width * 0.02, height: geometry.size.width * 0.02)
                    Text(appState.getStatusText())
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.025))
                }
                
                // Main display
                VStack(spacing: geometry.size.height * 0.02) {
                    Text("ISS Waste Tank Level")
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.035))
                    
                    Text(appState.pissAmount)
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.08, weight: .bold))
                        .foregroundColor(.pissYellowDark)
                }
                .padding(min(geometry.size.width, geometry.size.height) * 0.03)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.pissYellowLight.opacity(0.2))
                )
                
                // Astronaut emoji
                Text("🧑🏽‍🚀🚽")
                    .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.06))
            }
            .padding(min(geometry.size.width, geometry.size.height) * 0.03)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
