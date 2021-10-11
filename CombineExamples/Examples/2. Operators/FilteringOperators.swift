//
//  ListenToNotificationPublisher.swift
//  CombineExamples
//
//  Created by Shalom Friss on 10/11/21.
//

import Foundation
import Combine

class FilteringOperators {
    var cancellable:AnyCancellable
    
    init() {
        print("-------------------------------------------")
        print("FilterOperator")
        print("-------------------------------------------")
        let numbers = (1...20).publisher
        
        cancellable = numbers.filter { $0 % 2 == 0 }
        .sink {
            print($0)
        }
        
        print("-------------------------------------------")
        print("removeDuplicates")
        print("-------------------------------------------")
        //Removes when duplicates are next ot each other. Duplicates here are based on the previous value.
        let words = "apple apple fruit apple mango watermelon apple".components(separatedBy: " ").publisher
        
        cancellable = words.removeDuplicates().sink {
            print($0)
        }
        
        
        print("-------------------------------------------")
        print("compactMap")
        print("-------------------------------------------")
        //Will ignore nil values
        cancellable = ["a", "1.24", "b", "3.45", "6.7"].publisher.compactMap{ Float($0) }.sink {
            print($0)
        }
        
        
        print("-------------------------------------------")
        print("ignoreOutput")
        print("-------------------------------------------")
        //Will ignore the output and just return finished
        cancellable = numbers.ignoreOutput().sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
        
        
        print("-------------------------------------------")
        print("first")
        print("-------------------------------------------")
        cancellable = numbers.first(where: { $0 % 2 == 0 }).sink {
            print($0)
        }
        
        print("-------------------------------------------")
        print("last")
        print("-------------------------------------------")
        cancellable = numbers.last(where: { $0 % 2 == 0 }).sink {
            print($0)
        }
        
        print("-------------------------------------------")
        print("dropFirst")
        print("-------------------------------------------")
        cancellable = numbers.dropFirst(5).sink {
            print($0)
        }
        
        print("-------------------------------------------")
        print("dropWhile")
        print("-------------------------------------------")
        //Drop while the condition is true.  Once the condition becomes false
        //even one time, it stops dropping values.
        cancellable = numbers.drop(while: { $0 % 4 != 0 }).sink {
            print($0)
        }
        
        print("-------------------------------------------")
        print("X dropUntilOutputFromFilteringOperator")
        print("-------------------------------------------")
        //Will not ouput anything until it gets a value from another publisher
        let isReady = PassthroughSubject<Void, Never>()
        let taps = PassthroughSubject<Int, Never>()
        
        cancellable = taps.drop(untilOutputFrom: isReady).sink {
            print($0)
        }
        
        (1...10).forEach { n in
            taps.send(n)
            if n == 4 {
                //Should release the barrier?
                isReady.send()
            }
        }
        
        print("-------------------------------------------")
        print("prefix")
        print("-------------------------------------------")
        //Get the first n values.
        cancellable = numbers.prefix(4).sink { print($0) }
        cancellable = numbers.prefix(while: { $0 < 4 }).sink { print($0) }
        
        
        
    }
}
