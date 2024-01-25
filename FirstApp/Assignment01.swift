import SceneKit

class Assignment01: SCNScene {
    //Initialize the camera
    var cameraNode = SCNNode()
    //Main cube
    var cubeMain = SCNNode()
    
    var rotAngle = CGSize.zero
    
    var rot = CGSize.zero
    
    var isRotating = true
    
    
    
    //Check for failure in initialization
    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialixation failed  bruh!")
    }
    
    // Initializer
    override init() {
        super.init() // Implement the superclass' initializer
        
        background.contents = UIColor.black // Set the background colour to black
        
        setUpCamera()
        addMainCube()
        Task(priority: .userInitiated) {
            await firstUpdate()
        }
    }
        
        //Set up the camera
        func setUpCamera() {
            let camera = SCNCamera() //camera object
            cameraNode.camera = camera
            cameraNode.position = SCNVector3(5, 5, 5)
            cameraNode.eulerAngles = SCNVector3(-Float.pi/4, Float.pi/4, 0)
            
            rootNode.addChildNode(cameraNode)
        }
        
        func addMainCube() {
            let cube = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
            
            cube.name = "Cube_1"
            
            let cubeFaceMaterials = [UIColor.magenta, UIColor.white, UIColor.orange, UIColor.blue, UIColor.red, UIColor.cyan]
            
            cube.geometry?.firstMaterial?.diffuse.contents = cubeFaceMaterials[0]
            
            var faceMaterial: SCNMaterial
            
            for (index, material) in cubeFaceMaterials.enumerated() {
                faceMaterial = SCNMaterial()
                faceMaterial.diffuse.contents = material
                cube.geometry?.insertMaterial(faceMaterial, at: index)
            }
            
            cube.position = SCNVector3(0,0,0)
            cubeMain = cube
            rootNode.addChildNode(cube)
            
        }
    
        @MainActor
        func processPinch (f: CGFloat) {
//            cameraNode.position.y = cameraNode.position.y * Float(f)
//            print("Pitching - \(f) Camera Pos - \(cameraNode.position)")
            if (!isRotating) {
                let theCube = rootNode.childNode(withName: "Cube_1", recursively: true)
                let scale: Float = Float(f)
                theCube?.scale = SCNVector3(x: scale, y: scale, z: scale)
                print("Pitching - \(f) Scale - \(cubeMain.scale)")
            }

        }
        
        @MainActor
        func firstUpdate() {
            reanimate() // Call reanimate on the first graphics update frame
        }
        
        @MainActor
        func reanimate() {
            let theCube = rootNode.childNode(withName: "Cube_1", recursively: true)
            
            if (isRotating) {
                rot.width += 0.05
            } else {
                rot = rotAngle
            }

            theCube?.eulerAngles = SCNVector3(Double(rot.height / 50), Double(rot.width / 50), 0)
            // Repeat increment of rotation every 10000 nanoseconds
            Task { try! await Task.sleep(nanoseconds: 10000)
                reanimate()
            }
        }
    
        @MainActor
        // Function to be called by double-tap gesture
        func handleDoubleTap() {
            isRotating = !isRotating // Toggle rotation
        }
        @MainActor
        // Function to be called by drag gesture
        func handleDrag(offset: CGSize) {
            rotAngle = offset // Get the width and height components of the CGSize, which only gives us two, and put them into the x and y rotations of the flashlight
        }
    }

 
