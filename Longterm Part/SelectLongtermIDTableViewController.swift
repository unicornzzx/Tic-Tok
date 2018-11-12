//
//  SelectLongtermIDTableViewController.swift
//  Tic-Tok
//
//  Created by Zhixiang.Zhang on 2018/5/14.
//  Copyright © 2018 Echo. All rights reserved.
//

import UIKit
import CoreData

class SelectLongtermTableViewController: UITableViewController {

    // MARK: Properties
    var longterms : [Longterms]?
    var returnLongterm : Longterms?
    
    // MARK: Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        let dele = (UIApplication.shared.delegate as! AppDelegate)
        let context = dele.persistentContainer.viewContext
        let longtermDAO = LongtermDAO(context: context)
        longterms = longtermDAO.getUnfinished()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
  
            guard let selectedLongtermCell = sender as? LongtermTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedLongtermCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            returnLongterm = longterms![indexPath.row]
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if longterms == nil {
            return 0
        }else{
            return longterms!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifer = "LongtermTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifer, for: indexPath) as? LongtermTableViewCell else {
            fatalError("The dequeued cell is not an instance of LongtermTableViewCell")
        }
        let longterm = longterms![indexPath.row]
        cell.nameLabel.text = longterm.name
        if longterm.hasDDL.boolValue {
            cell.progress.progress = Float(longterm.timeSoFar!.intValue)/Float(longterm.estimatedTime!.intValue)
            cell.infoLabel.text = String(Int(Float(longterm.timeSoFar!.intValue)/Float(longterm.estimatedTime!.intValue) * 100))+" %"
        }else{
            cell.progress.isHidden = true
            cell.infoLabel.text = "already done part:" + String(Int(longterm.timeSoFar!.intValue/3600)) + " hour(s)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    //MARK: Actions
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
