//
//  ListenToNotificationPublisher.swift
//  CombineExamples
//
//  Created by Shalom Friss on 10/11/21.
//

import Foundation
import Combine

class TypeErasure {
    init() {
        //Returns the AnyPublisher so that we don't need to know types
        let publisher = PassthroughSubject<String, Never>().eraseToAnyPublisher()
    }
}
