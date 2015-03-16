//
//  Group.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/10/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import Foundation
import CoreData

class Group: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var ideas: NSSet

}
