//
//  CategoryViewController.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/3/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITextViewDelegate {

    let coreDataStack = CoreDataStack.sharedInstance
    
    var bulletOn = false
    
    var idea: Idea!
    var promptText = ""
    var categoryIndex: Int!
    var accentColor: UIColor!
    var defaultColor: UIColor!
    
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var promptTextView: UITextView!
    @IBOutlet weak var promptContainer: UIView!
    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var animateView: SpringView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateView.transform = CGAffineTransformMakeTranslation(0, 150)

        promptContainer.backgroundColor = accentColor
        promptTextView.text = promptText
        
        var notesOpt: String? = nil
        
        switch (categoryIndex) {
        case 0:
            if let problem = idea.problem {
                notesOpt = problem
            }
        case 1:
            if let customerSegments = idea.customerSegments {
                notesOpt = customerSegments
            }
        case 2:
            if let alts = idea.alternatives {
                notesOpt = alts
            }
        case 3:
            if let uvp = idea.uvp {
                notesOpt = uvp
            }
        case 4:
            if let solution = idea.solution {
                notesOpt = solution
            }
        case 5:
            if let channels = idea.channels {
                notesOpt = channels
            }
        case 6:
            if let revenue = idea.revenue {
                notesOpt = revenue
            }
        case 7:
            if let costs = idea.costs {
                notesOpt = costs
            }
        case 8:
            if let metrics = idea.metrics {
                notesOpt = metrics
            }
        case 9:
            if let adv = idea.unfairAdv {
                notesOpt = adv
            }
        default:
            println("ERROR: No category index set.")
        }
        
        if let notes = notesOpt {
            notesTextView.text = notes
        } else {
            notesTextView.text = ""
        }
        notesTextView.delegate = self
        notesTextView.layoutManager.allowsNonContiguousLayout = false
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.barTintColor = accentColor
        animateView.animate()
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        updateIdea()
        self.navigationController!.navigationBar.barTintColor = defaultColor
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        if self.isMovingFromParentViewController() {
            iRate.sharedInstance().promptIfAllCriteriaMet()
        }
        
        super.viewWillDisappear(animated)
    }
    
    func updateIdea() {
        
        switch (categoryIndex) {
        case 0:
            idea.problem = notesTextView.text
        case 1:
            idea.customerSegments = notesTextView.text
        case 2:
            idea.alternatives = notesTextView.text
        case 3:
            idea.uvp = notesTextView.text
        case 4:
            idea.solution = notesTextView.text
        case 5:
            idea.channels = notesTextView.text
        case 6:
            idea.revenue = notesTextView.text
        case 7:
            idea.costs = notesTextView.text
        case 8:
            idea.metrics = notesTextView.text
        case 9:
            idea.unfairAdv = notesTextView.text
        default:
            println("ERROR: No category index set.")
        }
        
        idea.updatedAt = NSDate();
        coreDataStack.saveContext()
        Branch.getInstance().userCompletedAction("saved_category")
    }
    
    // MARK: Keyboard and TextView manipulation
    func dismissKeyboard() {
        notesTextView.resignFirstResponder()
        updateIdea()
        iRate.sharedInstance().promptIfAllCriteriaMet()
    }
    
    func keyboardWillChange(notification: NSNotification) {
        
        // Animate UITextView bottom constraint
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
            textViewBottomConstraint.constant = 150.0
            self.view.layoutIfNeeded()
        }
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
    }
    
}
