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

class SpaceShip: SCNNode {
    
    func loadModel() {
        //load ship
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/ship.scn") else {return}
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
        
    }
}
