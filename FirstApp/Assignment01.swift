import SceneKit
import SpriteKit

class Assignment01: SCNScene {
    //Initialize the camera
    var cameraNode = SCNNode()
    //Main cube
    var cubeMain = SCNNode()
    
    var cubeSecond = SCNNode()
    
    var flashLightNode = SCNNode()
    
    var ambientLightNode = SCNNode()
    
    var diffuseLightNode = SCNNode()
    
    //var positionText = SCNNode()
    
    var rotAngle = CGSize.zero
    
    var rot = CGSize.zero
    
    var scndRot = 0.0
    
    var isRotating = true
    
    var isFlashlightOn: Bool = true
    
    var isAmbientLightOn: Bool = true
    
    var isDiffuseLightOn: Bool = true
    
    @Published var positionString:String = "rot: "
    
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
        addSecondCube()
        setDummyLight()
        setupAmbientLight() // try commenting out this line
        setupFlashlight()
        setupDiffuseLight()
        addPositionText()
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
    
    func addSecondCube() {
        let cube = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
        
        cube.name = "Cube_2"
        
        let cubeFaceTextures = [UIImage(named: "texture1"), UIImage(named: "texture2"), UIImage(named: "texture3"), UIImage(named: "texture4"), UIImage(named: "texture5"), UIImage(named: "texture6")]
        
        cube.geometry?.firstMaterial?.diffuse.contents = cubeFaceTextures[0]
        
        var faceMaterial: SCNMaterial
        
        for (index, texture) in cubeFaceTextures.enumerated() {
            faceMaterial = SCNMaterial()
            faceMaterial.diffuse.contents = texture
            cube.geometry?.insertMaterial(faceMaterial, at: index)
        }
        
        cube.position = SCNVector3(0,-8,0)
        cubeSecond = cube
        rootNode.addChildNode(cube)
    }
    
    func addPositionText() {
        //### Repeat the above but this time for text we will use to track angles
        let dynamicText = SCNText(string: "123", extrusionDepth: 1.0)
        let dynamicTextNode = SCNNode(geometry: dynamicText)
        dynamicTextNode.name = "Dynamic Text"
        dynamicTextNode.position = SCNVector3(x: 0, y: -5.5, z: 0) // Position below the crate
        dynamicTextNode.scale = SCNVector3(0.05, 0.05, 0.05)
        dynamicTextNode.eulerAngles = cameraNode.eulerAngles    // Tie the rotation to the camera so it looks 2D
        dynamicTextNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        rootNode.addChildNode(dynamicTextNode) // Add the text object to the scene
    }
    
    // Sets up an ambient light (all around)
    func setupAmbientLight() {
        let ambientLight = SCNNode() // Create a SCNNode for the lamp
        ambientLight.light = SCNLight() // Add a new light to the lamp
        ambientLight.light!.type = .ambient // Set the light type to ambient
        ambientLight.light!.color = UIColor.white // Set the light color to white
        ambientLight.light!.intensity = 500// Set the light intensity to 5000 lumins (1000 is default)
        rootNode.addChildNode(ambientLight) // Add the lamp node to the scene
        ambientLightNode = ambientLight
    }
    
    // Sets up a directional light (flashlight)
    func setupFlashlight() {
        let lightNode = SCNNode()
        lightNode.name = "Flashlight"
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.spot
        lightNode.light!.castsShadow = true
        lightNode.light!.color = UIColor.yellow
        lightNode.light!.intensity = 5000
        lightNode.position = SCNVector3(0, 5, 3)
        lightNode.rotation = SCNVector4(1, 0, 0, -Double.pi/3)
        lightNode.light!.spotInnerAngle = 0
        lightNode.light!.spotOuterAngle = 10.0
        lightNode.light!.shadowColor = UIColor.black
        lightNode.light!.zFar = 500
        lightNode.light!.zNear = 50
        rootNode.addChildNode(lightNode)
        
        flashLightNode = lightNode
    }

    func setupDiffuseLight() {
        let directionalLight = SCNNode() // Create a SCNNode for the lamp
        directionalLight.name = "Directional Light" // Name the node so we can reference it later
        directionalLight.light = SCNLight() // Add a new light to the lamp
        directionalLight.light!.type = .directional // Set the light type to directional
        directionalLight.light!.color = UIColor.green // Set the light color to white
        directionalLight.light!.intensity = 20000 // Set the light intensity to 20000 lumins (1000 is default)
        directionalLight.rotation = SCNVector4(0, 0, 0, Double.pi/2)  // Set the rotation of the light from the flashlight to the flashlight position variable
        rootNode.addChildNode(directionalLight) // Add the lamp node to the scene
        
        diffuseLightNode = directionalLight
    }
    
    func setDummyLight() {
        let dummyLight = SCNNode()
        dummyLight.name = "Dummy Light"
        dummyLight.light = SCNLight()
        dummyLight.light!.type = .directional
        dummyLight.light!.color = UIColor.black
        dummyLight.light!.intensity = 0
        
        rootNode.addChildNode(dummyLight)
    }
    
    func setAmbientLight() {
        isAmbientLightOn = !isAmbientLightOn
    }
    
    func setDiffuseLight() {
        isDiffuseLightOn = !isDiffuseLightOn
    }
    
    func setFlashLight() {
        isFlashlightOn = !isFlashlightOn
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
        //handleUIUpdate()
    }
    
    @MainActor
    func reanimate() {
        let _theCube = rootNode.childNode(withName: "Cube_1", recursively: true)
        
        if (isRotating) {
            rot.width += 0.05
        } else {
            rot = rotAngle
        }
        
        let _theScndCube = rootNode.childNode(withName: "Cube_2", recursively: true)
        
        scndRot += 0.00075
        
        if scndRot > Double.pi * 2 {
            scndRot -= Double.pi * 2
        }
        
        _theScndCube?.eulerAngles = SCNVector3(scndRot, scndRot, 0)

        _theCube?.eulerAngles = SCNVector3(Double(rot.height / 50), Double(rot.width / 50), 0)
        // Repeat increment of rotation every 10000 nanoseconds
        

        let dynamicTextNode = rootNode.childNode(withName: "Dynamic Text", recursively: true)
        if let textGeometry = dynamicTextNode?.geometry as? SCNText {
            textGeometry.string = String(format: "(%.2f,%.2f)", rot.height, rot.width)
            let (minVec, maxVec) = textGeometry.boundingBox
            dynamicTextNode?.pivot = SCNMatrix4MakeTranslation((maxVec.x - minVec.x) / 2 + minVec.x, (maxVec.y - minVec.y) / 2 + minVec.y, 0)
        }
        toggleLights()
        Task { try! await Task.sleep(nanoseconds: 10000)
            reanimate()
        }
    }
    
    @MainActor
    func handleUIUpdate() {
        
        DispatchQueue.main.async {
            self.positionString = "rot: \(self.rot.width)"
        }
        
        Task { try! await Task.sleep(nanoseconds: 10000000)
                handleUIUpdate()
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
        let text = "\(_cubePosition?.x ?? 1), \(_cubePosition?.z ?? 0), \(_cubePosition?.z ?? 0) + \(rot.width)"
        print(text)
        return text
    }
    
    @MainActor
    func toggleLights() {
        if (isFlashlightOn) {
            flashLightNode.isHidden = false
        } else {
            flashLightNode.isHidden = true
        }
        
        if (isAmbientLightOn) {
            ambientLightNode.isHidden = false
        } else {
            ambientLightNode.isHidden = true
        }
        
        if (isDiffuseLightOn) {
            diffuseLightNode.isHidden = false
        } else {
            diffuseLightNode.isHidden = true
        }
    }
    
}

 
