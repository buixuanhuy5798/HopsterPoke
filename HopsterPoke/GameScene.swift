//
//  GameScene.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 09/05/2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameNode: SKNode!
    var backgroundNode: SKNode!
    var rabbitNode: SKNode!
    var cactusNode: SKNode!
    
    var rabbitSprite: SKSpriteNode!
    
    var dinoYPosition: CGFloat?
    
    var groundHeight: CGFloat = 120
    var groundWidth: CGFloat = 590
    var groundSpeed: CGFloat = 50
    let dinoHopForce = 100 as Int
    
    let background: CGFloat = 0
    let foreground: CGFloat = 1
    
    //spawning vars
    var spawnRate = 1.5 as Double
    var timeSinceLastSpawn = 0.0 as Double
    
    //sound effects
    let jumpSound = SKAction.playSoundFileNamed("arrow_up_down", waitForCompletion: false)
    
    let groundCategory = 1 << 0 as UInt32
    let dinoCategory = 1 << 1 as UInt32
    let cactusCategory = 1 << 2 as UInt32
    
    var obstacles = [SKSpriteNode]()
    var obstacleTimer: Timer?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            if let groundPosition = dinoYPosition {
                if rabbitSprite.position.y < 100 {
                    if rabbitSprite.position.y <= groundPosition && gameNode.speed > 0 {
                        rabbitSprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                        rabbitSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: dinoHopForce))
                        run(jumpSound)
                    }
                }
            }
        }
    }
    
    override func didMove(to view: SKView) {
//        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -12)
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
        physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if (gameNode.speed > 0) {
            groundSpeed += 0.2
//            score += 1
//            scoreNode.text = "Score: \(score/5)"
            if(currentTime - timeSinceLastSpawn > spawnRate){
                timeSinceLastSpawn = currentTime
                spawnRate = Double.random(in: 1.0 ..< 3.5)
                
                if(Int.random(in: 0...10) < 8){
                    createObstacle()
                } else {
//                    spawnBird()
                }
            }
        }
    }
    
    @objc func createObstacle() {
         let obstacleSize = CGSize(width: 30, height: 30)
         let obstacle = SKSpriteNode(color: .red, size: obstacleSize)
         obstacle.position = CGPoint(x: size.width + obstacleSize.width / 2, y: CGFloat.random(in: size.height * 0.2...size.height * 0.8))
         addChild(obstacle)
         obstacles.append(obstacle)
         
         // Di chuyển chướng ngại vật sang trái
         let moveAction = SKAction.moveBy(x: -size.width - obstacleSize.width, y: 0, duration: 4)
         obstacle.run(moveAction) {
             // Xóa chướng ngại vật khi nó đi ra khỏi màn hình
             obstacle.removeFromParent()
             if let index = self.obstacles.firstIndex(of: obstacle) {
                 self.obstacles.remove(at: index)
             }
         }
     }
    
    func createRabbit() {
        let rabbitTexture = SKTexture(imageNamed: "rabbit_go_ahead")
        rabbitTexture.filteringMode = .nearest
        rabbitSprite = SKSpriteNode()
        rabbitSprite.texture = rabbitTexture
        rabbitSprite.size = CGSize(width: 64, height: 64)
        let physicsBox = CGSize(width: 64, height: 64)
        rabbitSprite.physicsBody?.isDynamic = true
        rabbitSprite.physicsBody?.mass = 5.0
        rabbitSprite.physicsBody = SKPhysicsBody(rectangleOf: physicsBox)
        dinoYPosition = groundHeight + 64
        rabbitSprite.position = CGPoint(x: -frame.width/2+90, y: 0)
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

