//
//  AddTaskViewModel.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 3.10.23.
//

import Foundation

class AddTaskViewModel: ObservableObject {
    
    @Published
    var dataManager: DataManager
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    func addNewTask(text: String, date: Date) async {
        dataManager.insertTask(text: text, date: date)
    }
    
}
