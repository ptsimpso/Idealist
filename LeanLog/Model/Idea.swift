//
//  Idea.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/10/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import Foundation
import CoreData

class Idea: NSManagedObject {

    @NSManaged var priority: NSNumber
    @NSManaged var alternatives: String?
    @NSManaged var channels: String?
    @NSManaged var costs: String?
    @NSManaged var createdAt: NSDate
    @NSManaged var customerSegments: String?
    @NSManaged var metrics: String?
    @NSManaged var notes: String?
    @NSManaged var problem: String?
    @NSManaged var revenue: String?
    @NSManaged var solution: String?
    @NSManaged var title: String?
    @NSManaged var unfairAdv: String?
    @NSManaged var updatedAt: NSDate
    @NSManaged var uvp: String?
    @NSManaged var groups: NSSet

}
