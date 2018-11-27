//
//  SettingsLauncher.swift
//  Pocket_Pet
//
//  Created by 林岳 on 11/26/18.
//  Copyright © 2018 Leiquan Pan. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject  {
    let blackView = UIView()
    
    let foodCollectionView: FoodCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = FoodCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "foodCeil")
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    func showFoodMenu() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFoodMenu)))
            
            let height: CGFloat = 200
            let y = window.frame.height - height
            
            window.addSubview(blackView)
            window.addSubview(foodCollectionView)
            foodCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                self.foodCollectionView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: height)
                
            }, completion: nil)
            
            
        }
        
    }
    
    @objc func dismissFoodMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.foodCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.foodCollectionView.frame.width, height: self.foodCollectionView.frame.height)
            }
        })
    }
    
    override init() {
        super.init()
    }
    
    
}
