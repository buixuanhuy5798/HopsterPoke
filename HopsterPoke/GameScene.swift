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
    
    var skyWidth: CGFloat = 1106
    var skyHeight: CGFloat = 1000
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            if let groundPosition = dinoYPosition {
                if rabbitSprite.position.y < 50 {
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
        
        cactusNode = SKNode()
        cactusNode.zPosition = foreground
//        spawnCactus()
        
        gameNode = SKNode()
        gameNode.addChild(backgroundNode)
        gameNode.addChild(rabbitNode)
        gameNode.addChild(cactusNode)
        self.addChild(gameNode)
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(hitCactus(contact)){
            print("DIEEEE")
        }
    }
    
    func hitCactus(_ contact: SKPhysicsContact) -> Bool {
        return contact.bodyA.categoryBitMask & cactusCategory == cactusCategory ||
            contact.bodyB.categoryBitMask & cactusCategory == cactusCategory
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if (gameNode.speed > 0) {
            if(currentTime - timeSinceLastSpawn > spawnRate){
                timeSinceLastSpawn = currentTime
                spawnRate = Double.random(in: 2 ..< 4.5)
                
                if(Int.random(in: 0...10) < 8){
                    spawnCactus()
                } else {
//                    spawnBird()
                }
            }
        }
    }
    
    private func getSizeCactus(name: String) -> CGSize {
        switch name {
        case "flowerpot1":
            return CGSize(width: 40, height: 63)
        case "flowerpot2":
            return CGSize(width: 40, height: 50)
        case "flowerpot3":
            return CGSize(width: 40, height: 47)
        case "flowerpot4":
            return CGSize(width: 40, height: 41)
        case "flowerpot5":
            return CGSize(width: 40, height: 41)
        default:
            return .zero
        }
    }
    
    func spawnCactus() {
        let cactusTextures = ["flowerpot1", "flowerpot2", "flowerpot3", "flowerpot4", "flowerpot5"]
        
        //texture
        let imagedName = cactusTextures.randomElement()!
        let cactusTexture = SKTexture(imageNamed: imagedName)
        cactusTexture.filteringMode = .nearest
        
        //sprite
        
        let cactusSprite = SKSpriteNode(texture: cactusTexture)
        cactusSprite.size = getSizeCactus(name: imagedName)
        cactusSprite.position = CGPoint(x: frame.width/2 + 30, y: -frame.height/2 + groundHeight)
        
        //physics
        let contactBox = getSizeCactus(name: imagedName)
        cactusSprite.physicsBody = SKPhysicsBody(rectangleOf: contactBox)
        cactusSprite.physicsBody?.isDynamic = true
        cactusSprite.physicsBody?.mass = 1.0
        cactusSprite.physicsBody?.categoryBitMask = cactusCategory
        cactusSprite.physicsBody?.contactTestBitMask = dinoCategory
        cactusSprite.physicsBody?.collisionBitMask = groundCategory
        
        //add to scene
        cactusNode.addChild(cactusSprite)
        //animate
        animateCactus(sprite: cactusSprite, texture: cactusTexture)
    }

    
    func animateCactus(sprite: SKSpriteNode, texture: SKTexture) {
        let screenWidth = self.frame.size.width
        let distanceOffscreen = 50.0 as CGFloat
        let distanceToMove = frame.width + 100
        
        //actions
        let moveCactus = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
        let removeCactus = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([moveCactus, removeCactus])
        sprite.run(moveAndRemove)
    }
    
    func createRabbit() {
        let rabbitTexture = SKTexture(imageNamed: "rabbit_go_ahead")
        rabbitTexture.filteringMode = .nearest
        rabbitSprite = SKSpriteNode()
        rabbitSprite.texture = rabbitTexture
        rabbitSprite.size = CGSize(width: 64, height: 64)
        let physicsBox = CGSize(width: 64, height: 64)
        rabbitSprite.physicsBody?.isDynamic = true
        rabbitSprite.physicsBody?.mass = 1.0
        rabbitSprite.physicsBody = SKPhysicsBody(rectangleOf: physicsBox)
        dinoYPosition = groundHeight + 64
        rabbitSprite.position = CGPoint(x: -frame.width/2+90, y: -frame.height/2 + groundHeight + 16)
        rabbitSprite.physicsBody?.categoryBitMask = dinoCategory
        rabbitSprite.physicsBody?.contactTestBitMask = cactusCategory
        rabbitSprite.physicsBody?.collisionBitMask = groundCategory
        rabbitNode.addChild(rabbitSprite)
    }
    
    func createAndMoveGround() {
        let screenWidth = self.frame.size.width
        
        //ground texture
        let groundTexture = SKTexture(imageNamed: "underground_background")
        let skyTexture = SKTexture(imageNamed: "sky_background")
        
        //ground actions
        let moveGroundLeft = SKAction.moveBy(x: -groundWidth,
                                             y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
        let resetGround = SKAction.moveBy(x: groundWidth, y: 0.0, duration: 0.0)
        let groundLoop = SKAction.sequence([moveGroundLeft, resetGround])
        
        //ground nodes
        let numberOfGroundNodes = 2
        
        for i in 0 ..< numberOfGroundNodes {
            let node = SKSpriteNode(texture: groundTexture)
            node.position = CGPoint(x: CGFloat(i) * groundWidth, y: -frame.height/2 + groundHeight/2)
            node.size = CGSize(width: groundWidth, height: groundHeight)
            backgroundNode.addChild(node)
            node.run(SKAction.repeatForever(groundLoop))
        }
        
        let skyHeight = frame.height - groundHeight
        let skyWidth = skyHeight * 4937/3472
//        let moveSkyLeft = SKAction.moveBy(x: -skyWidth,
//                                          y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
//        let resetSky = SKAction.moveBy(x: skyWidth, y: 0.0, duration: 0.0)
//        let skyLoop = SKAction.sequence([moveSkyLeft, resetSky])
        
        for i in 0 ..< numberOfGroundNodes {
            let node = SKSpriteNode(texture: skyTexture)
            node.position = CGPoint(x: CGFloat(i) * skyWidth, y: frame.height/2 - skyHeight/2)
            node.size = CGSize(width: skyWidth, height: skyHeight)
            backgroundNode.addChild(node)
//            node.run(SKAction.repeatForever(skyLoop))
        }
    }
    
    func addCollisionToGround() {
        let groundContactNode = SKNode()
        groundContactNode.position = CGPoint(x: 0, y: -frame.size.height/2 + groundHeight/2)
        groundContactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: groundWidth * 2, height: groundHeight - 60))
        groundContactNode.physicsBody?.friction = 0.0
        groundContactNode.physicsBody?.isDynamic = false
        groundContactNode.physicsBody?.categoryBitMask = groundCategory
        
        backgroundNode.addChild(groundContactNode)
    }
}

