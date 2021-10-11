//
//  ListenToNotificationPublisher.swift
//  CombineExamples
//
//  Created by Shalom Friss on 10/11/21.
//

import Foundation
import Combine

class SequenceOperators {
    var cancellable:AnyCancellable
    
    init() {
        print("-------------------------------------------")
        print("min")
        print("-------------------------------------------")
        //Return the smallest value
        
        let publisher = [-1, -45, 3, 45, 100].publisher
        cancellable = publisher.min().sink {
            print($0)
        }
        
        print("-------------------------------------------")
        print("max")
        print("-------------------------------------------")
        //Return the largest value
        
        cancellable = publisher.max().sink {
            print($0)
        }
        
        
        print("-------------------------------------------")
        print("output")
        print("-------------------------------------------")
        //Can specify an index or range of items to return
        
        cancellable = publisher.output(at: 2).sink {
            print($0)
        }
        cancellable = publisher.output(in: 0...2).sink {
            print($0)
        }
        
        
        print("-------------------------------------------")
        print("count")
        print("-------------------------------------------")
        //Returns the number of elements
        //If using a PassthroughSubject, you have to send a finished event for it to count
        cancellable = publisher.count().sink {
            print($0)
        }
      
        let publisher1 = PassthroughSubject<Int, Never>()
        cancellable = publisher1.count().sink {
            print($0)
        }
        
        publisher1.send(1)
        publisher1.send(2)
        publisher1.send(3)
        publisher1.send(4)
        publisher1.send(completion: .finished)
        
        
        print("-------------------------------------------")
        print("contains")
        print("-------------------------------------------")
        //Returns true or false if the element is contained here
        cancellable = publisher.contains(-45).sink {
            print($0)
        }
        
        print("-------------------------------------------")
        print("contains")
        print("-------------------------------------------")
        //Returns true or false if all the elements satisfy the condition
        cancellable = publisher.allSatisfy { $0 % 2 == 0 }.sink {
            print($0)
        }
        
        print("-------------------------------------------")
        print("reduce")
        print("-------------------------------------------")
        //Returns true or false if all the elements satisfy the condition
        cancellable = publisher.reduce(0) { accumulator, value in
            return accumulator + value
        }.sink {
            print($0)
        }
        
        
    }
}
