//
//  DailyTask+CoreDataProperties.swift
//  txtodo
//
//  Created by FIGBERT on 4/14/20.
//  Copyright © 2020 FIGBERT Industries. All rights reserved.
//
//

import Foundation
import CoreData


extension DailyTask {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyTask> {
        return NSFetchRequest<DailyTask>(entityName: "DailyTask")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var priority: Int16
    @NSManaged public var name: String
    @NSManaged public var notes: Array<String>
    @NSManaged public var id: UUID
    @NSManaged public var creationDate: Date

}
