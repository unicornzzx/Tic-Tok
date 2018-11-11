//
//  TimeTransfer.swift
//  Tic-Tok
//
//  Created by Zhixiang.Zhang on 2018/5/14.
//  Copyright © 2018 Echo. All rights reserved.
//

import Foundation
class TimeTransfer {
    
    static func transTimeS(time: Date) -> String { 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let convertedDate = dateFormatter.string(from: time)
        return convertedDate
    }
    
    static func transTimeS2(time: Date) -> String { 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertedDate = dateFormatter.string(from: time)
        return convertedDate
    }
    
    static func transTimeS3(time: Date) -> String { 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let convertedDate = dateFormatter.string(from: time)
        return convertedDate
    }
    
    static func transTimeI(time: Date) -> Int{ 
        let timeInterval:TimeInterval = time.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
    
    static func transTimeST(time: String) -> Date { 
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.date(from: time)! as Date
    }
    
    static func transTimeIT(time: Int) -> Date { 
        let timeInterval:TimeInterval = TimeInterval(time)
        let date = Date(timeIntervalSince1970: timeInterval)
        return date as Date
    }
}
