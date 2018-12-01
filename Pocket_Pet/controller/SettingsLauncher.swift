//
//  SettingsLauncher.swift
//  Pocket_Pet
//
//  Created by 林岳 on 11/26/18.
//  Copyright © 2018 Leiquan Pan. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject {
    let blackView = UIView()
    
    let foodCollectionView: FoodCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = FoodCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "foodCeil")
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let textureCollectionView: TextureCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = TextureCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "textureCeil")
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let settingView: SettingView = {
        let cv = SettingView(frame: .zero)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    override init() {
        super.init()
    }
    
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
            
            
            setLayout(collectionView: foodCollectionView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                self.foodCollectionView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: height)
                
            }, completion: nil)
            
            
        }
        
    }
    
    func showSetting() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissSetting)))
            
            let width: CGFloat = window.frame.width * 2/3
            let x = window.frame.width - width
            
            window.addSubview(blackView)
            window.addSubview(settingView)
            settingView.frame = CGRect(x: window.frame.width, y: 0, width: width, height: window.frame.height)
            
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                self.settingView.frame = CGRect(x: x, y: 0, width: width, height: window.frame.height)
                
            }, completion: nil)
            
            
        }
    }
    
    @objc func dismissSetting() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.settingView.frame = CGRect(x: window.frame.width, y: 0, width: self.settingView.frame.width, height: self.settingView.frame.height)
            }
        })
    }
    
    @objc func dismissFoodMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.foodCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.foodCollectionView.frame.width, height: self.foodCollectionView.frame.height)
            }
        })
    }
    
    func showTextureMenu() {
        
        if let window = UIApplication.shared.keyWindow {
            
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissTextureMenu)))
            
            let height: CGFloat = 200
            let y = window.frame.height - height
            
            window.addSubview(blackView)
            window.addSubview(textureCollectionView)
            textureCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            
            blackView.frame = window.frame
            blackView.alpha = 0
            
            setLayout(collectionView: textureCollectionView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackView.alpha = 1
                self.textureCollectionView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: height)
                
            }, completion: nil)
            
            
        }
        
    }
    
    @objc func dismissTextureMenu() {
        UIView.animate(withDuration: 0.5, animations: {
            self.blackView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.textureCollectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.textureCollectionView.frame.width, height: self.textureCollectionView.frame.height)
            }
        })
    }
    
    private func setLayout(collectionView: UICollectionView){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let width = (collectionView.bounds.width - (5 * 20)) / 5
        let height = width
        let cellSize = CGSize(width: width, height: height)
        
        layout.sectionInset = UIEdgeInsets(top: collectionView.bounds.height / 2 - height, left: 20, bottom: 10, right: 20)
        layout.itemSize = cellSize
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout
    }

}
