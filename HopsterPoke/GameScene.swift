//
//  GameScene.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 09/05/2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameNode: SKNode!
    var backgroundNode: SKNode!
    var rabbitNode: SKNode!
    
    var rabbitSprite: SKSpriteNode!
    
    var dinoYPosition: CGFloat?
    
    var groundHeight: CGFloat = 350
    var groundWidth: CGFloat = 1717
    var groundSpeed: CGFloat = 100
    let dinoHopForce = 400 as Int
    
    let background: CGFloat = 0
    let foreground: CGFloat = 1
    
    let groundCategory = 1 << 0 as UInt32
    let dinoCategory = 1 << 1 as UInt32
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            if let groundPosition = dinoYPosition {
                if rabbitSprite.position.y <= groundPosition && gameNode.speed > 0 {
                    rabbitSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: dinoHopForce))
                }
            }
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundNode = SKNode()
        backgroundNode.zPosition = background
        createAndMoveGround()
        addCollisionToGround()
        
        //dinosaur
        rabbitNode = SKNode()
        rabbitNode.zPosition = foreground
        createRabbit()
        
        gameNode = SKNode()
        gameNode.addChild(backgroundNode)
        gameNode.addChild(rabbitNode)
        self.addChild(gameNode)
        
       
    }
    
    func createRabbit() {
        let rabbitTexture = SKTexture(imageNamed: "rabbit_go_ahead")
        rabbitSprite = SKSpriteNode()
        rabbitSprite.texture = rabbitTexture
        rabbitSprite.size = CGSize(width: 110, height: 110)
        let physicsBox = CGSize(width: 110, height: 110)
        rabbitSprite.physicsBody?.isDynamic = true
        rabbitSprite.physicsBody?.mass = 0
        rabbitSprite.physicsBody = SKPhysicsBody(rectangleOf: physicsBox)
        dinoYPosition = groundHeight + 110
        rabbitSprite.position = CGPoint(x: -frame.width/2+135, y: -frame.size.height/2 + 400)
        rabbitSprite.physicsBody?.categoryBitMask = dinoCategory
        rabbitSprite.physicsBody?.collisionBitMask = groundCategory
        rabbitNode.addChild(rabbitSprite)
    }
    
    func createAndMoveGround() {
        let screenWidth = self.frame.size.width
        
        //ground texture
        let groundTexture = SKTexture(imageNamed: "underground_background")
        
        //ground actions
        let moveGroundLeft = SKAction.moveBy(x: -groundWidth,
                                             y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
        let resetGround = SKAction.moveBy(x: groundWidth, y: 0.0, duration: 0.0)
        let groundLoop = SKAction.sequence([moveGroundLeft, resetGround])
        
        //ground nodes
        let numberOfGroundNodes = 2
        
        for i in 0 ..< numberOfGroundNodes {
            let node = SKSpriteNode(texture: groundTexture)
            node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            node.position = CGPoint(x: CGFloat(i) * groundWidth, y: -frame.size.height/2 + groundHeight/2)
            node.size = CGSize(width: groundWidth, height: groundHeight)
            backgroundNode.addChild(node)
            node.run(SKAction.repeatForever(groundLoop))
        }
    }
    
    func addCollisionToGround() {
        let groundContactNode = SKNode()
        groundContactNode.position = CGPoint(x: 0, y: -frame.size.height/2 + groundHeight/2)
        groundContactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: groundWidth * 2,
                                                                          height: groundHeight))
        groundContactNode.physicsBody?.friction = 0.0
        groundContactNode.physicsBody?.isDynamic = false
        groundContactNode.physicsBody?.categoryBitMask = groundCategory
        
        backgroundNode.addChild(groundContactNode)
    }
}

