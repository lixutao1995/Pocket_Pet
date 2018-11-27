//
//  File.swift
//  Pocket_Pet
//
//  Created by Leiquan Pan on 11/25/18.
//  Copyright © 2018 Leiquan Pan. All rights reserved.
//

import Foundation

import UIKit
import ARKit

class Apple: SCNNode {
    
    func loadModel() {
        //load apple
        guard let virtualObjectScene = SCNScene(named: "art.scnassets/brain.dae") else {return}
        
        let wrapperNode = SCNNode()
        
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        
        self.addChildNode(wrapperNode)
        
    }
}
