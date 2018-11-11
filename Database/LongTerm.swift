//
//  LongTerm.swift
//  Tic-Tok
//
//  Created by Zhixiang Zhang on 2018/4/4.
//  Copyright © 2018 Echo. All rights reserved.
//

import Foundation
import CoreData

class LongTerm: NSManagedObject{
    static let entityName = "LongTerm"
    @NSManaged var memoL : String?
    @NSManaged var idL : NSNumber?
    @NSManaged var beginTimeL : Date?
    @NSManaged var endTimeL : Date?
    @NSManaged var priorityL : NSNumber?
    @NSManaged var periodL : NSNumber?
    @NSManaged var settingTimeL : Date?
    @NSManaged var everydayTimeL : NSNumber?
    var flagL = false
}
