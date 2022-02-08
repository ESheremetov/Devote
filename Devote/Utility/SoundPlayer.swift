//
//  SoundPlayer.swift
//  Devote
//
//  Created by Егор Шереметов on 08.02.2022.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Can't find the media <\(type)> file with path: \(sound)")
        }
    }
}
