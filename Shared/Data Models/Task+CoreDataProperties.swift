//
//  Task+CoreDataProperties.swift
//  txtodo
//
//  Created by FIGBERT on 7/31/20.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var daily: Bool
    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var notes: [String]
    @NSManaged public var priority: Int16
    @NSManaged public var hasBeenDelayed: Bool

}

extension Task : Identifiable {

}
