//
//  Texture.swift
//  Pocket_Pet
//
//  Created by 林岳 on 11/26/18.
//

import Foundation

enum TextureCategory {
    case lucifer
}

struct Texture {
    let identifier: TextureCategory
    
    init(textureCategory: TextureCategory) {
        identifier = textureCategory
    }
}
