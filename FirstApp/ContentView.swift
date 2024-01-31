//====================================================================
//
// (c) Borna Noureddin
// COMP 8051   British Columbia Institute of Technology
// Lab01: Draw red square using SceneKit
//
//====================================================================

import SwiftUI
import SceneKit
import SpriteKit

struct ContentView: View {
    @State var rotationOffset = CGSize.zero
    @State var stringCubeRotation: String = ""
    
//    private var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink{
                    let scene = RedSquare()
                    SceneView(scene: scene, pointOfView: scene.cameraNode)
                        .ignoresSafeArea()
                } label: { Text("Lab 1") }
                NavigationLink {
                    let scene = RotatingColouredCube()
                    SceneView(scene: scene, pointOfView: scene.cameraNode)
                        .ignoresSafeArea()
                } label: {
                    Text("Lab 2")
                }
                NavigationLink {
                    let scene = RotatingCrate()
                    SceneView(scene: scene, pointOfView: scene.cameraNode)
                        .ignoresSafeArea()
                } label: {
                    Text("Lab 3")
                }
                NavigationLink {
                    let scene = Assignment01()
                    ZStack{
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
                            ).gesture(
                                MagnifyGesture()
                                    .onChanged{ gesture in
                                        scene.processPinch(magnification: gesture.magnification)
                                    }
                            )
                        
                        VStack(alignment: .center, spacing: 20 ) {
                            Button {
                                //print("Reset")
                                scene.handleResetButton()
                            } label: {
                                Text("Reset")
                                    .font(.title2)
                            }
                            .buttonStyle(.borderedProminent)
                            .shadow(color: .blue,radius: 10,y: 2)
                            Text("xyz: pos \(stringCubeRotation)")
                                .foregroundStyle(.red.gradient)
                                .background(.white)
                                .padding()
                            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 30) {
                                Button {
                                    scene.setAmbientLight()
                                } label: {
                                    Text("Ambient Light")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.blue)
                                }
                                .buttonStyle(.plain)
                                Button {
                                    scene.setFlashLight()
                                } label: {
                                    Text("Flash Light")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.blue)
                                }
                                .buttonStyle(.plain)
                                Button {
                                    scene.setDiffuseLight()
                                } label: {
                                    Text("Diffuse Light")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.blue)
                                }
                                .buttonStyle(.plain)
                            }
                        }
//                        .onReceive(timer, perform: { _ in
//                            stringCubeRotation = scene.cubePosition()
//                            print(stringCubeRotation)
//                        })
                        
                    }

                } label: {
                    Text("Assign 1")
                }
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
                    let scene = ControlableRotatingCrate()
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
            }.navigationTitle("COMP8051")
        }
    }
}

#Preview {
    ContentView()
}
