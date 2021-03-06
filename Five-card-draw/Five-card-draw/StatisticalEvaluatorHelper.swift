//
//  stat_helper2.swift
//  Poker
//
//  Created by Varun Ravi Varma on 03/31/19.
//  Copyright © 2019 C. Roest. All rights reserved.
//

import Foundation

// Factorial function
// Input: int n
// Return: n!
func factorial(_ n: Int) -> Double {
    if n == 0 {
        return 1
    }
    var a: Double = 1
    for i in 1...n {
        a *= Double(i)
    }
    return a
}

// Combination function
// Input: int n, int r
// Return: nCr

func combination(_ n: Int, _ r: Int) -> Double {
    if n == r {
        return 1
    }
    if n > r {
        return 1
    }
    var c: Double = 1
    c = factorial(n) / (factorial(r) * factorial(n-r))
    return c
}

// Card Mapping function
// Maps an input hand of cards to an integer array of size 13
// Cards are in order [2, 3, 4, 5, 6, 7, 8, 9, T, J, Q, K, A]
//Input: [String] cards in hand
//Output: [Int] card map

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
        else if value == "J" {
            valueScore[9] = valueScore[9]+1
        }
        else if value == "Q" {
            valueScore[10] = valueScore[10]+1
        }
        else if value == "K" {
            valueScore[11] = valueScore[11]+1
        }
        else if value == "A" {
            valueScore[12] = valueScore[12]+1
        }
    }
    return valueScore
}

// Suit Count function
// Counts cards of a given suit in a dealt hand
// Output is an integer array of format [hearts, diamonds, spades, clubs]
// Input: [String] cards in hand
// Output: [Int] suit count

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

// Check if hand contains one pair
// Input: [String] cards in hand
// Output: bool

func checkOnePair(_ cardsHand: [String]) -> Bool {
    let valueScore = cardMapScore(cardsHand).sorted()
    let filterScore = valueScore.filter { $0 != 0 }
    if filterScore.contains(2) {
        return true
    }
    return false
}

// Check if hand contains two pairs
// Input: [String] cards in hand
// Output: bool

func checkTwoPairs(_ cardsHand: [String]) -> Bool {
    let valueScore = cardMapScore(cardsHand).sorted()
    let filterScore = valueScore.filter { $0 != 0 }
    if filterScore == [1,2,2] {
        return true
    }
    return false
}

// Check if hand contains three of a kind
// Input: [String] cards in hand
// Output: bool

func checkThreeOfAKind(_ cardsHand: [String]) -> Bool {
    let valueScore = cardMapScore(cardsHand).sorted()
    let filterScore = valueScore.filter { $0 != 0 }
    if filterScore.contains(3) {
        return true
    }
    return false
}

// Check if hand contains straight
// Input: [String] cards in hand
// Output: bool

func checkStraight(_ cardsHand: [String]) -> Bool {
    let valueScore = cardMapScore(cardsHand).map({"\($0)"}).joined(separator: "")
    if valueScore.contains("11111") {
        return true
    }
    return false
}

// Check if hand contains flush
// Input: [String] cards in hand
// Output: bool

func checkFlush(_ cardsHand: [String]) -> Bool {
    let suitCounts = suitCount(cardsHand)
    if suitCounts.contains(5) {
        return true
    }
    return false
}

// Check if hand contains full house
// Input: [String] cards in hand
// Output: bool

func checkFullHouse(_ cardsHand: [String]) -> Bool {
    if checkOnePair(cardsHand) && checkThreeOfAKind(cardsHand) {
        return true
    }
    return false
}

// Check if hand contains four of a kind
// Input: [String] cards in hand
// Output: bool

func checkFourOfAKind(_ cardsHand: [String]) -> Bool {
    let valueScore = cardMapScore(cardsHand).sorted()
    let filterScore = valueScore.filter { $0 != 0 }
    if filterScore.contains(4) {
        return true
    }
    return false
}

// Check if hand contains straight flush
// Input: [String] cards in hand
// Output: bool

func checkStraightFlush(_ cardsHand: [String]) -> Bool {
    if checkStraight(cardsHand) && checkFlush(cardsHand) {
        return true
    }
    return false
}

// Identify patterns in cards in hand
// Input: [String] cards in hand
// Output: int pattern rank

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

// Check improvement from 4 cards, drop 1
// Input: int current deck size
// Output: float total favourable outcomes

func improveFour(_ currentDeckSize: Int) -> Float64 {
    let drawOne = combination(currentDeckSize, 1)
    let toFullHouse = (drawOne - 4)/4
    let toFlush = (drawOne - 9)/9
    let straightTwoEnd = (drawOne - 8)/8
    let straightInside = (drawOne - 4)/4
    let totalFavourable = (toFullHouse + toFlush + straightTwoEnd + straightInside)
    return totalFavourable
}

// Check improvement from 3 cards, drop 2
// Input: int current deck size
// Output: float total favourable outcomes

func improveThree(_ currentDeckSize: Int) -> Float64 {
    let drawTwo = combination(currentDeckSize, 2)
    let fourKindOdds = (combination(2, 1) * combination(3, 1)) + (combination(4, 1) * combination(10, 1))
    let fullHouseOdds = (combination(2, 1) * combination(3, 2))
    let newPairOdds = (combination(10, 1) * combination(4, 2))
    let goodOdds = (fourKindOdds + fullHouseOdds + newPairOdds)
    let totalFavourable = (drawTwo - goodOdds)/goodOdds
    return totalFavourable
}

// Check improvement from 2 cards, drop 3
// Input: int current deck size
// Output: float total favourable outcomes

func improveTwo(_ currentDeckSize: Int) -> Float64 {
    let drawThree = combination(currentDeckSize, 3)
    let fourKindOdds = Double(currentDeckSize - 2)
    let threeKindOdds = (combination(2,1) * (combination(3,2) * combination(3,1) * combination(3,1) + combination(9,2) * combination(4,1) * combination(4,1) + combination(9,1) * combination(4,1) * combination(3,1) * combination(3,1)))
    let twoPairOdds = (combination(9,1) * combination(4,2) * combination(41,1)) + (combination(3,1) * combination(3,2) * combination(42,1))
    let fullHouseOdds = (combination(9,1) * combination(4,3)) + (combination(3,1) * combination(3,3)) + combination(2,1) * (combination(9,1) * combination(4,2) + combination(3,1) * combination(3,2))
    let goodOdds = fourKindOdds + threeKindOdds + twoPairOdds + fullHouseOdds
    let totalFavourable = (drawThree - goodOdds)/goodOdds
    return totalFavourable
}

// Check improvement from 1 cards, drop 1,2,3
// Input: int current deck size
// Output: float total favourable outcomes

func improveOne(_ currentDeckSize: Int) -> Float64 {
    let goodOdds = improveFour(currentDeckSize) + improveThree(currentDeckSize) + improveTwo(currentDeckSize)
    let totalFavourable = goodOdds/3
    return totalFavourable
}

