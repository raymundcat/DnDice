//
//  DiceSounds.swift
//  DnDice
//
//  Created by John Raymund Catahay on 07/04/2017.
//  Copyright © 2017 John Raymund Catahay. All rights reserved.
//

import Foundation

enum DiceSound{
    case Rolling
    case Finished
    case Pop
}

enum SoundExtension: String{
    case MP3 = "mp3"
}

class DiceSoundPaths{
    static func getPath(forSound sound: DiceSound) -> URL{
        switch sound {
        case .Rolling:
            return SoundFileHelper.getMP3Path(withName: "ticker", ext: .MP3)!
        case .Finished:
            return SoundFileHelper.getMP3Path(withName: "bell", ext: .MP3)!
        case .Pop:
            return SoundFileHelper.getMP3Path(withName: "pop", ext: .MP3)!
        }
    }
}

class SoundFileHelper{
    static func getMP3Path(withName name: String, ext: SoundExtension) -> URL?{
        return Bundle.main.url(forResource: name, withExtension: ext.rawValue)
    }
}

protocol Soundable {
    func play(url: URL)
    func pause()
}

protocol BoardSoundable: Soundable {
    func playRollSound()
    func playFinishedSound()
}

protocol StaticSoundable: Soundable {
    func playPop()
}
