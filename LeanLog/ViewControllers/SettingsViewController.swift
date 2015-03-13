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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func sharePressed(sender: AnyObject) {
        var shareText = "Idealist: http://www.getidealist.com"
        
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
    
    @IBAction func backPressed() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
