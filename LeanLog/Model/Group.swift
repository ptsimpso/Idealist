//
//  Group.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/23/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import Foundation
import CoreData

class Group: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var priority: NSNumber
    @NSManaged var r: NSNumber
    @NSManaged var g: NSNumber
    @NSManaged var b: NSNumber
    @NSManaged var ideas: NSSet

}
