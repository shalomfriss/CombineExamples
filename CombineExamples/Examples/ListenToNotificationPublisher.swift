//
//  ListenToNotificationPublisher.swift
//  CombineExamples
//
//  Created by Shalom Friss on 10/11/21.
//

import Foundation
import Combine

class ListenToNotificationPublisher {
    init() {
        let notification = Notification.Name("MyNotification")
        let publisher = NotificationCenter.default.publisher(for: notification, object: nil)

        let subscription = publisher.sink { _ in
            print("notification received")
        }
        NotificationCenter.default.post(name: notification, object: nil)
        subscription.cancel()
    }
}
