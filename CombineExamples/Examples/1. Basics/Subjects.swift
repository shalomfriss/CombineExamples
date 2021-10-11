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
        
        //Have to save a reference to the subscription or it will be released automatically
        //and you will get no values
        let subscription = subject.sink(receiveCompletion: { (completion) in
            print("Completion from sink")
        }) { value in
            print("Value from sink", value)
        }
        
        subject.send("A")
        subscription.cancel()
        subject.send("B")
        subject.send("C")
        subject.send("D")
        
        
        
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

