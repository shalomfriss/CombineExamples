//
//  ListenToNotificationPublisher.swift
//  CombineExamples
//
//  Created by Shalom Friss on 10/11/21.
//

import Foundation
import Combine

class Debugging {
    var cancellable:AnyCancellable
    
    init() {
        //Returns the AnyPublisher so that we don't need to know types
        let publisher = (1...10).publisher
        cancellable = publisher.print("Debug")
            .sink {
                print($0)
            }
        
        cancellable = publisher.handleEvents(receiveSubscription: { _ in
            print("Subscription received")
        }, receiveOutput: {_ in print("Received output")}, receiveCompletion: {_ in print("Received completion")}, receiveCancel: {print("Received cancel")}, receiveRequest: {_ in print("Received request")})
            .sink {
                print($0)
            }
        
        //Will create a breakpoint on an error
        cancellable = publisher.breakpointOnError()
            .sink {
                print($0)
            }
        
        //Will create a breakpoint if the value is greater than 9
        cancellable = publisher.breakpoint(receiveOutput: { value in
            return value > 9
        })
            .sink {
                print($0)
            }
        
    }
}
