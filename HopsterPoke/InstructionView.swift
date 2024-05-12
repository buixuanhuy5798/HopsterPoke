//
//  InstructionView.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 12/05/2024.
//

import UIKit
import SnapKit

class InstructionView: UIView {
    private var currentPage = 1 {
        didSet {
            updateView()
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        let labelText = "INSTRUCTIONS"
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.white,
            NSAttributedString.Key.foregroundColor : UIColor(hexString: "0655AB"),
            NSAttributedString.Key.strokeWidth : -2.0,
            NSAttributedString.Key.font: UIFont(name: "GangOfThree", size: 30)
        ] as [NSAttributedString.Key : Any]
        label.attributedText = NSAttributedString(string: labelText, attributes: strokeTextAttributes)
        label.textAlignment = .center
        return label
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private var nextButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_next_button"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private var backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "icon_back_button"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private var instructionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        nextButton.addTarget(self, action: #selector(handleTapNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(handleTapBackButton), for: .touchUpInside)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
        addSubview(instructionImageView)
        instructionImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(instructionImageView.snp.width)
        }
        addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(instructionImageView.snp.bottom).offset(16)
            $0.height.equalTo(56)
            $0.width.equalTo(56)
        }
        addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(instructionImageView.snp.bottom).offset(16)
            $0.height.equalTo(56)
            $0.width.equalTo(56)
        }
        updateView()
    }
    
    @objc private func handleTapNextButton() {
        if currentPage < 3 {
            currentPage += 1
        }
    }
    
    @objc private func handleTapBackButton() {
        if currentPage > 1 {
            currentPage -= 1
        }
    }
    
    private func updateView() {
        if currentPage == 1 {
            subTitleLabel.attributedText = getSubTitleText(input: "BET")
            backButton.isHidden = true
            nextButton.isHidden = false
            instructionImageView.image = UIImage(named: "instruction_bet")
        } else if currentPage == 2 {
            subTitleLabel.attributedText = getSubTitleText(input: "GAME")
            backButton.isHidden = false
            nextButton.isHidden = false
            instructionImageView.image = UIImage(named: "instruction_game")
        } else {
            subTitleLabel.attributedText = getSubTitleText(input: "MINI GAME")
            backButton.isHidden = false
            nextButton.isHidden = true
            instructionImageView.image = UIImage(named: "instruction_minigame")
        }
    }
    
    private func getSubTitleText(input: String) -> NSAttributedString {
        let strokeTextAttributes = [
             NSAttributedString.Key.strokeColor : UIColor.white,
             NSAttributedString.Key.foregroundColor : UIColor(hexString: "0655AB"),
             NSAttributedString.Key.strokeWidth : -2.0,
             NSAttributedString.Key.font: UIFont(name: "GangOfThree", size: 20)
           ] as [NSAttributedString.Key : Any]
        return NSAttributedString(string: input, attributes: strokeTextAttributes)
    }
    
    func resetContent() {
        currentPage = 1
    }
}
