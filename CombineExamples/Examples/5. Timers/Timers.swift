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
    var anyPublisher:Timer.TimerPublisher?
    
    init() {
        let runloop = RunLoop.main
        cancellable = runloop.schedule(after: runloop.now, interval: .seconds(2), tolerance: .milliseconds(100)) {
            print("Timer fired")
        }
        
        runloop.schedule(after: .init(Date(timeIntervalSinceNow: 3.0))) { [weak self] in
            self?.cancellable?.cancel()
        }
        
        
        //A better way
        anyPublisher = Timer.publish(every: 1.0, on: .main, in: .common)
        
        //Connect the timer
        //publisher.connect()
        
        //Or you can use autoconnect
        cancellable = anyPublisher?.autoconnect().sink(receiveValue: {_ in
            print("fired")
        })
        
    }
}
