//
//  Settings.swift
//  Mines
//
//  Created by Vitaliy Voronok on 7/26/17.
//  Copyright © 2017 Vitaliy Voronok. All rights reserved.
//

import Foundation

struct Settings {
    let minesCount : Int
    let boardHeight : Int
    let boardWidth : Int
    
    init(minesCount : Int, boardHeight : Int, boardWidth : Int) {
        self.minesCount = minesCount
        self.boardWidth = boardWidth
        self.boardHeight = boardHeight
    }
    
    init() {
        self.minesCount = 40
        self.boardWidth = 16
        self.boardHeight = 16
    }
}
