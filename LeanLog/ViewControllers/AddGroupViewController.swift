//
//  AddGroupViewController.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/15/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit

class AddGroupViewController: UIViewController {

    let coreDataStack = CoreDataStack.sharedInstance
    
    var group: Group?
    
    @IBOutlet weak var modalView: SpringView!
    @IBOutlet weak var groupTitleField: UITextField!
    @IBOutlet weak var closeButton: SpringButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: ModalDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupTitleField.autocorrectionType = UITextAutocorrectionType.No
        groupTitleField.autocapitalizationType = UITextAutocapitalizationType.Words
        saveButton.layer.cornerRadius = 2.0
        saveButton.layer.borderColor = UIColor.whiteColor().CGColor
        saveButton.layer.borderWidth = 2.0
        
        if let unwrappedGroup = group {
            titleLabel.text = "Edit Category"
            groupTitleField.text = unwrappedGroup.title
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        closeButton.animate()
        modalView.animate()
        groupTitleField.becomeFirstResponder()
    }

    @IBAction func savePressed(sender: UIButton) {
        if (count(groupTitleField.text) > 0) {
            if group != nil {
                group?.title = groupTitleField.text
                coreDataStack.saveContext()
            } else {
                coreDataStack.insertNewGroup(groupTitleField.text)
            }
            self.delegate.dismissModalHandler(nil)
            dismissVC()
        }
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        dismissVC()
    }
    
    func dismissVC() {
        groupTitleField.resignFirstResponder()
        closeButton.animation = "fadeOut"
        modalView.animation = "fall"
        closeButton.animate()
        modalView.animateNext({
            self.dismissViewControllerAnimated(false, completion: {
                
            })
        })
    }
}
