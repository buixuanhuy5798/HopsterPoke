//
//  GameScene.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 09/05/2024.
//

import SpriteKit
import GameplayKit

protocol GameDelegate {
    func gameOver()
    func gameWin()
    func showMinigame()
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameDelegate: GameDelegate?
    
    var gameNode: SKNode!
    var backgroundNode: SKNode!
    var rabbitNode: SKNode!
    var cactusNode: SKNode!
    
    var rabbitSprite: SKSpriteNode!
    
    var dinoYPosition: CGFloat?
    
    var groundHeight: CGFloat = 180
    var groundWidth: CGFloat = 885
    
    var skyWidth: CGFloat = 1106
    var skyHeight: CGFloat = 1000
    
    var groundSpeed: CGFloat = 80
    let dinoHopForce = 105 as Int
    
    let background: CGFloat = 0
    let foreground: CGFloat = 1
    
    //spawning vars
    var spawnRate = 1.5 as Double
    var timeSinceLastSpawn = 0.0 as Double
    
    var lifeCount = 2
    var totalPoint = 0
    var winnerPoint = Int.random(in: 13..<15)
    var miniGamePoint = Int.random(in: 5..<10)
    
    let buttonDirUp = SKSpriteNode(imageNamed: "up_button")
    let buttonDirDown = SKSpriteNode(imageNamed: "down_button")
    let buttonDirLeft = SKSpriteNode(imageNamed: "icon_back_button")
    let buttonDirRight = SKSpriteNode(imageNamed: "icon_next_button")
    
    let alphaUnpressed: CGFloat = 0.5
    let alphaPressed: CGFloat = 0.9
    var pressedButtons = [SKSpriteNode]()
    
    //sound effects
    let jumpSound = SKAction.playSoundFileNamed("arrow_up_down", waitForCompletion: false)
    let die1lifesound = SKAction.playSoundFileNamed("one_heart_left", waitForCompletion: false)
    
    let groundCategory = 1 << 0 as UInt32
    let dinoCategory = 1 << 1 as UInt32
    let cactusCategory = 1 << 2 as UInt32
    var needGenCactus = true
    
    var jumpTimer = Timer()
    var isJump = false
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for _ in touches {
//            if let groundPosition = dinoYPosition {
//                if rabbitSprite.position.y < 0 {
//                    if rabbitSprite.position.y <= groundPosition && gameNode.speed > 0 {
//                        rabbitSprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
//                        rabbitSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: dinoHopForce))
//                        if UserInfomation.turnOnSound {
//                            run(jumpSound)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    override func didMove(to view: SKView) {
//        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -10)
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
        
        setupControls(size: frame.size)
        
        self.addChild(gameNode)
        physicsWorld.contactDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(gameContinue), name: Notification.Name("ContiueGame"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        jumpTimer.invalidate()
    }
    
    private func runTimer() {
        jumpTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(timerAction), userInfo: nil, repeats: false)
    }
    
    @objc func timerAction() {
        isJump = false
    }
    
    func gameWin() {
        gameNode.speed = 0.0
        rabbitSprite.removeAllActions()
        gameDelegate?.gameWin()
    }
    
    func gameOver() {
        gameNode.speed = 0.0

        let deadRabbitTexture = SKTexture(imageNamed: "dead_rabbit")
        deadRabbitTexture.filteringMode = .nearest
        
        rabbitSprite.removeAllActions()
        rabbitSprite.texture = deadRabbitTexture
        gameDelegate?.gameOver()
    }
    
    @objc func gameContinue() {
        print("GAME CONTINUE")
        totalPoint += 1
        gameNode.speed = 1.0
    }
    
    func gameShowMiniGame() {
        gameDelegate?.showMinigame()
        cactusNode.removeAllChildren()
        gameNode.speed = 0
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if(hitCactus(contact)){
            lifeCount -= 1
            if lifeCount > 0 {
                if UserInfomation.turnOnSound {
                    run(die1lifesound)
                }
            } else {
                gameOver()
            }
        }
    }
    
    func hitCactus(_ contact: SKPhysicsContact) -> Bool {
        let hit = contact.bodyA.categoryBitMask & cactusCategory == cactusCategory ||
        contact.bodyB.categoryBitMask & cactusCategory == cactusCategory
        if hit {
            if let name = contact.bodyB.node?.name, name == "flowerpot_winner" {
                gameWin()
                return false
            }
            contact.bodyB.node?.removeFromParent()
        }
        return contact.bodyA.categoryBitMask & cactusCategory == cactusCategory ||
            contact.bodyB.categoryBitMask & cactusCategory == cactusCategory
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if rabbitSprite.position.x < -150 {
            rabbitSprite.position.x = -150
        }
        if rabbitSprite.position.x > 110 {
            rabbitSprite.position.x = 110
        }
        if gameNode.speed > 0 {
            if currentTime - timeSinceLastSpawn > spawnRate && needGenCactus {
                timeSinceLastSpawn = currentTime
                spawnRate = Double.random(in: 1.5 ..< 3.5)
               
                if(Int.random(in: 0...13) < 8) {
                    if totalPoint == winnerPoint {
                        spawnWinner()
                        needGenCactus = false
                    } else if totalPoint == miniGamePoint {
                        gameShowMiniGame()
                    } else {
                        spawnCactus()
                        totalPoint += 1
                    }
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
        case "flowerpot_double_1":
            return CGSize(width: 80, height: 63)
        case "flowerpot_double_2":
            return CGSize(width: 80, height: 47)
        case "flowerpot_tripple_1":
            return CGSize(width: 120, height: 63)
        default:
            return .zero
        }
    }
    
    func spawnWinner() {
        let cactusTexture = SKTexture(imageNamed: "flowerpot_winner")
        
        cactusTexture.filteringMode = .nearest
        let cactusSprite = SKSpriteNode(texture: cactusTexture)
        cactusSprite.size = CGSize(width: 40, height: 70)
        cactusSprite.name = "flowerpot_winner"
        cactusSprite.position = CGPoint(x: frame.width/2 + 30, y: -frame.height/2 + groundHeight)
        //physics
        let contactBox = CGSize(width: 40, height: 70)
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
    
    func spawnCactus() {
        let cactusTextures = ["flowerpot1", "flowerpot2", "flowerpot3", "flowerpot4", "flowerpot5", "flowerpot_double_1", "flowerpot_double_2", "flowerpot_tripple_1"]
        
        //texture
        let imagedName = cactusTextures.randomElement()!
        let cactusTexture = SKTexture(imageNamed: imagedName)
        cactusTexture.filteringMode = .nearest
        
        //sprite
        
        let cactusSprite = SKSpriteNode(texture: cactusTexture)
        cactusSprite.size = getSizeCactus(name: imagedName)
        cactusSprite.name = imagedName
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
        let distanceToMove = frame.width + 50
        
        //actions
        let moveCactus = SKAction.moveBy(x: -distanceToMove, y: 0.0, duration: TimeInterval(screenWidth / groundSpeed))
        let removeCactus = SKAction.removeFromParent()
        let moveAndRemove = SKAction.sequence([moveCactus, removeCactus])
        sprite.run(moveAndRemove) { [weak self] in
            if sprite.name == "flowerpot_winner" {
                self?.gameWin()
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
    
    // MARK: - Add button and logic
    
    func addButton(button: SKSpriteNode, position: CGPoint, name: String) {
        button.position = position
        button.size = CGSize(width: 56, height: 56)
        button.name = name
        button.zPosition = 10
        button.alpha = alphaUnpressed
        self.addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            for button in [buttonDirUp, buttonDirDown, buttonDirLeft, buttonDirRight] {
                if button.contains(location) && pressedButtons.firstIndex(of: button) == nil {
                    pressedButtons.append(button)
                    follow(command: button.name)
                }
                if pressedButtons.firstIndex(of: button) != nil {
                    button.alpha = alphaPressed
                } else {
                    button.alpha = alphaUnpressed
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let previousLocation = t.previousLocation(in: self)
            
            for button in [buttonDirUp, buttonDirDown, buttonDirLeft, buttonDirRight] {
                if button.contains(previousLocation) && !button.contains(location) {
                    if let index = pressedButtons.firstIndex(of: button) {
                        pressedButtons.remove(at: index)
                        follow(command: "cancel \(button.name ?? "")")
                    }
                } else if !button.contains(previousLocation) && button.contains(location) && pressedButtons.firstIndex(of: button) == nil {
                    pressedButtons.append(button)
                    follow(command: button.name)
                }
                if pressedButtons.firstIndex(of: button) != nil {
                    button.alpha = alphaPressed
                } else {
                    button.alpha = alphaUnpressed
                }
            }
        }
    }
    
    func touchUp(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            let previousLocation = t.previousLocation(in: self)
            for button in [buttonDirUp, buttonDirDown, buttonDirLeft, buttonDirRight] {
                if let index = pressedButtons.firstIndex(of: button) {
                    pressedButtons.remove(at: index)
                    follow(command: "stop \(button.name ?? "")")
                }
                if pressedButtons.firstIndex(of: button) != nil {
                    button.alpha = alphaPressed
                } else {
                    button.alpha = alphaUnpressed
                }
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches, with: event)
    }
    
    func follow(command: String?) {
        if command == "up" {
            if !isJump {
                isJump = true
                runTimer()
                if let groundPosition = dinoYPosition {
                    if rabbitSprite.position.y < 0 {
                        if rabbitSprite.position.y <= groundPosition && gameNode.speed > 0 {
                            rabbitSprite.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                            rabbitSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: dinoHopForce))
                            if UserInfomation.turnOnSound {
                                run(jumpSound)
                            }
                        }
                    }
                }
            }
           
        } else if command == "down" {
            rabbitSprite.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -dinoHopForce))
//            rabbitSprite.position = CGPoint(x: -frame.width/2+90, y: -frame.height/2 + groundHeight + 16)
        } else if command == "left" {
            let actionMove = SKAction.move(by: CGVector(dx: -50, dy: 0), duration: 0.5)
            rabbitSprite.run(actionMove)
            
        } else if command == "right" {
            let actionMove = SKAction.move(by: CGVector(dx: 50, dy: 0), duration: 0.5)
            rabbitSprite.run(actionMove)
        }
        print("Command: \(command ?? "")")
    }
    
    func setupControls(size: CGSize) {
        addButton(button: buttonDirUp,
                  position: CGPoint(x: frame.width / 2 - 24 - 72, y: -frame.height / 2 + 100),
                  name: "up")
        addButton(button: buttonDirDown,
                  position: CGPoint(x: frame.width / 2 - 24 - 72, y: -frame.height / 2 + 40),
                  name: "down")
        addButton(button: buttonDirLeft,
                  position: CGPoint(x: -frame.width / 2 + 80, y: -frame.height / 2 + 75),
                  name: "left")
        addButton(button: buttonDirRight,
                  position: CGPoint(x: -frame.width / 2 + 140, y: -frame.height / 2 + 75),
                  name: "right")
    }
}

