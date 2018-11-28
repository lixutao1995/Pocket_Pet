//
//  FoodCollectionView.swift
//  Pocket_Pet
//
//  Created by 林岳 on 11/26/18.
//  Copyright © 2018 Leiquan Pan. All rights reserved.
//

import UIKit

class FoodCollectionView: UICollectionView, UICollectionViewDataSource {
    
    var food: [FoodCategory:Food] = [.brain:Food(foodCategory: .brain)] {
        didSet {
            setNeedsDisplay()
            updateLabel()
        }
    }
    
    var labelDic: [UILabel: FoodCategory] = [:]
    
    private func updateLabel() {
        for label in labelDic.keys {
            let cate = labelDic[label]!
            let count = food[cate]!.count
            label.text = "x\(count)"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.dataSource = self
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCeil", for: indexPath)
        // fix more than one movie content add to same cell
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        let ind = indexPath.section * 5 + indexPath.row
        if ind < food.count {
            let curFood = Array(food.values)[ind]
            
            let imageFrame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            let imageView = UIImageView(frame: imageFrame)
            imageView.contentMode = .scaleAspectFill
            
            imageView.image = getImage(food: curFood)
            cell.contentView.addSubview(imageView)
            
            var label = UILabel(frame: CGRect(x:0, y: cell.bounds.height, width: cell.bounds.width, height: 40))
            label.textAlignment = .center
            label.numberOfLines = 1
            label.text = "x\(curFood.count)"
            cell.addSubview(label)
            labelDic[label] = curFood.identifier
        }
        
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(ceil((Double(food.count) / 5.0)))
    }
    
    func getImage(food: Food) -> UIImage{
        switch food.identifier {
            case .brain:
                return UIImage(named: "brain")!
        }
        
    }
}
