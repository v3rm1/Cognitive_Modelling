//
//  ViewController.swift
//  Poker
//
//  Created by C. Roest on 08/02/2019.
//  Copyright © 2019 C. Roest. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let model = Model()
    
    // Label
    @IBOutlet weak var potLabel: UILabel!
    @IBOutlet weak var cardTwoImage: UIImageView!
    @IBOutlet weak var cardOneImage: UIImageView!
    @IBOutlet weak var boardOneImage: UIImageView!
    @IBOutlet weak var boardTwoImage: UIImageView!
    @IBOutlet weak var boardThreeImage: UIImageView!
    @IBOutlet weak var boardFourImage: UIImageView!
    @IBOutlet weak var boardFiveImage: UIImageView!
    @IBOutlet weak var CpuChips: UILabel!
    @IBOutlet weak var PlayerChips: UILabel!
    @IBOutlet weak var CallLabel: UIButton!
    @IBOutlet weak var StatusLabel: UILabel!
    
    // Actions
    @IBAction func betButton(_ sender: Any) {
        model.progress(action: "raise")
        reloadCards()
        reloadPot()
    }
    @IBAction func callButton(_ sender: Any) {
        model.progress(action: "call")
        reloadCards()
        reloadPot()
    }
    
    @IBAction func foldButton(_ sender: Any) {
        model.progress(action: "fold")
        reloadCards()
        reloadPot()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.dealHoleCards()
        reloadCards()
        reloadPot()
    }
    
    func reloadCards() {
        cardOneImage.image = UIImage(named: model.player.card1!.toPictureName())
        cardTwoImage.image = UIImage(named: model.player.card2!.toPictureName())
        if model.currentState() == GameState.preflop{
            boardOneImage.image = nil
            boardTwoImage.image = nil
            boardThreeImage.image = nil
            boardFourImage.image = nil
            boardFiveImage.image = nil
        }
        if model.currentState() == GameState.flop{
            boardOneImage.image = UIImage(named: model.board[0]!.toPictureName())
            boardTwoImage.image = UIImage(named: model.board[1]!.toPictureName())
            boardThreeImage.image = UIImage(named: model.board[2]!.toPictureName())
        }
        if model.currentState() == GameState.turn{
            boardFourImage.image = UIImage(named: model.board[3]!.toPictureName())
        }
        if model.currentState() == GameState.river{
            boardFiveImage.image = UIImage(named: model.board[4]!.toPictureName())
        }
    }
    
    func reloadPot() {
        potLabel.text = String(model.pot)
        CpuChips.text = String(model.cpu.chips)
        PlayerChips.text = String(model.player.chips)
        if model.curbet == 0 {
            CallLabel.setTitle("Check", for: .normal)
        }else{
            CallLabel.setTitle("Call $20", for: .normal)
        }
        updateStatusLabel()
    }
    
    func updateStatusLabel() {
        var text : String
        if (model.nextToAct() === model.player){
            text = "Player's turn."
        }else{
            text = "CPU's turn."
        }
        StatusLabel.text = text
    }
}

