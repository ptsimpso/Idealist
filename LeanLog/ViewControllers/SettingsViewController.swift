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
    
    @IBOutlet weak var referralLabel: UILabel!
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
        
        /*
        let sail = Sail.sharedInstance()
        sail.getUserData { (userParams) -> Void in
            let referralCount = userParams["totalReferrals"] as? NSNumber
            if let referralCount = referralCount {
                self.referralLabel.text = "Referral count: \(referralCount.integerValue)"
            }
        }
        */
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        delegate.minimizeView(self)
        backButton.animate()
        modalView.animate()
        hiLabel.animate()
        /*
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if !userDefaults.boolForKey("firstSettings") {
            PFConfig.getConfigInBackgroundWithBlock {
                (var config, error) -> Void in
                if error == nil {
                    
                } else {
                    config = PFConfig.currentConfig()
                }
                
                var paidApp: Bool
                var paidAppOpt = config?.objectForKey("paidApp") as? Bool
                if let paidAppBool = paidAppOpt {
                    paidApp = paidAppBool
                } else {
                    paidApp = false
                }
                
                var referralPrize: Int
                var referralPrizeConfig = config?.objectForKey("referralPrize") as? Int
                if let referralPrizeConfig = referralPrizeConfig {
                    referralPrize = referralPrizeConfig
                } else {
                    referralPrize = 3
                }
                
                var productPriceString: String
                var productPriceConfig = config?.objectForKey("productPrice") as? String
                if let productPrice = productPriceConfig {
                    productPriceString = productPrice
                } else {
                    productPriceString = "$1.99"
                }
                
                if !paidApp {
                    let alert = UIAlertController(title: "Refer friends and win!", message: "Get \(referralPrize) friends to download and open the app with your unique URL, and you'll be able to add unlimited ideas for free (normally \(productPriceString)).", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    userDefaults.setBool(true, forKey: "firstSettings")
                    userDefaults.synchronize()
                }

            }
        }
        */
    }
    
    @IBAction func sharePressed(sender: AnyObject) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let referralURL = userDefaults.objectForKey("referralURL") as? String
        var shareURL: String
        if let referralURL = referralURL {
            shareURL = referralURL
        } else {
            shareURL = "https://bnc.lt/idealist-ios"
            let sail = Sail.sharedInstance()
            sail.getUserData { (userParams) -> Void in
                let referralURL = userParams["referralURL"] as? String
                if let referralURL = referralURL {
                    userDefaults.setObject(referralURL, forKey: "referralURL")
                    userDefaults.synchronize()
                }
            }
        }
        Branch.getInstance().userCompletedAction("shared")
        let activityVC: UIActivityViewController = UIActivityViewController(activityItems: [shareURL], applicationActivities: nil)
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func ratePressed(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "itms-apps://itunes.apple.com/app/id975937527")!)
    }
    
    @IBAction func sendFeedbackPressed(sender: AnyObject) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.navigationBar.tintColor = UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0)
            mailComposeVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0)]
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
