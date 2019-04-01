//
//  Classes.swift
//  Five-card-draw
//
//  Created by Andris on 15/03/2019.
//  Copyright © 2019 Andris. All rights reserved.
//

import Foundation

enum Suit : CaseIterable{
    case S
    case H
    case C
    case D
}

enum GameState : CaseIterable{
    case preDraw
    case draw
    case postDraw
    case done
}

enum Action : CaseIterable {
    case fold
    case call
    case raise
    case draw
}

class Card {
    var suit : Suit
    var rank : Int
    
    init (suit : Suit, rank : Int){
        self.suit = suit
        self.rank = rank
    }
    
    func toPictureName() -> String{
        var out = String()
        
        // Set card color in string
        
        out = getRankName()
        
        switch suit{
        case Suit.S:
            out.append("S")
        case Suit.H:
            out.append("H")
        case Suit.C:
            out.append("C")
        case Suit.D:
            out.append("D")

        }
        return out
    }
    
    func getCommaSeperatedString() -> String {
        return "\(getRankName()),\(self.suit)"
    }
    
    func getRankName() -> String {
        if self.rank < 11{
            return String(self.rank)
        }else if(self.rank == 11){
            return "J"
        }else if(self.rank == 12){
            return "Q"
        }else if(self.rank == 13){
            return "K"
        }else {
            return "A"
        }
    }
}

class Deck {
    var cardList : [Card]
    
    init (){
        cardList = []
        reset()
    }
    
    func generateCards() {
        cardList = [Card]()
        for suit in Suit.allCases {
            for rank in 2..<15{
                cardList.append(Card(suit: suit, rank: rank))
            }
        }
    }
    
    func shuffle() {
        var tempDeck = cardList
        cardList = [Card]()
        var randomValue : Int
        
        while (!tempDeck.isEmpty) {
            randomValue = Int.random(in: 0..<tempDeck.count)
            cardList.append(tempDeck[randomValue])
            tempDeck.remove(at: randomValue)
        }
    }
    
    func reset() {
        cardList = [Card]()
        generateCards()
        cardList.shuffle()
    }
    
    func draw () -> Card? {
        return cardList.popLast()
    }
}

class Player {
    var name = ""
    var chipCount : Int = 500
    var cards = [Card]()
    var betSize = 0
    var phe : PokerHand // Poker Hand Evalutator used for determening strength of a poker hand
    
    init() {
        name = ""
        chipCount = 500
        cards = [Card]()
        betSize = 0
        phe = PokerHand()
    }
    
    init(name: String) {
        self.name = name
        chipCount = 500
        cards = [Card]()
        betSize = 0
        phe = PokerHand()
    }
    
    public static func ==(lhs: Player, rhs: Player) -> Bool{
        return
            lhs.name == rhs.name
    }
}

class Hand {
    let deck = Deck()
    var totalPot = 0
    var sb = 10
    var bb = 20
    var gameState = GameState.preDraw
    let cpu = Player(name: "CPU")
    let player = Player(name: "Player")
    var players = [Player]()
    var hasSomeoneActed = false
    var playerToAct : Player
    var playerToActAfter : Player
    var playerUtg : Player // Player to act first
    var playerOnButton : Player // Player to act second
    var playerCardsToDrawIndexes = [Int]()
    var cpuCardsToDrawIndexes = [Int]()
    
    init () {
        players.append(cpu)
        players.append(player)
        let randomVal = Int.random(in: 0..<2)
        self.playerUtg = players[randomVal]
        self.playerOnButton = players[(randomVal+1) % 2]
        self.playerToAct = self.playerUtg
        self.playerToActAfter = self.playerOnButton
    }
    
    func collectBlinds() {
        playerUtg.chipCount = playerUtg.chipCount - sb
        playerUtg.betSize = sb
        totalPot = totalPot + sb
        
        playerOnButton.chipCount = playerOnButton.chipCount - bb
        playerOnButton.betSize = bb
        totalPot = totalPot + bb
    }
    
    func dealCards() {
        deck.reset()
        for _ in 0..<5 {
            player.cards.append(deck.draw()!)
        }
        for _ in 0..<5 {
            cpu.cards.append(deck.draw()!)
        }
    }
    
    func showdown() {
        let winner = getWinnerOfTheHand()
        if (winner == nil) {
            player.chipCount += totalPot/2
            cpu.chipCount += totalPot/2
        }
        else {
        winner!.chipCount += totalPot
        }
        reset()
    }

    func getWinnerOfTheHand() -> Player? {
        var playerPheCards = [PheCard]()
        var cpuPheCards = [PheCard]()
        for i in 0..<5 {
            let cardValues = player.cards[i].getCommaSeperatedString().components(separatedBy: ",")
            guard let card = translateUserInputToCardInput(card: cardValues) else {
                print("Invalid Input, please try entering the card details again!")
                continue
            }
            playerPheCards.append(PheCard(card.0, card.1))
        }
        for i in 0..<5 {
            let cardValues = cpu.cards[i].getCommaSeperatedString().components(separatedBy: ",")
            guard let card = translateUserInputToCardInput(card: cardValues) else {
                print("Invalid Input, please try entering the card details again!")
                continue
            }
            cpuPheCards.append(PheCard(card.0, card.1))
        }
        player.phe = PokerHand(playerPheCards)
        cpu.phe = PokerHand(cpuPheCards)
        let playerHandValue = player.phe.getValueCount(player.phe.getHandCardValues()).values.reduce(0) { $0 + $1 }
        let cpuHandValue = cpu.phe.getValueCount(player.phe.getHandCardValues()).values.reduce(0) { $0 + $1 }
        let playerHandRank = player.phe.getHandRank()
        let cpuHandRank = cpu.phe.getHandRank()
        if (playerHandRank.rawValue > cpuHandRank.rawValue) {
            return player
        }
        else if (cpuHandRank.rawValue > playerHandRank.rawValue) {
            return cpu
        }
        else if (playerHandValue > cpuHandValue) {
            return player
        }
        else if (cpuHandValue > playerHandValue) {
            return cpu
        }
        else { return nil }
    }
    
    func changePlayerToAct() {
        if (playerToAct == player) {
            playerToAct = cpu
            playerToActAfter = player
        }
        else {
            playerToAct = player
            playerToActAfter = cpu
        }
    }
    
    func changePlayerOnButton() {
        if (playerOnButton == player) {
            playerOnButton = cpu
            playerUtg = player
            playerToAct = player
            playerToActAfter = cpu
        }
        else {
            playerOnButton = player
            playerUtg = cpu
            playerToAct = cpu
            playerToActAfter = player
        }
    }
    
    func actionMade(action: Action) {
        switch action {
        case .fold:
            gameState = .done
            playerToActAfter.chipCount += totalPot
            reset()
        case .call:
            playerToAct.chipCount -= playerToActAfter.betSize - playerToAct.betSize
            totalPot += playerToActAfter.betSize - playerToAct.betSize
            playerToAct.betSize = playerToActAfter.betSize
        case .raise:
            playerToAct.chipCount -= playerToActAfter.betSize - playerToAct.betSize + bb
            totalPot += playerToActAfter.betSize - playerToAct.betSize + bb
            playerToAct.betSize += playerToActAfter.betSize - playerToAct.betSize + bb
        case .draw:
            if (playerToAct == player) {
                for cardToDrawIndex in playerCardsToDrawIndexes {
                    player.cards[cardToDrawIndex] = deck.draw()!
                }
            }
            else {
                for cardToDrawIndex in cpuCardsToDrawIndexes {
                    cpu.cards[cardToDrawIndex] = deck.draw()!
                }
            }
        default:
            print("🧐")
        }
        if (isGamesStateChanging()) {
            moveToNextGameState()
            if (gameState == .done) {
                showdown()
            }
        }
        else {
            hasSomeoneActed = true
            changePlayerToAct()
        }
    }
    
    func isGamesStateChanging() -> Bool {
        if (!hasSomeoneActed || playerToAct.betSize != playerToActAfter.betSize) {
            return false
        }
        else {
            return true
        }
    }
    
    func moveToNextGameState() {
        switch gameState {
        case .preDraw:
            gameState = .draw
        case .draw:
            gameState = .postDraw
        case .postDraw:
            gameState = .done
        default:
            print("🧐")
        }
        player.betSize = 0
        cpu.betSize = 0
        playerToAct = playerUtg
        playerToActAfter = playerOnButton
        hasSomeoneActed = false
        
    }
    
    func reset() {
        totalPot = 0
        playerUtg.betSize = 0
        playerOnButton.betSize = 0
        gameState = .preDraw
        hasSomeoneActed = false
        player.cards = [Card]()
        cpu.cards = [Card]()
        player.phe = PokerHand()
        cpu.phe = PokerHand()
        
        changePlayerOnButton()
        collectBlinds()
        dealCards()
    }
}