//
//  ViewController.swift
//  Mines
//
//  Created by Vitaliy Voronok on 7/21/17.
//  Copyright © 2017 Vitaliy Voronok. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    // MARK: - Constants
    
    let mineSize = 20
    
    // MARK: - Property
    
    @IBOutlet var skView: SKView!
    
    var settings = Settings()
    
    // MARK: - Life Cycle
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        updateWindowSize(settings: settings)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                sceneNode.settings = settings
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .resizeFill
                
                // Present the scene
                if let view = self.skView {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    // MARK: - Privat
    
    func updateWindowSize(settings: Settings) {
        let width : CGFloat = CGFloat(mineSize * settings.boardWidth + 20)
        let height : CGFloat = CGFloat(mineSize * settings.boardHeight + 70)
        
        let skView = self.view as! SKView
        let sizeWindow = NSSize(width: width, height: height)
        
        if let window = skView.window {
            let screenFrame = NSScreen.main()!.frame
            let x = screenFrame.size.width / 2.0 - width / 2.0
            let y = screenFrame.size.height / 2.0 - height / 2.0
            
            window.setFrame(NSRect(origin: NSPoint(x: x, y: y), size: sizeWindow), display: true)
            window.minSize = sizeWindow
            window.maxSize = sizeWindow
            
            skView.needsLayout = true
            skView.scene?.size = sizeWindow
        }
    }
}

