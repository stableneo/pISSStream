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
                // Add fill level visualization
                let fillLevel = ModelEntity(
                    mesh: .generateCylinder(height: 2.0, radius: 0.3),
                    materials: [SimpleMaterial(
                        color: .yellow,
                        roughness: 1.0,
                        isMetallic: false
                    )]
                )
                fillLevel.name = "fillLevel"
            
                // Create a 3D model of the ISS waste tank
                let tank = ModelEntity(
                    mesh: .generateCylinder(height: 2, radius: 0.5),
                    materials: [SimpleMaterial(
                        color: .gray.withAlphaComponent(0.3),
                        roughness: 0.2,
                        isMetallic: true
                    )]
                )
                tank.name = "tank"
                tank.addChild(createSpatialAudio())

                // Determines the position of two cylinders (waste tank and fill level indicator) in a 3D environment
                
                // This positions the cylinder directly in front of the user, 1.5 units above the ground and 3 units away.
                // In this way, the fullness indicator is right inside and in the middle of the tank.
                fillLevel.position = SIMD3(x: 0, y: 1.5, z: -3) // Move fill back inside tank
                
                // It also places the tank (waste tank) model at the same point. Thus, the tank and the fill indicator overlap and the fill level is shown correctly inside the tank.
                tank.position = SIMD3(x: 0, y: 1.5, z: -3)
            
                // Add to content (fill first)
                content.add(fillLevel)
                content.add(tank)
            
            } update: { content in
                // Update fill level based on piss amount
                // As the fill level of the tank changes, the fillLevel cylinder is rescaled and its position is updated, visualizing the fill level in 3D.
                if let entity = content.entities.first(where: { $0.name == "fillLevel" }) {
                    // The fill rate of the tank is kept as a variable in percentage (e.g. 75).
                    let fillPercentage = Float(appState.pissAmount.replacingOccurrences(of: "%", with: "")) ?? 0
                    
                    // The total height of the tank is 2.0 units (the height of the cylinder).
                    // The fullness ratio is divided by the percentage to obtain a ratio between 0 and 1.
                    // This ratio is multiplied by the height of the tank to calculate the height of the full part.
                    let fillHeight: Float = 2.0 * (fillPercentage / 100.0)
                    
                    // The entity (i.e. the occupancy indicator fillness) is scaled only on the Y axis (vertically).
                    // The scale on the X and Z axes is 1 (does not change), and on the Y axis it decreases or increases according to the fill rate.
                    entity.scale = SIMD3<Float>(x: 1, y: fillPercentage / 100.0, z: 1)
                    
                    /*
                      The vertical (Y axis) position of the cylinder is adjusted.
                      This ensures that the filled part is correctly placed from the bottom of the tank upwards.
                      The constant 0.5 is to adjust the height of the tank bottom from the ground.
                      fillHeight / 2 ensures that the center of the scaled cylinder is at the correct height.
                      The fill indicator thus grows from the bottom upwards inside the tank.
                     */
                    entity.position.y = 0.5 + fillHeight / 2
                }
            }
        #endif
    }
}

extension pISSImmersiveView {
    func createSpatialAudio() -> Entity {
        let audioSource = Entity()
        /*
         • gain: -8 → relatively low volume
         • gain: 0 → default (normal) volume
         • gain: +6 → fairly high volume (use with caution)
         */
        audioSource.spatialAudio = SpatialAudioComponent(gain: 3)

        // Setting directivity property
        audioSource.spatialAudio?.directivity = .beam(focus: 1)
        do {
            let resource = try AudioFileResource.load(named: "deep-space", configuration: .init(shouldLoop: true))
            audioSource.playAudio(resource)
        } catch {
            print("Error loading audio file: \\(error.localizedDescription)")
        }

        return audioSource
    }
}
