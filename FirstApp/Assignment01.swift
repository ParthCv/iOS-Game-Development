import SceneKit

class Assignment01: SCNScene {
    //Initialize the camera
    var cameraNode = SCNNode()
    //Main cube
    var cubeMain = SCNNode()
    
    //var positionText = SCNNode()
    
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
        //addPositionText()
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
    
    func addPositionText() {
        let textGeomentry = SCNText(string: "Position of the cube -> ", extrusionDepth: 1.0)
        textGeomentry.font = UIFont(name: "Arial", size: 35)
        textGeomentry.firstMaterial?.diffuse.contents = UIColor.green
        
        let positionText = SCNNode(geometry:textGeomentry)
        positionText.position = SCNVector3(1, 1, 1)

        
        rootNode.addChildNode(positionText)
    }

    @MainActor
    func processPinch (magnification: CGFloat) {
        if (!isRotating) {
            //Get the cube
            let _theCube = rootNode.childNode(withName: "Cube_1", recursively: true)
            //caste the CGFloat to a Float
            let scale: Float = Float(magnification)
            //set the scale of the cube to the magnification
            _theCube?.scale = SCNVector3(x: scale, y: scale, z: scale)
            //print("Pitching - \(magnification) Scale - \(cubeMain.scale)")
        }
    }
    
    @MainActor
    func firstUpdate() {
        reanimate() // Call reanimate on the first graphics update frame
    }
    
    @MainActor
    func reanimate() {
        let _theCube = rootNode.childNode(withName: "Cube_1", recursively: true)
        
        if (isRotating) {
            rot.width += 0.05
        } else {
            rot = rotAngle
        }

        _theCube?.eulerAngles = SCNVector3(Double(rot.height / 50), Double(rot.width / 50), 0)
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
    
    @MainActor
    func handleResetButton() {
        // get cube
        let _theCube = rootNode.childNode(withName: "Cube_1", recursively: true)
        _theCube?.position = SCNVector3(0,0,0)
        rot = CGSize.zero
        rotAngle = CGSize.zero
        
    }
    
    @MainActor
    func cubePosition() -> String {
        let _theCube = rootNode.childNode(withName: "Cube_1", recursively: true)
        let _cubePosition = _theCube?.position
        var text = "\(_cubePosition?.x ?? 1), \(_cubePosition?.z ?? 0), \(_cubePosition?.z ?? 0) + \(rot.width)"
        print(text)
        return text
    }
}

 
