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
    
    var fullness:Int = 0
    var happiness:Int = 0
    
    var wrapperNode = SCNNode()
    
    func eatFood(food: Food) {
        
        switch food.identifier {
        case .brain:
            fullness = fullness + 10
            happiness = happiness + 5
        }
        
        if fullness > MAX_VALUE {
            fullness = MAX_VALUE
        }
        if happiness > MAX_VALUE {
            happiness = MAX_VALUE
        }
    }
    
    func touched() {
        //change movement when
        
        wrapperNode.removeFromParentNode()
        
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/DanceFixed.dae") else {return}
        
        wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: {
            self.loadModel()
        })
    }
    
    func loadModel() {
        //load ship
        wrapperNode.removeFromParentNode()
        
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/Donothing.dae") else {return}
        
        wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
    }
}
