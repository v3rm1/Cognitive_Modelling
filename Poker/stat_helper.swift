//
//  stat_helper.swift
//  Poker
//
//  Created by Varun Ravi Varma on 03/31/19.
//  Copyright © 2019 C. Roest. All rights reserved.
//

import Foundation

//// Hand dictionary, tracking the possible hands in Poker
//var handDictionary = [("Straight Flush", 9), ("Four of a Kind", 8), ("Full House", 7), ("Flush", 6), ("Straight", 5), ("Three of a Kind", 4), ("Two Pairs", 3), ("One Pair", 2), ("High Card", 1)]
//
//// Card Order Dictionary, tracks a point for each card in a suit
//var cardOrderDict = [("2", 2), ("3", 3), ("4", 4), ("5", 5), ("6", 6), ("7", 7), ("8", 8), ("9", 9), ("T", 10), ("J", 11), ("Q", 12), ("K", 13), ("A", 14)]

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

// Hand evaluator function
// Input: array hand, array table
// Return: string Hand_Type, int improvement_score

func handEvaluator(_ cardsHand: [String], _ cardsTable: [String]) -> (String?, Double?){
    var currentDeckSize: Int = 52 - (cardsHand.count) * 2 + cardsTable.count
    var handValue: Int = checkHand(cardsHand)
    if handValue == 9{
    return("Straight flush", 0)
    }
    else if handValue == 8{
        var improvement: Float64 = improveFour(currentDeckSize)
    return("Four of a kind", improvement)}
    else if handValue == 7{
    var improvement: Float64 = (improveFour(currentDeckSize) + improveThree(currentDeckSize)) / 2
    return("Full house", improvement)}
    else if handValue == 6{
    var improvement: Float64 = (improveFour(currentDeckSize) + improveThree(currentDeckSize) + improveTwo(currentDeckSize)) / 3
    return("Flush", improvement)
    }
    else if handValue == 5{
    var improvement: Float64 = improveFour(currentDeckSize)
    return("Straight", improvement)
    }
    else if handValue == 4{
    var improvement: Float64 = (improveFour(currentDeckSize) + improveThree(currentDeckSize)) / 2
    return("Three of a kind", improvement)}
    else if handValue == 3{
    var improvement: Float64 = (improveFour(currentDeckSize) + improveThree(currentDeckSize) + improveTwo(currentDeckSize)) / 3
    return("Two pairs", improvement)}
    else if handValue == 2{
    var improvement: Float64 = (improveFour(currentDeckSize) + improveThree(currentDeckSize) + improveTwo(currentDeckSize)) / 3
    return("One pair", improvement)}
    else{
    var improvement: Float64 = (improveFour(currentDeckSize) + improveThree(currentDeckSize) + improveTwo(currentDeckSize)) / 3
    return("High card", improvement)}

}
