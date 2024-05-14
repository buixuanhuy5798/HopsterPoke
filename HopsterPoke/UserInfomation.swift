//
//  UserInfomation.swift
//  HopsterPoke
//
//  Created by buixuanhuy on 12/05/2024.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct UserInfomation {
    @UserDefault("first_launch_app", defaultValue: true)
    static var firstLauchApp: Bool

    @UserDefault("turn_on_sound", defaultValue: true)
    static var turnOnSound: Bool
    
    @UserDefault("turn_on_daily_noti", defaultValue: true)
    static var turnOnDailyNoti: Bool
    
    @UserDefault("daily_checkin_count", defaultValue: 0)
    static var dailyCheckinCount: Int
    
    @UserDefault("number_of_carrots", defaultValue: 0)
    static var numberOfCarrots: Int
    
    @UserDefault("last_time_checkin", defaultValue: nil)
    static var lastTimeCheckin: Date?
}
