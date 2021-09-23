//
//  GameLogic.swift
//  XO
//
//  Created by Daniel Yamrak on 29.05.2021.
//

import UIKit

protocol GameDelegate: class {
    func displaySymbol(index: Int, symbol: UIImage)
    var infoLabel: UILabel! { get set }
    var winLabel: UILabel! { get set }
}

class GameLogic {
    
//    static let shared = GameLogic()
//    private init() { }
    
    weak var delegate: GameDelegate?
    private(set) var field = [[Int]]() // Поле для крестиков-ноликов
    private let emptyCellValue = 0
    private let xCellValue = 1
    private let oCellValue = -1
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
                field[i][j] = emptyCellValue
            }
        }
    }
    
    func createField() {
        for _ in 0...2 {
            var tempArray = [Int]()
            for _ in 0...2 {
                tempArray.append(emptyCellValue)
            }
            field.append(tempArray)
        }
    }
    
    func getButtonIndex(_ row: Int, _ column: Int) -> Int {
        let indexOfButton = (field[column].count * row + column)
        return indexOfButton
    }
    
    func setOValue() {
        var row = 0
        var column = 0
        // Проверяем, чтобы нолик установился в незанятую ячейку
        repeat {
            row = Int.random(in: 0...2)
            column = Int.random(in: 0...2)
        } while !(field[row][column] == emptyCellValue)
        
        field[row][column] = oCellValue
        let index = getButtonIndex(row, column)
        delegate?.displaySymbol(index: index, symbol: computerSymbol)
        cellsTaken += 1
        checkGameStatus()
        printField()
    }

    func setXValue(_ tag: Int) -> Bool {
        delegate?.infoLabel.text = ""
        var isSuccess = false
        var row = 0
        var col = 0
        switch tag {
        case 0, 3, 6:
            col = 0
            row = (tag - col) / 3
        case 1, 4, 7:
            col = 1
            row = (tag - col) / 3
        case 2, 5, 8:
            col = 2
            row = (tag - col) / 3
        default:
            break
        }

        if field[row][col] == emptyCellValue {
            field[row][col] = xCellValue
            let index = tag
            delegate?.displaySymbol(index: index, symbol: userSymbol)
            cellsTaken += 1
            isSuccess = true
        } else {
            delegate?.infoLabel.text = "This coodinate is taken"
        }
        return isSuccess
    }

    // For debugging purposes
    func printField() {
        for i in 0...2 {
            for j in 0...2 {
                print(field[i][j], terminator:" ")
            }
            print()
        }
        print()
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
            sum = 0
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
        sum = 0
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
        sum = 0
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
            return
        }
        // Проверка на наличие свободных клеток для хода
        if !gameIsOver && cellsTaken == 9 {
            delegate?.infoLabel.text = "No more free cells"
            delegate?.winLabel.text = "GAME OVER"
            gameIsOver = true
            return
        }
    }
    
}
