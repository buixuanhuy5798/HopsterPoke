//
//  MenuView.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 12/05/2024.
//

import UIKit
import SnapKit

enum MenuButton: Int {
    case playGame = 0
    case setting = 1
    case instructions = 2
    case daily = 3
    case home = 4
}

class MenuView: UIView {
    var didChangeTab: ((MenuButton) -> ())?
    
    var currentSelection = MenuButton.home {
        didSet {
            updateMenu()
        }
    }
    
    private var playGameButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_play_game"), for: .normal)
        button.backgroundColor = .clear
        button.tag = MenuButton.playGame.rawValue
        return button
    }()
    
    private var settingButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_setting"), for: .normal)
        button.backgroundColor = .clear
        button.tag = MenuButton.setting.rawValue
        return button
    }()
    
    private var instructionsButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_instruction"), for: .normal)
        button.backgroundColor = .clear
        button.tag = MenuButton.instructions.rawValue
        return button
    }()
    
    private var dailyButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_daily"), for: .normal)
        button.backgroundColor = .clear
        button.tag = MenuButton.daily.rawValue
        return button
    }()
    
    private var homeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_home"), for: .normal)
        button.backgroundColor = .clear
        button.tag = MenuButton.home.rawValue
        return button
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    private func setUpView() {
        backgroundColor = .clear
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.axis = .horizontal
        stackView.addArrangedSubview(playGameButton)
        stackView.addArrangedSubview(settingButton)
        stackView.addArrangedSubview(instructionsButton)
        stackView.addArrangedSubview(dailyButton)
        stackView.addArrangedSubview(homeButton)
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        [playGameButton, settingButton, instructionsButton, dailyButton, homeButton].forEach {

            $0.addTarget(self, action: #selector(handleTapButton), for: .touchUpInside)
        }
        updateMenu()
    }
    
    @objc private func handleTapButton(_ sender: UIButton) {
        SoundService.shared.playButtonTapSound()
        if let state = MenuButton(rawValue: sender.tag) {
            currentSelection = state
            didChangeTab?(currentSelection)
        }
    }
    
    private func updateMenu() {
        [playGameButton, settingButton, instructionsButton, dailyButton, homeButton].forEach {
            if $0.tag == currentSelection.rawValue {
                $0.alpha = 1
            } else {
                $0.alpha = 0.5
            }
        }
        
    }
}
