//
//  TimerService.swift
//  Smack
//
//  Created by Jim Long on 3/21/18.
//  Copyright © 2018 Jim Long. All rights reserved.
//

import UIKit

class TimerService {
    static let instance = TimerService()
    
    public private(set) var timeoutInSeconds = TimeInterval(INACTIVITY_TIMEOUT_IN_SECONDS)
    private var idleTimer: Timer?
    
    func cancelIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }
    }
    
    func resetIdleTimer() {
        cancelIdleTimer()
        
        idleTimer = Timer.scheduledTimer(timeInterval: timeoutInSeconds,
                                         target: self,
                                         selector: #selector(TimerService.timerExpired),
                                         userInfo: nil,
                                         repeats: false)
    }
    
    @objc private func timerExpired() {
        NotificationCenter.default.post(name: NOTIF_TIMER_EXPIRED, object: nil)
    }
    
    
    
}
