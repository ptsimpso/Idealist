//
//  DetailsViewController.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/2/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {

    let kCategorySegue = "CategorySegue"
    
    var bulletOn = false
    
    var idea: Idea!
    let coreDataStack = CoreDataStack.sharedInstance
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var separatorView: UIView!
    var placeholderLabel : UILabel!
    
    var accentColor = UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0)
    var defaultColor: UIColor!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableShadow: UIView!
    
    @IBOutlet weak var dotProblem: UIView!
    @IBOutlet weak var dotCustomers: UIView!
    @IBOutlet weak var dotAlts: UIView!
    @IBOutlet weak var dotUvp: UIView!
    @IBOutlet weak var dotSolution: UIView!
    @IBOutlet weak var dotChannels: UIView!
    @IBOutlet weak var dotRevenue: UIView!
    @IBOutlet weak var dotCosts: UIView!
    @IBOutlet weak var dotMetrics: UIView!
    @IBOutlet weak var dotAdvantage: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        separatorView.backgroundColor = accentColor
        
        titleField.delegate = self
        titleField.autocorrectionType = UITextAutocorrectionType.No
        titleField.textColor = accentColor
        if let ideaTitle = idea.title {
            titleField.text = ideaTitle
        }
        
        notesTextView.delegate = self
        notesTextView.autocorrectionType = UITextAutocorrectionType.No
        notesTextView.textColor = accentColor
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Notes"
        placeholderLabel.font = UIFont.boldSystemFontOfSize(notesTextView.font.pointSize)
        placeholderLabel.sizeToFit()
        notesTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPointMake(5, notesTextView.font.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 203/255.0, alpha: 1.0)
        if let ideaNotes = idea.notes {
            notesTextView.text = ideaNotes
        }
        placeholderLabel.hidden = countElements(notesTextView.text) != 0
        
        let shadow = CAGradientLayer()
        shadow.frame = tableShadow.bounds
        let shadowArray = [UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).CGColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).CGColor]
        shadow.colors = shadowArray
        shadow.locations = [0.0, 0.8]
        tableShadow.layer.insertSublayer(shadow, atIndex:0)
        
        let backgroundView = UIView(frame: self.tableView.bounds);
        let gradient = CAGradientLayer()
        gradient.frame = backgroundView.bounds
        let colorArray = [UIColor(red: 1.0, green: 197/255.0, blue: 0, alpha: 1.0).CGColor, UIColor(red: 1.0, green: 80/255.0, blue: 0, alpha: 1.0).CGColor]
        gradient.colors = colorArray
        gradient.locations = [0.5, 0.5]
        backgroundView.layer.insertSublayer(gradient, atIndex:0)
        self.tableView.backgroundView = backgroundView
    }
    
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = countElements(textView.text) != 0
    }
    
    override func viewWillAppear(animated: Bool) {
        refreshData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        updateIdea()
        super.viewWillDisappear(animated)
    }
    
    func updateIdea() {
        if titleField.text != idea.title || notesTextView.text != idea.notes {
            idea.title = titleField.text
            idea.notes = notesTextView.text
            idea.updatedAt = NSDate();
            coreDataStack.saveContext()
        }
    }
    
    // MARK: - Text Delegates

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
        updateIdea()
    }
    
    func refreshData() {
        IdeaHelper.setUpDetailsDots(self, idea: idea)
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
            
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        }
    }
    
}
