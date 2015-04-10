//
//  SettingsViewController.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/11/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var backButton: SpringButton!
    @IBOutlet weak var modalView: SpringView!
    @IBOutlet weak var hiLabel: SpringLabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var feedbackButton: UIButton!
    @IBOutlet weak var iCloudButton: UIButton!
    var iCloudBool = true
    
    var delegate: ModalDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareButton.layer.borderColor = UIColor.whiteColor().CGColor
        rateButton.layer.borderColor = UIColor.whiteColor().CGColor
        feedbackButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        modalView.transform = CGAffineTransformMakeTranslation(0, 300)
        
        let iCloudBoolOpt: Bool? = NSUserDefaults.standardUserDefaults().boolForKey("iCloudDisabled")
        if let storediCloudBool = iCloudBoolOpt {
            iCloudBool = storediCloudBool
            updateiCloudButton()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        delegate.minimizeView(self)
        backButton.animate()
        modalView.animate()
        hiLabel.animate()
    }
    
    @IBAction func sharePressed(sender: AnyObject) {
        var shareText = "Idealist -- app for tracking biz ideas: https://bnc.lt/idealist-ios"
        Branch.getInstance().userCompletedAction("shared")
        let activityVC: UIActivityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func ratePressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/app/id975937527")!)
    }
    
    @IBAction func sendFeedbackPressed(sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            mailComposeVC.setToRecipients(["contact@getidealist.com"])
            mailComposeVC.setSubject("Idealist Feedback")
            self.presentViewController(mailComposeVC, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func iCloudPressed(sender: AnyObject) {
        iCloudBool = !iCloudBool
        NSUserDefaults.standardUserDefaults().setBool(iCloudBool, forKey: "iCloudDisabled")
        updateiCloudButton()
    }
    
    func updateiCloudButton() {
        var boolString = iCloudBool ? "disabled" : "enabled"
        iCloudButton.setTitle("iCloud sync " + boolString, forState: UIControlState.Normal)
    }
    
    @IBAction func backPressed() {
        delegate.maximizeView(self)
        
        UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.modalView.transform = CGAffineTransformMakeTranslation(0, 300)
                self.backButton.alpha = 0
            }) { (completed: Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: nil)
            }
    }

}
