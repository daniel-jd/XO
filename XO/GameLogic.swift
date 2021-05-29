//
//  GameLogic.swift
//  XO
//
//  Created by Daniel Yamrak on 29.05.2021.
//

import UIKit

protocol GameDelegate: class {
    func displaySymbol(index: Int, symbol: UIImage)
    var rowTextField: UITextField! { get set }
    var columnTextField: UITextField! { get set }
    var infoLabel: UILabel! { get set }
    var winLabel: UILabel! { get set }
}

class GameLogic {
    
//    static let shared = GameLogic()
//    private init() { }
    
    weak var delegate: GameDelegate?
    private(set) var field = [[Int]]() // Поле для крестиков-ноликов
    private let emptyCell = 0
    private let xCell = 1
    private let oCell = -1
    private var playerName = ""
    private let userSymbol = #imageLiteral(resourceName: "X")
    private let computerSymbol = #imageLiteral(resourceName: "O")
    private var cellsTaken = 0 // Счётчик занятых ячеек
    private(set) var gameIsOver = false // Проверка не закончилась ли игра: победа или нет свободных клеток
    
    // Methods
    
    func startGame() {
        gameIsOver = false
        cellsTaken = 0
        createField()
    }
    
    func restartGame() {
        gameIsOver = false
        cellsTaken = 0
        for i in 0...2 {
            for j in 0...2 {
                field[i][j] = emptyCell
            }
        }
    }
    
    func createField() {
        for _ in 0...2 {
            var tempArray = [Int]()
            for _ in 0...2 {
                tempArray.append(emptyCell)
            }
            field.append(tempArray)
        }
    }
    
    func getButtonIndex(_ column: Int, _ row: Int) -> Int {
        let indexOfButton = (field[row].count * column + row)
        return indexOfButton
    }
    
    func setOValue() {
        var column = 0
        var row = 0
        // Проверяем, чтобы нолик установился в незанятую ячейку
        repeat {
            column = Int.random(in: 0...2)
            row = Int.random(in: 0...2)
        } while !(field[column][row] == emptyCell)
        
        field[column][row] = oCell
        let index = getButtonIndex(column, row)
        delegate?.displaySymbol(index: index, symbol: computerSymbol)
        cellsTaken += 1
        checkGameStatus()
    }
    
    func setXValue() {
        guard let row = Int((delegate?.rowTextField.text)!),
              let col = Int((delegate?.columnTextField.text)!) else {
            delegate?.infoLabel.text = "Column or row is not correct"
            return
        }
        if field[col-1][row-1] == emptyCell {
            field[col-1][row-1] = xCell
            delegate?.rowTextField.text = ""
            delegate?.columnTextField.text = ""
            let index = getButtonIndex(col-1, row-1)
            delegate?.displaySymbol(index: index, symbol: userSymbol)
            cellsTaken += 1
        } else {
            delegate?.infoLabel.text = "This coodinate is taken"
        }
    }
    
    func checkWin() -> (isWin: Bool, winnerName: String) {
        var isWin = false
        let winSum = 3
        var sum = 0
        var winnerName: String {
            if isWin {
                if sum < 0 {
                    return "Computer"
                } else {
                    return "Player"
                }
            } else {
                return ""
            }
        }
        
        if checkLeftDiagonal(&sum, for: winSum) {
            isWin = true
        }
        if checkRightDiagonal(&sum, for: winSum) {
            isWin = true
        }
        if checkRow(&sum, for: winSum) {
            isWin = true
        }
        if checkColumn(&sum, for: winSum) {
            isWin = true
        }
        
        return (isWin, winnerName)
    }
    
    func checkRow(_ sum: inout Int, for winSum: Int) -> Bool {
        var isWin = false
        for i in 0..<field.count {
            sum = 0
            for j in 0..<field.count {
                sum += field[i][j]
            }
            if abs(sum) == winSum {
                isWin = true
                return isWin
            }
        }
        return isWin
    }
    
    func checkColumn(_ sum: inout Int, for winSum: Int) -> Bool {
        var isWin = false
        for j in 0..<field.count {
            var sum = 0
            for i in 0..<field.count {
                sum += field[i][j]
            }
            if abs(sum) == 3 {
                isWin = true
                return isWin
            }
        }
        return isWin
    }
    
    func checkLeftDiagonal(_ sum: inout Int, for winSum: Int) -> Bool {
        var isWin = false
        var sum = 0
        for i in 0..<field.count {
            for j in 0..<field.count {
                if i == j {
                    sum += field[i][j]
                }
            }
        }
        if abs(sum) == winSum {
            isWin = true
            return isWin
        }
        return isWin
    }
    
    func checkRightDiagonal(_ sum: inout Int, for winSum: Int) -> Bool {
        var isWin = false
        var sum = 0
        for i in 0..<field.count {
            for j in 0..<field.count {
                if i == (field.count - 1 - j) {
                    sum += field[i][j]
                }
            }
        }
        if abs(sum) == winSum {
            isWin = true
            return isWin
        }
        return isWin
    }
    
    // Проверка статуса игры: победа или конец игры
    func checkGameStatus() {
        if cellsTaken > 4 && checkWin().0 {
            delegate?.winLabel.text = "\(checkWin().1) WIN!"
            gameIsOver = true
        }
        // Проверка на наличие свободных клеток для хода
        if !gameIsOver && cellsTaken == 9 {
            delegate?.infoLabel.text = "No more free cells"
            delegate?.winLabel.text = "GAME OVER"
            gameIsOver = true
        }
    }
    
    
}
