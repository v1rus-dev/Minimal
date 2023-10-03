//
//  DataManager.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 2.10.23.
//

import Foundation
import Combine
import CoreData

enum DataManagerType {
    case normal
    case preview
}

class DataManager: NSObject, ObservableObject {
    static let shared = DataManager(type: .normal)
    static let preview = DataManager(type: .preview)
    
    fileprivate var managedObjectContext: NSManagedObjectContext
    
    var contex: NSManagedObjectContext {
        managedObjectContext
    }
    
    private init(type: DataManagerType) {
        switch type {
        case .normal:
            let persitanceController = PersistenceController.shared
            self.managedObjectContext = persitanceController.container.viewContext

        case .preview:
            let persitanceController = PersistenceController.preview
            self.managedObjectContext = persitanceController.container.viewContext
            
            self.managedObjectContext.insertMocData()
            
            try? self.managedObjectContext.save()
        }
        
        super.init()
    }
    
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unreolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}

extension DataManager {
    func insertTask(text: String, date: Date) {
        let task = TaskEntity(context: managedObjectContext)
        task.id = UUID()
        task.date = date
        task.text = text
        task.isDone = false
        task.timestamp = .now
        
        saveData()
    }
}
