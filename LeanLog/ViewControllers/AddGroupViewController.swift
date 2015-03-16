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
    
    @IBOutlet weak var modalView: SpringView!
    @IBOutlet weak var groupTitleField: UITextField!
    @IBOutlet weak var closeButton: SpringButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate: ModalDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groupTitleField.autocorrectionType = UITextAutocorrectionType.No
        groupTitleField.autocapitalizationType = UITextAutocapitalizationType.Words
        saveButton.layer.cornerRadius = 2.0
        saveButton.layer.borderColor = UIColor.whiteColor().CGColor
        saveButton.layer.borderWidth = 2.0
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        delegate.minimizeView(self)
        closeButton.animate()
        modalView.animate()
        groupTitleField.becomeFirstResponder()
    }

    @IBAction func savePressed(sender: UIButton) {
        if (countElements(groupTitleField.text) > 0) {
            coreDataStack.insertNewGroup(groupTitleField.text)
            self.delegate.dismissModalHandler()
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
