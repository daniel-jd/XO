//
//  ViewController.swift
//  XO
//
//  Created by Daniel Yamrak on 12.05.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var rowTextField: UITextField!
    @IBOutlet weak var columnTextField: UITextField!
    @IBOutlet var xoButtons: [UIButton]!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    
    var xoItems = [[Int]]() // Поле 3х3 для крестиков-ноликов
    private let emptyCell = 0
    private let xCell = 1
    private let oCell = -1
    var playerName = ""
    let userSymbol = "X"
    let computerSymbol = "0"
    var cellsTaken = 0 // Счётчик занятых ячеек
    var gameIsOver = false // Проверка не закончилась ли игра: победа или нет свободных клеток
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.text = ""
        winLabel.text = ""
        
        // Заполняем поле 3х3 пустыми символами
        for _ in 0...2 {
            var tempArray = [Int]()
            for _ in 0...2 {
                tempArray.append(emptyCell)
            }
            xoItems.append(tempArray)
        }
    }
    
    func displaySymbol(_ column: Int, _ row: Int, symbol: String) {
        let indexOfButton = (xoItems[row].count * column + row)
        xoButtons[indexOfButton].setTitle(symbol, for: .normal)
    }
    
    func setOValue() {
        var column = 0
        var row = 0
        // Проверяем, чтобы нолик установился в незанятую ячейку
        repeat {
            column = Int.random(in: 0...2)
            row = Int.random(in: 0...2)
        } while !(xoItems[column][row] == emptyCell)
        
        xoItems[column][row] = oCell
        displaySymbol(column, row, symbol: computerSymbol)
        cellsTaken += 1
        print(xoItems)
        checkGameStatus()
    }
    
    func setXValue() {
        if var row = Int(rowTextField.text!),
           var column = Int(columnTextField.text!) {
            row -= 1
            column -= 1
            if xoItems[row][column] == emptyCell {
                xoItems[row][column] = xCell
                rowTextField.text = ""
                columnTextField.text = ""
                
                displaySymbol(row, column, symbol: userSymbol)
                cellsTaken += 1
            } else {
                infoLabel.text = "This coodinate is taken"
            }
        } else {
            infoLabel.text = "Column or row is not correct"
        }
    }
    
    func checkWin() -> Bool {
        var isWin = false
        let winSum = 3
        var sum = 0
        
        func winnerIs() -> String {
            if sum < 0 {
                return "Computer"
            } else {
                return "Player"
            }
        }
        // Проверка сумм рядов
        for i in 0..<xoItems.count {
            sum = 0
            for j in 0..<xoItems.count {
                sum += xoItems[i][j]
            }
            if abs(sum) == winSum {
                playerName = winnerIs()
                isWin = true
            }
        }

        // Проверка сумм столбцов
        for j in 0..<xoItems.count {
            sum = 0
            for i in 0..<xoItems.count {
                sum += xoItems[i][j]
            }
            if abs(sum) == winSum {
                playerName = winnerIs()
                isWin = true
            }
        }
        
        // Проверка сумм диагоналей
        sum = 0
        for i in 0..<xoItems.count {
            for j in 0..<xoItems.count {
                if i == j {
                    sum += xoItems[i][j]
                }
            }
            if abs(sum) == winSum {
                playerName = winnerIs()
                isWin = true
            }
        }
        
        sum = 0
        for i in 0..<xoItems.count {
            for j in 0..<xoItems.count {
                if i == (xoItems.count - 1 - j) {
                    sum += xoItems[i][j]
                }
            }
            if abs(sum) == winSum {
                playerName = winnerIs()
                isWin = true
            }
        }
        
        return isWin
    }
    
    // Проверка статуса игры: победа или конец игры
    func checkGameStatus() {
        if cellsTaken > 4 && checkWin() {
            winLabel.text = "\(playerName) WIN!"
            gameIsOver = true
        }
        // Проверка на наличие свободных клеток для хода
        if !gameIsOver && cellsTaken == 9 {
            infoLabel.text = "No more free cells"
            winLabel.text = "GAME OVER"
            gameIsOver = true
        }
    }
    
    @IBAction func setValueDidTapped(_ sender: Any) {
        infoLabel.text = ""
        setXValue()
        checkGameStatus()
        if !gameIsOver {
            setOValue()
        }
    }
    
}

