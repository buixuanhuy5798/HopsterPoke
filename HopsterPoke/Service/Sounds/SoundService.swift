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
        guard let url = Bundle.main.url(forResource: "button_tap", withExtension: "mp3") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            self.buttonPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    var buttonPlayer: AVAudioPlayer?
    
    func playButtonTapSound() {
        if UserInfomation.turnOnSound {
            DispatchQueue.global().async {
                self.buttonPlayer?.stop()
                self.buttonPlayer?.play()
            }
        }
    }
}


