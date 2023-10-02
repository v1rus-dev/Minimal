//
//  AddMocData.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 2.10.23.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func insertMocData() {
        insertMocTasks()
    }
    
    fileprivate func insertMocTasks() {
        for i in 0..<10 {
            let task = TaskEntity(context: self)
            task.id = UUID()
            task.text = "Random task text: \(i)"
            task.isDone = i % 2 == 0
            if i < 5 {
                task.date = Date()
            } else {
                let calendar = Calendar.current
                let nextDate = calendar.date(byAdding: .day, value: 1, to: Date())
                task.date = nextDate
            }
        }
    }
}
