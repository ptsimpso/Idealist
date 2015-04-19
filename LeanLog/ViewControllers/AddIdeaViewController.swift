//
//  AddIdeaViewController.swift
//  LeanLog
//
//  Created by Peter Simpson on 4/6/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit

class AddIdeaViewController: UIViewController {
    
    @IBOutlet weak var modalView: SpringView!
    @IBOutlet weak var ideaTitleField: UITextField!
    @IBOutlet weak var closeButton: SpringButton!
    @IBOutlet weak var saveButton: UIButton!

    var delegate: ModalDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ideaTitleField.autocorrectionType = UITextAutocorrectionType.No
        ideaTitleField.autocapitalizationType = UITextAutocapitalizationType.Words
        saveButton.layer.cornerRadius = 2.0
        saveButton.layer.borderColor = UIColor.whiteColor().CGColor
        saveButton.layer.borderWidth = 2.0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        closeButton.animate()
        modalView.animate()
        ideaTitleField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePressed(sender: UIButton) {
        if (count(ideaTitleField.text) > 0) {
            self.delegate.dismissModalHandler(ideaTitleField.text)
            dismissVC()
        }
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        dismissVC()
    }
    
    func dismissVC() {
        ideaTitleField.resignFirstResponder()
        closeButton.animation = "fadeOut"
        modalView.animation = "fall"
        closeButton.animate()
        modalView.animateNext({
            self.dismissViewControllerAnimated(false, completion: {
                
            })
        })
    }

}
