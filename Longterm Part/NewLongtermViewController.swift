//
//  NewLongtermViewController.swift
//  Tic-Tok
//
//  Created by Zhixiang.Zhang on 2018/5/14.
//  Copyright © 2018 Echo. All rights reserved.
//
 
import UIKit
import os.log

class NewLongtermViewController: UIViewController , UITextFieldDelegate{
    //MARK: Properties
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameEntry: UITextField!
    @IBOutlet weak var typeSwitch: UISwitch!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeButton: UIButton!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var estimatedTimeEntry: UITextField!
    @IBOutlet weak var hoursLabel: UILabel!

    @IBOutlet weak var descriptionTextView: UITextView!
    var longterm : Longterms?
    
    // MARK: - Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.
        nameEntry.delegate = self
        estimatedTimeEntry.delegate = self
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let dele = (UIApplication.shared.delegate as! AppDelegate)
        let context = dele.persistentContainer.viewContext
        let longtermDAO = LongtermDAO(context: context)
        
        let name = nameEntry.text ?? ""
        let description = descriptionTextView.text ?? "No description"
        if !typeSwitch.isOn {
            longterm = longtermDAO.addWithoutTime(name: name, overview: description)
            print("NODDL")
        } else {
            let startTime = TimeTransfer.transTimeST(time: startTimeLabel.text!)
            let endTime = TimeTransfer.transTimeST(time: endTimeLabel.text!)
            //MARK: Wanting for correcting!
            let estimatedTime = 3600 * Int(estimatedTimeEntry.text!)!
            longterm = longtermDAO.addWithTime(name: name, overview: description, startTime: startTime, endTime: endTime, estimatedTime: estimatedTime)
            print("DDL")
        }
    }
    
    @IBAction func switchTriggered(_ sender: Any) {
        if typeSwitch.isOn {
            startTimeButton.isEnabled = true
            endTimeButton.isEnabled = true
            estimatedTimeEntry.isEnabled = true
            enableLabels()
            
        }else{
            startTimeButton.isEnabled = false
            endTimeButton.isEnabled = false
            estimatedTimeEntry.isEnabled = false
            estimatedTimeEntry.text = nil
            disableLabels()
        }
        updateSaveButtonState()
    }
    
    @IBAction func selectStartTime(_ sender: Any) {
        let alertController = selectDateAndTime(timeLabel: self.startTimeLabel)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func selectEndTime(_ sender: Any) {
        let alertController = selectDateAndTime(timeLabel: self.endTimeLabel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    private func disableLabels(){
        //Swtich off : the text in related label will be gray and the content will become "Disable"
        startTimeLabel.text = "Disable"
        endTimeLabel.text = "Disable"
        startTimeLabel.textColor = UIColor.gray
        endTimeLabel.textColor = UIColor.gray
        hoursLabel.textColor = UIColor.gray
    }
    
    private func enableLabels(){
        // Switch on : The view of related label recovered.
        startTimeLabel.text = "Unknown"
        endTimeLabel.text = "Unknown"
        startTimeLabel.textColor = UIColor.black
        endTimeLabel.textColor = UIColor.black
        hoursLabel.textColor = UIColor.black
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty or vacancy in ddl part.
        if typeSwitch.isOn {
            if startTimeLabel.text != "Unknown" && endTimeLabel.text != "Unknown" && !(estimatedTimeEntry.text?.isEmpty)! && !(nameEntry.text?.isEmpty)!{
                saveButton.isEnabled = true
            } else {
                saveButton.isEnabled = false
            }
        }else{
            saveButton.isEnabled = !(nameEntry.text?.isEmpty)!
        }
    }
    
    private func selectDateAndTime (timeLabel : UILabel) -> UIAlertController{
        // Use UIDatePicker to choose a time and change the text of given label.
        
        let alertController:UIAlertController=UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let timePicker = SelectTime.dateAndTimePicker()
        
        alertController.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default){
            (alertAction)in
            timeLabel.text = TimeTransfer.transTimeS(time: timePicker.date)
            self.checkLabelTime(trigger: timeLabel)
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel,handler:nil))
        alertController.view.addSubview(timePicker)
        return alertController
    }
    
    private func checkLabelTime(trigger : UILabel){
        //method called when user press a time limit button, in order to avoid the time parameters exceptions
        if (estimatedTimeEntry.text?.isEmpty)! {
            if startTimeLabel.text != "Unknown" && endTimeLabel.text != "Unknown"{
                if TimeTransfer.transTimeST(time: startTimeLabel.text!) >= TimeTransfer.transTimeST(time: endTimeLabel.text!) {
                    //when start time is after the end time
                    trigger.text = "Unknown"
                    AlertMessage.alertOnlyConfirm( viewController : self, title : "Conflict between two time limits", message : "Start time can't be later than or equals to the end time")
                }
            }
        }else{
            if startTimeLabel.text != "Unknown" && endTimeLabel.text != "Unknown"{
                let start = TimeTransfer.transTimeI(time: TimeTransfer.transTimeST(time: startTimeLabel.text!))
                let end = TimeTransfer.transTimeI(time: TimeTransfer.transTimeST(time: endTimeLabel.text!))
                let estimated = Int(estimatedTimeEntry.text!)! * 3600
                if estimated > end - start {
                    // estimated time should be less than endtime - startime
                    trigger.text = "Unknown"
                    AlertMessage.alertOnlyConfirm( viewController : self, title : "Conflict with estimated time", message : "Change time limits or reduce the estimated time")
                }
            }
        }
        updateSaveButtonState()
    }
    
    private func checkEntryTime(){
        // this method will be called after finishing the editing of estimated time text field
        if !(estimatedTimeEntry.text?.isEmpty)! {
            if Int(estimatedTimeEntry.text!) != nil {
                let estimated = Int(estimatedTimeEntry.text!)!
                if estimated <= 0 || estimated > 2000 {
                    //valid estimated time: 0 < hours <= 2000
                    estimatedTimeEntry.text = nil
                    AlertMessage.alertOnlyConfirm( viewController : self, title : "Out of range", message : "Range of valid estimated time: 0 < hours <= 2000 ")
                }else if (startTimeLabel.text != "Unknown" && endTimeLabel.text != "Unknown") {
                    //estimated time should be less than end time - start time
                    if estimated * 3600 > TimeTransfer.transTimeI(time: TimeTransfer.transTimeST(time: endTimeLabel.text!)) - TimeTransfer.transTimeI(time: TimeTransfer.transTimeST(time: startTimeLabel.text!)){
                        estimatedTimeEntry.text = nil
                        AlertMessage.alertOnlyConfirm( viewController : self, title : "Estimated time is too long", message : "Change time limits or reduce the estimated time")
                    }
                }
            } else {
                estimatedTimeEntry.text = nil
                AlertMessage.alertOnlyConfirm( viewController : self, title : "Invalid input", message : "Please input an integer between 0 and 2000 as your estimated time.")
            }
        }
    }
    
    
    //MARK: UIFieldDelegate
    func textFieldDidBeginEditing(_ textField : UITextField) {
        //Disable the Save Button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === estimatedTimeEntry{
            checkEntryTime()
        }
        updateSaveButtonState()
    }
    
}

