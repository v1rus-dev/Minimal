//
//  TaskEntity+CoreDataProperties.swift
//  Minimal
//
//  Created by Yegor Cheprasov on 2.10.23.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var text: String
    @NSManaged public var date: Date?
    @NSManaged public var isDone: Bool
    @NSManaged public var timestamp: Date?

    var isToday: Bool {
        guard let date = date else {
            return false
        }
        return Calendar.current.isDateInToday(date)
    }
}

extension TaskEntity : Identifiable {

}
