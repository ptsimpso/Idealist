//
//  SetGroupViewController.swift
//  LeanLog
//
//  Created by Peter Simpson on 4/21/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit

class SetGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GroupCellDelegate, ModalDelegate {

    let kAddGroupSegue = "AddGroupSegue"
    let kEditGroupSegue = "EditGroupSegue"
    
    @IBOutlet weak var tableView: UITableView!
    
    let coreDataStack = CoreDataStack.sharedInstance
    var groups: [Group] = []
    var idea: Idea!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func dismissModalHandler(sender: AnyObject?) {
        refreshData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    func refreshData() {
        if let fetchResults = coreDataStack.fetchGroups() {
            groups = fetchResults
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count + 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 78.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath) as! GroupCell
            
            var group: Group?
            
            IdeaHelper.setUpGroupCell(cell, row: indexPath.row, count: groups.count + 1, group: group)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("GroupEditCell", forIndexPath: indexPath) as! GroupCell
            
            var group: Group? = groups[indexPath.row - 1]
            
            IdeaHelper.setUpGroupCell(cell, row: indexPath.row, count: groups.count + 1, group: group)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            idea.groups = Set<Group>()
        } else {
            Branch.getInstance().userCompletedAction("selected_group")
            let group = groups[indexPath.row - 1]
            idea.groups = [group] as Set
        }
        idea.updatedAt = NSDate()
        coreDataStack.saveContext()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleEditPressed(sender: GroupCell) {
        let indexPath = self.tableView.indexPathForCell(sender)
        if let indexPath = indexPath {
            let group = self.groups[indexPath.row - 1]
            self.performSegueWithIdentifier(self.kEditGroupSegue, sender: group)
        }
    }
    
    func handleDeletePressed(sender: GroupCell) {
        
        var deleteAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this category?", preferredStyle: UIAlertControllerStyle.Alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (action: UIAlertAction!) in
            let indexPath = self.tableView.indexPathForCell(sender)
            if let indexPath = indexPath {
                let group = self.groups.removeAtIndex(indexPath.row - 1)
                self.coreDataStack.deleteGroup(group)
                
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:nil))
        
        self.presentViewController(deleteAlert, animated: true, completion: nil)
    }
    
    // MARK: Navigation
    
    @IBAction func dismissVC(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func minimizeView(sender: AnyObject) {
        
    }
    
    func maximizeView(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kAddGroupSegue {
            let destination = segue.destinationViewController as! AddGroupViewController
            destination.delegate = self
        } else if segue.identifier == kEditGroupSegue {
            let destination = segue.destinationViewController as! AddGroupViewController
            destination.group = sender as? Group
            destination.delegate = self
        }
    }

}
