//
//  MiniGameController.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 14/05/2024.
//

import UIKit

enum MiniGameItem: Int {
    case yellow = 1000
    case purple = 1001
    case green = 1002
    case blue = 1003
}

class MiniGameController: UIViewController {

    @IBOutlet weak var blueImageView: UIImageView!
    @IBOutlet weak var purpleImageView: UIImageView!
    @IBOutlet weak var greenImageView: UIImageView!
    @IBOutlet weak var yellowImageView: UIImageView!
    var random = [1000, 1001, 1002, 1003]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        purpleImageView.tag = MiniGameItem.purple.rawValue
        blueImageView.tag = MiniGameItem.blue.rawValue
        yellowImageView.tag = MiniGameItem.yellow.rawValue
        greenImageView.tag = MiniGameItem.green.rawValue
        [purpleImageView, blueImageView, yellowImageView, greenImageView].forEach {
            $0.alpha = 0
        }
        random = random.shuffled()
        print(random)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationDisplay()
    }
    
    private func animationDisplay() {
        UIView.animate(withDuration: 0.5) {
            self.displayView(tag: self.random[0])
        } completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.displayView(tag: self.random[1])
            } completion: { _ in
                UIView.animate(withDuration: 0.5) {
                    self.displayView(tag: self.random[2])
                } completion: { _ in
                    UIView.animate(withDuration: 0.5) {
                        self.displayView(tag: self.random[3])
                    }
                }
            }
        }
    }
    
    private func displayView(tag: Int) {
        if let foundView = view.viewWithTag(tag) {
            foundView.alpha = 1
        }
    }
}
