//
//  NotificationViewController.swift
//  PushNotificationDemo
//
//  Created on 06/04/26.
//  Copyright © 2026 . All rights reserved.
//  

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        print("🔥 Extension triggered")
        self.label?.text = notification.request.content.body
    }
}
