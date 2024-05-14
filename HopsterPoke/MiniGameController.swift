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
    var tap = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        purpleImageView.tag = MiniGameItem.purple.rawValue
        blueImageView.tag = MiniGameItem.blue.rawValue
        yellowImageView.tag = MiniGameItem.yellow.rawValue
        greenImageView.tag = MiniGameItem.green.rawValue
        [purpleImageView, blueImageView, yellowImageView, greenImageView].forEach {
            $0?.alpha = 0
            $0?.isUserInteractionEnabled = false
            $0?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapImage(sender:))))
        }
        random = random.shuffled()
        print(random)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationDisplay()
    }
    
    func resetAll() {
        [purpleImageView, blueImageView, yellowImageView, greenImageView].forEach {
            $0?.alpha = 0
            $0?.isUserInteractionEnabled = false
        }
        random = random.shuffled()
        tap = []
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animationDisplay()
        }
    }
    
    @objc private func handleTapImage(sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            if !tap.contains(tag) {
                sender.view?.alpha = 0.5
                tap.append(tag)
                print(tap)
                if tap.count == 4 {
                    if tap == random {
                        resetAll()
                    } else {
                        print("LOSE")
                    }
                }
            }
        }
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
                        [self.purpleImageView, self.blueImageView, self.yellowImageView, self.greenImageView].forEach {
                            $0?.isUserInteractionEnabled = true
                        }
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
