//
//  Food.swift
//  Pocket_Pet
//
//  Created by 林岳 on 11/26/18.
//  Copyright © 2018 Leiquan Pan. All rights reserved.
//

import Foundation

enum FoodCategory {
    case raspberry
}

struct Food {
    let identifier: FoodCategory
    var count = 0
    
    init(foodCategory: FoodCategory) {
        identifier = foodCategory
    }
}
