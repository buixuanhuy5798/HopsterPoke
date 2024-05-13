//
//  OptionView.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 12/05/2024.
//

import UIKit

class OptionView: UIView {
    private var soundLabel: UILabel = {
        let label = UILabel()
        let labelText = "SOUND"
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
    
    private var notiLabel: UILabel = {
        let label = UILabel()
        let labelText = "DAILY NOTIFICATIONS"
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
    
    private var soundButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    private var notifiButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
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
        addSubview(soundLabel)
        soundLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
        addSubview(soundButton)
        soundButton.snp.makeConstraints {
            $0.top.equalTo(soundLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        soundButton.addTarget(self, action: #selector(handleTapSoundButton), for: .touchUpInside)
        addSubview(notiLabel)
        notiLabel.snp.makeConstraints {
            $0.top.equalTo(soundButton.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
        addSubview(notifiButton)
        notifiButton.snp.makeConstraints {
            $0.top.equalTo(notiLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(56)
            $0.height.equalTo(56)
        }
        notifiButton.addTarget(self, action: #selector(handleTapNotiButton), for: .touchUpInside)
        updateStateButton()
    }
    
    private func updateStateButton() {
        soundButton.setImage(UserInfomation.turnOnSound ? UIImage(named: "icon_turn_on") : UIImage(named: "icon_turn_off"), for: .normal)
        notifiButton.setImage(UserInfomation.turnOnDailyNoti ? UIImage(named: "icon_turn_on") : UIImage(named: "icon_turn_off"), for: .normal)
    }
    
    @objc private func handleTapSoundButton() {
        SoundService.shared.playButtonTapSound()
        UserInfomation.turnOnSound.toggle()
        updateStateButton()
    }
    
    @objc private func handleTapNotiButton() {
        SoundService.shared.playButtonTapSound()
        UserInfomation.turnOnDailyNoti.toggle()
        if UserInfomation.turnOnDailyNoti {
            NotificationService.shared.scheduleLocal()
        } else {
            NotificationService.shared.turnOfNoti()
        }
        updateStateButton()
    }
}
