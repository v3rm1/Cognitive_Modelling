//
//  main.swift
//  PokerHandEvaluator
//
//  Created by German Om on 2/9/17.
//  Copyright © 2017 German Om. All rights reserved.
//
import Foundation

enum PokerSuit: String {
    case hearts
    case diamonds
    case clubs
    case spades
}

enum PokerValue: Int, Comparable{
    case ace = 1
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
    case jack
    case queen
    case king
    
    //MARK: From Comparable
    public static func < (a: PokerValue, b: PokerValue) -> Bool {
        return a.rawValue < b.rawValue
    }
    
    public static func > (a: PokerValue, b: PokerValue) -> Bool {
        return a.rawValue > b.rawValue
    }
}

struct PheCard: Equatable{
    let value: PokerValue
    let suit: PokerSuit
    init(_ value: PokerValue, _ suit: PokerSuit) {
        self.value = value
        self.suit = suit
    }
    
    //MARK: From Equatable
    public static func ==(lhs: PheCard, rhs: PheCard) -> Bool {
        return (lhs.value == rhs.value) && (lhs.suit == rhs.suit)
    }
}

enum PokerHandRank: Int{
    case highCard = 1
    case onePair
    case twoPairs
    case threeOfAKind
    case straight
    case flush
    case fullHouse
    case fourOfAKind
    case straightFlush
    case royalFlush
}

enum PokerHandError: Error {
    case InvalidPokerHand
}

struct PokerHand {
    let card1: PheCard
    let card2: PheCard
    let card3: PheCard
    let card4: PheCard
    let card5: PheCard
    let hand: [PheCard]
    //    let handSuitCounter: [PokerSuit:Int]
    //    let handValueCounter: [PokerValue:Int]
    
    init() {
        self.card1 = PheCard(.two, .hearts)
        self.card2 = PheCard(.two, .hearts)
        self.card3 = PheCard(.two, .hearts)
        self.card4 = PheCard(.two, .hearts)
        self.card5 = PheCard(.two, .hearts)
        self.hand = [card1, card2, card3, card4, card5]
    }
    
    init (_ cards: [PheCard])  {
        self.card1 = cards[0]
        self.card2 = cards[1]
        self.card3 = cards[2]
        self.card4 = cards[3]
        self.card5 = cards[4]
        self.hand = [card1, card2, card3, card4, card5]
        //        if isHandValid() == false {
        //            throw PokerHandError.InvalidPokerHand
        //        }
    }
    
    func isHandValid() -> Bool {
        for i in 0...hand.count - 2 {
            for j in i+1...hand.count - 1 {
                if hand[i] == hand[j] {
                    return false
                }
            }
        }
        return true
    }
    
    func getHandCardValues() -> [PokerValue] {
        var cardValues: [PokerValue] = []
        for card in 0...hand.count - 1 {
            cardValues.append(hand[card].value)
        }
        return cardValues
    }
    
    func getHandCardSuits() -> [PokerSuit] {
        var cardSuits: [PokerSuit] = []
        for card in 0...hand.count - 1 {
            cardSuits.append(hand[card].suit)
        }
        return cardSuits
    }
    
    func getValueCount(_ cardValues: [PokerValue]) -> [PokerValue: Int] {
        var counter: [PokerValue: Int] = [:]
        for value in cardValues {
            guard let count = counter[value] else {
                counter[value] = 1
                continue
            }
            counter[value] = count + 1
        }
        return counter
    }
    
    func getSuitCount(_ cardSuits: [PokerSuit]) -> [PokerSuit: Int] {
        var counter: [PokerSuit: Int] = [:]
        for suit in cardSuits {
            guard let count = counter[suit] else {
                counter[suit] = 1
                continue
            }
            counter[suit] = count + 1
        }
        return counter
    }
    
    //    func isStraight() -> Bool {
    //        //if
    //    }
    func hasThreeOfAKind(_ handValueCounter: [PokerValue: Int]) -> Bool {
        var hasThreeOfAKind = false
        for key in handValueCounter.keys {
            print (key)
            if handValueCounter[key] == 3 {
                hasThreeOfAKind = true
            }
        }
        return hasThreeOfAKind
    }
    
    func hasPair(_ handValueCounter: [PokerValue: Int]) -> Bool {
        var hasPair = false
        for key in handValueCounter.keys {
            if handValueCounter[key] == 2 {
                hasPair = true
            }
        }
        return hasPair
    }
    
    func hasTwoPairs(_ handValueCounter: [PokerValue: Int]) -> Bool {
        var hasTwoPairs = false
        var foundFirstPair = false
        for key in handValueCounter.keys {
            if handValueCounter[key] == 2 && foundFirstPair == false {
                foundFirstPair = true
            } else if handValueCounter[key] == 2 {
                hasTwoPairs = true
            }
        }
        return hasTwoPairs
    }
    
    func isFlush(_ handSuitCounter: [PokerSuit: Int]) -> Bool {
        var isFlush = false
        if handSuitCounter.count == 1 {
            isFlush = true
        }
        return isFlush
    }
    
    func isStraight(_ handValues: [PokerValue]) -> Bool {
        var isStraight = false
        var sortedValues = handValues.sorted()
        if sortedValues[4].rawValue - sortedValues[0].rawValue == 4 || sortedValues[0].rawValue == 1 && sortedValues[4].rawValue - sortedValues[1].rawValue == 3 {
            isStraight = true
        }
        return isStraight
    }
    
    func isRoyal(_ handValues: [PokerValue]) -> Bool {
        var isRoyal = false
        var sortedValues = handValues.sorted()
        if sortedValues[0].rawValue == 1 && sortedValues[4].rawValue - sortedValues[1].rawValue == 3 && sortedValues[4].rawValue == 13 {
            isRoyal = true
        }
        return isRoyal
    }
    
    func getHandRank() -> PokerHandRank {
        let handSuits = getHandCardSuits()
        let handValues = getHandCardValues()
        let handSuitCounter = getSuitCount(handSuits)
        let handValueCounter = getValueCount(handValues)
        var handRank = PokerHandRank.highCard
        let isHandStraight = isStraight(handValues)
        
        if handValueCounter.count == 2 {
            if hasThreeOfAKind(handValueCounter) && hasPair(handValueCounter) {
                handRank = PokerHandRank.fullHouse          //FULL HOUSE
            } else {
                handRank = PokerHandRank.fourOfAKind        //FOUR OF A KIND
            }
        }
        else if handValueCounter.count == 3 {
            if hasThreeOfAKind(handValueCounter) {
                handRank = PokerHandRank.threeOfAKind       //THREE OF A KIND
            }
            else if hasTwoPairs(handValueCounter) {
                handRank = PokerHandRank.twoPairs           //TWO PAIR
            }
        }
        else if handValueCounter.count == 4 {
            handRank = PokerHandRank.onePair                //ONE PAIR
        }
        else if isFlush(handSuitCounter) {
            if isHandStraight && isRoyal(handValues) {      //ROYAL FLUSH
                handRank = PokerHandRank.royalFlush
            }
            else if isHandStraight{                         //STRAIGHT FLUSH
                handRank = PokerHandRank.straightFlush
            }
            else {                                          //FLUSH
                handRank = PokerHandRank.flush
            }
        }
        else if isHandStraight{                             //STRAIGHT
            handRank = PokerHandRank.straight
        }
        else {
            handRank = PokerHandRank.highCard               //HIGH CARD
        }
        return handRank
    }
    
    func compare(other: PokerHand) -> Int {
        // Get the hand ranks so we don't have to calculate them again
        let ownRank     = self.getHandRank().rawValue
        let otherRank   = other.getHandRank().rawValue
        let ownHand     = self.getHandCardValues().sorted()
        let otherHand   = other.getHandCardValues().sorted()
        let ownCounts   = self.getValueCount(self.getHandCardValues())
        let otherCounts = other.getValueCount(other.getHandCardValues())
        
        // If the hands are of the same rank, we do not have to check further
        if (ownRank != otherRank){
            return ownRank > otherRank ? 1 : -1
        }
        
        return 0;
    }
}

let userInputValueTranslator: [String: PokerValue] = [
    "A": PokerValue.ace,
    "K": PokerValue.king,
    "Q": PokerValue.queen,
    "J": PokerValue.jack,
    "10": PokerValue.ten,
    "9": PokerValue.nine,
    "8": PokerValue.eight,
    "7": PokerValue.seven,
    "6": PokerValue.six,
    "5": PokerValue.five,
    "4": PokerValue.four,
    "3": PokerValue.three,
    "2": PokerValue.two
]

let userInputSuitTranslator: [String: PokerSuit] = [
    "H": PokerSuit.hearts,
    "D": PokerSuit.diamonds,
    "C": PokerSuit.clubs,
    "S": PokerSuit.spades
]

func translateUserInputToCardInput(card: [String?]) -> (PokerValue, PokerSuit)? {
    if card.count != 2 {
        return nil
    }
    guard let value = card[0], let suit = card[1] else {
        return nil
    }
    guard let validValue = userInputValueTranslator[value], let validSuit = userInputSuitTranslator[suit] else {
        return nil
    }
    return (validValue, validSuit)
    
}

func isNewCardValid(_ newCard: PheCard, cardsSoFar: [PheCard]) -> Bool {
    var newCardValid = true
    for card in cardsSoFar {
        if newCard == card {
            newCardValid = false
            break
        }
    }
    return newCardValid
}

func main () {
    var validInput = false
    var userPokerHand: [PheCard] = []
    
    while validInput != true {
        // ask for poker hand
        print ("\n<<< WELCOME TO THE POKER HAND EVALUATOR!>>>\n")
        print ("Please enter your poker hand following the following format:")
        print ("Valid value: A, K, Q, J, 10, 9, 8, 7, 6, 5, 4, 3, 2")
        print ("Valid suits: H, D, S, C")
        print ("FORMAT: value,suit")
        print ("EXAMPLE: 'A,H' (for Ace of Hearts), or '10,D' (for 10 of Diamonds)")
        while userPokerHand.count < 5 {
            print (">> Please enter card \(userPokerHand.count + 1):")
            let userInput: String = readLine()!
            let userInputArr = userInput.components(separatedBy: ",")
            guard let card = translateUserInputToCardInput(card: userInputArr) else {
                print("Invalid Input, please try entering the card details again!")
                continue
            }
            let newCard = PheCard(card.0, card.1)
            if isNewCardValid(newCard, cardsSoFar: userPokerHand) != true {
                print ("Cannot add a duplicate card to the hand. Please try to enter another card.\n")
                continue
            }
            print ("Successful card addition to the Hand!")
            userPokerHand.append(newCard)
            
            // print cards in your hand so far...
            print ("Your hand consists of the following cards so far:")
            for card_num in 0...userPokerHand.count - 1{
                print ("Card #\(card_num + 1): \(userPokerHand[card_num].value) of \(userPokerHand[card_num].suit)")
            }
            print ("")
        }
        let pokerHand = PokerHand(userPokerHand)
        if pokerHand.isHandValid() != true {
            print ("Poker Hand is Invalid!")
            continue
        }
        validInput = true
        print ("You have a: \(pokerHand.getHandRank())\n")
    }
}
