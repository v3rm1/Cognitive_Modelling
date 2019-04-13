//
//  Classes.swift
//  Five-card-draw
//
//  Created by Andris on 15/03/2019.
//  Copyright © 2019 Andris. All rights reserved.
//

import Foundation

var model = Poker()
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
    
    func sortHand() -> [String]{
        var sortedCards: [String] = []
        for card in self.cards {
            sortedCards.append(card.getRankName())
        }
        print("Sorted cards: ", self.name, sortedCards.sorted())
        return sortedCards.sorted()
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
    var playerAction = false
    var playerToAct : Player
    var playerToActAfter : Player
    var playerUtg : Player // Player to act first
    var playerOnButton : Player // Player to act second
    var playerCardsToDrawIndexes = [Int]()
    var cpuCardsToDrawIndexes = [Int]()
    var tableCardCount = Int()
    var waitingForWinAnimation = false
    var winnername = "Player"
    var winninghandname = ""
    
    init () {
        players.append(cpu)
        model.loadModel(fileName: "poker2")
        model.loadedModel = "poker2"
//        model.run()
        players.append(player)
        self.tableCardCount = 0
        self.playerUtg = cpu
        self.playerOnButton = player
        self.playerToAct = self.playerOnButton
        self.playerToActAfter = self.playerUtg
        consoleLogPlayer()
//        let randomVal = Int.random(in: 0..<2)
//        self.playerUtg = players[randomVal]
//        self.playerOnButton = players[(randomVal+1) % 2]
//        self.playerToAct = self.playerUtg
//        self.playerToActAfter = self.playerOnButton
    }
    
    func consoleLogPlayer() {
        print("Player To Act: ", playerToAct.name)
        print("Player on Button: ", playerOnButton.name)

        print("/nPlayer To Act After: ", playerToActAfter.name)
        print("Player Utg: ", playerUtg.name)
        
        print("/nPLAYER STATS")
        print("Player tokens: ", player.chipCount)
        print("Player bet: ", player.betSize)
        print("CPU bet: ", cpu.betSize)
        print("CPU tokens: ", cpu.chipCount)
        print("Total Pot: ", totalPot)
        print("/nPOOL VALUE: ", player.chipCount + cpu.chipCount + totalPot)

        print("GAME STATE: ", gameState)

    }
    
    func collectBlinds() {
        playerUtg.betSize = sb
        playerUtg.chipCount = playerUtg.chipCount - sb
        totalPot = totalPot + sb
        
        playerOnButton.betSize = bb
        playerOnButton.chipCount = playerOnButton.chipCount - bb
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
    
    func modelAction() {
        model.run()
        print("modelAction run")
        consoleLogPlayer()
        if !(playerToAct == cpu){
            return 
        }
        if (gameState == GameState.preDraw || gameState == GameState.postDraw){
            let handComparer = HandComparer()
            let hr = handComparer.getHandRank(h: cpu.cards)
//            let betpercentage = Double(hr.rawValue) * 0.1
//            let callpercentage = (1.00 - betpercentage) * 0.80
//            let foldpercentage = 1 - (betpercentage + callpercentage)
//            let rnd = Double.random(in:0.0..<1.0)
            if (model.loadedModel != nil && model.loadedModel == "poker2") &&
                model.actionChunk() {
                print("Passing winning scores to model")
                model.modifyLastAction(slot: "winning_scoresA", value: String(hr.rawValue))
                model.time += 1.0
                model.run()
            }
            print("\nPassed winning scores to model.")
            print("Last cpu action: ", model.lastAction(slot: "cpu") as Any)

            if (model.loadedModel != nil && model.loadedModel == "poker2") &&
                model.actionChunk() {
                switch (model.lastAction(slot: "cpu")!) {
                case ("raise"):
                    if (handEvaluator(cpu.sortHand(), tableCardCount) > 0.5 * maxHandScore(cpu.sortHand(), tableCardCount)) {
                        print("MODEL RAISED: ", playerToAct.betSize)
                        actionMade(action: Action.raise)
                        playerOnButton = player
                        playerUtg = cpu
                        changePlayerToAct()
                    }
                    else
                        {
                            print("MODEL CALLED: ", playerToAct.betSize)
                            actionMade(action: Action.call)
                            playerOnButton = player
                            playerUtg = cpu
                            changePlayerToAct()
                        }

                case ("call"):
                    print("MODEL CALLED: ", playerToAct.betSize)
                    actionMade(action: Action.call)
                    playerOnButton = player
                    playerUtg = cpu
                    changePlayerToAct()

                case ("fold"):
                    print("MODEL FOLDED")
                    print("Total Pot: ", totalPot)
                    actionMade(action: Action.fold)
                default:  actionMade(action: Action.call)
                }
                model.time += 2.0
                model.run()
                print("END: modelAction")
                consoleLogPlayer()
            }
            print("playerAction: ", playerAction)
        }
        else if (gameState == GameState.draw) {
            var idxs :[Int] = []
            for x in 0...4 {
                let rnd = Double.random(in:0.0..<1.0)
                if (rnd <= 0.33) {
                    idxs.append(x)
                }
            }
            cpuCardsToDrawIndexes = idxs
            actionMade(action: Action.draw)
            return
//            }
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
        // Inject win animation
        self.winnername = winner!.name
        self.winninghandname = "With " + HandComparer().getHandRank(h: winner!.cards).description
        self.waitingForWinAnimation = true
        //reset()
    }

    func getWinnerOfTheHand() -> Player? {
        let x = HandComparer()
        
        switch x.compare(h1: player.cards, h2: cpu.cards){
        case 1:
            return player
        case -1:
            return cpu
        default:
            return nil
        }
    }
    
    func changePlayerToAct() {
        if (playerToAct == player) {
            playerToAct = cpu
            playerToActAfter = player
            playerOnButton = playerToAct
            playerUtg = playerToActAfter
            print("Change player to act: init player=player")
            consoleLogPlayer()
        }
        else if (playerToAct == cpu) {
            playerToAct = player
            playerToActAfter = cpu
            playerOnButton = playerToAct
            playerUtg = playerToActAfter
            print("Change player to act: init player=cpu")
            consoleLogPlayer()
        }
    }
    
    func changePlayerOnButton() {
        if (playerOnButton == cpu && playerToAct == cpu){
            print("Change player on button: init player=cpu")
            consoleLogPlayer()
            modelAction()
            playerOnButton = player
            playerUtg = cpu
            playerAction = true
        }
        else if (playerOnButton == player && playerToAct == player) {
            print("Change player on button: init player=player")
            consoleLogPlayer()
            playerOnButton = cpu
            playerUtg = player
        }
    }
    
    func actionMade(action: Action) {
        switch action {
        case .fold:
            self.winnername = playerToActAfter.name
            self.winninghandname = playerToAct.name + " folded"
            self.waitingForWinAnimation = true
            gameState = .done
            playerToActAfter.chipCount += totalPot
            totalPot = 0
            consoleLogPlayer()
        case .call:
            playerToAct.chipCount -= playerToActAfter.betSize - playerToAct.betSize
            totalPot += playerToActAfter.betSize - playerToAct.betSize
            playerToAct.betSize = playerToActAfter.betSize
            print("ActionMade Call")
            consoleLogPlayer()
        case .raise:
            playerToAct.chipCount -= playerToActAfter.betSize - playerToAct.betSize + bb
            totalPot += playerToActAfter.betSize - playerToAct.betSize + bb
            playerToAct.betSize += playerToActAfter.betSize - playerToAct.betSize + bb
            print("ActionMade Raise")
            consoleLogPlayer()

        case .draw:
            if (playerToAct == player) {
                for cardToDrawIndex in playerCardsToDrawIndexes {
                    player.cards[cardToDrawIndex] = deck.draw()!
                    tableCardCount = tableCardCount + 1
                    consoleLogPlayer()
                }
            }
            else if (playerToAct == cpu) {
                for cardToDrawIndex in cpuCardsToDrawIndexes {
                    cpu.cards[cardToDrawIndex] = deck.draw()!
                    tableCardCount = tableCardCount + 1
                    consoleLogPlayer()
                }
            }
        default:
            print("🧐")
        }
        
        if (playerToAct == cpu) {
            playerAction = false
        }
        else if (playerToAct == player){
            playerAction = true
        }
        else if (isGamesStateChanging()) {
            moveToNextGameState()
            if (gameState == .done) {
                showdown()
            }
            else if (gameState == GameState.draw && playerToAct == player) {
                actionMade(action: Action.draw)
                print("Game state draw")
                consoleLogPlayer()
            }
            else if (gameState == GameState.draw && playerToAct == cpu) {
                actionMade(action: Action.draw)
                print("Game state draw")
                consoleLogPlayer()
            }
        }

    }
    
    func isGamesStateChanging() -> Bool {
        print("PLAYER TO ACT BET: ", playerToAct.betSize)
        print("PLAYER TO ACT AFTER BET: ", playerToActAfter.betSize)
        if (!playerAction || playerToAct.betSize != playerToActAfter.betSize) {
            return true
        }
        else {
            return false
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
        consoleLogPlayer()
        playerToAct = playerOnButton
        playerToActAfter = playerUtg
        playerAction = true
        if (gameState == .done) {
            showdown()
        }
    }
    
    func reset() {
        totalPot = 0
        playerUtg.betSize = 0
        playerOnButton.betSize = 0
        gameState = .preDraw
        playerAction = false
        player.cards = [Card]()
        cpu.cards = [Card]()
        player.phe = PokerHand()
        cpu.phe = PokerHand()
        cpuCardsToDrawIndexes = []
        playerCardsToDrawIndexes = []
        playerToAct = player
        print("Init player values")
        consoleLogPlayer()
        collectBlinds()
        dealCards()
    }
}

