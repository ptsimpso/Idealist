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
    var selectedHolder: Set<Group> = []
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
    
    override func viewDidAppear(animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if !userDefaults.boolForKey("firstGroup") {
            let alert = UIAlertController(title: "Multiple Categories", message: "After adding more categories, tap the check marks and then the save button to add your idea to multiple categories. Or just tap a category name to add it to one.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            userDefaults.setBool(true, forKey: "firstGroup")
            userDefaults.synchronize()
        }
    }
    
    func refreshData() {
        groups = []
        
        if let fetchResults = coreDataStack.fetchGroups() {
            groups = fetchResults
        }
        selectedHolder = idea.groups as! Set<Group>
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
            
            IdeaHelper.setUpGroupCell(cell, row: indexPath.row, count: groups.count + 1, group: nil)
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("GroupEditCell", forIndexPath: indexPath) as! GroupCell
            
            var group: Group? = groups[indexPath.row - 1]
            
            IdeaHelper.setUpGroupCell(cell, row: indexPath.row, count: groups.count + 1, group: group)
            
            updateCheckButton(cell.checkButton!, group: group!)
            
            cell.delegate = self
            return cell
        }
    }
    
    func updateCheckButton(checkButton: UIButton, group: Group) {
        if selectedHolder.contains(group) {
            checkButton.setBackgroundImage(UIImage(named: "yesCheck"), forState: UIControlState.Normal)
            checkButton.backgroundColor = UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0)
        } else {
            checkButton.setBackgroundImage(UIImage(named: "noCheck"), forState: UIControlState.Normal)
            checkButton.backgroundColor = UIColor.whiteColor()
        }
    }
    
    // MARK: Actions
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedHolder.removeAll(keepCapacity: false)
        if indexPath.row != 0 {
            let group = groups[indexPath.row - 1]
            selectedHolder.insert(group)
        }
        savePressed(nil)
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
                self.selectedHolder.remove(group)
            }
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))
        
        self.presentViewController(deleteAlert, animated: true, completion: nil)
    }
    
    func handleCheckPressed(sender: GroupCell) {
        let indexPath = self.tableView.indexPathForCell(sender)
        if let indexPath = indexPath {
            let group = groups[indexPath.row - 1]
            if selectedHolder.contains(group) {
                selectedHolder.remove(group)
            } else {
                selectedHolder.insert(group)
            }
            updateCheckButton(sender.checkButton!, group: group)
        }
    }
    
    @IBAction func savePressed(sender: AnyObject?) {
        if selectedHolder.count > 1 {
            Heap.track("Multiple Categories")
        }
        idea.groups = selectedHolder
        idea.updatedAt = NSDate()
        coreDataStack.saveContext()
        dismissVC(nil)
    }
    
    // MARK: Navigation
    
    @IBAction func dismissVC(sender: AnyObject?) {
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
