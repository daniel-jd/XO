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
    
    let xo = GameLogic()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xo.delegate = self
        infoLabel.text = ""
        winLabel.text = ""
        
        xo.createField()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //infoLabel.text = NSLocalizedString("info", comment: "")
    }
    
    @IBAction func setValueDidTap(_ sender: Any) {
        infoLabel.text = ""
//        xo.setXValue()
        xo.checkGameStatus()
        if !xo.gameIsOver {
            xo.setOValue()
        }
    }

    @IBAction func fieldButtonDidTap(_ sender: UIButton) {
        xo.setXValue(sender.tag)
        xo.checkGameStatus()
        if !xo.gameIsOver {
            xo.setOValue()
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
