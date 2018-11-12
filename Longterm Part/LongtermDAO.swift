//
//  LongtermDAO.swift
//  Tic-Tok
//
//  Created by Zhixiang.Zhang on 2018/5/14.
//  Copyright © 2018 Echo. All rights reserved.
//

import Foundation
import CoreData

class LongtermDAO {
    var context: NSManagedObjectContext
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //Save to database
    func saveChanges(){
        do{
            try context.save()
        }catch let error as NSError{
            print(error)
        }
    }
    
    //Zhang: Add a new longterm task with time limit into the database
    func addWithTime(name:String, overview:String, startTime:Date, endTime:Date, estimatedTime: Int) -> Longterms{ //estimated time 
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        let en = Longterms.entityName
        let ctx = context
        let e = NSEntityDescription.insertNewObject(forEntityName: en, into: ctx)
            as! Longterms 
        e.id = timeStamp as NSNumber
        e.name = name
        e.overview = overview
        e.startTime = startTime
        e.endTime = endTime
        e.estimatedTime = estimatedTime as NSNumber?
        e.timeSoFar = 0 as NSNumber?
        e.settingTime = now
        e.done = false as NSNumber
        e.hasDDL = true as NSNumber
        saveChanges()
        return e
    }
    
    //Zhang: Add a new longterm task which does not have ddl
    func addWithoutTime(name:String, overview :String) -> Longterms {
        let now = Date()
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)//得到现在时刻的时间戳，并换算成int
        let en = Longterms.entityName
        let ctx = context
        let e = NSEntityDescription.insertNewObject(forEntityName: en, into: ctx)
            as! Longterms
        e.id = timeStamp as NSNumber
        e.name = name
        e.overview = overview
        e.startTime = nil
        e.endTime = nil
        e.estimatedTime = nil
        e.timeSoFar = 0 as NSNumber
        e.settingTime = now
        e.done = false as NSNumber
        e.hasDDL = false as NSNumber
        saveChanges()
        return e
    }
    
    //get method of LongTerm object
    func get(withPredicate p:NSPredicate) -> [Longterms]{
        let en = Longterms.entityName
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: en)
        req.predicate = p
        do{
            let resp = try context.fetch(req)
            return resp as! [Longterms]
        }catch let error as NSError{
            print(error)
            return [Longterms]()
        }
    }
    //这两个从数据库里获取对象的函数不是很懂
    func getAll() -> [Longterms]{
        return get(withPredicate: NSPredicate(value: true))
    }
    
    func getUnfinished()->[Longterms] {
        let longterms = getAll()
        var result = [Longterms]()
        for l in longterms {
            if !l.done.boolValue {
                result.append(l)
            }
        }
        return result
    }
    
    func getById(id : Int) -> Longterms{
        let p = NSPredicate(format: "id = %i",id)
        let en = Longterms.entityName
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: en)
        req.predicate = p
        do{
            let resp = try context.fetch(req)
            let res = resp[0]
            return res as! Longterms
        }catch let error as NSError{
            print(error)
            return Longterms()
        }
    }
    
    func setDescription (id:Int , overview : String){
        let longterm = getById(id : id)
        longterm.overview = overview
        saveChanges()
    }
    
    func finish(id : Int) {
        let longterm = getById(id : id)
        longterm.done = true as NSNumber
        saveChanges()
    }
    
    func acumulateTime(id : Int, time : Int){
        let longterm = getById(id : id)
        var timeSoFar = longterm.timeSoFar!.intValue
        timeSoFar += time
        longterm.timeSoFar = timeSoFar as NSNumber
        saveChanges()
    }
    
    func deletByID(id: Int){
        let idss = getById(id: id)
        context.delete(idss)
        saveChanges()
    }
}
