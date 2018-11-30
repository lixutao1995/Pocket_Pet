//
//  Food.swift
//  Pocket_Pet
//
//  Created by 林岳 on 11/26/18.
//  Copyright © 2018 Leiquan Pan. All rights reserved.
//

import Foundation

enum FoodCategory {
    case brain
    case apple
    case pokemon
    case bone
}

struct Food {
    let identifier: FoodCategory
    var count = 0
    
    init(foodCategory: FoodCategory) {
        identifier = foodCategory
    }
    
    init(foodCategory: FoodCategory, count: Int) {
        identifier = foodCategory
        self.count = count
    }
}
