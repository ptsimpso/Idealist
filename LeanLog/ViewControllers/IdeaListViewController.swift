//
//  IdeaListViewController.swift
//  LeanLog
//
//  Created by Peter Simpson on 2/26/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit
import CoreData

class IdeaListViewController: UITableViewController {

    let iapKey = "unlimited"
    let kIAPIdentifer = "me.petersimpson.idealist.unlimited"
    let kDetailSegue = "DetailSegue"
    
    let coreDataStack = CoreDataStack.sharedInstance
    var ideas: [Idea] = [];
    
    let formatter: NSDateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        let backgroundView = UIView(frame: CGRectMake(self.tableView.frame.width-6, 0, 6.0, self.tableView.frame.height));
        
        let goldView = UIView(frame: CGRectMake(self.tableView.frame.width-6, 0, 6.0, self.tableView.frame.height))
        goldView.backgroundColor = UIColor(red: 1.0, green: 213/255.0, blue: 0, alpha: 1.0)
        backgroundView.addSubview(goldView);
        self.tableView.backgroundView = backgroundView

        formatter.dateFormat = "h:mm a, MMM d"
        formatter.AMSymbol = "am"
        formatter.PMSymbol = "pm"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "persistentStoreDidChange", name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "persistentStoreWillChange:", name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: coreDataStack.managedObjectContext!.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveICloudChanges:", name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: coreDataStack.managedObjectContext!.persistentStoreCoordinator)

        refreshData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: coreDataStack.managedObjectContext!.persistentStoreCoordinator)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: coreDataStack.managedObjectContext!.persistentStoreCoordinator)
        
        super.viewWillDisappear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // Return the number of rows in the section.
        if ideas.count > 0 {
            return ideas.count
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if ideas.count > 0 {
            return 70.0
        }
        return 142.0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if ideas.count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("IdeaCell", forIndexPath: indexPath) as IdeaTitleCell
            
            // Configure the cell...
            IdeaHelper.setUpIdeaCell(cell, idea: ideas[indexPath.row], row: indexPath.row, count: ideas.count, formatter: formatter)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("NoDataCell", forIndexPath: indexPath) as UITableViewCell
            
            return cell
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let idea = ideas.removeAtIndex(indexPath.row)
            coreDataStack.deleteIdea(idea)
            
            if ideas.count == 0 {
                tableView.reloadData()
            } else {
                // Delete the row from the data source
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
        }
    }

    func refreshData() {

        if let fetchResults = coreDataStack.fetchIdeas() {
            ideas = fetchResults
        }
        
        self.tableView.reloadData()
    }

    @IBAction func addPressed(sender: UIBarButtonItem) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if ideas.count < 3 || userDefaults.boolForKey(iapKey) {
            
            let newIdea = coreDataStack.insertNewIdea()
            ideas.insert(newIdea, atIndex: 0)
            
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            if ideas.count == 1 {
                tableView.reloadData()
            } else {
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            }
            
            performSegueWithIdentifier(kDetailSegue, sender: indexPath)
            
        } else {
            
            var purchaseAlert = UIAlertController(title: "Limit Reached", message: "Unlock the ability to create unlimited ideas for $1.99!", preferredStyle: UIAlertControllerStyle.Alert)
            
            purchaseAlert.addAction(UIAlertAction(title: "Purchase", style: .Default, handler: { (action: UIAlertAction!) in
                PFPurchase.buyProduct(self.kIAPIdentifer, block: { (error:NSError?) -> Void in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
            }))
            
            purchaseAlert.addAction(UIAlertAction(title: "Restore", style: .Default, handler: { (action: UIAlertAction!) in
                PFPurchase.buyProduct(self.kIAPIdentifer, block: { (error:NSError?) -> Void in
                    if error != nil {
                        let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
            }))
            
            purchaseAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler:nil))
            
            presentViewController(purchaseAlert, animated: true, completion: nil)
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(kDetailSegue, sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kDetailSegue {
            let indexPath = sender as NSIndexPath
            let cell: IdeaTitleCell = self.tableView.cellForRowAtIndexPath(indexPath) as IdeaTitleCell
            
            let destination = segue.destinationViewController as DetailsViewController
            destination.accentColor = cell.ideaTitleLabel.textColor
            destination.defaultColor = UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0)
            destination.idea = ideas[indexPath.row]
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        }
    }
    
    // MARK: Core Data Notifications
    func persistentStoreDidChange() {
        println("did change")
//        self.refreshData()
    }
    
    func persistentStoreWillChange(notification: NSNotification) {
        println("will change")
        coreDataStack.managedObjectContext!.performBlock { () -> Void in
            var error: NSError? = nil
            self.coreDataStack.managedObjectContext!.save(&error)
            if error != nil {
                println("Save error: \(error)")
            } else {
                self.coreDataStack.managedObjectContext!.reset()
                self.refreshData()
            }
        }
    }
    
    func receiveICloudChanges(notification: NSNotification) {
        println("icloud")
        coreDataStack.managedObjectContext!.performBlock { () -> Void in
            self.coreDataStack.managedObjectContext!.mergeChangesFromContextDidSaveNotification(notification)
            self.refreshData()
        }
    }

}
