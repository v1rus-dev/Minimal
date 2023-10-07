//
//  EditTaskViewModel.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 8.10.23.
//

import SwiftUI

class EditTaskViewModel: ObservableObject {
    @Published
    var dataManager: DataManager
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    func remove(task: TaskEntity) {
        dataManager.contex.delete(task)
        dataManager.saveData()
    }
}
