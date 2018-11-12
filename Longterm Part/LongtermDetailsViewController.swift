// 
//  LongtermDetailsViewController.swift
//  Tic-Tok
//
//  Created by Zhixiang.Zhang on 2018/5/14.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit
import os.log

class LongtermDetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set up views if editing an existing Meal.
        nameLabel.text   = longterm.name
        if longterm.hasDDL.boolValue {
            startTimeLabel.text = TimeTransfer.transTimeS2(time: longterm.startTime!)
            endTimeLabel.text = TimeTransfer.transTimeS2(time: longterm.endTime!)
            estimatedTimeLabel.text = String(longterm.estimatedTime!.intValue/3600)
        } else {
            startTimeLabel.isHidden = true
            endTimeLabel.isHidden = true
            estimatedTimeLabel.isHidden = true
        }
        let timeSoFar = longterm.timeSoFar!.intValue
        let hours = Int(timeSoFar / 3600)
        let mins = Int((timeSoFar - hours * 3600) / 60)
        timeSoFarLabel.text = "already done part: "+String(hours)+" hour(s) "+String(mins)+" min(s)"
        settingTimeLabel.text = "this task was set on "+TimeTransfer.transTimeS2(time: longterm.settingTime)
        finishedIndexButton.isUserInteractionEnabled = false
        if longterm.done.boolValue {
            finishedLabel.text = "this task is finished"
            finishButton.isHidden = true
            setDescriptionButton.isHidden = true
            confirmDescriptionButton.isHidden = true
        }else{
            finishedLabel.text = "this task hasn't finished yet"
            finishedIndexButton.alpha = 0.2
        }
        confirmDescriptionButton.isHidden = true
        descriptionTextView.text = longterm.overview
        descriptionTextView.isEditable = false
        
    }
    
    //MARK: Actions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setDescription(_ sender: UIButton) {
        descriptionTextView.isEditable = true
        setDescriptionButton.isHidden = true
        confirmDescriptionButton.isHidden = false
    }
    
    @IBAction func confirmEdit(_ sender: UIButton) {
        let dele = (UIApplication.shared.delegate as! AppDelegate)
        let context = dele.persistentContainer.viewContext
        let longtermDAO = LongtermDAO(context: context)
        var description : String!
        if descriptionTextView.text == nil {
            description = ""
        } else {
            description = descriptionTextView.text
        }
        longtermDAO.setDescription(id: longterm!.id.intValue, overview: description)
        descriptionTextView.isEditable = false
        setDescriptionButton.isHidden = false
        confirmDescriptionButton.isHidden = true
        AlertMessage.alertOnlyConfirm(viewController: self, title:"The editing of description is saved.", message: "")
    }
    
    @IBAction func finish(_ sender: UIButton) {
        let alertController:UIAlertController=UIAlertController(title: "Finish this task?", message: "The information of finished task can't be edited.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default){
            (alertAction)in
            let dele = (UIApplication.shared.delegate as! AppDelegate)
            let context = dele.persistentContainer.viewContext
            let longtermDAO = LongtermDAO(context: context)
            longtermDAO.finish(id: self.longterm.id.intValue)
            self.finishedLabel.text = "this task is finished"
            self.finishButton.isHidden = true
            self.setDescriptionButton.isHidden = true
            self.confirmDescriptionButton.isHidden = true
            self.descriptionTextView.isEditable = false
            self.finishedIndexButton.alpha = 1.0
        })
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //MARK: Preperties
    var longterm:Longterms!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var estimatedTimeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var setDescriptionButton: UIButton!
    @IBOutlet weak var confirmDescriptionButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var timeSoFarLabel: UILabel!
    @IBOutlet weak var settingTimeLabel: UILabel!
    @IBOutlet weak var finishedLabel: UILabel!
    @IBOutlet weak var finishedIndexButton: UIButton!
    
    
}

