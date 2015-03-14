//
//  GroupsViewController.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/13/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit
import CoreData

class GroupsViewController: UITableViewController {

    let coreDataStack = CoreDataStack.sharedInstance
    var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count + 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 78.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell", forIndexPath: indexPath) as GroupCell
        
        var group: Group?
        if indexPath.row > 0 {
            group = groups[indexPath.row - 1]
        }
        
        IdeaHelper.setUpGroupCell(cell, row: indexPath.row, count: groups.count + 1, group: group)
        
        return cell
    }
    
    @IBAction func addGroup(sender: UIBarButtonItem) {
        var titleField:UITextField?
        var addAlert = UIAlertController(title: "Add Category", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        addAlert.addTextFieldWithConfigurationHandler({
            (field: UITextField!) in
            field.autocapitalizationType = UITextAutocapitalizationType.Words
            field.placeholder = "Category title"
            titleField = field
        })
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:nil))
        
        addAlert.addAction(UIAlertAction(title: "Save", style: .Default, handler: { (action: UIAlertAction!) in
            if (countElements(titleField!.text) > 0) {
                self.coreDataStack.insertNewGroup(titleField!.text)
                self.refreshData()
            }
        }))
        
        presentViewController(addAlert, animated: true, completion: nil)
    }
    
    @IBAction func dismissVC(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
