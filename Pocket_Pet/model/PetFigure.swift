//
//  SpaceShip.swift
//  Pocket_Pet
//
//  Created by 林岳 on 11/15/18.
//  Copyright © 2018 Leiquan Pan. All rights reserved.
//

import Foundation

import UIKit
import ARKit

class PetFigure: SCNNode {
    let MAX_VALUE = 100
    
    var prevFullness: Int = 50
    
    var fullness:Int = 50 {
        didSet {
            changeModel()
        }
    }
    var happiness:Int = 50
    
    override init() {
        idleModel = NORMAL_IDLE_MODEL
        clickedModel = CLICKED_MODEL
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let HAPPY_IDLE_MODEL = "art.scnassets/DanceFixed.dae"
    let NORMAL_IDLE_MODEL = "art.scnassets/Donothing.dae"
    let ANGRY_IDLE_MODEL = "art.scnassets/HungryToDie.dae"
    
    let EAT_MODEL = "art.scnassets/HappyToEat.dae"
    
    let CLICKED_MODEL = "art.scnassets/touchHim.dae"
    
    let INIT_MODEL = "art.scnassets/touchToShow.dae"
    
    var idleModel: String {
        didSet {
            loadModel()
        }
    }

    var clickedModel: String
    
    var wrapperNode = SCNNode()
    
    func eatFood(food: Food) {
        
        switch food.identifier {
        case .brain:
            fullness = fullness + 16
            happiness = happiness + 20
        case .apple:
            fullness = fullness + 4
            happiness = happiness + 8
        case .pokemon:
            fullness = fullness + 10
            happiness = happiness + 15
        case .bone:
            fullness = fullness + 6
            happiness = happiness + 12
        }
        
        if fullness > MAX_VALUE {
            fullness = MAX_VALUE
        }
        if happiness > MAX_VALUE {
            happiness = MAX_VALUE
        }
        
        
        wrapperNode.removeFromParentNode()
        
        guard let virtualObjectScene = SCNScene(named: EAT_MODEL) else {return}
        
        wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
        // TODO: modify delay second to smooth movement
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            self.loadModel()
        })
    }
    
    func show() {
        
        wrapperNode.removeFromParentNode()
        
        guard let virtualObjectScene = SCNScene(named: INIT_MODEL) else {return}
        
        wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
        // TODO: modify delay second to smooth movement
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7, execute: {
            self.loadModel()
        })
    }
    
    func touched() {
        //change movement when
        print("touched")
        wrapperNode.removeFromParentNode()
        
        guard let virtualObjectScene = SCNScene(named: clickedModel) else {return}
        
        wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
        
        let playDuration = Int.random(in: 7...10)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(playDuration), execute: {
            self.loadModel()
        })
    }
    
    
    
    func loadModel() {
        //load ship
        wrapperNode.removeFromParentNode()
        
        guard let virtualObjectScene = SCNScene(named: idleModel) else {return}
        
        wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
        
    }
    
    func changeModel() {
        if prevFullness <= 80 && fullness > 80 {
            idleModel = HAPPY_IDLE_MODEL
        } else if (prevFullness >= 80 && fullness < 80) || (prevFullness <= 20 && fullness > 20) {
            idleModel = NORMAL_IDLE_MODEL
        } else if prevFullness >= 20 && fullness < 20 {
            idleModel = ANGRY_IDLE_MODEL
        }
        print(prevFullness, ",", fullness, ",", idleModel)
        prevFullness = fullness
    }
    
    func decreaseFullness(degree: Int) {
        fullness = fullness - degree
        print("fullness: ", fullness)
        if fullness < 0 {
            fullness = 0
        }
    }
    
    func decreaseHappiness(degree: Int) {
        happiness = happiness - degree
        print("happiness: ", happiness)
        if happiness < 0 {
            happiness = 0
        }
        
    }
}
