//
//  Model.swift
//  Poker
//
//  Created by C. Roest on 08/02/2019.
//  Copyright © 2019 C. Roest. All rights reserved.
//

import Foundation

enum CardColor : CaseIterable{
    case spades
    case hearts
    case clubs
    case diamonds
}

enum GameState : CaseIterable{
    case preflop
    case flop
    case turn
    case river
    case done
}

class Card {
    var color : CardColor
    var value : Int
    
    init (color : CardColor, value : Int){
        self.color = color
        self.value = value
    }
    
    func toPictureName() -> String{
        var out : String
        
        // Set card color in string
        switch color{
        case CardColor.spades:
            out = "cardSpades"
        case CardColor.hearts:
            out = "cardHearts"
        case CardColor.clubs:
            out = "cardClubs"
        case CardColor.diamonds:
            out = "cardDiamonds"
        }
        
        if value < 11{
            out.append(String(value))
        }else if(value == 11){
            out.append(String("J"))
        }else if(value == 12){
            out.append(String("Q"))
        }else if(value == 13){
            out.append(String("K"))
        }else if(value == 14){
            out.append(String("A"))
        }
        out.append(".png")
        return out
    }
}

class Deck {
    var cardList : [Card]
    
    init (){
        cardList = []
        reset()
    }
    
    func reset (){
        // Reset the list, add all cards in order
        cardList = [Card]()
        
        for col in CardColor.allCases {
            for val in 7..<15{
                cardList.append(Card(color: col, value: val))
            }
        }
        cardList.shuffle()
    }
    
    func draw () -> Card? {
        return cardList.popLast()
    }
}

class Player {
    var chips = 100
    var card1 : Card?
    var card2 : Card?
    
    init (chips : Int){
        self.chips = chips
    }
    
    func loseChips (amount: Int){
        chips = chips - amount
    }
    
    func winChips (amount: Int){
        chips = chips + amount
    }
    
    func getCards(card1 : Card, card2 : Card){
        self.card1 = card1
        self.card2 = card2
    }
}

class Model {
    var pot     : Int
    var curbet  : Int
    var utg     : Player
    var player  : Player
    var cpu     : Player
    var deck    : Deck
    var board   : [Card?]
    var turn    : Int
    var lastAct : Player?
    
    init () {
        turn    = 1
        pot     = 0
        curbet  = 0
        player  = Player(chips: 100)
        cpu     = Player(chips: 100)
        utg     = player    // Player starts action first hand
        deck    = Deck()
        board   = []
    }
    
    func reset() {
        turn    = 1
        pot     = 0
        curbet  = 0
        player  = Player(chips: 100)
        cpu     = Player(chips: 100)
        utg     = player    // Player starts action first hand
        deck    = Deck()
        board   = []
    }
    
    func nextToAct() -> Player {
        if lastAct == nil {
            if turn % 2 == 0 {
                return player
            }else{
                return cpu
            }
        }else{
            if lastAct! === player {
                return cpu
            }else{
                return player
            }
        }
    }
    
    func otherPlayer(p : Player) -> Player {
        if p === player {
            return cpu
        }else {
            return player
        }
    }
    
    func dealHoleCards(){
        // Deal player cards
        player.card1 = deck.draw()
        player.card2 = deck.draw()
        
        // Deal CPU cards
        cpu.card1 = deck.draw()
        cpu.card2 = deck.draw()
    }
    
    func dealFlop(){
        // Put three cards on table
        board.append(deck.draw())
        board.append(deck.draw())
        board.append(deck.draw())
    }
    
    func dealTurn(){
        // Put fourth card on table
        board.append(deck.draw())
    }
    
    func dealRiver(){
        // Put fifth card on table
        board.append(deck.draw())
    }
    
    func currentState() -> GameState {
        switch board.count{
        case 0:
            return GameState.preflop
        case 3:
            return GameState.flop
        case 4:
            return GameState.turn
        case 5:
            return GameState.river
        default:
            return GameState.done
        }
    }
    
    func goToNextState(){
        switch currentState(){
        case GameState.preflop:
            dealFlop()
        case GameState.flop:
            dealTurn()
        case GameState.turn:
            dealRiver()
        case GameState.river:
            reset()
            dealHoleCards()
        default:
            print ("wtf")
        }
        lastAct = nil
        curbet = 0
    }
    
    func progress (action : String){
        let someoneActedBefore : Bool = lastAct != nil
        switch action {
        case "call":
            nextToAct().loseChips(amount: curbet)
            pot = pot + curbet
            if someoneActedBefore{
                goToNextState()
            }else{
                lastAct = nextToAct()
            }
        case "raise":
            nextToAct().loseChips(amount: curbet + 20)
            pot = pot + curbet + 20
            curbet = 20
            lastAct = nextToAct()
        case "fold":
            otherPlayer(p: nextToAct()).winChips(amount: pot)
            reset()
            dealHoleCards()
        default :
            nextToAct().loseChips(amount: curbet)
            pot = pot + curbet
        }
    }
}
