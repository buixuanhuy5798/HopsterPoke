//
//  BetView.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 12/05/2024.
//

import UIKit

class BetView: UIView {
    var didTapPlay: (() -> Void)?
    
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
            $0.top.equalTo(carrotImageView.snp.bottom).offset(-16)
            $0.height.equalTo(56)
            $0.width.equalTo(164)
            $0.centerX.equalToSuperview()
        }
        playButton.addTarget(self, action: #selector(handleTapPlayButton), for: .touchUpInside)
    }
     
    @objc private func handleTapPlayButton() {
        didTapPlay?()
    }
}
