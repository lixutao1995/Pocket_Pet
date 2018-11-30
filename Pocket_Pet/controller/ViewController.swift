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

class ViewController: UIViewController, ARSCNViewDelegate, UICollectionViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    //for put a pet
    @IBOutlet weak var surfaceButton: UIButton!
    
    @IBOutlet var happinessBar: DisplayView!
    
    @IBOutlet var fullnessBar: DisplayView!
    
    //create an plane object for pet, and a plane list for all detected planes
    var curPetPlane:SCNPlane!
    
    // current anchor for display current pet
    var curAnchor:ARPlaneAnchor!
    
    // current indicator for ball placing
    var curBallNode:SCNNode!
    
    // visualization for plane, 1: light, 0: invisible
    var planeVisualizationParam:Float = 1
    
    // current petNode
    var curPetNode:SCNNode? = nil
    
    // current pet
    let pet = PetFigure()
    
    // food diction
    var foods:[FoodCategory:Food]=[.brain:Food(foodCategory: .brain, count:5), .apple:Food(foodCategory: .apple, count : 15), .bone:Food(foodCategory: .bone, count : 10), .pokemon:Food(foodCategory: .pokemon, count: 3)]{
        didSet {
            updataFoodCollection()
        }
    }
    
    // collection view controller
    let settingsLauncher = SettingsLauncher()
    
    // time interval fo updating food, 60 = 1 min

    let timeInterval = 10
    
    // maximum food generated each time
    let maxFood = 5
    
    // current food in scene
    var foodHasGenerated = 0
    
    // food generation flag, started generation when enabled
    var foodGeneration:Bool = false
    
    
    //create anchor list for placing, and scene light for display
    var petAnchors = [ARPlaneAnchor]()
    var sceneLight:SCNLight!
    
    // all the point node
    var points = [SCNNode]()
    
    // the prob of generate an apple in a plane when detected
    let probabilityOfFruit:Float = 0.5
    
    //locatePet? boolean for determining whether to put pet into detected plane
    var locatePet:Bool = true
    
    
    @IBAction func settingButton(_ sender: Any) {
        let settingController=SettingViewController()
        settingController.modalPresentationStyle = .custom
        settingController.transitioningDelegate=self
        present(settingController, animated: true, completion: nil)
        
    }
    
    
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
        
        
        settingsLauncher.foodCollectionView.delegate = self
        settingsLauncher.textureCollectionView.delegate = self
        
        updataFoodCollection()
        
        fullnessBar.backgroundColor = UIColor.white
        
//        fullnessBar.alpha = 0.35
        fullnessBar.color = UIColor(red: 52/255.0, green: 152/255.0, blue: 219/255.0, alpha: 1.0)
        
        happinessBar.backgroundColor = UIColor(white: 0.9, alpha: 0.4)
//        happinessBar.alpha = 0.35
//        happinessBar.color = UIColor(red: 230/255.0, green: 126/255.0, blue: 34/255.0, alpha: 1.0)
        happinessBar.color = UIColor(red: 234/255.0, green: 70/255.0, blue: 60/255.0, alpha: 1)
        fullnessBar.backgroundColor = UIColor(white: 0.9, alpha: 0.4)
    }
    
    // surface click function, when clicked, put pet, enable food generation
    @IBAction func SurfaceClicked(_ sender: Any) {
        //when clicked put a object on the plane
        addPet()
        foodGeneration = true
        
        // set all points to be invisible

        for ball in points {
            ball.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //surface enable and light estimation
        
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        
        // set the plane visualization percentage
        planeVisualizationParam = 1
        
        // display the feature points for debug issue
        //        #if DEBUG
        //            sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        //        #endif
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        foodGeneration = false
    }
    
    // MARK: - ARSCNViewDelegate
    
    // for adapting light, timely
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // if exist a estimate of light
        if let lightEsti = self.sceneView.session.currentFrame?.lightEstimate {
            sceneLight.intensity = lightEsti.ambientIntensity
        }
        
        // update food
        if Int(time) % timeInterval == 0 && foodGeneration == true {
            GenerateFoodAccordingtoAllPlanes()
        }
    }
    
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        var node:SCNNode?
        
        //if the anchor can change to ARPlaneAnchor, which means it has found a valid plane anchor
        if let planeAnchor = anchor as? ARPlaneAnchor {
            
            //create plane node, and initialize a plane object
            node = SCNNode()
            curPetPlane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            curAnchor = planeAnchor
            
            //set the first material, which would be the indication of finding a plane
            curPetPlane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(CGFloat(planeVisualizationParam))
            
            //initialize the return node
            let planeNode = SCNNode(geometry: curPetPlane)
            //find a place for the planeNode to put
            planeNode.position = SCNVector3(CGFloat(planeAnchor.center.x), 0, CGFloat(planeAnchor.center.z))
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
            
            // create ball position
            let ballPosition = SCNVector3(CGFloat(planeAnchor.transform.columns.3.x), CGFloat(planeAnchor.transform.columns.3.y), CGFloat(planeAnchor.transform.columns.3.z))
            
            updatePetMaterial()
            
            // create ball indication
            createPoint(position: ballPosition)
            
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
            
            curAnchor = planeAnchor
            //if already contains
            if petAnchors.contains(planeAnchor) {
                //check if have plane node?
                if node.childNodes.count > 0 {
                    //try to change the position, incase the plane is different
                    let planeNode = node.childNodes.first!
                    planeNode.position = SCNVector3(CGFloat(planeAnchor.center.x), 0, CGFloat(planeAnchor.center.z))
                    
                    // if has a plane, change position and create updated ball
                    if let plane = planeNode.geometry as? SCNPlane {
                        plane.width = CGFloat(planeAnchor.center.x)
                        plane.height = CGFloat(planeAnchor.center.z)
                        let ballPosition = SCNVector3(CGFloat(planeAnchor.transform.columns.3.x), CGFloat(planeAnchor.transform.columns.3.y), CGFloat(planeAnchor.transform.columns.3.z))
                        
                        createPoint(position: ballPosition)
                        plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(CGFloat(planeVisualizationParam))
                        updatePetMaterial()
                    }
                }
            }
        }
    }
    
    private func randomPosition(lowerBound lower: Float, upperBound upper: Float) -> Float {
        return Float(arc4random()) / Float(UInt32.max) * (lower - upper) + upper
    }
    
    // for every detected planeAnchor, there is a probability to generate a food here every minute
    func GenerateFoodAccordingtoAllPlanes() {
        
        // for every anchorx
        DispatchQueue.global(qos: .background).async {
        
            //generate prob
            let prob = Float.random(in: 0.0...1.0)
    
            // if meet
            if prob < self.probabilityOfFruit {
                
                // if has already generated enough food
                self.foodHasGenerated = self.foodHasGenerated + 1
                if self.foodHasGenerated >= self.maxFood {return}
                
                // create a food node and added into scene
                let brain = Brain()
                brain.loadModel()
                
                print("place an apple")
                brain.position = SCNVector3(x: self.randomPosition(lowerBound: -1.5, upperBound: 1.5), y: self.randomPosition(lowerBound: -1.5, upperBound: 1.5), z: -0.5)
                
                brain.simdScale = simd_float3(10, 10, 10)

                self.sceneView.scene.rootNode.addChildNode(brain)
            }
        }
    }
    
    // create point, which is the ball, called whenever detected a plane
    func createPoint(position: SCNVector3) {
        if let ballNode = curBallNode {
            ballNode.removeFromParentNode()
        }
        
        DispatchQueue.global().async {
            DispatchQueue.main.async {
                let point = SCNSphere(radius: 0.005)
                let ballNode = SCNNode(geometry: point)
                ballNode.position = position
                self.sceneView.scene.rootNode.addChildNode(ballNode)
                self.curBallNode = ballNode
                
                // if has a pet, set the ball to be hidden
                if self.foodGeneration == true {
                    self.curBallNode.isHidden = true
                } else {
                    self.points.append(ballNode)
                }
            }
        }
        
//        let rectPath = UIBezierPath(rect: <#T##CGRect#>)
//        //        let circle =
    }
    
    //added by lin yue
    //when touched, action can be added into this function
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: sceneView)
            
            let hitList = sceneView.hitTest(location, options: nil)
            
            //hitobject test, in order for playing and collecting
            if let hitObject = hitList.first {
                let node = hitObject.node
                
                //if its a playing
                if node.name == "Figure" {
                    node.removeFromParentNode()
                    pet.touched()
                }
                
                //if its a collection
                if node.name == "brain" {
                    node.removeFromParentNode()
                    updateFood(foodCategory: .brain, num: 1)
                }
            }
        }
    }
    
    private func updateFood(foodCategory: FoodCategory, num: Int) {
        if var curFood = foods[foodCategory] {
            curFood.count = curFood.count + num
            foods[foodCategory] = curFood
        } else {
            var food = Food(foodCategory: foodCategory)
            food.count = num
            foods[foodCategory] = food
        }
    }

    @IBAction func popUpFoodMenu(_ sender: UIButton) {
        settingsLauncher.showFoodMenu()
    }
    
    
    @IBAction func popUpTextureMenu(_ sender: UIButton) {
        settingsLauncher.showTextureMenu()
    }
    
    // food collection view update
    func updataFoodCollection() {
        settingsLauncher.foodCollectionView.food = foods
    }
    
    //add object will be called when plane detected, put into currentPetAnchor
    func addPet() {
        if petAnchors.count <= 0 {
            print("no available anchor or already have a pet located")
            return
        }
        
//        DispatchQueue.global().async {
        DispatchQueue.main.async {
            
            self.pet.removeFromParentNode()
            
            guard let plane = self.curAnchor else {
                print("No plane Available")
                return
            }
            
            self.pet.loadModel()
            
            self.pet.position = SCNVector3(x: plane.transform.columns.3.x, y: plane.transform.columns.3.y, z: plane.transform.columns.3.z)
            self.pet.simdScale = simd_float3(0.1, 0.1, 0.1)
            
            self.sceneView.scene.rootNode.addChildNode(self.pet)
            self.planeVisualizationParam = 0
            print("locate one")
        }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)!
        let ind = indexPath.section * 5 + indexPath.row
        if let foodCollectionView = collectionView as? FoodCollectionView {
            if ind < foodCollectionView.food.count {
                let foodCate = Array(foodCollectionView.food.keys)[ind]
                let food = foods[foodCate]!
                if food.count > 0 {
                    updateFood(foodCategory: foodCate, num: -1)
                    pet.eatFood(food: food)
                    settingsLauncher.dismissFoodMenu()
                }
            }
        } else if let textureCollectionView = collectionView as? TextureCollectionView {
            
            
        }
        updateBars()
    }
    
    func updateBars() {
        fullnessBar.animateValue(to: CGFloat(Float(pet.fullness) / Float(pet.MAX_VALUE)))
        happinessBar.animateValue(to: CGFloat(Float(pet.happiness) / Float(pet.MAX_VALUE)))
    }
    
    // ended
    
    // function for funding pet material
    func updatePetMaterial() {
        let material = self.curPetPlane.materials.first!
        
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(self.curPetPlane.width), Float(self.curPetPlane.height), 3)
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

extension ViewController: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationViewController(presentedViewController: presented, presenting: presenting)
    }
}
