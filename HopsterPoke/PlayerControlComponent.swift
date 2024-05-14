////
////  PlayerControlComponent.swift
////  HopsterPoke
////
////  Created by buixuanhuy on 13/05/2024.
////
//
//import SpriteKit
//import GameplayKit
//
//class PlayerControlComponent: GKComponent, ControlInputDelegate {
//    var touchControlNode: TouchControlInputNode?
//    
//    func setupControls(camera: SKCameraNode, scene: SKScene)  {
//        touchControlNode = TouchControlInputNode(frame: scene.frame)
//        touchControlNode?.inputDelegate = self
//        touchControlNode?.position = CGPoint.zero
//        camera.addChild(touchControlNode!)
//    }
//    
//    func follow(command: String?) {
//        print("Command: \(command ?? "")")
//    }
//}
//
//
//
//class GameScene: SKScene {
//    let buttonDirUp = SKSpriteNode(imageNamed: "icon_back_button")
//    let buttonDirDown = SKSpriteNode(imageNamed: "icon_back_button")
//    let buttonDirLeft = SKSpriteNode(imageNamed: "icon_back_button")
//    let buttonDirRight = SKSpriteNode(imageNamed: "icon_next_button")
//    var backgroundNode: SKNode!
//    var rabbitNode: SKNode!
//    var rabbitSprite: SKSpriteNode!
//    var gameNode: SKNode!
//    var cameraNode: SKCameraNode!
//    
//    var pressedButtons = [SKSpriteNode]()
//    var dinoYPosition: CGFloat?
//    var groundHeight: CGFloat = 350
//    var groundWidth: CGFloat = 1717
//    
//    var alphaUnpressed: CGFloat = 0.5
//    var alphaPressed: CGFloat = 0.9
//    
//    let background: CGFloat = 0
//    let foreground: CGFloat = 1
//    
//    let groundCategory = 1 << 0 as UInt32
//    let dinoCategory = 1 << 1 as UInt32
//    
//    override func didMove(to view: SKView) {
//        createRabbit()
//        createBackground()
//        setupControls(size: UIScreen.main.bounds.size)
//        addCollisionToGround()
//        createCamera()
//    }
//    
//    override func update(_ currentTime: TimeInterval) {
//         // Cập nhật vị trí của camera để theo dõi nhân vật
//         cameraNode.position = rabbitSprite.position
//     }
//    
//    func createCamera() {
//        cameraNode = SKCameraNode()
//        camera = cameraNode
//        addChild(cameraNode)
//        // Đặt camera để theo dõi nhân vật
////        cameraNode.position = rabbitNode.positionx
//    }
//    
//    func addCollisionToGround() {
//        let groundContactNode = SKNode()
//        groundContactNode.position = CGPoint(x: 0, y: -frame.size.height/2 + groundHeight/2)
//        groundContactNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: groundWidth * 2,
//                                                                          height: groundHeight))
//        groundContactNode.physicsBody?.friction = 0.0
//        groundContactNode.physicsBody?.isDynamic = false
//        groundContactNode.physicsBody?.categoryBitMask = groundCategory
//        backgroundNode.addChild(groundContactNode)
//    }
//    
//    func createBackground() {
//        backgroundNode = SKNode()
//        backgroundNode.zPosition = background
//        let groundTexture = SKTexture(imageNamed: "underground_background")
//        let numberOfGroundNodes = 2
//        for i in 0 ..< numberOfGroundNodes {
//            let node = SKSpriteNode(texture: groundTexture)
//            node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//            node.position = CGPoint(x: CGFloat(i) * groundWidth, y: -frame.size.height/2 + groundHeight/2)
//            node.size = CGSize(width: groundWidth, height: groundHeight)
//            backgroundNode.addChild(node)
//        }
//        gameNode = SKNode()
//        gameNode.addChild(backgroundNode)
//        gameNode.addChild(rabbitNode)
//        self.addChild(gameNode)
//    }
//    
//    func createRabbit() {
//        rabbitNode = SKNode()
//        rabbitNode.zPosition = foreground
//        let rabbitTexture = SKTexture(imageNamed: "rabbit_go_ahead")
//        rabbitTexture.filteringMode = .nearest
//        rabbitSprite = SKSpriteNode()
//        rabbitSprite.texture = rabbitTexture
//        rabbitSprite.size = CGSize(width: 110, height: 110)
//        let physicsBox = CGSize(width: 110, height: 110)
//        rabbitSprite.physicsBody?.isDynamic = true
//        rabbitSprite.physicsBody?.mass = 1.0
//        rabbitSprite.physicsBody = SKPhysicsBody(rectangleOf: physicsBox)
//        dinoYPosition = groundHeight + 110
//        rabbitSprite.position = CGPoint(x: -frame.width/2+150, y: -frame.size.height/2 + 400)
////        rabbitSprite.physicsBody?.categoryBitMask = dinoCategory
//        rabbitSprite.physicsBody?.collisionBitMask = groundCategory
//        rabbitNode.addChild(rabbitSprite)
//    }
//    
//    func setupControls(size: CGSize) {
//        addButton(button: buttonDirLeft,
//                  position: CGPoint(x: -(size.width / 3) - 50, y: -size.height / 4 - 250),
//                  name: "left",
//                  scale: 2)
//        addButton(button: buttonDirRight,
//                  position: CGPoint(x: -(size.width / 3) + 50, y: -size.height / 4 - 250),
//                  name: "right",
//                  scale: 2)
//        addButton(button: buttonDirUp,
//                  position: CGPoint(x: (size.width / 3), y: -size.height / 4 - 200),
//                  name: "up",
//                  scale: 2)
//        addButton(button: buttonDirDown,
//                  position: CGPoint(x: (size.width / 3), y: -size.height / 4 - 300),
//                  name: "down",
//                  scale: 2)
//    }
//    
//    func addButton(button: SKSpriteNode, position: CGPoint, name: String, scale: CGFloat) {
//        button.position = position
//        button.setScale(scale)
//        button.name = name
//        button.zPosition = 10
//        button.alpha = alphaUnpressed
//        self.addChild(button)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches {
//            let location = t.location(in: self)
//            for button in [buttonDirUp, buttonDirDown, buttonDirLeft, buttonDirRight] {
//                if button.contains(location) && pressedButtons.firstIndex(of: button) == nil {
//                    pressedButtons.append(button)
//                    follow(command: button.name)
//                }
//                if pressedButtons.firstIndex(of: button) != nil {
//                    button.alpha = alphaPressed
//                } else {
//                    button.alpha = alphaUnpressed
//                }
//            }
//        }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches {
//            let location = t.location(in: self)
//            let previousLocation = t.previousLocation(in: self)
//            
//            for button in [buttonDirUp, buttonDirDown, buttonDirLeft, buttonDirRight] {
//                if button.contains(previousLocation) && !button.contains(location) {
//                    if let index = pressedButtons.firstIndex(of: button) {
//                        pressedButtons.remove(at: index)
//                        follow(command: "cancel \(button.name ?? "")")
//                    }
//                } else if !button.contains(previousLocation) && button.contains(location) && pressedButtons.firstIndex(of: button) == nil {
//                    pressedButtons.append(button)
//                    follow(command: button.name)
//                }
//                if pressedButtons.firstIndex(of: button) != nil {
//                    button.alpha = alphaPressed
//                } else {
//                    button.alpha = alphaUnpressed
//                }
//            }
//        }
//    }
//    
//    func touchUp(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches {
//            let location = t.location(in: self)
//            let previousLocation = t.previousLocation(in: self)
//            for button in [buttonDirUp, buttonDirDown, buttonDirLeft, buttonDirRight] {
//                if let index = pressedButtons.firstIndex(of: button) {
//                    pressedButtons.remove(at: index)
//                    follow(command: "stop \(button.name ?? "")")
//                }
//                if pressedButtons.firstIndex(of: button) != nil {
//                    button.alpha = alphaPressed
//                } else {
//                    button.alpha = alphaUnpressed
//                }
//            }
//        }
//        
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        touchUp(touches, with: event)
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        touchUp(touches, with: event)
//    }
//    
//    func follow(command: String?) {
//        if command == "right" {
//            rabbitSprite.physicsBody?.applyImpulse(CGVector(dx: 50, dy: 0))
//        }
//        print("Command: \(command ?? "")")
//    }
//}
