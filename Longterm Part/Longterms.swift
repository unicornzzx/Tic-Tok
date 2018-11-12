
//
//  Longterms.swift
//  Tic-Tac
//
//  Created by Zhixiang.Zhang on 2018/5/14.
//  Copyright © 2018 Echo. All rights reserved.
//

import Foundation
import CoreData

class Longterms: NSManagedObject{
    //Zhang: this class define object which is the type of "Long Term Task"
    static let entityName = "Longterms"
    @NSManaged var id : NSNumber!
    @NSManaged var name : String!
    @NSManaged var overview : String!
    @NSManaged var startTime : Date?
    @NSManaged var endTime : Date?
    @NSManaged var estimatedTime : NSNumber?
    @NSManaged var timeSoFar : NSNumber? //seconds -> int
    @NSManaged var settingTime : Date!
    @NSManaged var done : NSNumber!
    @NSManaged var hasDDL : NSNumber! //distinct taks with dll and those without ddl
}
