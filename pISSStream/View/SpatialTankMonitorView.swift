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
    @State private var tankScale: Float = 1.0

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
                
                // Update tank scale based on pinch gesture
                if let tankEntity = anchor.findEntity(named: "tank") as? ModelEntity {
                    tankEntity.scale = [tankScale, tankScale, tankScale]
                }

                // Update fill level based on piss amount (relative to anchor)
                if let fillLevelEntity = anchor.findEntity(named: "fillLevel") as? ModelEntity {
                    // Remove the "%" symbol from the pissAmount string and convert to Float (e.g. "75%" -> 75.0). If conversion fails, default to 0.
                    let fillPercentage = Float(appState.pissAmount.replacingOccurrences(of: "%", with: "")) ?? 0
                    
                    // Clamp the fill ratio between 0.0 (empty) and 1.0 (full), by dividing percentage by 100.
                    let fillRatio = max(0.0, min(1.0, fillPercentage / 100.0))

                    // Scale the fillLevelEntity in X and Z to match tankScale, Y is scaled according to fill ratio.
                    fillLevelEntity.scale = [tankScale, max(0.001, fillRatio) * tankScale, tankScale]
                    
                    // Position the fillLevelEntity so its base stays at the bottom of the tank and its center rises with fill level.
                    // Y axis: Multiplied by both the fill rate and the new scale of the tank, it becomes completely synchronous.
                    fillLevelEntity.position.y = -tankHeight * tankScale / 2 + (tankHeight * fillRatio * tankScale) / 2
                }
            }
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        tankScale = Float(value.magnification)
                    }
                    .simultaneously(
                        with:
                            DragGesture(minimumDistance: 0)
                                .targetedToAnyEntity()
                                .updating($dragOffset) { value, state, _ in
                                    // DragGesture behavior changes proportionally to tank size as tank grows/shrinks. Drag is now natural at all sizes.
                                    let deltaX = Float(value.translation.width) * dragSensitivity / tankScale
                                    let deltaZ = Float(value.translation.height) * dragSensitivity * -1 / tankScale
                                    state = SIMD3<Float>(deltaX, 0, deltaZ)
                                }
                                .onEnded { value in
                                    let deltaX = Float(value.translation.width) * dragSensitivity / tankScale
                                    let deltaZ = Float(value.translation.height) * dragSensitivity * -1 / tankScale
                                    anchorPosition += SIMD3<Float>(deltaX, 0, deltaZ)
                                }
                    )
            )
        #endif
    }
}

extension SpatialTankMonitorView {
    @available(macOS 15.0, *)
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
