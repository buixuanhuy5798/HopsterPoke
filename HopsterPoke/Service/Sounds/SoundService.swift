//
//  SoundService.swift
//  HopsterPoke
//
//  Created by Huy Bùi Xuân on 13/5/24.
//

import AVFoundation

class SoundService: NSObject {
    static let shared = SoundService()
    
    override init() {
        super.init()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            if let buttonTapUrl = Bundle.main.url(forResource: "button_tap", withExtension: "mp3") {
                self.buttonPlayer = try AVAudioPlayer(contentsOf: buttonTapUrl, fileTypeHint: AVFileType.mp3.rawValue)
            }
            if let miniGameUrl = Bundle.main.url(forResource: "minigametapbutton", withExtension: "mp3") {
                self.minigamePlayer = try AVAudioPlayer(contentsOf: miniGameUrl, fileTypeHint: AVFileType.mp3.rawValue)
            }
            if let miniGameWinUrl = Bundle.main.url(forResource: "minigamewin", withExtension: "mp3") {
                self.minigameWinPlayer = try AVAudioPlayer(contentsOf: miniGameWinUrl, fileTypeHint: AVFileType.mp3.rawValue)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    var buttonPlayer: AVAudioPlayer?
    var minigamePlayer: AVAudioPlayer?
    var minigameWinPlayer: AVAudioPlayer?
    
    func playButtonTapSound() {
        if UserInfomation.turnOnSound {
            DispatchQueue.global().async {
                self.buttonPlayer?.stop()
                self.buttonPlayer?.play()
            }
        }
    }
    
    func playButtonMiniGame() {
        if UserInfomation.turnOnSound {
            DispatchQueue.global().async {
//                self.minigamePlayer?.stop()
                self.minigamePlayer?.play()
            }
        }
    }
    
    func playMinigameWin() {
        if UserInfomation.turnOnSound {
            DispatchQueue.global().async {
//                self.minigamePlayer?.stop()
                self.minigameWinPlayer?.play()
            }
        }
    }
}


