//
//  MiniGameController.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 14/05/2024.
//

import UIKit

enum MiniGameLevel {
    case level1
    case level2
    case level3
}

struct LevelInfo {
    let time: Int
    let rate: Int
}

enum MiniGameItem: Int {
    case yellow = 1000
    case purple = 1001
    case green = 1002
    case blue = 1003
}

class MiniGameController: UIViewController {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var poupView: UIView!
    @IBOutlet weak var blueImageView: UIImageView!
    @IBOutlet weak var purpleImageView: UIImageView!
    @IBOutlet weak var greenImageView: UIImageView!
    @IBOutlet weak var yellowImageView: UIImageView!
    
    var result: ((Int) -> Void)?
    
    var timer: Timer?
    var random = [1000, 1001, 1002, 1003]
    var tap = [Int]()
    var level = MiniGameLevel.level1
    var remainTime = 0
    var rate = 1
    var duration = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        purpleImageView.tag = MiniGameItem.purple.rawValue
        blueImageView.tag = MiniGameItem.blue.rawValue
        yellowImageView.tag = MiniGameItem.yellow.rawValue
        greenImageView.tag = MiniGameItem.green.rawValue
        [purpleImageView, blueImageView, yellowImageView, greenImageView].forEach {
            $0?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapImage(sender:))))
        }
        resetAll()
    }
    
    func startGame() {
        countDownLabel.attributedText = setTextInput(input: "\(remainTime) SEC", size: 30)
        rateLabel.attributedText = setTextInput(input: "X\(rate)", size: 30)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animationDisplay()
        }
    }
    
    func gameOver() {
        print("LOSE")
        timer?.invalidate()
        result?(1)
        dismiss(animated: true)
    }
    
    @objc private func timerAction() {
        remainTime -= 1
        countDownLabel.attributedText = setTextInput(input: "\(remainTime) SEC", size: 30)
        if remainTime == 0 {
            gameOver()
        }
    }
    
    func resetAll() {
        [purpleImageView, blueImageView, yellowImageView, greenImageView].forEach {
            $0?.alpha = 0
            $0?.isUserInteractionEnabled = false
            print("SET FAIL")
        }
        random = random.shuffled()
        tap = []
        timer?.invalidate()
        switch level {
        case .level1:
            duration = 0.5
            remainTime = 10
            rate = 2
        case .level2:
            duration = 0.35
            remainTime = 5
            rate = 3
        case .level3:
            duration = 0.2
            remainTime = 3
            rate = 4
        }
        poupView.isHidden = true
        poupView.alpha = 0
        startGame()
    }
    
    @objc private func handleTapImage(sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            if !tap.contains(tag) {
                SoundService.shared.playButtonMiniGame()
                sender.view?.alpha = 0.5
                tap.append(tag)
                print(tap)
                if tap.count == 4 {
                    timer?.invalidate()
                    if tap == random {
                        if level == .level3 {
                            SoundService.shared.playMinigameWin()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                SoundService.shared.playMinigameWin()
                            }
                            result?(4)
                            dismiss(animated: true)
                        } else {
                            SoundService.shared.playMinigameWin()
                            showWinPopup()
                        }
                    } else {
                        gameOver()
                    }
                }
            }
        }
    }
    
    func showWinPopup() {
        poupView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.poupView.alpha = 1
        }
    }
    
    private func animationDisplay() {
        UIView.animate(withDuration: duration) {
            self.displayView(tag: self.random[0])
        } completion: { _ in
            UIView.animate(withDuration: self.duration) {
                self.displayView(tag: self.random[1])
            } completion: { _ in
                UIView.animate(withDuration: self.duration) {
                    self.displayView(tag: self.random[2])
                } completion: { _ in
                    UIView.animate(withDuration: self.duration) {
                        self.displayView(tag: self.random[3])
                        [self.purpleImageView, self.blueImageView, self.yellowImageView, self.greenImageView].forEach {
                            $0?.isUserInteractionEnabled = true
                            print("SET")
                        }
                    } completion: { _ in
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                    }
                }
            }
        }
    }
    
    @IBAction func handleTapBack(_ sender: Any) {
        switch level {
        case .level1:
            result?(2)
        case .level2:
            result?(3)
        case .level3:
            result?(4)
        }
        dismiss(animated: true)
    }
    
    @IBAction func handleTapNext(_ sender: Any) {
        switch level {
        case .level1:
            level = .level2
        case .level2:
            level = .level3
        case .level3:
            return
        }
        resetAll()
    }
    
    private func displayView(tag: Int) {
        if let foundView = view.viewWithTag(tag) {
            foundView.alpha = 1
        }
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
}
