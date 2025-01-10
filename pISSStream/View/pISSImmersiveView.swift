//
//  pISSImmersiveView.swift
//  pISSStream
//
//  Created by durul dalkanat on 12/25/24.
//

import RealityKit
import SwiftUI

struct pISSImmersiveView: View {
    @EnvironmentObject var appState: AppStateViewModel
    
    var body: some View {
        #if os(visionOS)
            RealityView { content in
                // Create a 3D model of the ISS waste tank
                let tank = ModelEntity(
                    mesh: .generateCylinder(height: 2, radius: 0.5),
                    materials: [SimpleMaterial(color: .init(white: 0.8, alpha: 0.5), isMetallic: true)]
                )
                tank.name = "tank"
            
                // Add fill level visualization
                let fillLevel = ModelEntity(
                    mesh: .generateCylinder(height: 2.0, radius: 0.48), // Changed initial height to match tank
                    materials: [SimpleMaterial(color: .yellow.withAlphaComponent(0.7), isMetallic: true)]
                )
                fillLevel.name = "fillLevel"
            
                // Position the models in front of the user
                tank.position = SIMD3(x: 0, y: 1.5, z: -3)
                fillLevel.position = SIMD3(x: 0, y: 1.5, z: -3) // Changed to match tank's Y position
            
                // Add to content
                content.add(tank)
                content.add(fillLevel)
            
            } update: { content in
                // Update fill level based on piss amount
                if let entity = content.entities.first(where: { $0.name == "fillLevel" }) {
                    let fillPercentage = Float(appState.pissAmount.replacingOccurrences(of: "%", with: "")) ?? 0
                    let height = 2.0 * (fillPercentage / 100.0)
                    entity.scale = SIMD3(x: 1, y: Float(height), z: 1)
                    entity.position.y = 1.5 - (1.0 - height / 2) // Adjusted position calculation
                }
            }
        #endif
    }
}
