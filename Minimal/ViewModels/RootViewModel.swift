//
//  RootViewModel.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 2.10.23.
//

import Foundation
import Combine
import CoreData

class RootViewModel: ObservableObject {
    
    @Published
    var dataManager: DataManager
    
    @Published
    var tasks: [TaskEntity] = []
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    func toggleCheckBox(task: TaskEntity) {
        print("Check toggle")
        task.isDone.toggle()
        dataManager.saveData()
    }
}
