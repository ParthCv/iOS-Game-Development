//====================================================================
//
// (c) Borna Noureddin
// COMP 8051   British Columbia Institute of Technology
// Lab01: Draw red square using SceneKit
// Lab02: Make an auto-rotating cube with different colours on each side
// Lab03: Make a rotating cube with a crate texture that can be toggled
// Lab04: Make a cube that can be rotated with gestures
// Lab05: Add text that shows rotation angle of rotating cube
// Lab06: Add diffuse light
// Lab07: Add flashlight
// Lab08: Add fog
// Lab09: Load models with animations
// PinchView: Process touches using UIKit to recognize a pinch gesture
// TwoFigureDragView: Process touches using UIKit to recognize a two-fingure drag gesture
// TapView: Process multi-touch taps
//
//====================================================================

import SwiftUI
import SceneKit
import SpriteKit
// This scene has to be global so the button and navigation views can both access

// We separate out the Button whose text will change so that we only update the button and not the whole ContentView when

struct ContentView: View {

    @State private var circleLocations: [CGPoint]?
    @State private var pinchCircles = [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0)]

    var body: some View {
        NavigationStack {
            List {
                NavigationLink{
                    let scene = RedSquare()
                    SceneView(scene: scene, pointOfView: scene.cameraNode)
                        .ignoresSafeArea()
                } label: { Text("Lab 1: Red square") }
                NavigationLink{
                    let scene = RotatingColouredCube()
                    SceneView(scene: scene, pointOfView: scene.cameraNode)
                        .ignoresSafeArea()
                } label: { Text("Lab 2: Rotating cube") }
                NavigationLink{
                    let scene = RotatingCrate()
                    SceneView(scene: scene, pointOfView: scene.cameraNode)
                        .ignoresSafeArea()
                        .onTapGesture(count: 2) {
                            scene.handleDoubleTap()
                        }
                } label: { Text("Lab 3: Textured cube") }
                NavigationLink{
                    let scene = ControlableRotatingCrate()
                    SceneView(scene: scene, pointOfView: scene.cameraNode)
                        .ignoresSafeArea()
                        .onTapGesture(count: 2) {
                            scene.handleDoubleTap()
                        }
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    scene.handleDrag(offset: gesture.translation)
                                }
                        )
                } label: { Text("Lab 4: Rotatable cube") }
                NavigationLink{
                    let scene = ControlableRotatingCrateWithText()
                    ZStack {
                        SceneView(scene: scene, pointOfView: scene.cameraNode)
                            .ignoresSafeArea()
                            .onTapGesture(count: 2) {
                                scene.handleDoubleTap()
                            }
                            .gesture(
                                DragGesture()
                                    .onChanged{ gesture in
                                        scene.handleDrag(offset: gesture.translation)
                                    }
                            )
                        Text("Hello World")
                            .foregroundStyle(.white)
                    }
                } label: { Text("Lab 5: Text examples") }
                NavigationLink{
                    let scene = RotatingCrateLight()
                    SceneView(scene: scene, pointOfView: scene.cameraNode)
                        .ignoresSafeArea()
                        .onTapGesture(count: 2) {
                            scene.handleDoubleTap()
                        }
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    scene.handleDrag(offset: gesture.translation)
                                }
                        )
                } label: { Text("Lab 6: Diffuse lighting") }
                NavigationLink{
                    let scene = RotatingCrateFlashlight()
                    SceneView(scene: scene, pointOfView: scene.cameraNode)
                        .ignoresSafeArea()
                        .onTapGesture(count: 2) {
                            scene.handleDoubleTap()
                        }
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    scene.handleDrag(offset: gesture.translation)
                                }
                        )
                } label: { Text("Lab 7: Spotlight (flashlight)") }
                NavigationLink{
                    let scene = RotatingCrateFog()
                    SceneView(scene: scene, pointOfView: scene.cameraNode)
                        .ignoresSafeArea()
                        .onTapGesture(count: 2) {
                            scene.handleDoubleTap()
                        }
                        .gesture(
                            DragGesture()
                                .onChanged{ gesture in
                                    scene.handleDrag(offset: gesture.translation)
                                }
                        )
                } label: { Text("Lab 8: Fog") }
                NavigationLink {
                    let scene = Box2DDemo()
                    VStack {
                        SceneView(scene: scene, pointOfView: scene.cameraNode)
                            .ignoresSafeArea()
                            .onTapGesture(count: 2) {
                                scene.handleDoubleTap()
                            }
                        Button(action: {
                            scene.resetPhysics()
                        }, label: {
                            Text("Reset")
                                .font(.system(size: 24))
                                .padding(.bottom, 50)
                        })
                    }
                    .background(.black)
                } label: { Text("Lab 10: Box2D") }
                    .onSubmit {
                        print("Submit")
                    }
            }.navigationTitle("COMP8051")
        }
    }
}

#Preview {
    ContentView()
}
