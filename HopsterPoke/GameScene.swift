//
//  GameScene.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 09/05/2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // Background nodes
    var background1: SKSpriteNode!
    var background2: SKSpriteNode!
    var poke: SKSpriteNode!
    
    // Speed of scrolling
    let scrollSpeed: CGFloat = 2
    
    override func didMove(to view: SKView) {
        // Set up backgrounds
        background1 = createBackground()
        background2 = createBackground()
        poke = createPoke()
        
        // Position background nodes
        background1.position = CGPoint(x: 0, y: -frame.size.height/2 + 175)
        background2.position = CGPoint(x: background1.size.width, y: -frame.size.height/2 + 175)
        poke.position = CGPoint(x: -frame.width/2+135, y: -frame.size.height/2 + 400)
        // Add background nodes to the scene
        addChild(background1)
        addChild(background2)
        addChild(poke)
    }
    
    override func update(_ currentTime: TimeInterval) {
//        // Move backgrounds
        background1.position.x -= scrollSpeed
        background2.position.x -= scrollSpeed
        
        // If a background node moves completely off the screen, move it to the other side
        if background1.position.x < -background1.size.width {
            background1.position.x = background2.position.x + background2.size.width
        }
        if background2.position.x < -background2.size.width {
            background2.position.x = background1.position.x + background1.size.width
        }
    }
    
    func createPoke() -> SKSpriteNode {
        let poke = SKSpriteNode(imageNamed: "rabbit_go_ahead")
        poke.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        poke.size = CGSize(width: 110, height: 110)
        return poke
    }
     
    // Function to create a repeating background node
    func createBackground() -> SKSpriteNode {
        let background = SKSpriteNode(imageNamed: "underground_background")
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.size = CGSize(width: 1717, height: 350)
        return background
    }
}
