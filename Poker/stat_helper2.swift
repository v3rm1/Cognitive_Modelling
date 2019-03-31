//
//  stat_helper2.swift
//  Poker
//
//  Created by Varun Ravi Varma on 03/31/19.
//  Copyright © 2019 C. Roest. All rights reserved.
//

import Foundation

func cardMapScore(_ cardsHand: [String]) -> [Int] {
    var sortedHand = cardsHand.sorted()
    var valueScore: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0]
    var values: [String] = []
    for index in 0..<sortedHand.count {
        values.append(String(sortedHand[index].prefix(1)))
    }
    for value in values {
        if value == "2" {
            valueScore[0] = valueScore[0]+1
        }
        else if value == "3" {
            valueScore[1] = valueScore[1]+1
        }
        else if value == "4" {
            valueScore[2] = valueScore[2]+1
        }
        else if value == "5" {
            valueScore[3] = valueScore[3]+1
        }
        else if value == "6" {
            valueScore[4] = valueScore[4]+1
        }
        else if value == "7" {
            valueScore[5] = valueScore[5]+1
        }
        else if value == "8" {
            valueScore[6] = valueScore[6]+1
        }
        else if value == "9" {
            valueScore[7] = valueScore[7]+1
        }
        else if value == "T" {
            valueScore[8] = valueScore[8]+1
        }
        else if value == "K" {
            valueScore[9] = valueScore[9]+1
        }
        else if value == "Q" {
            valueScore[10] = valueScore[10]+1
        }
        else if value == "J" {
            valueScore[11] = valueScore[11]+1
        }
        else if value == "A" {
            valueScore[12] = valueScore[12]+1
        }
    }
    return valueScore
}

func suitCount(_ cardsHand: [String]) -> [Int] {
    var sortedHand = cardsHand.sorted()
    var suitCount: [Int] = [0,0,0,0]
    for index in 0..<sortedHand.count {
        let suit = (String(sortedHand[index].suffix(1)))
        if suit == "h" {
            suitCount[0] = suitCount[0]+1
        }
        if suit == "d" {
            suitCount[1] = suitCount[1]+1
        }
        if suit == "s" {
            suitCount[2] = suitCount[2]+1
        }
        if suit == "c" {
            suitCount[3] = suitCount[3]+1
        }
    }
    return suitCount
}

func checkOnePair(_ cardsHand: [String]) -> Bool {
    let valueScore = cardMapScore(cardsHand).sorted()
    let filterScore = valueScore.filter { $0 != 0 }
    if filterScore.contains(2) {
        return true
    }
    return false
}

func checkTwoPairs(_ cardsHand: [String]) -> Bool {
    let valueScore = cardMapScore(cardsHand).sorted()
    let filterScore = valueScore.filter { $0 != 0 }
    if filterScore == [1,2,2] {
        return true
    }
    return false
}

func checkThreeOfAKind(_ cardsHand: [String]) -> Bool {
    let valueScore = cardMapScore(cardsHand).sorted()
    let filterScore = valueScore.filter { $0 != 0 }
    if filterScore.contains(3) {
        return true
    }
    return false
}

func checkStraight(_ cardsHand: [String]) -> Bool {
    let valueScore = cardMapScore(cardsHand).map({"\($0)"}).joined(separator: "")
    if valueScore.contains("11111") {
        return true
    }
    return false
}

func checkFlush(_ cardsHand: [String]) -> Bool {
    let suitCounts = suitCount(cardsHand)
    if suitCounts.contains(5) {
        return true
    }
    return false
}

func checkFullHouse(_ cardsHand: [String]) -> Bool {
    if checkOnePair(cardsHand) && checkThreeOfAKind(cardsHand) {
        return true
    }
    return false
}

func checkFourOfAKind(_ cardsHand: [String]) -> Bool {
    let valueScore = cardMapScore(cardsHand).sorted()
    let filterScore = valueScore.filter { $0 != 0 }
    if filterScore.contains(4) {
        return true
    }
    return false
}

func checkStraightFlush(_ cardsHand: [String]) -> Bool {
    if checkStraight(cardsHand) && checkFlush(cardsHand) {
        return true
    }
    return false
}

func checkHand(_ cardsHand: [String]) -> Int {
    if checkStraightFlush(cardsHand) {
        return 9
    }
    else if checkFourOfAKind(cardsHand) {
        return 8
    }
    else if checkFullHouse(cardsHand) {
        return 7
    }
    else if checkFlush(cardsHand) {
        return 6
    }
    else if checkStraight(cardsHand) {
        return 5
    }
    else if checkThreeOfAKind(cardsHand) {
        return 4
    }
    else if checkTwoPairs(cardsHand) {
        return 3
    }
    else if checkOnePair(cardsHand) {
        return 2
    }
    return 1
}
