//
//  Poker.swift
//  Five-card-draw
//
//  Created by Varun Ravi Varma on 04/08/19.
//  Copyright © 2019 Andris. All rights reserved.
//

import Foundation

class Poker: Model {
    var playerScore:Double = 0
    var modelScore:Double = 0
    var loadedModel: String? = nil
    
    //Reset the ACT-R model: reset scores then do standard model init

    override func reset() {
        self.playerScore = 0
        self.modelScore = 0
        super.reset()
    }
    
}
