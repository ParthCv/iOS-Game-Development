import SceneKit

class Assignment01: SCNScene {
    //Initialize the camera
    var cameraNode = SCNNode()
    
    //Main cube
    var cubeMain = SCNNode()
    
    //Check for failure in initialization
    required init?(coder aDecoder: NSCoder) {
        fatalError("Initialixation failed  bruh!")
    }
    
    //Initialize
    override init() {
        super.init()
        
        //Set the bg
        background.contents = UIColor.darkGray
    }
    
    //Set up the camera
    func setUpCamera() {
        let camera = SCNCamera() //camera object
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0, 0)
        cameraNode.eulerAngles = SCNVector3(0, 0, 0)
        
        rootNode.addChildNode(cameraNode)
    }
    
    func addMainCube() {
        cubeMain = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 1))
    }
    
}
