//
//  ListenToNotificationPublisher.swift
//  CombineExamples
//
//  Created by Shalom Friss on 10/11/21.
//

import Foundation
import Combine

class Timers {
    var cancellable:Cancellable?
    
    init() {
        let runloop = RunLoop.main
        cancellable = runloop.schedule(after: runloop.now, interval: .seconds(2), tolerance: .milliseconds(100)) {
            print("Timer fired")
        }
    }
}
