//
//  DetailsViewController.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/2/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit
import MessageUI

class DetailsViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    let kCategorySegue = "CategorySegue"
    let kGroupSegue = "SetGroupSegue"
    
    var bulletOn = false
    
    var idea: Idea!
    let coreDataStack = CoreDataStack.sharedInstance
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var groupButton: SpringButton!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    var placeholderLabel : UILabel!
    
    var accentColor = UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0)
    var defaultColor: UIColor!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableShadow: UIView!
    
    @IBOutlet var dotArray: [SpringView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dotArray.sort({ $0.frame.origin.x < $1.frame.origin.x }) // Can now access dots from left to right
        
        separatorView.backgroundColor = accentColor
        groupButton.backgroundColor = accentColor
        
        titleField.delegate = self
        titleField.textColor = accentColor
        if let ideaTitle = idea.title {
            titleField.text = ideaTitle
        }
        
        notesTextView.delegate = self
        notesTextView.textColor = accentColor
        notesTextView.layoutManager.allowsNonContiguousLayout = false
        
        // Placeholder hack for UITextView
        placeholderLabel = UILabel()
        placeholderLabel.text = "General notes"
        placeholderLabel.font = UIFont.boldSystemFontOfSize(notesTextView.font.pointSize)
        placeholderLabel.sizeToFit()
        notesTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, notesTextView.font.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 203/255.0, alpha: 1.0)
        if let ideaNotes = idea.notes {
            notesTextView.text = ideaNotes
        }
        placeholderLabel.hidden = countElements(notesTextView.text) != 0
        
        // Layout category TableView background and top shadow
        let shadow = CAGradientLayer()
        shadow.frame = tableShadow.bounds
        let shadowArray = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.12).CGColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).CGColor]
        shadow.colors = shadowArray
        shadow.locations = [0.0, 0.8]
        tableShadow.layer.insertSublayer(shadow, atIndex:0)
        
        let backgroundView = UIView(frame: CGRectMake(0, 0, self.view.frame.width, self.tableView.frame.height));
        let gradient = CAGradientLayer()
        gradient.frame = backgroundView.bounds
        let colorArray = [UIColor(red: 1.0, green: 197/255.0, blue: 0, alpha: 1.0).CGColor, UIColor(red: 1.0, green: 80/255.0, blue: 0, alpha: 1.0).CGColor]
        gradient.colors = colorArray
        gradient.locations = [0.5, 0.5]
        backgroundView.layer.insertSublayer(gradient, atIndex:0)
        self.tableView.backgroundView = backgroundView
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshDots()
        refreshData()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        updateIdeaText()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        if self.isMovingFromParentViewController() {
            iRate.sharedInstance().promptIfAllCriteriaMet()
        }
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Text and keyboard manipulation

    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = countElements(textView.text) != 0
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if titleField.inputAccessoryView == nil {
            titleField.inputAccessoryView = IdeaHelper.createAccessoryView(self)
        }
        
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if notesTextView.inputAccessoryView == nil {
            notesTextView.inputAccessoryView = IdeaHelper.createBulletAccessoryView(self)
        }
        
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return IdeaHelper.handleTextView(textView, shouldChangeTextInRange: range, replacementText: text, withBulletOn: bulletOn)
    }
    
    func toggleBullet(sender: UIButton) {
        IdeaHelper.handleBulletToggleForTextView(notesTextView, sender: sender, bulletOn: bulletOn)
        bulletOn = !bulletOn
        self.textViewDidChange(notesTextView)
    }
    
    func dismissKeyboard() {
        titleField.resignFirstResponder()
        notesTextView.resignFirstResponder()
        updateIdeaText()
        iRate.sharedInstance().promptIfAllCriteriaMet()
    }
    
    func keyboardWillChange(notification: NSNotification) {
        let userDict: [NSObject : AnyObject] = notification.userInfo!
        
        let rectRaw: NSValue = userDict[UIKeyboardFrameEndUserInfoKey] as NSValue
        var rect: CGRect = rectRaw.CGRectValue()
        rect = self.view.convertRect(rect, fromView: nil)
        let diffValue = self.view.frame.height - rect.origin.y
        
        if diffValue > 0 {
            textViewBottomConstraint.constant = diffValue + 5
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        } else {
            textViewBottomConstraint.constant = 260.0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: Refreshing / saving data and views
    func updateIdeaText() {
        if titleField.text != idea.title || notesTextView.text != idea.notes {
            idea.title = titleField.text
            idea.notes = notesTextView.text
            idea.updatedAt = NSDate();
            coreDataStack.saveContext()
        }
    }
    
    @IBAction func priorityTapped(sender: UIButton) {
        Heap.track("Priority Set")
        Branch.getInstance().userCompletedAction("set_priority")
        idea.priority = sender.tag
        coreDataStack.saveContext()
        refreshDots()
    }
    
    func refreshDots() {
        for index in 0..<dotArray.count {
            let dot = dotArray[index]
            dot.hidden = true
            if index < idea.priority.integerValue {
                dot.hidden = false
                let delay: CGFloat = CGFloat(index) * 0.02 + 0.07
                dot.delay = delay
                dot.animate()
            }
        }
    }
    
    func refreshData() {
        if let group = idea.group {
            groupButton.setTitle(group.title, forState: .Normal)
        } else {
            groupButton.setTitle("Uncategorized", forState: .Normal)
        }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Return the number of rows in the section.
        return Categories.array.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as CategoryCell
        
        // Configure the cell...
        let category = Categories.array[indexPath.row]["title"]
        IdeaHelper.setUpCategoryCell(cell, row: indexPath.row, category: category!, idea: idea)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(kCategorySegue, sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kCategorySegue {
            
            let indexPath = sender as NSIndexPath
            let cell = self.tableView.cellForRowAtIndexPath(indexPath)
            let destination = segue.destinationViewController as CategoryViewController
            let categoryDict = Categories.array[indexPath.row]
            destination.title = categoryDict["title"]
            destination.promptText = categoryDict["prompt"]!
            destination.accentColor = cell?.contentView.backgroundColor
            destination.defaultColor = defaultColor
            destination.categoryIndex = indexPath.row
            destination.idea = idea
            
            Heap.track("Section Pressed", withProperties:["sectionIndex":indexPath.row])
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        } else if segue.identifier == kGroupSegue {
            
            let navController = segue.destinationViewController as UINavigationController
            let destination = navController.viewControllers[0] as GroupsViewController
            destination.idea = idea
        }
    }
    
    // MARK: Sharing idea
    
    @IBAction func shareIdea(sender: UIBarButtonItem) {
        updateIdeaText()
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            
            let htmlString = IdeaHelper.composeShareStringWithIdea(idea)
            
            mailComposeVC.setMessageBody(htmlString, isHTML: true)
            self.presentViewController(mailComposeVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
