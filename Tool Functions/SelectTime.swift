//
//  SelectTime.swift
//  Tic-Tok
//
//  Created by Zhixiang.Zhang on 2018/5/14.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit

class SelectTime {
    static func dateAndTimePicker() -> UIDatePicker{
        let datePicker = UIDatePicker( )
        datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        datePicker.date = NSDate() as Date
        return datePicker
    }
    
    static func timerPicker() -> UIDatePicker{
        let datePicker = UIDatePicker( )
        datePicker.datePickerMode = UIDatePickerMode.countDownTimer
        datePicker.date = NSDate() as Date
        return datePicker
    }
}
