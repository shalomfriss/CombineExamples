//
//  Subjects.swift
//  CombineExamples
//
//  Created by Shalom Friss on 10/11/21.
//

import Foundation
import Combine

//Subjects are both publisher and subscriber
class Subjects {
    
    init() {
        print("-------------------------------------------")
        print("Subjects")
        print("-------------------------------------------")
        //Passthrough subject
        let subscriber = StringSubscriber2()
        let subject = PassthroughSubject<String, MyError>()
        subject.subscribe(subscriber)
        subject.send("A")
    }
    
}

//Our custom errors
enum MyError:Error {
    case someError
}

//A basic subscriber class
class StringSubscriber2: Subscriber {
    
    func receive(subscription: Subscription) {
        subscription.request(.max(2))
    }
    
    func receive(_ input: String) -> Subscribers.Demand {
        print(input)
        //Can use max, unlimited, none...
        return .none
    }
    
    func receive(completion: Subscribers.Completion<MyError>) {
        print("Completion")
    }
    
    typealias Input = String
    typealias Failure = MyError
}

