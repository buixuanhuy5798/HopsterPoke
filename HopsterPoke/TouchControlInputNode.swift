//
//  TouchControlInputNode.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 13/05/2024.
//

import SpriteKit

class TouchControlInputNode: SKSpriteNode {
    var alphaUnpressed: CGFloat = 0.5
    var alphaPressed: CGFloat = 0.9
    
    var pressedButtons = [SKSpriteNode]()
    let buttonDirUp = SKSpriteNode(imageNamed: "icon_back_button")
    let buttonDirDown = SKSpriteNode(imageNamed: "icon_back_button")
    let buttonDirLeft = SKSpriteNode(imageNamed: "icon_back_button")
    let buttonDirRight = SKSpriteNode(imageNamed: "icon_next_button")
    
    var inputDelegate: ControlInputDelegate?
    
    init(frame: CGRect) {
        super.init(texture: nil, color: .clear, size: frame.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupControls(size: CGSize) {
        addButton(button: buttonDirLeft,
                  position: CGPoint(x: -(size.width / 3) - 50, y: -size.height / 4),
                  name: "left",
                  scale: 2)
        addButton(button: buttonDirRight,
                  position: CGPoint(x: -(size.width / 3) + 50, y: -size.height / 4),
                  name: "right",
                  scale: 2)
        addButton(button: buttonDirUp,
                  position: CGPoint(x: (size.width / 3), y: -size.height / 4 + 50),
                  name: "up",
                  scale: 2)
        addButton(button: buttonDirDown,
                  position: CGPoint(x: (size.width / 3), y: -size.height / 4 - 50),
                  name: "down",
                  scale: 2)
    }
    
    func addButton(button: SKSpriteNode, position: CGPoint, name: String, scale: CGFloat) {
        button.position = position
        button.setScale(scale)
        button.name = name
        button.zPosition = 10
        button.alpha = alphaUnpressed
        self.addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if let parent = parent {
                let location = t.location(in: parent)
                for button in [buttonDirUp, buttonDirDown, buttonDirLeft, buttonDirRight] {
                    if button.contains(location) && pressedButtons.firstIndex(of: button) == nil {
                        pressedButtons.append(button)
                        if let inputDelegate = inputDelegate {
                            inputDelegate.follow(command: button.name)
                        }
                    }
                    if pressedButtons.firstIndex(of: button) != nil {
                        button.alpha = alphaPressed
                    } else {
                        button.alpha = alphaUnpressed
                    }
                }
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if let parent = parent {
                let location = t.location(in: parent)
                let previousLocation = t.previousLocation(in: parent)
                
                for button in [buttonDirUp, buttonDirDown, buttonDirLeft, buttonDirRight] {
                    if button.contains(previousLocation) && !button.contains(location) {
                        if let index = pressedButtons.firstIndex(of: button) {
                            pressedButtons.remove(at: index)
                            if let inputDelegate = inputDelegate {
                                inputDelegate.follow(command: "cancel \(button.name ?? "")")
                            }
                        }
                    } else if !button.contains(previousLocation) && button.contains(location) && pressedButtons.firstIndex(of: button) == nil {
                        pressedButtons.append(button)
                        if let inputDelegate = inputDelegate {
                            inputDelegate.follow(command: button.name)
                        }
                    }
                    if pressedButtons.firstIndex(of: button) != nil {
                        button.alpha = alphaPressed
                    } else {
                        button.alpha = alphaUnpressed
                    }
                }
            }
        }
    }
    
    func touchUp(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if let parent = parent {
                let location = t.location(in: parent)
                let previousLocation = t.previousLocation(in: parent)
                for button in [buttonDirUp, buttonDirDown, buttonDirLeft, buttonDirRight] {
                    if let index = pressedButtons.firstIndex(of: button) {
                        pressedButtons.remove(at: index)
                        if let inputDelegate = inputDelegate {
                            inputDelegate.follow(command: "stop \(button.name ?? "")")
                        }
                    }
                    if pressedButtons.firstIndex(of: button) != nil {
                        button.alpha = alphaPressed
                    } else {
                        button.alpha = alphaUnpressed
                    }
                }
            }
        }
    }
}

