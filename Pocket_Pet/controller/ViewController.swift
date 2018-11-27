//
//  ViewController.swift
//  Pocket_Pet
//
//  Created by Leiquan Pan on 11/13/18.
//  Copyright © 2018 Leiquan Pan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    //for put a pet
    @IBOutlet weak var surfaceButton: UIButton!
    
    //create an plane object for pet, and a plane list for all detected planes
    var curPetPlane:SCNPlane!
    let detectedPlanes = [SCNPlane]()
    
    //create anchor list for placing, and scene light for display
    var petAnchors = [ARAnchor]()
    var sceneLight:SCNLight!
    
    // the prob of generate an apple in a plane when detected
    let probabilityOfFruit:Float = 1
    
    //locatePet? boolean for determining whether to put pet into detected plane
    var locatePet:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        //disable sceneView Default Lighting
        sceneView.autoenablesDefaultLighting = false
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        //set own light
        sceneLight = SCNLight()
        sceneLight.type = .omni
        
        //create node with this light property
        let lightNode = SCNNode()
        lightNode.light = sceneLight
        lightNode.position = SCNVector3(x:0, y:10, z:2)
        
        //add this light Node
        sceneView.scene.rootNode.addChildNode(lightNode)
        
    }
    
    @IBAction func SurfaceClicked(_ sender: Any) {
        //when clicked put a object on the plane
//        addObject()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //surface enable and light estimation
        
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        
        // display the feature points for debug issue
        #if DEBUG
            sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        #endif

        // Run the view's session
        sceneView.session.run(configuration)
        
//        addObject()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // for adapting light, timely
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // if exist a estimate of light
        if let lightEsti = self.sceneView.session.currentFrame?.lightEstimate {
            sceneLight.intensity = lightEsti.ambientIntensity
        }
    }
    

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var node:SCNNode?
        
        //if the anchor can change to ARPlaneAnchor, which means it has found a valid plane anchor
        if let planeAnchor = anchor as? ARPlaneAnchor {
            
            //create node, and initialize a plane object
            node = SCNNode()
            curPetPlane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            //set the first material, which would be the indication of finding a plane
            curPetPlane.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.5)
            
            //initialize the return node
            let planeNode = SCNNode(geometry: curPetPlane)
            //find a place for the planeNode to put
            planeNode.position = SCNVector3(CGFloat(planeAnchor.center.x), 0, CGFloat(planeAnchor.center.z))
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            updatePetMaterial()
            
            //when a plane detected, generate a random float, to check whether its meet the probability, if yes, put an apple into this plane for future collection
            let prob = Float.random(in: 0.0...1.0)
            if prob < probabilityOfFruit {
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        print("place an apple")
                        let apple = Apple()
                        apple.loadModel()
                        apple.position = SCNVector3(CGFloat(planeAnchor.transform.columns.3.x), CGFloat(planeAnchor.transform.columns.3.y), CGFloat(planeAnchor.transform.columns.3.z))
                
                        self.sceneView.scene.rootNode.addChildNode(apple)
                    }
                }
            }
            
            //print message
            print("a plane detected")
            
            //add childnode into the return node
            node?.addChildNode(planeNode)
            petAnchors.append(planeAnchor)
        }
     
        return node
    }
    
    //check new plane anchor detected and added into the pet anchors list
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            //if already contains
            if petAnchors.contains(planeAnchor) {
                //check if have plane node?
                if node.childNodes.count > 0 {
                    //try to change the position, incase the plane is different
                    let planeNode = node.childNodes.first!
                    planeNode.position = SCNVector3(CGFloat(planeAnchor.center.x), 0, CGFloat(planeAnchor.center.z))
                    
                    // if has geometry
                    if let plane = planeNode.geometry as? SCNPlane {
                        plane.width = CGFloat(planeAnchor.center.x)
                        plane.height = CGFloat(planeAnchor.center.z)
                        updatePetMaterial()
                    }
                }
            }
        }
    }
    
    //added by lin yue
    //when touched, action can be added into this function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: sceneView)

            let hitList = sceneView.hitTest(location, options: nil)
            let hitPlanes = sceneView.hitTest(location, types: .existingPlane)
            
            //hitobject test, in order for playing and collecting
            if let hitObject = hitList.first {
                let node = hitObject.node
                var flag = false
                
                //if its a playing
                if node.name == "shipMesh" {
                    node.removeFromParentNode()
                    locatePet = true
                    flag = true
                }
                
                //if its a collection
                if node.name == "Apple" {
                    node.removeFromParentNode()
                    flag = true
                }
                
                if flag == true {return}
            }
            
            // if its a plane, check whether to put a pet, when locatePet is true
            if hitPlanes.count > 0 && locatePet == true{
                print("here is a plane")
                let plane = hitPlanes.first!
                let newLocation = SCNVector3(x: plane.worldTransform.columns.3.x, y: plane.worldTransform.columns.3.y, z: plane.worldTransform.columns.3.z)
                
                //create a ship object
                let ship = SpaceShip()
                ship.loadModel()
                ship.position = newLocation
                
                locatePet = false
                
                sceneView.scene.rootNode.addChildNode(ship)
            }
        }
    }
    
    let settingsLauncher = SettingsLauncher()
    
    @IBAction func popUpFoodMenu(_ sender: UIButton) {
        settingsLauncher.showFoodMenu()
    }
    
    //add object will be called when plane detected, parameter is the position
//    func addObject() {
//        if locatePet == false || petAnchors.count <= 0 {
//            print("no available anchor or already have a pet located")
//            return
//        }
//        DispatchQueue.global().async {
//            DispatchQueue.main.async {
//                let ship = SpaceShip()
//                ship.loadModel()
//
//                if let planeAnchor = self.petAnchors.first! as? ARPlaneAnchor {
//                    ship.position = SCNVector3(CGFloat(planeAnchor.center.x), CGFloat(planeAnchor.center.y), CGFloat(planeAnchor.center.z))
//                    self.sceneView.scene.rootNode.addChildNode(ship)
//                    print("locate one")
//                    self.locatePet = false
//                }
//            }
//        }
//    }
    
    // ended

    // function for funding pet material
    func updatePetMaterial() {
        let material = self.curPetPlane.materials.first!

        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.curPetPlane.width), Float(self.curPetPlane.height), 1)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
