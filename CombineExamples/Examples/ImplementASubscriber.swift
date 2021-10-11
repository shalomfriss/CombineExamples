//
//  ListenToNotificationPublisher.swift
//  CombineExamples
//
//  Created by Shalom Friss on 10/11/21.
//

import Foundation
import Combine

class ImplementASubscriber {
    init() {
        let publisher = ["A", "B", "C", "D", "E", "F", "G"].publisher
        let stringSubscriber = StringSubscriber()
        publisher.subscribe(stringSubscriber)
    }
}


class StringSubscriber: Subscriber {
    func receive(subscription: Subscription) {
        print("Received subscription")
        //Specify that you want a maximum of 3 items.  This is called the backpressure.
        subscription.request(.max(3))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print("Received value", input)
        //Return the demand.  You can change the backpressure here.  Returning
        //.none means you don't want to change anything.
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        print("Completed")
    }
    
    typealias Input = String
    typealias Failure = Never
}


