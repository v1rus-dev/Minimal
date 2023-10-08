//
//  AddTaskViewModel.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 3.10.23.
//

import Foundation
import UserNotifications

class AddTaskViewModel: ObservableObject {
    
    @Published
    var dataManager: DataManager
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    func addNewTask(
        text: String, 
        date: Date,
        isNotifieble: Bool,
        timeOfNotification: Date
    ) async {
        let notififcationId = dataManager.insertTask(text: text, date: date, isNotifieble: isNotifieble, timeOfNotification: timeOfNotification)
        if isNotifieble && notififcationId != nil {
            processNotification(text: text, timeOfNotification: timeOfNotification, notificationId: notififcationId!)
        }
    }
    
    private func processNotification(text: String, timeOfNotification: Date, notificationId: UUID) {
        let content = UNMutableNotificationContent()
        content.title = "Minimal"
        content.body = text
        content.sound = .default
        
        let interval = getInterval(date: timeOfNotification)
            
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
            
        let request = UNNotificationRequest(identifier: notificationId.uuidString, content: content, trigger: trigger)
            
        UNUserNotificationCenter.current().add(request)
    }
    
    private func getInterval(date: Date) -> TimeInterval {
        var interval = date.timeIntervalSince(.now)
        
        if interval < 0 {
            let dat = .now + 60
            interval = dat.timeIntervalSince(.now)
        }
        
        return interval
    }
    
}
