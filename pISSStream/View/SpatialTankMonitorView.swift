//
//  SpatialTankMonitorView.swift
//  pISSStream
//
//  Created by durul dalkanat on 12/25/24.
//

import RealityKit
import SwiftUI

struct SpatialTankMonitorView: View {
    // State for the base position of the anchor
    @State private var anchorPosition: SIMD3<Float> = [0, 0.5, -3]
    // Gesture state for the drag translation offset (calculated from 2D gesture)
    @GestureState private var dragOffset: SIMD3<Float> = .zero

    @EnvironmentObject var appState: AppStateViewModel

    let tankHeight: Float = 2.0
    let tankRadius: Float = 0.5
    let fillRadius: Float = 0.3 // Keep fill slightly smaller radius
    let dragSensitivity: Float = 0.002 // Adjust sensitivity as needed

    var body: some View {
        #if os(visionOS)
            RealityView { content in
                // Create the anchor without initial position, position managed in update
                let anchor = AnchorEntity()
                anchor.name = "interactiveAnchor"
                anchor.addChild(createSpatialAudio())

                // Tank model, centered at anchor's origin
                let tank = ModelEntity(
                    mesh: .generateCylinder(height: tankHeight, radius: tankRadius),
                    materials: [SimpleMaterial(
                        color: .black.withAlphaComponent(0.5),
                        roughness: 0.2,
                        isMetallic: true
                    )]
                )
                tank.name = "tank"

                // It places the tank (waste tank) model at the same point.
                // Thus, the tank and the fill indicator overlap and the fill level is shown correctly inside the tank.
                tank.position = SIMD3(x: 0, y: 0, z: 0)

                // Generate collision shapes for the tank entity so it can participate in hit-testing and physics interactions.
                tank.generateCollisionShapes(recursive: false)
                
                // Add an InputTargetComponent to make the tank entity respond to user input (e.g. gestures, taps, etc.)
                tank.components.set(InputTargetComponent())

                // Add the tank entity to the anchor
                anchor.addChild(tank)

                // Fill level model, initially empty, centered horizontally
                let fillLevel = ModelEntity(
                    mesh: .generateCylinder(height: tankHeight, radius: fillRadius), // Use full height, scale adjusts
                    materials: [SimpleMaterial(
                        color: .yellow,
                        roughness: 1.0,
                        isMetallic: false
                    )]
                )
                fillLevel.name = "fillLevel"

                // Initial position at bottom (relative y = -tankHeight/2), scaled height effectively 0
                fillLevel.position = [0, -tankHeight / 2, 0]
                fillLevel.scale = [1, 0.001, 1] // Start almost invisible/empty
                fillLevel.generateCollisionShapes(recursive: false)
                fillLevel.components.set(InputTargetComponent())
                anchor.addChild(fillLevel)

                content.add(anchor)

            } update: { content in
                // Find the anchor
                guard let anchor = content.entities.first(where: { $0.name == "interactiveAnchor" }) else { return }

                // Apply position based on state + gesture offset
                anchor.position = anchorPosition + dragOffset

                // Update fill level based on piss amount (relative to anchor)
                if let fillLevelEntity = anchor.findEntity(named: "fillLevel") as? ModelEntity {
                    // Remove the "%" symbol from the pissAmount string and convert to Float (e.g. "75%" -> 75.0). If conversion fails, default to 0.
                    let fillPercentage = Float(appState.pissAmount.replacingOccurrences(of: "%", with: "")) ?? 0
                    
                    // Clamp the fill ratio between 0.0 (empty) and 1.0 (full), by dividing percentage by 100.
                    let fillRatio = max(0.0, min(1.0, fillPercentage / 100.0))
                    
                    // Calculate the height of the filled portion of the tank, scaled by the fill ratio.
                    let scaledFillHeight = tankHeight * fillRatio
                    
                    // Scale the fillLevelEntity in the Y axis to visually represent the fill amount (minimum 0.001 to avoid disappearing).
                    fillLevelEntity.scale = [1, max(0.001, fillRatio), 1]
                    
                    // Position the fillLevelEntity so its base stays at the bottom of the tank and its center rises with fill level.
                    fillLevelEntity.position.y = -tankHeight / 2 + scaledFillHeight / 2
                }
            }
            .gesture(
                // Use standard DragGesture and map 2D translation to 3D XZ plane
                DragGesture(minimumDistance: 0)
                    .targetedToAnyEntity()
                    .updating($dragOffset) { value, state, _ in
                        // Calculate 3D offset in XZ plane based on 2D drag
                        let deltaX = Float(value.translation.width) * dragSensitivity
                        // Map screen Y drag to world Z (negative Y down -> negative Z towards user)
                        let deltaZ = Float(value.translation.height) * dragSensitivity * -1
                        state = SIMD3<Float>(deltaX, 0, deltaZ) // Update offset, keeping Y constant
                    }
                    .onEnded { value in
                        // Calculate final 3D offset and apply to the base position
                        let deltaX = Float(value.translation.width) * dragSensitivity
                        let deltaZ = Float(value.translation.height) * dragSensitivity * -1
                        anchorPosition += SIMD3<Float>(deltaX, 0, deltaZ)
                    }
            )
        #endif
    }
}

extension SpatialTankMonitorView {
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
