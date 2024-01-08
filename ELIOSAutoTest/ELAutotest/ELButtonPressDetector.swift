//
//  ELButtonPressDetector.swift
//  ELIOSAutoTest
//
//  Created by jack on 16.11.2023.
//

import UIKit
import AVFAudio

// todo weak delegates
// volumeIncreased/volumeDecreased
// silentMode

// dirty, dirty cheats of the world
protocol ELButtonPressDetectorDelegage: AnyObject {
//    func volumeIncreased(_ value: Float)
//    func volumeDecreased(_ value: Float)
    func volumeChanged(_ value: Float)
}

//extension ELButtonPressDetectorDelegage {
//    func volumeIncreased(_ value: Float) { }
//    func volumeDecreased(_ value: Float) { }
//    func volumeChanged(_ value: Float) { }
//}

class ELButtonPressDetector: NSObject {
    static var currentVolume: Float = 0.0
    
    private static var detectVolumeChangeTimer: Timer?
    private static var delegates: [ELButtonPressDetectorDelegage] = []
    
    private static func start() {
        if detectVolumeChangeTimer == nil {
            currentVolume = AVAudioSession.sharedInstance().outputVolume
            detectVolumeChangeTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        }
    }
    
    private static func stop() {
        detectVolumeChangeTimer?.invalidate()
        detectVolumeChangeTimer = nil
    }
    
    @objc private static func timerFired() {
        let newValue = AVAudioSession.sharedInstance().outputVolume
        if ELButtonPressDetector.currentVolume != newValue {
            ELButtonPressDetector.currentVolume = newValue
            for listener in delegates {
                listener.volumeChanged(newValue)
            }
        }
    }
    
    static func addRetainedListener(_ obj: ELButtonPressDetectorDelegage) {
        delegates.append(obj)
        start()
    }
    
    static func removeListener (_ obj: ELButtonPressDetectorDelegage) {
        delegates.removeAll{$0 === obj}
        if delegates.isEmpty {
            stop()
        }
    }
}
