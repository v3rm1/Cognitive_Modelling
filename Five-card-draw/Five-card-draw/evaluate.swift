//
//  evaluate.swift
//  Five-card-draw Hand Strength Evaluator and Comparator
//
//  Created by C. Roest on 01/04/2019.
//  Copyright © 2019 Andris. All rights reserved.
//

import Foundation

enum HandRank: Int, Comparable{
    case HighCard = 1
    case Pair
    case TwoPair
    case ThreeOfAKind
    case Straight
    case Flush
    case FullHouse
    case FourOfAKind
    case StraightFlush
    
    //MARK: From Comparable
    public static func < (a: HandRank, b: HandRank) -> Bool {
        return a.rawValue < b.rawValue
    }
    
    public static func > (a: HandRank, b: HandRank) -> Bool {
        return a.rawValue > b.rawValue
    }
    
    var description : String {
        switch self {
        // Use Internationalization, as appropriate.
        case .HighCard: return "a High Card"
        case .Pair: return "a Pair"
        case .TwoPair: return "Two Pair"
        case .ThreeOfAKind: return "Three of a Kind"
        case .Straight: return "a Straight"
        case .Flush: return "a Flush"
        case .FullHouse: return "a Full House"
        case .FourOfAKind: return "Four of a Kind"
        case .StraightFlush: return "a Straight Flush"
        }
    }
}

func compareHands(hand1: [Card], hand2: [Card]) {
}

class HandComparer {
//    var own: [Card], other: [Card]
//    
//    init() {
//    }
    
    func getCounts (hand: [Card]) -> [Int:Int]{
        var out: [Int:Int] = [:]
        for card in hand {
            if (out.keys.contains(card.rank)){
                out[card.rank]! += 1
            }else{
                out[card.rank] = 1
            }
        }
        return out
    }
    
    func getSortedRanks (h: [Card]) -> [Int]{
        var out: [Int] = []
        var rankCounts = getCounts(hand: h)
        
        for x in (1...5).reversed(){
            for i in (2...15).reversed(){
                if (rankCounts[i] != nil){
                    if (rankCounts[i]! == x){
                        for _ in 1...x{
                            out.append(i)
                        }
                    }
                }
            }
        }
        return out
    }
    
    func hasFlush (h: [Card]) -> Bool{
        // If all cards are of the same suit as the first card in the hand
        if (h.allSatisfy({$0.suit == h[0].suit})){
            return true
        }
        return false
    }
    
    func hasStraight (h: [Card]) -> Bool {
        let ranks = Array(Set(h.map { $0.rank })).sorted()
        
        // Special case wheel straight (A,2,3,4,5)
        if Set(ranks) == Set([14,2,3,4,5]){
            return true
        }
        
        // Have 5 different values
        if (ranks.count) != 5{
            return false
        }
        
        // Check if the distance between each card is equal to 1
        for x in 0...3 {
            if (abs(ranks[x] - ranks[x + 1]) != 1){
                return false
            }
        }
        
        return true
    }
    
    func hasStraightFlush (h: [Card]) -> Bool {
        return hasStraight(h: h) && hasFlush(h: h)
    }
    
    func hasPair (h: [Card]) -> Bool {
        let counts = getCounts(hand: h)
        let ranks = Array(Set(h.map { $0.rank })).sorted()
        
        // If there is no rank that appears 2 times
        if (!(counts.filter { $0.value == 2 }.count == 1)){
            return false
        }
        
        if (ranks.count != 4){
            return false
        }
        
        return true
    }
    
    func hasTwoPair (h: [Card]) -> Bool {
        let counts = getCounts(hand: h)
        
        // If there is a rank that appears 2 times
        if (counts.filter { $0.value == 2 }.count == 2){
            return true
        }
        return false
    }
    
    func hasTrips (h: [Card]) -> Bool {
        let counts = getCounts(hand: h)
        let ranks = Array(Set(h.map { $0.rank })).sorted()
        
        // If there is no rank that appears 3 times
        if (!(counts.filter { $0.value == 3 }.count == 1)){
            return false
        }
        
        if (ranks.count != 3) {
            return false
        }
        return true
    }
    
    func hasQuads (h: [Card]) -> Bool {
        let counts = getCounts(hand: h)
        let ranks = Array(Set(h.map { $0.rank })).sorted()
        
        // If there is no rank that appears 3 times
        if (!(counts.filter { $0.value == 4 }.count == 1)){
            return false
        }
        
        if (ranks.count != 2) {
            return false
        }
        return true
    }
    
    func hasFullHouse (h: [Card]) -> Bool {
        let counts = getCounts(hand: h)
        let ranks = Array(Set(h.map { $0.rank })).sorted()
        
        // If there is no rank that appears 3 times
        if (!(counts.filter { $0.value == 3 }.count == 1)){
            return false
        }
        
        // If there is no rank that appears 2 times
        if (!(counts.filter { $0.value == 2 }.count == 1)){
            return false
        }
        
        if (ranks.count != 2) {
            return false
        }
        return true
    }
    
    func getHandRank (h: [Card]) -> HandRank {
        if (hasStraightFlush(h: h)){
            return HandRank.StraightFlush
        }
        if (hasQuads(h: h)) {
            return HandRank.FourOfAKind
        }
        if (hasFullHouse(h: h)) {
            return HandRank.FullHouse
        }
        if (hasFlush(h: h)) {
            return HandRank.Flush
        }
        if (hasStraight(h: h)) {
            return HandRank.Straight
        }
        if (hasTrips(h: h)) {
            return HandRank.ThreeOfAKind
        }
        if (hasTwoPair(h: h)) {
            return HandRank.TwoPair
        }
        if (hasPair(h: h)) {
            return HandRank.Pair
        }
        return HandRank.HighCard
    }
    
    func compare (h1: [Card], h2: [Card]) -> Int {
        // First players hand is better than the second players hand
        if (getHandRank(h: h1) > getHandRank(h: h2)) {
            return 1
        }
        
        // Seconds players hand is better than the first players hand
        if (getHandRank(h: h2) > getHandRank(h: h1)) {
            return -1
        }
        
        // Hands are equal, decide using card ranks
        let sr1 = getSortedRanks(h: h1)
        let sr2 = getSortedRanks(h: h2)
        
        for x in 0...4{
            if (sr1[x]>sr2[x]){
                // Player 1 has the higher card
                return 1
            }
            if (sr1[x]<sr2[x]){
                // Player 2 has the higher card
                return -1
            }
        }
        return 0
    }
}
