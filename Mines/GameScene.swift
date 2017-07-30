//
//  GameScene.swift
//  Mines
//
//  Created by Vitaliy Voronok on 7/21/17.
//  Copyright © 2017 Vitaliy Voronok. All rights reserved.
//

import SpriteKit
import GameplayKit

indirect enum BoardType {
    case empty
    case mine
    case flagMine
    case flagEmpty
    case explosion
    case open
}

extension NSColor {
    open class var lightBlue: NSColor {
        get {
            return NSColor(calibratedRed: 62.0/255.0, green: 83.0/255.0, blue: 163.0/255, alpha: 1.0)
        }
    }
    
    open class var darkBlue: NSColor {
        get {
            return NSColor(calibratedRed: 45.0/255.0, green: 46.0/255.0, blue: 117.0/255, alpha: 1.0)
        }
    }
    
    open class var lightGreen: NSColor {
        get {
            return NSColor(calibratedRed: 40.0/255.0, green: 129.0/255.0, blue: 64.0/255, alpha: 1.0)
        }
    }
    
    open class var lightRed: NSColor {
        get {
            return NSColor(calibratedRed: 255.0/255.0, green: 31.0/255.0, blue: 38.0/255, alpha: 1.0)
        }
    }
    
    open class var darkRed: NSColor {
        get {
            return NSColor(calibratedRed: 123.0/255.0, green: 1.0/255.0, blue: 0.0/255, alpha: 1.0)
        }
    }
    
    open class var turquoise: NSColor {
        get {
            return NSColor(calibratedRed: 34.0/255.0, green: 130.0/255.0, blue: 130.0/255, alpha: 1.0)
        }
    }
}

class GameScene: SKScene {

    // MARK: - Constants
    
    let labelsFontSize : CGFloat = 44.0
    let labelsFontName = "Digital-7"
    let colors = [NSColor.white, NSColor.blue, NSColor.lightGreen, NSColor.lightRed, NSColor.darkBlue, NSColor.darkRed, NSColor.turquoise, NSColor.black, NSColor.brown]
    
    // MARK: - Property
    
    var minesLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    var gameStartTime: TimeInterval = 0
    var board : [[BoardType]] = [[]]
    var gameOver = false
    
    public var settings = Settings() {
        didSet {
            refresh()
        }
    }
    
    var mines = 0 {
        didSet {
            let formater = NumberFormatter()
            formater.numberStyle = .decimal
            formater.minimumIntegerDigits = 3
            
            if let formattedMines = formater.string(from: mines as NSNumber) {
                minesLabel?.text = "\(formattedMines)"
            }
        }
    }
    
    var time = 0 {
        didSet {
            let formater = NumberFormatter()
            formater.numberStyle = .decimal
            formater.minimumIntegerDigits = 3
            
            if let formattedTime = formater.string(from: time as NSNumber) {
                timeLabel?.text = "\(formattedTime)"
            }
        }
    }
    
    // MARK: - Life Cycle
    
    override func sceneDidLoad() {
        refresh()
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameStartTime == 0 {
            gameStartTime = currentTime
        }
        
        let elapsed = (currentTime - gameStartTime)
        time = Int(elapsed)
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        
        let size = self.size
        if minesLabel != nil {
            minesLabel.position = CGPoint(x: 10, y: size.height - 10)
        }
        
        if timeLabel != nil {
            timeLabel.position = CGPoint(x: size.width - 10, y: size.height - 10)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        if gameOver {
            refresh()
            return
        }
        
        let location = event.location(in: self)
        guard let clickedCell = cell(at: location) else { return }
        openCell(cell: clickedCell)
    }
    
    override func rightMouseUp(with event: NSEvent) {
        if gameOver {
            refresh()
            return
        }
        
        let location = event.location(in: self)
        guard let clickedCell = cell(at: location) else { return }
        setFlagCell(cell: clickedCell)
    }
    
    func cell(at point: CGPoint) -> SKSpriteNode? {
        let cell = nodes(at: point).flatMap { $0 as? SKSpriteNode }
        return cell.first
    }
    
    func setFlagCell(cell: SKSpriteNode) {
        let position = positionInArray(cell: cell)
        let x = Int(position.x)
        let y = Int(position.y)
        
        if board[y][x] == .open {
            return
        }
        
        cell.removeAllChildren()
        
        if board[y][x] != .flagMine && board[y][x] != .flagEmpty {
            board[y][x] = board[y][x] == .mine ? .flagMine : .flagEmpty
            let label = SKLabelNode()
            label.fontSize = 13
            label.fontColor = NSColor.white
            label.text = "🚩"
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .center
            label.position = CGPoint(x: 10, y: 10)
            cell.removeAllChildren()
            cell.addChild(label)
            mines -= 1
        } else {
            board[y][x] = board[y][x] == .flagMine ? .mine : .empty;
            mines += 1
        }
        
        if isWin() {
            gameOver = true
            winGame()
        }
    }
    
    func openCell(cell: SKSpriteNode) {
        let position = positionInArray(cell: cell)
        let x = Int(position.x)
        let y = Int(position.y)
        
        if board[y][x] == .flagMine || board[y][x] == .flagEmpty {
            return
        }
        
        if board[y][x] == .mine {
            for yn in 0..<settings.boardHeight  {
                for xn in 0..<settings.boardWidth  {
                    if board[yn][xn] == .mine || board[yn][xn] == .flagEmpty {
                        guard let clickedCell = self.cell(at: cellPosition(x: xn, y: yn)) else { continue }
                        let label = SKLabelNode()
                        label.fontSize = 13
                        label.fontColor = NSColor.white
                        label.text = board[yn][xn] == .mine ? "💣" : "❌"
                        label.horizontalAlignmentMode = .center
                        label.verticalAlignmentMode = .center
                        label.position = CGPoint(x: 10, y: 10)
                        clickedCell.removeAllChildren()
                        clickedCell.addChild(label)
                        clickedCell.color = NSColor.darkGray
                    }
                }
            }
            board[y][x] = .explosion
            gameOver = true
            cell.color = NSColor.red
        } else if board[y][x] == .empty {
            board[y][x] = .open
            
            var count = 0
            for yn in y-1...y+1 {
                for xn in x-1...x+1 {
                    if (yn == y && xn == x) || yn < 0 || xn < 0 || xn >= settings.boardWidth || yn >= settings.boardHeight {
                        continue
                    }
                    
                    if board[yn][xn] == .mine
                        || board[yn][xn] == .explosion
                        || board[yn][xn] == .flagMine
                    {
                        count += 1
                    }
                }
            }
            
            if count > 0 {
                let label = SKLabelNode()
                label.fontSize = 15
                label.fontColor = count <= colors.count ? colors[count] : NSColor.white
                label.fontName = "SF Pro Display Black"
                label.text = "\(count)"
                label.colorBlendFactor = 1.0
                label.horizontalAlignmentMode = .center
                label.verticalAlignmentMode = .center
                label.position = CGPoint(x: 10, y: 10)
                cell.removeAllChildren()
                cell.addChild(label)
            } else {
                for yn in y-1...y+1 {
                    for xn in x-1...x+1 {
                        if (yn == y && xn == x) || yn < 0 || xn < 0 || xn >= settings.boardWidth || yn >= settings.boardHeight {
                            continue
                        }
                        
                        if board[yn][xn] != .mine || board[yn][xn] != .explosion || board[yn][xn] == .flagMine || board[yn][xn] == .flagEmpty {
                            guard let nextCell = self.cell(at: cellPosition(x: xn, y: yn)) else { continue }
                            openCell(cell: nextCell)
                        }
                    }
                }
            }
            
            cell.color = NSColor.darkGray
        }
        
        if isWin() {
            gameOver = true
            winGame()
        }
    }
    
    func positionInArray(cell: SKSpriteNode) -> CGPoint {
        return CGPoint(x: (cell.position.x - 10) / 20, y: (cell.position.y - 10) / 20)
    }
    
    func cellPosition(x: Int, y: Int) -> CGPoint {
        return CGPoint(x: x * 20 + 10, y: y * 20 + 10)
    }
    
    // MARK: - Privat
    
    func setupLabels() {
        let size = self.size
        minesLabel = SKLabelNode(fontNamed: labelsFontName)
        minesLabel.fontColor = NSColor.green
        minesLabel.fontSize = labelsFontSize
        minesLabel.horizontalAlignmentMode = .left
        minesLabel.verticalAlignmentMode = .top
        minesLabel.position = CGPoint(x: 10, y: size.height - 10)
        addChild(minesLabel)
        
        timeLabel = SKLabelNode(fontNamed: labelsFontName)
        timeLabel.fontSize = labelsFontSize
        timeLabel.fontColor = NSColor.green
        timeLabel.horizontalAlignmentMode = .right
        timeLabel.verticalAlignmentMode = .top
        timeLabel.position = CGPoint(x: size.width - 10, y: size.height - 10)
        addChild(timeLabel)
    }
    
    func refresh() {
        gameOver = false
        self.removeAllChildren()
        
        self.setupLabels()
        
        mines = settings.minesCount
        time = 0
        gameStartTime = 0
        
        board = [[BoardType]](repeating: [BoardType](repeating: .empty, count: settings.boardWidth), count: settings.boardHeight)
        
        var currentMines = 0
        while currentMines < settings.minesCount {
            let x = GKARC4RandomSource.sharedRandom().nextInt(upperBound: settings.boardWidth)
            let y = GKARC4RandomSource.sharedRandom().nextInt(upperBound: settings.boardHeight)
            
            if board[y][x] != .mine {
                board[y][x] = .mine
                currentMines += 1
            }
        }
        
        fillBoard()
    }
    
    func fillBoard() {
        for y in 0..<settings.boardHeight {
            for x in 0..<settings.boardWidth {
                let sprite = SKSpriteNode(color: NSColor.gray, size: CGSize(width: 19, height: 19))
                sprite.anchorPoint = CGPoint(x: 0, y: 0)
                sprite.position = cellPosition(x: x, y: y)
                addChild(sprite)
            }
        }
    }
    
    func isWin() -> Bool {
        let reduced = board.reduce([], +)
        let minesCount = reduced.filter { (value) -> Bool in
            return value == .mine
        }.count
        
        let flagsMineCount = reduced.filter { (value) -> Bool in
            return value == .flagMine
        }.count
        
        let flagsEmptyCount = reduced.filter { (value) -> Bool in
            return value == .flagEmpty
        }.count
        
        let openCount = reduced.filter { (value) -> Bool in
            return value == .open
            }.count
        
        if flagsEmptyCount > 0 {
            return false
        }

        if settings.boardWidth * settings.boardHeight - openCount == flagsMineCount + minesCount {
            return true
        }
        
        if minesCount == 0 && flagsMineCount == settings.minesCount {
            return true
        }
        
        return false
    }
    
    func winGame() {
        let label = SKLabelNode()
        label.fontSize = 72
        label.fontColor = NSColor.green
        label.fontName = "SF Pro Display Black"
        label.text = "You Win"
        label.colorBlendFactor = 1.0
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: self.size.width / 2.0, y: self.size.height / 2.0)
        label.zPosition = 100
        addChild(label)
    }
}
