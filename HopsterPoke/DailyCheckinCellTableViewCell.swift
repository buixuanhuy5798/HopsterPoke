//
//  DailyCheckinCellTableViewCell.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 13/05/2024.
//

import UIKit

struct DailyCheckinInfo {
    let day: Int
    let numberOfCarrots: Int
    
    var title: String {
        return "DAY \(day)\n\(numberOfCarrots) CARROTS"
    }
}

class DailyCheckinCellTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleItem2Label: UILabel!
    @IBOutlet private weak var dailyItem2: UIView!
    @IBOutlet private weak var titleItem1Label: UILabel!
    @IBOutlet private weak var dailyItem1: UIView!
    private var item1: DailyCheckinInfo?
    private var item2: DailyCheckinInfo?
    var didTapCell: ((DailyCheckinInfo) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        dailyItem1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapItem1)))
        dailyItem2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapItem2)))
    }
    
    @objc private func handleTapItem1() {
        if let item = item1 {
            didTapCell?(item)
        }
    }
    
    @objc private func handleTapItem2() {
        if let item = item2 {
            didTapCell?(item)
        }
    }
    
    func setUpView(data: [DailyCheckinInfo]) {
        item1 = nil
        item2 = nil
        let count = UserInfomation.dailyCheckinCount
        if data.count > 1 {
            item1 = data[0]
            item2 = data[1]
            dailyItem2.isHidden = false
            titleItem1Label.attributedText = setTextInput(input: data[0].title)
            dailyItem1.alpha = count >= data[0].day ? 0.5 : 1
            titleItem2Label.attributedText = setTextInput(input: data[1].title)
            dailyItem2.alpha = count >= data[1].day ? 0.5 : 1
        } else {
            item1 = data[0]
            dailyItem1.alpha = count >= data[0].day ? 0.5 : 1
            dailyItem2.isHidden = true
            titleItem1Label.attributedText = setTextInput(input: data[0].title)
        }
    }
    
    func setTextInput(input: String) -> NSAttributedString {
        let strokeTextAttributes = [
             NSAttributedString.Key.strokeColor : UIColor(hexString: "0655AB"),
             NSAttributedString.Key.foregroundColor : UIColor.white,
             NSAttributedString.Key.strokeWidth : -2.0,
             NSAttributedString.Key.font: UIFont(name: "GangOfThree", size: 14)
           ] as [NSAttributedString.Key : Any]
        return NSAttributedString(string: input, attributes: strokeTextAttributes)
    }
}

