//
//  IntroView.swift
//  LeanLog
//
//  Created by Peter Simpson on 4/21/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit

class IntroView: UIView {

    var slideShow = DRDynamicSlideShow()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        let colorArray = [UIColor(red: 75/255.0, green: 200/255.0, blue: 195/255.0, alpha: 1.0).CGColor, UIColor(red: 75/255.0, green: 90/255.0, blue: 195/255.0, alpha: 1.0).CGColor]
        gradient.colors = colorArray
        gradient.locations = [0.0, 1.0]
        self.layer.insertSublayer(gradient, atIndex:0)
        
        slideShow.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        slideShow.showsHorizontalScrollIndicator = false
        slideShow.showsVerticalScrollIndicator = false
        slideShow.alwaysBounceVertical = false
        slideShow.pagingEnabled = true
        slideShow.contentSize = CGSizeMake(self.frame.width * 3, self.frame.height)
        
        let pageControl = UIPageControl(frame: CGRectMake(0, self.frame.height-80, self.frame.width, 50))
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        self.addSubview(pageControl)
        
        slideShow.didReachPageBlock = { (reachedPage) -> Void in
            pageControl.currentPage = reachedPage
        }
        
        // PAGE ONE
        let pageOne = UIView(frame: CGRectMake(0, 0, self.frame.width, self.frame.height))
        let actionsImageView = UIImageView(frame: CGRectMake(self.frame.width / 2 - 130, self.frame.height / 2 - 240, 260, 260))
        actionsImageView.image = UIImage(named: "priority")
        actionsImageView.backgroundColor = UIColor.whiteColor()
        actionsImageView.layer.masksToBounds = true
        actionsImageView.layer.cornerRadius = 130
        actionsImageView.layer.borderColor = UIColor.orangeColor().CGColor
        actionsImageView.layer.borderWidth = 5
        
        let actionsTitle = UILabel(frame: CGRectMake(0, self.frame.height / 2 + 60, self.frame.width, 24))
        actionsTitle.text = "Rank & Categorize" // rank and categorize new ideas
        actionsTitle.textAlignment = NSTextAlignment.Center
        actionsTitle.font = UIFont.boldSystemFontOfSize(20.0)
        actionsTitle.textColor = UIColor.whiteColor()
        
        let actionsLabel = UILabel(frame: CGRectMake(self.frame.width / 2 - 130, self.frame.height / 2 + 80, 260, 130))
        actionsLabel.text = "Tap the dots beneath the title to give a priority from 0-10.\n\nTap the 'Uncategorized' tag to add the idea to a category."
        actionsLabel.numberOfLines = 0
        actionsLabel.textColor = UIColor.whiteColor()
        actionsLabel.font = UIFont.systemFontOfSize(17.0)
        actionsLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        actionsLabel.textAlignment = NSTextAlignment.Center
        
        pageOne.addSubview(actionsImageView)
        pageOne.addSubview(actionsTitle)
        pageOne.addSubview(actionsLabel)
        
        let pageTwo = UIView(frame: CGRectMake(self.frame.width, 0, self.frame.width, self.frame.height))
        let sectionsImageView = UIImageView(frame: CGRectMake(self.frame.width / 2 - 130, self.frame.height / 2 - 240, 260, 260))
        sectionsImageView.image = UIImage(named: "sections")
        sectionsImageView.backgroundColor = UIColor.whiteColor()
        sectionsImageView.layer.masksToBounds = true
        sectionsImageView.layer.cornerRadius = 130
        sectionsImageView.layer.borderColor = UIColor.orangeColor().CGColor
        sectionsImageView.layer.borderWidth = 5
        
        let sectionsTitle = UILabel(frame: CGRectMake(0, self.frame.height / 2 + 60, self.frame.width, 24))
        sectionsTitle.text = "Expand & Validate"
        sectionsTitle.textAlignment = NSTextAlignment.Center
        sectionsTitle.font = UIFont.boldSystemFontOfSize(20.0)
        sectionsTitle.textColor = UIColor.whiteColor()
        
        let sectionsLabel = UILabel(frame: CGRectMake(self.frame.width / 2 - 130, self.frame.height / 2 + 80, 260, 130))
        sectionsLabel.text = "Break your idea down into manageable components.\n\nTap on the sections within\nan idea for prompts."
        sectionsLabel.numberOfLines = 0
        sectionsLabel.textColor = UIColor.whiteColor()
        sectionsLabel.font = UIFont.systemFontOfSize(17.0)
        sectionsLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        sectionsLabel.textAlignment = NSTextAlignment.Center
        
        pageTwo.addSubview(sectionsImageView)
        pageTwo.addSubview(sectionsTitle)
        pageTwo.addSubview(sectionsLabel)
        
        let pageThree = UIView(frame: CGRectMake(self.frame.width * 2, 0, self.frame.width, self.frame.height))
        
        let syncLabel = UILabel(frame: CGRectMake(0, self.frame.height / 2 - 130, self.frame.width, 100))
        syncLabel.text = "iCloud syncs across\ndevices automatically."
        syncLabel.textColor = UIColor.whiteColor()
        syncLabel.font = UIFont.boldSystemFontOfSize(17.0)
        syncLabel.numberOfLines = 2
        syncLabel.textAlignment = NSTextAlignment.Center
        syncLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        let dismissButton = UIButton(frame: CGRectMake(self.frame.width / 2 - 120, self.frame.height / 2 - 30, 240, 60))
        dismissButton.backgroundColor = UIColor.clearColor()
        dismissButton.setTitle("I'm ready!", forState: UIControlState.Normal)
        dismissButton.titleLabel?.textColor = UIColor.whiteColor()
        dismissButton.titleLabel?.font = UIFont.boldSystemFontOfSize(19.0)
        dismissButton.layer.cornerRadius = 4.0
        dismissButton.layer.borderColor = UIColor.whiteColor().CGColor
        dismissButton.layer.borderWidth = 2.0
        dismissButton.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside)
        
        let disclaimer = UILabel(frame: CGRectMake(40, self.frame.height - 135, self.frame.width - 80, 80))
        disclaimer.text = "Note: If you have data on another device, please wait 60 seconds for the initial sync to display data."
        disclaimer.textColor = UIColor.whiteColor()
        disclaimer.font = UIFont.boldSystemFontOfSize(14.0)
        disclaimer.numberOfLines = 0
        disclaimer.textAlignment = NSTextAlignment.Center
        disclaimer.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        pageThree.addSubview(dismissButton)
        pageThree.addSubview(syncLabel)
        pageThree.addSubview(disclaimer)
        
        slideShow.addSubview(pageOne)
        slideShow.addSubview(pageTwo)
        slideShow.addSubview(pageThree)
        
        self.addSubview(slideShow)
        
        slideShow.alpha = 0
        
        // PAGE 0
        
        let actionsImagePoint = CGPointMake(actionsImageView.center.x+self.slideShow.frame.size.width, actionsImageView.center.y-self.slideShow.frame.size.height)
        slideShow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(actionsImageView, page: 0, keyPath: "center", toValue: NSValue(CGPoint: actionsImagePoint), delay: 0) as! DRDynamicSlideShowAnimation)
        
        let actionsTitlePoint = CGPointMake(actionsTitle.center.x+slideShow.frame.size.width, actionsTitle.center.y+slideShow.frame.size.height*2)
        slideShow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(actionsTitle, page: 0, keyPath: "center", toValue: NSValue(CGPoint: actionsTitlePoint), delay: 0) as! DRDynamicSlideShowAnimation)
        slideShow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(actionsTitle, page: 0, keyPath: "alpha", toValue: NSNumber(integer: 0), delay: 0) as! DRDynamicSlideShowAnimation)
        
        let actionsLabelPoint = CGPointMake(actionsLabel.center.x+slideShow.frame.size.width, actionsLabel.center.y+slideShow.frame.size.height*2)
        slideShow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(actionsLabel, page: 0, keyPath: "center", toValue: NSValue(CGPoint: actionsLabelPoint), delay: 0) as! DRDynamicSlideShowAnimation)
        slideShow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(actionsLabel, page: 0, keyPath: "alpha", toValue: NSNumber(integer: 0), delay: 0) as! DRDynamicSlideShowAnimation)
        
        // PAGE 1
        
        slideShow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(sectionsImageView, page: 0, keyPath: "alpha", fromValue: NSNumber(integer: 0), toValue: NSNumber(integer: 1), delay: 0.75) as! DRDynamicSlideShowAnimation)
        
        slideShow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(sectionsTitle, page: 0, keyPath: "transform", fromValue: NSValue(CGAffineTransform: CGAffineTransformMakeRotation(-0.9)), toValue: NSValue(CGAffineTransform: CGAffineTransformMakeRotation(0)), delay: 0) as! DRDynamicSlideShowAnimation)
        
        slideShow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(sectionsLabel, page: 0, keyPath: "transform", fromValue: NSValue(CGAffineTransform: CGAffineTransformMakeRotation(-0.9)), toValue: NSValue(CGAffineTransform: CGAffineTransformMakeRotation(0)), delay: 0) as! DRDynamicSlideShowAnimation)
        
        // PAGE 2
        slideShow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(disclaimer, page: 1, keyPath: "alpha", fromValue: NSNumber(integer: 0), toValue: NSNumber(integer: 1), delay: 0.75) as! DRDynamicSlideShowAnimation)
        
        syncLabel.center = CGPointMake(syncLabel.center.x-self.slideShow.frame.size.width, syncLabel.center.y-self.slideShow.frame.size.height)
        let syncLabelPoint = CGPointMake(syncLabel.center.x+self.slideShow.frame.size.width, syncLabel.center.y+self.slideShow.frame.size.height)
        slideShow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(syncLabel, page: 1, keyPath: "center", toValue: NSValue(CGPoint: syncLabelPoint), delay: 0) as! DRDynamicSlideShowAnimation)
        
        dismissButton.center = CGPointMake(dismissButton.center.x-self.slideShow.frame.size.width, dismissButton.center.y+self.slideShow.frame.size.height)
        let dismissButtonPoint = CGPointMake(dismissButton.center.x+self.slideShow.frame.size.width, dismissButton.center.y-self.slideShow.frame.size.height)
        slideShow.addAnimation(DRDynamicSlideShowAnimation.animationForSubview(dismissButton, page: 1, keyPath: "center", toValue: NSValue(CGPoint: dismissButtonPoint), delay: 0) as! DRDynamicSlideShowAnimation)
        
        UIView.animateWithDuration(0.6, delay: 0.3, options: nil, animations: { () -> Void in
            self.slideShow.alpha = 1.0
        }, completion: nil)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(true, forKey: "firstRun")
        userDefaults.synchronize()
    }
    
    func dismiss() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.transform = CGAffineTransformMakeTranslation(0, self.frame.height + 100)
        }) { (success) -> Void in
            self.removeFromSuperview()
        }
    }

}
