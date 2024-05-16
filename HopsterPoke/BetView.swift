//
//  BetView.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 12/05/2024.
//

import UIKit

class BetView: UIView {
    var didTapPlay: ((Int) -> Void)?
    
    private var betNumber = 1  {
        didSet {
            setTextInput()
        }
    }
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        let labelText = "BET"
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
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let labelText = "If you don't have enough carrots to play, then you can come the next day and take the reward from the Daily (it will be bigger every day, so come back more often). In order not to forget, you can put a notification on the Options screen."
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.white,
            NSAttributedString.Key.foregroundColor : UIColor(hexString: "0655AB"),
            NSAttributedString.Key.strokeWidth : -2.0,
            NSAttributedString.Key.font: UIFont(name: "GangOfThree", size: 15)
        ] as [NSAttributedString.Key : Any]
        label.attributedText = NSAttributedString(string: labelText, attributes: strokeTextAttributes)
        return label
    }()
    
    private var numberOfCarrotsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    private var carrotIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "icon_carrot")
        return imageView
    }()
    
    private var carrotImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "carrot_image")
        return imageView
    }()
    
    private var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "play_button"), for: .normal)
        return button
    }()
    
    private var bounderUpdateCarrotView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private var subtractButton: UIButton = {
        let button = UIButton()
        button.isMultipleTouchEnabled = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "subtract_button"), for: .normal)
        return button
    }()
    
    private var addButton: UIButton = {
        let button = UIButton()
        button.isMultipleTouchEnabled = false
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "add_button"), for: .normal)
        return button
    }()
    
    private var bounderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "bounder_input_image")
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
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
        addSubview(carrotImageView)
        carrotImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(150)
        }
        addSubview(playButton)
        playButton.snp.makeConstraints {
            $0.top.equalTo(carrotImageView.snp.bottom).offset(-24)
            $0.height.equalTo(56)
            $0.width.equalTo(164)
            $0.centerX.equalToSuperview()
        }
        playButton.addTarget(self, action: #selector(handleTapPlayButton), for: .touchUpInside)
        addSubview(bounderUpdateCarrotView)
        bounderUpdateCarrotView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(playButton.snp.bottom).offset(32)
        }
        bounderUpdateCarrotView.addSubview(subtractButton)
        subtractButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(12)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
        bounderUpdateCarrotView.addSubview(numberOfCarrotsLabel)
        numberOfCarrotsLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(subtractButton.snp.trailing).offset(12)
        }
        bounderUpdateCarrotView.addSubview(carrotIconImageView)
        carrotIconImageView.snp.makeConstraints {
            $0.centerY.equalTo(numberOfCarrotsLabel).offset(-2)
            $0.leading.equalTo(numberOfCarrotsLabel.snp.trailing).offset(4)
            $0.width.equalTo(16)
            $0.height.equalTo(26)
        }
        bounderUpdateCarrotView.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(carrotIconImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(12)
            $0.width.equalTo(40)
            $0.height.equalTo(40)
        }
        bounderUpdateCarrotView.insertSubview(bounderImageView, at: 0)
        bounderImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        subtractButton.addTarget(self, action: #selector(handleTapSubtractButton), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(handleTapAddButton), for: .touchUpInside)
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(bounderUpdateCarrotView.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
        setTextInput()
    }
    
    @objc private func handleTapAddButton() {
        SoundService.shared.playButtonTapSound()
        betNumber += 1
    }
    
    @objc private func handleTapSubtractButton() {
        SoundService.shared.playButtonTapSound()
        if betNumber >= 2 {
            betNumber -= 1
        }
    }
    
    func setTextInput() {
        let strokeTextAttributes = [
             NSAttributedString.Key.strokeColor : UIColor.white,
             NSAttributedString.Key.foregroundColor : UIColor(hexString: "0655AB"),
             NSAttributedString.Key.strokeWidth : -2.0,
             NSAttributedString.Key.font: UIFont(name: "GangOfThree", size: 23)
           ] as [NSAttributedString.Key : Any]
        numberOfCarrotsLabel.attributedText = NSAttributedString(string: "\(betNumber)", attributes: strokeTextAttributes)
    }
    
    func reloadData() {
        betNumber = 1
        setTextInput()
    }
     
    @objc private func handleTapPlayButton() {
        if betNumber == 0 || UserInfomation.numberOfCarrots < betNumber {
            return
        }
        SoundService.shared.playButtonTapSound()
        didTapPlay?(betNumber)
    }
}
