//
//  DailyCheckinView.swift
//  HopsterPoke
//
//  Created by Huy Bùi Xuân on 13/5/24.
//

import UIKit

class DailyCheckinView: UIView {
    private var titleLabel: UILabel = {
        let label = UILabel()
        let labelText = "DAILY"
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
    }
}
