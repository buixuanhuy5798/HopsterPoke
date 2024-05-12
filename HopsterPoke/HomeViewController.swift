//
//  HomeViewController.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 11/05/2024.
//

import UIKit

class HomeViewController: UIViewController {
    
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
        optionView.tag = MenuButton.setting.rawValue
        instructionView.tag = MenuButton.instructions.rawValue
        homeView.tag = MenuButton.home.rawValue
        menuView.didChangeTab = { [weak self] state in
            self?.updateView(state: state)
        }
        betView.didTapPlay = { [weak self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {
                return
            }
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }
        if UserInfomation.firstLauchApp {
            let descriptionView = GameWarningView()
            view.addSubview(descriptionView)
            descriptionView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    private func updateView(state: MenuButton) {
        [betView, optionView, instructionView, homeView].forEach {
            if state == .instructions {
                instructionView.resetContent()
            }
            if $0.tag == state.rawValue {
                $0.isHidden = false
            } else {
                $0.isHidden = true
            }
        }
    }
}

extension HomeViewController {
}
