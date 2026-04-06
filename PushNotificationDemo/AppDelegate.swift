//
//  AppDelegate.swift
//  PushNotificationDemo
//
//  Created on 06/04/26.
//  Copyright © 2026 . All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        registerNotificationCategories()
        registerForNotification()
        return true
    }
    
    private func registerForNotification() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted:", granted)
            
        }
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token:", token)
        
        // Send this token to your backend
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    // Foreground Notification Handling
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
                                @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .sound])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let payload = response.notification.request.content.userInfo
        print("Tapped notification:", payload)
        
        if response.actionIdentifier == "REPLY" {
            print("User tapped reply")
        } else if response.actionIdentifier == "remove" {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [response.notification.request.identifier])
        }
        
        completionHandler()
    }
    
    private func registerNotificationCategories() {
        
        let replyAction = UNNotificationAction(
            identifier: "REPLY",
            title: "Reply",
            options: [.foreground]
        )
        
        let category = UNNotificationCategory(
            identifier: "IMAGE_CATEGORY",
            actions: [replyAction],
            intentIdentifiers: [],
            options: []
        )
        
        let closeAction = UNNotificationAction(
            identifier: "remove",
            title: "Close",
            options: [.foreground]
        )
        
        let category2 = UNNotificationCategory(
            identifier: "Local_Notification",
            actions: [closeAction],
            intentIdentifiers: [],
            options: [.customDismissAction, .hiddenPreviewsShowSubtitle]
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([category, category2])
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler:
                     @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("Silent push received:", userInfo)
        
        completionHandler(.newData)
    }
}
