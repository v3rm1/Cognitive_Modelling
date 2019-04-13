//
//  stat_helper.swift
//  Poker
//
//  Created by Varun Ravi Varma on 03/31/19.
//  Copyright © 2019 C. Roest. All rights reserved.
//

import Foundation

// Hand evaluator function
// Input: array hand, array table
// Return: string Hand_Type, int improvement_score

func handEvaluator(_ cardsHand: [String], _ cardsTable: Int) -> (Float64){
    let currentDeckSize: Int = 52 - (cardsHand.count) * 2 + cardsTable
    let handValue: Int = checkHand(cardsHand)
    if handValue == 9{
    return(0)
    }
    else if handValue == 8{
        let improvement: Float64 = improveFour(currentDeckSize)
    return(improvement)}
    else if handValue == 7{
        let improvement: Float64 = (improveFour(currentDeckSize) + improveThree(currentDeckSize)) / 2
    return(improvement)}
    else if handValue == 6{
        let improvement: Float64 = (improveFour(currentDeckSize) + improveThree(currentDeckSize) + improveTwo(currentDeckSize)) / 3
    return(improvement)
    }
    else if handValue == 5{
        let improvement: Float64 = improveFour(currentDeckSize)
    return(improvement)
    }
    else if handValue == 4{
        let improvement: Float64 = (improveFour(currentDeckSize) + improveThree(currentDeckSize)) / 2
    return(improvement)}
    else if handValue == 3{
        let improvement: Float64 = (improveFour(currentDeckSize) + improveThree(currentDeckSize) + improveTwo(currentDeckSize)) / 3
    return(improvement)}
    else if handValue == 2{
        let improvement: Float64 = (improveFour(currentDeckSize) + improveThree(currentDeckSize) + improveTwo(currentDeckSize)) / 3
    return(improvement)}
    else{
        let improvement: Float64 = (improveOne(currentDeckSize))
        
    return(improvement)}

}

func maxHandScore(_ cardsHand: [String], _ cardsTable: Int) -> (Float64) {
    let currentDeckSize: Int = 52 - (cardsHand.count) * 2 + cardsTable
    let maxImprovement = (improveFour(currentDeckSize) + improveThree(currentDeckSize) + improveTwo(currentDeckSize) + improveOne(currentDeckSize))
    return maxImprovement
}

// Scoring hand
// Rank is calculated as pattern rank (generated from checkHand function) + . + reversed cardMap (cards are in order [A, K, Q, J, T, 9, 8, 7, 6, 5, 4, 3, 2] => the score of having a Queen high is preserved over having a 5 high.
// Input: [String] cards in hand
// Output: String rank

func handRank(_ cardsHand: [String]) -> String {
    var rank: String
    let cardMap = cardMapScore(cardsHand)
    rank = String(checkHand(cardsHand)) + "." + String(cardMap.map({"\($0)"}).joined(separator: "")).reversed()
    return rank
}
