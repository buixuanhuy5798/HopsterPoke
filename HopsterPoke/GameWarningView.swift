//
//  GameWarningView.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 12/05/2024.
//

import UIKit

class GameWarningView: UIView {
    
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "description_game_image")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let labelText = "The game does not involve a casino and purchasable game currency with real money. The whole game is based on gamification and fun."
        let strokeTextAttributes = [
            NSAttributedString.Key.strokeColor : UIColor.white,
            NSAttributedString.Key.foregroundColor : UIColor(hexString: "0655AB"),
            NSAttributedString.Key.strokeWidth : -2.0,
            NSAttributedString.Key.font: UIFont(name: "GangOfThree", size: 25)
        ] as [NSAttributedString.Key : Any]
        label.attributedText = NSAttributedString(string: labelText, attributes: strokeTextAttributes)
        label.textAlignment = .center
        return label
    }()
    
    private var okeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "oke_button_image"), for: .normal)
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
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
        }
        addSubview(okeButton)
        okeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentLabel.snp.bottom).offset(16)
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        okeButton.addTarget(self, action: #selector(handleTapOkeButton), for: .touchUpInside)
    }
    
    @objc private func handleTapOkeButton() {
        UserInfomation.firstLauchApp = false
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
        }, completion: { (finished: Bool) in
            if finished {
                self.removeFromSuperview()
            }
        })
    }
}
