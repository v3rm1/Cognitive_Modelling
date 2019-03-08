
//
//  ACT-R_Model.swift
//  Poker
//
//  Created by L. Meng on 08/03/2019.
//  Copyright © 2019 C. Roest. All rights reserved.
//

import Foundation

class Poker: Model {
    var playerChips:Double = 100
    var modelChips:Double = 100
    var loadedModel: String? = nil
    /**
     Reset the players' chips
     */
    override func reset() {
        self.playerChips = 0
        self.modelChips = 0
        super.reset()
    }
    
}
