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

    // Vars
    let hand = Hand()
    let BET_SIZE = 20
    let PLAYER_NAME = "Player"
    let CPU_NAME = "CPU"
    // Controls
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
    @IBAction func btnFold_Clicked(_ sender: Any) {
        hand.actionMade(action: .fold)
        refreshControls()    }
    @IBAction func btnCheckCall_Clicked(_ sender: Any) {
        hand.actionMade(action: .call)
        refreshControls()
    }
    @IBAction func btnRaise_Clicked(_ sender: Any) {
        hand.actionMade(action: .raise)
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
            for i in 0..<cpuCards.count {
                cpuCards[i].layer.borderWidth = 0
            }
        }
        refreshControls()
    }
    @IBAction func cpuCardTouched(_ sender: UIButton) {
        if (hand.gameState == .draw && hand.playerToAct == hand.cpu) {
            addRemoveBorder(sender)
            for i in 0..<cpuCards.count {
                if (sender == cpuCards[i]) {
                    if (!hand.cpuCardsToDrawIndexes.contains(i)) {
                        hand.cpuCardsToDrawIndexes.append(i)
                    }
                    else {
                        hand.cpuCardsToDrawIndexes.remove(at: hand.cpuCardsToDrawIndexes.firstIndex(of: i)!)
                    }
                }
            }
        }
    }
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
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hand.reset()
        refreshControls()
    }
    
    func addRemoveBorder(_ button: UIButton) {
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.cornerRadius = 4
        button.layer.borderWidth = button.layer.borderWidth > 0 ? 0 : 2
    }
    
    func displayCards() {
        for i in 0..<5 {
        cpuCards[i].setBackgroundImage(UIImage(named: hand.cpu.cards[i].toPictureName()), for: .normal)
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
    
    func refreshControls() {
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
