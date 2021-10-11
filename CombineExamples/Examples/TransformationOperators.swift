//
//  ListenToNotificationPublisher.swift
//  CombineExamples
//
//  Created by Shalom Friss on 10/11/21.
//

import Foundation
import Combine
import UIKit

struct Point {
    let x: Int
    let y: Int
}

struct School {
    let name:String
    let noOfStudents: CurrentValueSubject<Int, Never>
    
    init(name:String, noOfStudents:Int) {
        self.name = name
        self.noOfStudents = CurrentValueSubject(noOfStudents)
    }
}


class TransformationOperators {
    init() {
        print("-------------------------------------------")
        print("CollectOperator")
        print("-------------------------------------------")
        
        //Collect items and return an array
        let _ = ["A","B","C","D"].publisher.collect().sink {
            print($0)
        }
        
        //You can chunk items into pieces
        let _ = ["A","B","C","D"].publisher.collect(2).sink { print($0) }
        let _ = ["A","B","C","D"].publisher.collect(3).sink { print($0) }
        
        
        print("-------------------------------------------")
        print("MapOperator")
        print("-------------------------------------------")
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        
        //The map operator works just like in Swift
        let _ = [123, 45, 67].publisher.map {
            formatter.string(from: NSNumber(integerLiteral: $0)) ?? ""
        }.sink {
            print($0)
        }
        
        print("-------------------------------------------")
        print("X KeyMap")
        print("-------------------------------------------")
        //Map KeyPath
        let publisher = PassthroughSubject<Point, Never>()
        let _ = publisher.map(\.x, \.y).sink {x, y in
            print("x: \(x) - y: \(y)")
        }
        publisher.send(Point(x:2, y:10))
        
        print("-------------------------------------------")
        print("X FlatMap")
        print("-------------------------------------------")
//        //Flatmap
        let citySchool = School(name: "City school", noOfStudents: 100)
        let school = CurrentValueSubject<School, Never>(citySchool)
        let _ = school.sink {
            print($0)
        }
        //Nothing happens
        citySchool.noOfStudents.value += 1
        
        let townSchool = School(name: "Town school", noOfStudents: 45)
        //Should fire event
        school.value = townSchool
        
        
        let _ = school.flatMap {
            $0.noOfStudents
        }
        .sink {
            print($0)
        }
        //Should fire another event
        citySchool.noOfStudents.value += 1
        
        
        print("-------------------------------------------")
        print("replaceNil")
        print("-------------------------------------------")
        
        let _ = ["A","B",nil,"D"].publisher.replaceNil(with: "*").sink {
            print($0)
        }
        
        print("-------------------------------------------")
        print("replaceEmpty")
        print("-------------------------------------------")
        
        let empty = Empty<Int, Never>()
        let _ = empty
            .replaceEmpty(with: 1)
            .sink(receiveCompletion: { print($0) }, receiveValue: { print($0) })
        
        
        print("-------------------------------------------")
        print("scan")
        print("-------------------------------------------")
        //starts with an empty array, each call to the body of the function
        //gets an array and a value.  It then appends the value to the array.
        let numPublisher = (1...10).publisher
        let _ = numPublisher.scan([]) { numbers, value -> [Int] in
            numbers + [value]
        }.sink { print($0) }
        
    }
}
