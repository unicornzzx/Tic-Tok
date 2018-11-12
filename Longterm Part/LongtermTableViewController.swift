//
//  LongtermTableViewController.swift
//  Tic-Tok
//
//  Created by Zhixiang.Zhang on 2018/5/14.
//  Copyright © 2018 Echo. All rights reserved.
//


import UIKit
import os.log

class LongtermTableViewController: UITableViewController {
    
    //MARK:Properties
    var longterms : [Longterms]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dele = (UIApplication.shared.delegate as! AppDelegate)
        let context = dele.persistentContainer.viewContext
        let longtermDAO = LongtermDAO(context: context)
        longterms = longtermDAO.getAll()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
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
            //cell.progress.progress = Float(longterm.timeSoFar!.intValue)/Float(longterm.estimatedTime!.intValue)
            if longterm.done.boolValue {
                cell.infoLabel.text = "100 %"
                cell.progress.progress = 1.0
            } else {
                cell.infoLabel.text = String(Int(Float(longterm.timeSoFar!.intValue)/Float(longterm.estimatedTime!.intValue) * 100))+" %"
                cell.progress.progress = Float(longterm.timeSoFar!.intValue)/Float(longterm.estimatedTime!.intValue)
            }
        }else{
            cell.progress.isHidden = true
            cell.infoLabel.text = "already done part: " + String(Int(longterm.timeSoFar!.intValue/3600)) + " hour(s)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let dele = (UIApplication.shared.delegate as! AppDelegate)
            let context = dele.persistentContainer.viewContext
            let longtermDAO = LongtermDAO(context: context)
            let index = longterms![indexPath.row].id.intValue
            longtermDAO.deletByID(id: index)
            longterms!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddLongterm":
            os_log("Adding a new longterm.", log: OSLog.default, type: .debug)
            
        case "ShowDetails":
            guard let longtermDetailViewController = segue.destination as? LongtermDetailsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedLongtermCell = sender as? LongtermTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedLongtermCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedLongterm = longterms![indexPath.row]
            longtermDetailViewController.longterm = selectedLongterm
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    //MARK: Actions
    @IBAction func dismiss(_ sender: UISwipeGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func unwindTOLongtermList(sender : UIStoryboardSegue){
        if let sourceViewController = sender.source as? NewLongtermViewController, let longterm = sourceViewController.longterm {
            
            // Add a new longterm.
            let newIndexPath = IndexPath(row: longterms!.count, section: 0)
            
            longterms!.append(longterm)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
}
