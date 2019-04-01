//
//  Five_card_drawTests.swift
//  Five-card-drawTests
//
//  Created by Andris on 01/03/2019.
//  Copyright © 2019 Andris. All rights reserved.
//

import XCTest
@testable import Five_card_draw

class Five_card_drawTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        var c11:Card = Card(suit: Suit.C, rank: 14)
        var c12:Card = Card(suit: Suit.D, rank: 3)
        var c13:Card = Card(suit: Suit.H, rank: 2)
        var c14:Card = Card(suit: Suit.C, rank: 5)
        var c15:Card = Card(suit: Suit.D, rank: 4)
        
        var h1 = [c11,c12,c13,c14,c15]
        
        var c21:Card = Card(suit: Suit.C, rank: 4)
        var c22:Card = Card(suit: Suit.D, rank: 5)
        var c23:Card = Card(suit: Suit.H, rank: 8)
        var c24:Card = Card(suit: Suit.C, rank: 6)
        var c25:Card = Card(suit: Suit.D, rank: 7)
        
        var h2 = [c21,c22,c23,c24,c25]
        
        var c31:Card = Card(suit: Suit.D, rank: 4)
        var c32:Card = Card(suit: Suit.S, rank: 5)
        var c33:Card = Card(suit: Suit.C, rank: 8)
        var c34:Card = Card(suit: Suit.D, rank: 6)
        var c35:Card = Card(suit: Suit.C, rank: 7)
        
        var h3 = [c31,c32,c33,c34,c35]
        
        var x = HandComparer()
        var out  = x.getSortedRanks(h: h1)
        var out2 = x.hasFlush(h: h1)
        var out3 = x.hasStraight(h: h1)
        var handRank1 = x.getHandRank(h: h1)
        var handRank2 = x.getHandRank(h: h2)
        
        var winner = x.compare(h1: h1, h2: h2)
        var winner2 = x.compare(h1: h3, h2: h2)
        
        print (out)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
