//
//  ViewController.swift
//  XO
//
//  Created by Daniel Yamrak on 12.05.2021.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var xoButtons: [UIButton]!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var restartLabel: UILabel!
    
    private let xo = GameLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xo.delegate = self
        infoLabel.text = ""
        winLabel.text = ""
        
        xo.createField()
        
    }

    @IBAction func fieldButtonDidTap(_ sender: UIButton) {
        if xo.setXValue(sender.tag) {
            xo.checkGameStatus()
            if !xo.gameIsOver {
                xo.setOValue()
            }
        }
    }

    @IBAction func restartButtonDidTap(_ sender: Any) {
        for btn in xoButtons {
            btn.setBackgroundImage(.none, for: .normal)
        }
        infoLabel.text = ""
        winLabel.text = ""
        xo.restartGame()
    }

}

// MARK: - Extension GameDelegate

extension GameViewController: GameDelegate {
    func displaySymbol(index: Int, symbol: UIImage) {
        xoButtons[index].setBackgroundImage(symbol, for: .normal)
    }
}
