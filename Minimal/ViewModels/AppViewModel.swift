//
//  AppViewModel.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 7.10.23.
//

import SwiftUI

class AppViewModel: ObservableObject {
    static let shared: AppViewModel = AppViewModel()
    
    private let dataManager = DataManager.shared
    
    private init() {
        processOldTasks()
    }
    
    private func processOldTasks() {
        let request = TaskEntity.fetchRequest()
        let todayDate = Date().removeTimeStamp
        var tasks: [TaskEntity]
        do {
            tasks = try dataManager.contex.fetch(request)
            let previousTasks = tasks.filter { task in
                if task.date == nil {
                    return false
                }
                if let today = todayDate {
                    return task.date! < today
                } else {
                    return false
                }
            }
            DispatchQueue.main.async {
                previousTasks.forEach { task in
                    print("Prev task: \(task)")
                    if (task.isDone) {
                        self.dataManager.contex.delete(task)
                    } else {
                        task.date = .now.removeTimeStamp ?? .now
                    }
                }
                self.dataManager.saveData()
            }
        } catch {
            print("Error process old task")
        }
    }
}

struct Predicate<TaskEntity> {
    var matches: (TaskEntity) -> Bool
    
    init(matches: @escaping (TaskEntity) -> Bool) {
        self.matches = matches
    }
}
