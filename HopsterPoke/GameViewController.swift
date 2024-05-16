//
//  GameViewController.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 09/05/2024.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var numberOfCarrotsLabel: UILabel!
    
    var point = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.gameDelegate = self
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
        }
        gameOverView.isHidden = true
        gameOverView.alpha = 0
        numberOfCarrotsLabel.attributedText = setTextInput(input: "\(point)", size: 22)
        
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setTextInput(input: String, size: CGFloat) -> NSAttributedString {
        let strokeTextAttributes = [
             NSAttributedString.Key.strokeColor : UIColor.white,
             NSAttributedString.Key.foregroundColor : UIColor(hexString: "0655AB"),
             NSAttributedString.Key.strokeWidth : -2.0,
             NSAttributedString.Key.font: UIFont(name: "GangOfThree", size: size)
           ] as [NSAttributedString.Key : Any]
        return NSAttributedString(string: input, attributes: strokeTextAttributes)
    }
    
    @IBAction func handleTapMenuButton(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("TapMenu"), object: nil)
        dismiss(animated: true)
    }
    
    @IBAction func handleTapBetButton(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("TapBet"), object: nil)
        dismiss(animated: true)
    }
}

extension GameViewController: GameDelegate {
    func gameOver() {
        print("GAME OVERRRRR")
        UserInfomation.numberOfCarrots -= point
        gameOverLabel.attributedText = setTextInput(input: "GAME OVER", size: 30)
        gameOverView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.gameOverView.alpha = 1
        }
    }
    
    func gameWin() {
        print("GAME WINNNN")
        UserInfomation.numberOfCarrots += point
        if point > UserInfomation.record {
            UserInfomation.record = point
        }
        gameOverLabel.attributedText = setTextInput(input: "WIN", size: 30)
        gameOverView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.gameOverView.alpha = 1
        }
    }
    
    func showMinigame() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "MiniGameController") as? MiniGameController else {
            return
        }
        present(vc, animated: true)
    }
}
