//
//  ContentView.swift
//  PushNotificationDemo
//
//  Created on 06/04/26.
//  Copyright © 2026 . All rights reserved.
//  

import SwiftUI
import UserNotifications

struct ContentView: View {
    var body: some View {
        VStack {
           Text("Local Notifications")
                .font(.largeTitle)
            
            Button("Send Local Notification") {
                sendLocalNotification()
            }
        }
        .padding()
    }
    
    private func sendLocalNotification() {
        
        // Step 2: Create Notification Content
        
        let content = UNMutableNotificationContent()
        content.title = "Local Notification Demo"
        content.body = "This is a local notification"
        content.categoryIdentifier = "Local_Notification"
        content.sound = .defaultRingtone
        content.badge = 1
        
        // Step 3: Set a Trigger
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, // every 1 min
                                                        repeats: true)
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

        // Step 4: Schedule the Notification
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        Task {
            do {
                try await notificationCenter.add(request)
            } catch {
                // Handle errors that may occur during add.
                print(error)
            }
        }
    }
}

#Preview {
    ContentView()
}
