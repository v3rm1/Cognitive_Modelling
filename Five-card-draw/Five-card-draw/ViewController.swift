//
//  ViewController.swift
//  Five-card-draw
//
//  Created by Andris on 01/03/2019.
//  Copyright © 2019 Andris. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    var model: Poker?
    var timer: Timer? = nil
    // Vars
    let hand = Hand()
    let BET_SIZE = 20
    let PLAYER_NAME = "Player"
    let CPU_NAME = "CPU"
    // Controls
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var winLabel2: UILabel!
    @IBOutlet weak var cpuCard1: UIButton!
    @IBOutlet weak var cpuCard2: UIButton!
    @IBOutlet weak var cpuCard3: UIButton!
    @IBOutlet weak var cpuCard4: UIButton!
    @IBOutlet weak var cpuCard5: UIButton!
    @IBOutlet var cpuCards: [UIButton]!
    @IBOutlet weak var playerCard1: UIButton!
    @IBOutlet weak var playerCard2: UIButton!
    @IBOutlet weak var playerCard3: UIButton!
    @IBOutlet weak var playerCard4: UIButton!
    @IBOutlet weak var playerCard5: UIButton!
    @IBOutlet var playerCards: [UIButton]!
    @IBOutlet weak var cpuChipCount: UILabel!
    @IBOutlet weak var playerChipCount: UILabel!
    @IBOutlet weak var totalPot: UILabel!
    @IBOutlet weak var btnFold: UIButton!
    @IBOutlet weak var btnCheckCall: UIButton!
    @IBOutlet weak var btnRaise: UIButton!
    @IBOutlet weak var btnDraw: UIButton!
    @IBOutlet weak var cpuBetSize: UILabel!
    @IBOutlet weak var playerBetSize: UILabel!
    @IBOutlet weak var cpuChipsIcon: UIImageView!
    @IBOutlet weak var playerChipsIcon: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var cpuView: UIView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var cpuChipImage: UIImageView!
    @IBOutlet weak var playerChipImage: UIImageView!
    @IBOutlet weak var potChipImage: UIImageView!
    
    // UI Actions
    @IBAction func btnFold_Clicked(_ sender: Any) {
        hand.actionMade(action: .fold)
        hand.changePlayerToAct()
        hand.changePlayerOnButton()
        refreshControls()
    }
    
    @IBAction func btnCheckCall_Clicked(_ sender: Any) {
        hand.actionMade(action: .call)
        hand.changePlayerToAct()
        hand.changePlayerOnButton()
        hand.moveToNextGameState()
        refreshControls()
    }
    
    @IBAction func btnRaise_Clicked(_ sender: Any) {
        hand.actionMade(action: .raise)
        hand.changePlayerToAct()
        hand.changePlayerOnButton()
        hand.moveToNextGameState()
        refreshControls()
    }
    
    @IBAction func btnDraw_Clicked(_ sender: UIButton) {
        hand.actionMade(action: .draw)
        if (hand.playerToActAfter == hand.player) {
            for i in 0..<playerCards.count {
                playerCards[i].layer.borderWidth = 0
            }
        }
        else {
            print("CPU CARD COUNT: ", cpuCards.count)
            for i in 0..<cpuCards.count {
                cpuCards[i].layer.borderWidth = 0
            }
        }
        hand.moveToNextGameState()
        refreshControls()
//        hand.moveToNextGameState()
    }
//    @IBAction func cpuCardTouched(_ sender: UIButton) {
//        if (hand.gameState == .draw && hand.playerToAct == hand.cpu) {
//            addRemoveBorder(sender)
//            for i in 0..<cpuCards.count {
//                if (sender == cpuCards[i]) {
//                    if (!hand.cpuCardsToDrawIndexes.contains(i)) {
//                        hand.cpuCardsToDrawIndexes.append(i)
//                    }
//                    else {
//                        hand.cpuCardsToDrawIndexes.remove(at: hand.cpuCardsToDrawIndexes.firstIndex(of: i)!)
//                    }
//                }
//            }
//        }
//    }
    @IBAction func playerCardTouched(_ sender: UIButton) {
        if (hand.gameState == .draw && hand.playerToAct == hand.player) {
            addRemoveBorder(sender)
            for i in 0..<playerCards.count {
                if (sender == playerCards[i]) {
                    if (!hand.playerCardsToDrawIndexes.contains(i)) {
                        hand.playerCardsToDrawIndexes.append(i)
                    }
                    else {
                        hand.playerCardsToDrawIndexes.remove(at: hand.playerCardsToDrawIndexes.firstIndex(of: i)!)
                    }
                }
            }
            addRemoveBorder(sender)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        model?.loadModel(fileName: "poker2")
        model?.loadedModel = "poker2"
        model?.reset()
        print("Setting listener for Action")
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.receiveAction), name: NSNotification.Name(rawValue: "Action"), object: nil)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        hand.reset()
        refreshControls()
    }
    
    @objc func receiveAction() {
        print("Awaiting Player action")
        
    }
    
    func addRemoveBorder(_ button: UIButton) {
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.cornerRadius = 4
        button.layer.borderWidth = button.layer.borderWidth > 0 ? 0 : 2
    }
    
    func displayCards() {
        for i in 0..<5 {
        cpuCards[i].setBackgroundImage(UIImage(named: "yellow_back"), for: .normal)
            cpuCards[i].setTitle("", for: .normal)
        }
        for i in 0..<5 {
        playerCards[i].setBackgroundImage(UIImage(named: hand.player.cards[i].toPictureName()), for: .normal)
            playerCards[i].setTitle("", for: .normal)
        }
    }
    
    func changeCardButtonState() {
        let currButtonState = playerCard1.isEnabled
        playerCard1.isEnabled = !currButtonState
        playerCard2.isEnabled = !currButtonState
        playerCard3.isEnabled = !currButtonState
        playerCard4.isEnabled = !currButtonState
        playerCard5.isEnabled = !currButtonState
        cpuCard1.isEnabled = !currButtonState
        cpuCard2.isEnabled = !currButtonState
        cpuCard3.isEnabled = !currButtonState
        cpuCard4.isEnabled = !currButtonState
        cpuCard5.isEnabled = !currButtonState
    }
    
    func winAnimation (playerName: String, amount: String, handName: String) {
        btnFold.isEnabled = false
        btnCheckCall.isEnabled = false
        btnRaise.isEnabled = false
        btnDraw.isEnabled = false
        print("PLAYER WINS AMOUNT: ", amount)
        self.winLabel.text = playerName + " wins $" + String(amount)
        self.winLabel2.text = handName
        UIView.animate(withDuration: 0.25, delay: 0.2,
                       options: [ .curveEaseOut],
                       animations: {
                        self.winLabel.center.x = self.view.center.x
                        self.winLabel2.center.x = self.view.center.x
                        if (playerName == "CPU") {
                            self.potChipImage.center.x = self.cpuChipImage.center.x
                            self.potChipImage.center.y = -208
                        }else{
                                self.potChipImage.center.x = self.playerChipImage.center.x
                                self.potChipImage.center.y = 213 // Perfect on top = 218
                        }
        },
                       completion: revWinAnimation)
    }
    
    func revWinAnimation (b: Bool) {
        UIView.animate(withDuration: 0.5, delay: 1.5,
                       options: [ .curveEaseIn],
                       animations: {
                        self.winLabel.center.x -= self.view.bounds.width
                        self.winLabel2.center.x -= self.view.bounds.width
        },
                       completion: finishAnimation)
    }
    
    func finishAnimation (b : Bool){
        hand.waitingForWinAnimation = false
        hand.reset()
        btnFold.isEnabled = true
        btnCheckCall.isEnabled = true
        btnRaise.isEnabled = true
        btnDraw.isEnabled = true
        refreshControls()
        self.potChipImage.center.x = 290
        self.potChipImage.center.y = 55
    }
    
    func refreshControls() {
        if (hand.waitingForWinAnimation) {
            winAnimation(playerName: hand.winnername, amount: totalPot!.text!, handName: hand.winninghandname)
            return
        }
        
        playerBetSize.text = String(hand.player.betSize)
        playerChipCount.text = String(hand.player.chipCount)
        cpuBetSize.text = String(hand.cpu.betSize)
        cpuChipCount.text = String(hand.cpu.chipCount)
        totalPot.text = String(hand.totalPot)
        status.text = hand.playerToAct.name + "'s turn"
        
        // Show/Hide bet chip icon
        if (hand.player.betSize > 0) {
            playerChipsIcon.isHidden = false
            playerBetSize.isHidden = false
        }
        else {
            playerChipsIcon.isHidden = true
            playerBetSize.isHidden = true
        }
        if (hand.cpu.betSize > 0) {
            cpuChipsIcon.isHidden = false
            cpuBetSize.isHidden = false
        }
        else {
            cpuChipsIcon.isHidden = true
            cpuBetSize.isHidden = true
        }
        // Update buttons on bottom
        if (hand.gameState != .draw) {
        // Update check/call & raise buttons
            if (hand.playerToAct.betSize < hand.playerToActAfter.betSize) {
                btnCheckCall.setTitle("Call \(hand.playerToActAfter.betSize - hand.playerToAct.betSize)$", for: .normal)
                btnRaise.setTitle("Raise \(hand.playerToActAfter.betSize + BET_SIZE)$", for: .normal)
            }
            if (hand.playerToAct.betSize == hand.playerToActAfter.betSize) {
                btnCheckCall.setTitle("Check", for: .normal)
                btnRaise.setTitle("Bet \(BET_SIZE)$", for: .normal)
            }
            btnDraw.isHidden = true
        }
        else {
            btnDraw.isHidden = false
        }
        displayCards()
        
        // Highlight player to act
        if (hand.playerToAct.name == PLAYER_NAME) {
            playerView.layer.borderColor = UIColor(red:1.00, green:0.95, blue:0.48, alpha:1.0).cgColor
            playerView.layer.borderWidth = 2
            playerView.layer.cornerRadius = 4
            cpuView.layer.borderWidth = 0
        }
        else {
            cpuView.layer.borderColor = UIColor(red:1.00, green:0.95, blue:0.48, alpha:1.0).cgColor
            cpuView.layer.borderWidth = 2
            cpuView.layer.cornerRadius = 4
            playerView.layer.borderWidth = 0
        }
    }
}

