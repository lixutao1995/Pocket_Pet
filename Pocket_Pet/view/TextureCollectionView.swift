//
//  TextureCollectionView.swift
//  Pocket_Pet
//
//  Created by 林岳 on 11/26/18.
//

import UIKit

class TextureCollectionView: UICollectionView, UICollectionViewDataSource {
    
    var textures: [Texture] = [Texture(textureCategory: .lucifer)]
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "textureCeil", for: indexPath)
        // fix more than one movie content add to same cell
        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        let ind = indexPath.section * 3 + indexPath.row
        if ind < textures.count {
            let texture = textures[ind]
            
            let imageFrame = CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height)
            let imageView = UIImageView(frame: imageFrame)
            imageView.contentMode = .scaleAspectFill
            
            imageView.image = getImage(texture: texture)
            cell.contentView.addSubview(imageView)
        }
        
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(ceil((Double(textures.count) / 3.0)))
    }
    
    func getImage(texture: Texture) -> UIImage{
        switch texture.identifier {
        case .lucifer:
            return UIImage(named: "lucifer")!
        }
        
    }
}
