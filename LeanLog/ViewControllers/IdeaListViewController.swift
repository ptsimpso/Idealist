//
//  IdeaListViewController.swift
//  LeanLog
//
//  Created by Peter Simpson on 2/26/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit
import CoreData

class IdeaListViewController: UITableViewController, ModalDelegate {

    let iapKey = "unlimited"
    let kIAPIdentifer = "me.petersimpson.idealist.unlimited"
    let kDetailSegue = "DetailSegue"
    let kSettingsSegue = "SettingsSegue"
    
    let coreDataStack = CoreDataStack.sharedInstance
    var ideas: [Idea] = [];
    // andrea
    @IBOutlet weak var searchSegmentedControl: UISegmentedControl!
    var ungrouped: [Idea] = [];
    var groups: [Group] = [];
    var groupIdeaArrays: [[Idea]] = [];
    
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
        if searchSegmentedControl.selectedSegmentIndex == 0 {
            return 1
        } else {
            return groups.count + 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchSegmentedControl.selectedSegmentIndex == 0 {
            if ideas.count > 0 {
                return ideas.count
            }
            return 1
        } else {
            if section == 0 {
                return ungrouped.count
            } else {
                let ideaArray = groupIdeaArrays[section - 1]
                return ideaArray.count
            }
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if searchSegmentedControl.selectedSegmentIndex == 0 {
            return super.tableView(tableView, heightForHeaderInSection: section)
        } else {
            return 40.0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searchSegmentedControl.selectedSegmentIndex == 0 {
            return super.tableView(tableView, viewForHeaderInSection: section)
        } else {
            let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.width, 40.0))
            
            let green: CGFloat = 200.0 - CGFloat(section + 1) / CGFloat(groups.count + 1) * 110.0
            let headerColor: UIColor = UIColor(red: 75/255.0, green: green/255.0, blue: 195/255.0, alpha: 1.0)
            headerView.backgroundColor = headerColor
            
            let headerLabel = UILabel(frame: CGRectMake(18.0, 0, headerView.frame.width - 18.0, headerView.frame.height))
            headerLabel.textColor = UIColor.whiteColor()
            headerLabel.font = UIFont.boldSystemFontOfSize(16.0)
            
            if section == 0 {
                headerLabel.text = "Uncategorized"
            } else {
                let group = groups[section - 1]
                headerLabel.text = group.title
            }
            
            headerView.addSubview(headerLabel)
            
            return headerView
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if ideas.count > 0 || searchSegmentedControl.selectedSegmentIndex == 1 {
            return 70.0
        }
        return 142.0
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if searchSegmentedControl.selectedSegmentIndex == 0 {
            if ideas.count > 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("IdeaCell", forIndexPath: indexPath) as IdeaTitleCell
                
                IdeaHelper.setUpIdeaCell(cell, idea: ideas[indexPath.row], row: indexPath.row, count: ideas.count, formatter: formatter)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("NoDataCell", forIndexPath: indexPath) as UITableViewCell
                
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("IdeaCell", forIndexPath: indexPath) as IdeaTitleCell
            
            var rowIdea: Idea!
            var count: Int!
            
            if indexPath.section == 0 {
                rowIdea = ungrouped[indexPath.row]
                count = ungrouped.count
            } else {
                let ideaArray = groupIdeaArrays[indexPath.section - 1]
                rowIdea = ideaArray[indexPath.row]
                count = ideaArray.count
            }
            
            IdeaHelper.setUpIdeaCell(cell, idea: rowIdea, row: indexPath.row, count: count, formatter: formatter)
            
            return cell
        }
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if searchSegmentedControl.selectedSegmentIndex == 0 {
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
        } else {
            if editingStyle == .Delete {
                if indexPath.section == 0 {
                    let idea = ungrouped.removeAtIndex(indexPath.row)
                    coreDataStack.deleteIdea(idea)
                    
                    if ungrouped.count == 0 {
                        tableView.reloadData()
                    } else {
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    }
                } else {
                    let idea = groupIdeaArrays[indexPath.section - 1].removeAtIndex(indexPath.row)
                    coreDataStack.deleteIdea(idea)
                    
                    if groupIdeaArrays[indexPath.section - 1].count == 0 {
                        tableView.reloadData()
                    } else {
                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    }
                }
            }
        }
    }
    
    @IBAction func searchControlPressed(sender: UISegmentedControl) {
        refreshData()
    }

    func refreshData() {
        if searchSegmentedControl.selectedSegmentIndex == 0 {
            if let fetchResults = coreDataStack.fetchIdeas() {
                ideas = fetchResults
            }
        } else {
            if let groupResults = coreDataStack.fetchGroups() {
                groupIdeaArrays.removeAll(keepCapacity: true)
                groups = groupResults
                for singleGroup: Group in groups {
                    var groupIdeas: [Idea] = singleGroup.ideas.allObjects as [Idea]
                    groupIdeaArrays.append(groupIdeas)
                }
            }
            if let ungroupedIdeas = coreDataStack.fetchUngroupedIdeas() {
                ungrouped = ungroupedIdeas
            }
        }
        
        self.tableView.reloadData()
    }

    @IBAction func addPressed(sender: UIBarButtonItem) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let searchIndex = searchSegmentedControl.selectedSegmentIndex
        
        var totalIdeas: Int = 0
        if searchIndex == 1 {
            totalIdeas += ungrouped.count
            for ideaArray in groupIdeaArrays {
                totalIdeas += ideaArray.count
            }
        }
        
        if userDefaults.boolForKey(iapKey) || (searchIndex == 0 && ideas.count < 3) || (searchIndex == 1 && totalIdeas < 3) {
            Branch.getInstance().userCompletedAction("created_idea")
            let newIdea = coreDataStack.insertNewIdea()
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            
            var needsRefresh: Bool = true
            if searchIndex == 0 {
                ideas.insert(newIdea, atIndex: 0)
                needsRefresh = ideas.count <= 1
            } else {
                ungrouped.insert(newIdea, atIndex: 0)
                needsRefresh = ungrouped.count <= 1
            }
            
            if needsRefresh {
                tableView.reloadData()
            } else {
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            }
            
            performSegueWithIdentifier(kDetailSegue, sender: indexPath)
            
        } else {
            PFAnalytics.trackEventInBackground("reached_limit", block: nil)
            Branch.getInstance().userCompletedAction("reached_limit")
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
            
            if searchSegmentedControl.selectedSegmentIndex == 0 {
                destination.idea = ideas[indexPath.row]
            } else {
                if indexPath.section == 0 {
                    destination.idea = ungrouped[indexPath.row]
                } else {
                    let ideaArray = groupIdeaArrays[indexPath.section - 1]
                    destination.idea = ideaArray[indexPath.row]
                }
            }
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        } else if segue.identifier == kSettingsSegue {
            let destination = segue.destinationViewController as SettingsViewController
            destination.delegate = self
        }
    }
    
    func minimizeView(sender: AnyObject) {
        spring(0.7, {
            // .935
            self.navigationController!.view.transform = CGAffineTransformMakeScale(0.935, 0.935)
        })
    }
    
    func maximizeView(sender: AnyObject) {
        spring(0.7, {
            self.navigationController!.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        })
    }
    
    func dismissModalHandler() {
        
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
