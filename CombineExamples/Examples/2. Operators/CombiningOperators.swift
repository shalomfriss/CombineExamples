//
//  ListenToNotificationPublisher.swift
//  CombineExamples
//
//  Created by Shalom Friss on 10/11/21.
//

import Foundation
import UIKit
import Combine

class CombiningOperators {
    let images = ["Houston", "Denver", "Seattle"]
    var index = 0
    
    var cancellable:AnyCancellable
    
    func getImage() -> AnyPublisher<UIImage?, Never> {
        return Future<UIImage?, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) {
                promise(.success(UIImage(named: self.images[self.index])))
            }
        }.print().map { $0 }.receive(on: RunLoop.main).eraseToAnyPublisher()
    }
    
    init() {
        print("-------------------------------------------")
        print("prepend")
        print("-------------------------------------------")
        //Prepends some values to the publisher
        
        let numbers = (1...10).publisher
        let publisher2 = (500...510).publisher
        
        cancellable = numbers.prepend(100,101)
            .prepend([11,12])
            .prepend(publisher2)
            .sink { print($0) }
        
        
        print("-------------------------------------------")
        print("append")
        print("-------------------------------------------")
        //Appends some values to the publisher
        
        cancellable = numbers.append(100,101)
            .append([11,12])
            .append(publisher2)
            .sink { print($0) }
        
        print("-------------------------------------------")
        print("switchToLatest")
        print("-------------------------------------------")
        //Switches to the latest publisher that was used in a send function
        
        
        let publisherA = PassthroughSubject<String, Never>()
        let publisherB = PassthroughSubject<String, Never>()
        
        let publishers = PassthroughSubject<PassthroughSubject<String, Never>, Never>()
        cancellable = publishers.switchToLatest().sink {
            print($0)
        }
        
        //Will respond to A
        publishers.send(publisherA)
        
        publisherA.send("Pub A - Value 1")
        publisherA.send("Pub A -  2")
        
        //Will respond to B, but not A
        publishers.send(publisherB)
        publisherB.send("Pub B - Value 1")
        
        //This will not be output
        publisherA.send("Pub A -  3")
        print("-------------------------------------------")
        print("switchToLatest part 2")
        print("-------------------------------------------")
        
        let taps = PassthroughSubject<Void, Never>()
        cancellable = taps.map { _ in self.getImage() }
        .switchToLatest().sink {
            print($0)
        }
        
        //Houston
        taps.send()
        
        //Denver
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            self.index += 1
            taps.send()
        }
        
        //Seattle
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.5) {
            self.index += 1
            taps.send()
        }
        print("-------------------------------------------")
        print("merge")
        print("-------------------------------------------")
        
        let publisher1a = PassthroughSubject<Int, Never>()
        let publisher2a = PassthroughSubject<Int, Never>()
        cancellable = publisher1a.merge(with: publisher2a).sink { print($0) }
        
        publisher1a.send(1)
        publisher1a.send(2)

        publisher2a.send(3)
        publisher2a.send(4)
        
        
        cancellable = publisherA.merge(with: publisherB).sink {
            print($0)
        }
        
        publisherA.send("a")
        publisherA.send("b")
        
        publisherB.send("c")
        publisherB.send("d")
        
        print("-------------------------------------------")
        print("combineLatest")
        print("-------------------------------------------")
        
        //Gets the latest value from each publisher and returns a tuple of the two
        
        var publisher1b = PassthroughSubject<Int, Never>()
        var publisher2b = PassthroughSubject<String, Never>()
        
        cancellable = publisher1b.combineLatest(publisher2b).sink{
            print("p1 value - \($0) - p2 value - \($1)")
        }
        
        publisher1b.send(1)
        publisher2b.send("a")
        publisher2b.send("b")
        
        print("-------------------------------------------")
        print("zip")
        print("-------------------------------------------")
        //Will send a tuple from both publishers, but will match the number of calls from each
        //will output 2 values only if both publishers put out 2 values
        
        publisher1b = PassthroughSubject<Int, Never>()
        publisher2b = PassthroughSubject<String, Never>()
        
        cancellable = publisher1b.zip(publisher2b).sink {
            print("p1 value - \($0) - p2 value - \($1)")
        }
        
        
        publisher1b.send(1)
        publisher2b.send("a")
        publisher2b.send("b")
        publisher1b.send(2)
    }
}
