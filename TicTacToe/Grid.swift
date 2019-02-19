//
//  Grid.swift
//  TicTacToe
//
//  Created by Vincent Yu on 2/12/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import Foundation

enum CellValue {
    case Empty, O, X
}

enum Result {
    case Tie
    case Horizontal, Vertical, Diagnol, AntiDiagnol
}

class Grid {
    var leftCellsCnt: Int
    var cells: [[CellValue]]
    
    init() {
        self.leftCellsCnt = 9
        self.cells = Array(repeating: Array(repeating: .Empty, count: 3), count: 3)
    }
    
    // Return true when grid cell is empty
    func isEmpty(row r: Int, col c: Int) -> Bool {
        return cells[r][c] == .Empty
    }
    
    // Mark a cell as occupied
    func mark(row r: Int, col c: Int, mark m: CellValue) -> Result? {
        leftCellsCnt -= 1
        cells[r][c] = m
        
        if cells[r][0] == cells[r][1] && cells[r][1] == cells[r][2] {
            return .Horizontal
        }
        else if cells[0][c] == cells[1][c] && cells[1][c] == cells[2][c] {
            return .Vertical
        }
        else if r == c && cells[0][0] == cells[1][1] && cells[1][1] == cells[2][2] {
            return .Diagnol
        }
        else if r+c == 2 && cells[0][2] == cells[1][1] && cells[1][1] == cells[2][0] {
            return .AntiDiagnol
        }
        else if leftCellsCnt == 0 {
            return .Tie
        }
        else {
            return nil
        }
    }
    
    // Clear grid
    func clear() {
        leftCellsCnt = 9
        for i in 0...2 {
            for j in 0...2 {
                cells[i][j] = .Empty
            }
        }
    }
}
