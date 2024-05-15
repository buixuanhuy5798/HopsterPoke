//
//  DailyCheckinView.swift
//  HopsterPoke
//
//  Created by Huy Bùi Xuân on 13/5/24.
//

import UIKit

class DailyCheckinViewController: UIViewController {
    private let data: [[DailyCheckinInfo]] = [
        [.init(day: 1, numberOfCarrots: 20),
        .init(day: 2, numberOfCarrots: 35)],
        [.init(day: 3, numberOfCarrots: 45),
        .init(day: 4, numberOfCarrots: 60)],
        [.init(day: 5, numberOfCarrots: 70),
        .init(day: 6, numberOfCarrots: 85)],
        [.init(day: 7, numberOfCarrots: 100)]
    ]
    
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
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.bounces = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(16)
        }
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DailyCheckinCellTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func isGreaterThanLastDayCheckin() -> Bool {
        // Lấy ngày hiện tại
        guard let lastDayCheckin = UserInfomation.lastTimeCheckin else {
            return true
        }
        let calendar = Calendar.current
        if let nextDay = calendar.date(byAdding: .day, value: 1, to: lastDayCheckin) {
            return Date() >= nextDay
        }
        return false
    }
}

extension DailyCheckinViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? DailyCheckinCellTableViewCell else {
            return UITableViewCell()
        }
        cell.setUpView(data: data[indexPath.row])
        cell.didTapCell = { [weak self] data in
            if UserInfomation.dailyCheckinCount + 1 == data.day && self?.isGreaterThanLastDayCheckin() == true {
                UserInfomation.lastTimeCheckin = Date()
                UserInfomation.dailyCheckinCount += 1
                UserInfomation.numberOfCarrots += data.numberOfCarrots
                self?.tableView.reloadData()
            }
        }
        return cell
    }
}
