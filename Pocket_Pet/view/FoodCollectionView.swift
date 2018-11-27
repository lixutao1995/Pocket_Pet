//
//  FoodCollectionView.swift
//  Pocket_Pet
//
//  Created by 林岳 on 11/26/18.
//  Copyright © 2018 Leiquan Pan. All rights reserved.
//

import UIKit

class FoodCollectionView: UICollectionView, UICollectionViewDataSource {
    
    var food: [Food] = [Food(foodCategory: .raspberry)]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dataSource = self
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCeil", for: indexPath)
        // fix more than one movie content add to same cell
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        let ind = indexPath.section * 3 + indexPath.row
        if ind < food.count {
            let curFood = food[ind]
            
            let imageFrame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            let imageView = UIImageView(frame: imageFrame)
            imageView.contentMode = .scaleAspectFill
            
            imageView.image = getImage(food: curFood)
            cell.contentView.addSubview(imageView)
        }
        
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(ceil((Double(food.count) / 3.0)))
    }
    
    func getImage(food: Food) -> UIImage{
        switch food.identifier {
            case .raspberry:
                return UIImage(named: "raspberry")!
        }
        
    }
}
