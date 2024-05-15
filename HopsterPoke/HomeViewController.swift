//
//  HomeViewController.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 11/05/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var dailyCheckinView: UIView!
    @IBOutlet weak var betView: BetView!
    @IBOutlet weak var optionView: OptionView!
    @IBOutlet weak var menuView: MenuView!
    @IBOutlet weak var instructionView: InstructionView!
    @IBOutlet weak var homeView: UIView!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordLabel.font = UIFont(name: "GangOfThree", size: 30)
        recordLabel.textColor = UIColor(hexString: "0655AB")
        titleLabel.font = UIFont(name: "GangOfThree", size: 30)
        titleLabel.textColor = UIColor(hexString: "0655AB")
        homeView.isHidden = false
        betView.tag = MenuButton.playGame.rawValue
        dailyCheckinView.tag = MenuButton.daily.rawValue
        optionView.tag = MenuButton.setting.rawValue
        instructionView.tag = MenuButton.instructions.rawValue
        homeView.tag = MenuButton.home.rawValue
        menuView.didChangeTab = { [weak self] state in
            self?.updateView(state: state)
        }
        betView.didTapPlay = { [weak self] bet in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {
                return
            }
            vc.point = bet
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = DailyCheckinViewController()
        dailyCheckinView.addSubview(vc.view)
        vc.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        addChild(vc)
        if UserInfomation.firstLauchApp {
            let descriptionView = GameWarningView()
            view.addSubview(descriptionView)
            descriptionView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        reloadContent()
        NotificationCenter.default.addObserver(self, selector: #selector(gameOverTapMenu), name: Notification.Name("TapMenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(gameOverTapBet), name: Notification.Name("TapBet"), object: nil)
    }
    
    @objc private func gameOverTapBet() {
        menuView.currentSelection = .playGame
        updateView(state: .playGame)
//        betView.reloadData()
    }
    
    @objc private func gameOverTapMenu() {
        menuView.currentSelection = .home
        updateView(state: .home)
    }
    
    func reloadContent() {
        titleLabel.text = "BALANCE: \(UserInfomation.numberOfCarrots)"
    }
    
    private func updateView(state: MenuButton) {
        [betView, optionView, instructionView, dailyCheckinView, homeView].forEach {
            if state == .instructions {
                instructionView.resetContent()
            }
            if state == .home {
                reloadContent()
            }
            if $0.tag == state.rawValue {
                $0.isHidden = false
            } else {
                $0.isHidden = true
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension HomeViewController {
}
