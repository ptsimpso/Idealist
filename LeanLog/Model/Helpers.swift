//
//  IdeaHelper.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/10/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit
import Foundation

struct IdeaHelper {
    
    // MARK: IdeaListViewController helpers
    
    static func setUpIdeaCell(cell: IdeaTitleCell, idea: Idea, row: Int, count: Int, formatter: NSDateFormatter) {
        let green: CGFloat = 200.0 - CGFloat(row + 1) / CGFloat(count) * 110.0
        let cellColor: UIColor = UIColor(red: 75/255.0, green: green/255.0, blue: 195/255.0, alpha: 1.0)
        
        let ideaTitle: String? = idea.title
        if ideaTitle != nil && ideaTitle! != "" {
            cell.ideaTitleLabel.text = ideaTitle!
        } else {
            cell.ideaTitleLabel.text = formatter.stringFromDate(idea.updatedAt)
        }
        cell.ideaTitleLabel.textColor = cellColor
        cell.stripeView.backgroundColor = cellColor
        cell.barView.backgroundColor = cellColor
        for index in 0..<cell.dotArray.count {
            let dot = cell.dotArray[index]
            dot.hidden = true
            if index < idea.priority.integerValue {
                dot.hidden = false
            }
        }
    }
    
    static func createSectionHeader(section: Int, title: String, headersCount: Int, parentVC: IdeaListViewController) -> UIView {
        let headerView = UIView(frame: CGRectMake(0, 0, parentVC.tableView.frame.width, parentVC.kHeaderHeight))
        
        let green: CGFloat = 200.0 - CGFloat(section + 1) / CGFloat(headersCount) * 110.0
        let headerColor: UIColor = UIColor(red: 75/255.0, green: green/255.0, blue: 195/255.0, alpha: 1.0)
        headerView.backgroundColor = headerColor
        let headerLabel = UILabel(frame: CGRectMake(18.0, 0, headerView.frame.width - 18.0, headerView.frame.height))
        headerLabel.textColor = UIColor.whiteColor()
        headerLabel.font = UIFont.boldSystemFontOfSize(16.0)
        headerLabel.text = title
        
        headerView.addSubview(headerLabel)
        
        let toggleButton = SectionToggleButton(parentView: headerView)
        toggleButton.addTarget(parentVC, action: "sectionTogglePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        toggleButton.tag = section
        if !contains(parentVC.toggleArray, section) {
            toggleButton.toggleIcon.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2))
        }
        headerView.addSubview(toggleButton)
        
        return headerView
    }
    
    // MARK: DetailsViewController helpers
    
    static func setUpCategoryCell(cell: CategoryCell, row: Int, category: String, idea: Idea) {
        let green: CGFloat = 210.0 - CGFloat(row + 1) / CGFloat(Categories.array.count) * 130.0
        let cellColor: UIColor = UIColor(red: 255/255.0, green: green/255.0, blue: 0/255.0, alpha: 1.0)
        
        cell.categoryLabel.text = category
        cell.contentView.backgroundColor = cellColor
        
        var categoryOpt: String?
        
        switch (row) {
        case 0:
            categoryOpt = idea.problem
        case 1:
            categoryOpt = idea.customerSegments
        case 2:
            categoryOpt = idea.alternatives
        case 3:
            categoryOpt = idea.uvp
        case 4:
            categoryOpt = idea.tests
        case 5:
            categoryOpt = idea.solution
        case 6:
            categoryOpt = idea.channels
        case 7:
            categoryOpt = idea.revenue
        case 8:
            categoryOpt = idea.costs
        case 9:
            categoryOpt = idea.metrics
        case 10:
            categoryOpt = idea.unfairAdv
        default:
            println("ERROR: No category index set.")
        }
        
        cell.dot.hidden = true
        if let categoryNotes = categoryOpt {
            if categoryNotes != "" {
                cell.dot.hidden = false
            }
        }
    }
    
    static func composeShareStringWithIdea(idea: Idea) -> String {
        var messageTitle = "No title"
        if let title = idea.title {
            messageTitle = title
        }
        var messageNotes = ""
        if let notes = idea.notes {
            messageNotes = notes.stringByReplacingOccurrencesOfString("\n", withString: "<br>", options: NSStringCompareOptions.LiteralSearch, range: nil)
        }
        
        let defaultMessage = "n/a"
        
        var messageProblem = defaultMessage
        if let problem = idea.problem {
            messageProblem = problem == "" ? defaultMessage : problem
        }
        var messageCustomers = defaultMessage
        if let customers = idea.customerSegments {
            messageCustomers = customers == "" ? defaultMessage : customers
        }
        var messageAlts = defaultMessage
        if let alts = idea.alternatives {
            messageAlts = alts == "" ? defaultMessage : alts
        }
        var messageUvp = defaultMessage
        if let uvp = idea.uvp {
            messageUvp = uvp == "" ? defaultMessage : uvp
        }
        var messageSolution = defaultMessage
        if let solution = idea.solution {
            messageSolution = solution == "" ? defaultMessage : solution
        }
        var messageChannels = defaultMessage
        if let channels = idea.channels {
            messageChannels = channels == "" ? defaultMessage : channels
        }
        var messageRevenue = defaultMessage
        if let revenue = idea.revenue {
            messageRevenue = revenue == "" ? defaultMessage : revenue
        }
        var messageCosts = defaultMessage
        if let costs = idea.costs {
            messageCosts = costs == "" ? defaultMessage : costs
        }
        var messageMetrics = defaultMessage
        if let metrics = idea.metrics {
            messageMetrics = metrics == "" ? defaultMessage : metrics
        }
        var messageAdv = defaultMessage
        if let adv = idea.unfairAdv {
            messageAdv = adv == "" ? defaultMessage : adv
        }
        
        // Split string to keep Swift compiler happy
        let htmlStringFirst =
        "<div style='font-weight:bold'>\(messageTitle)</div><div>\(messageNotes)</div><br><div style='font-weight:bold'>Problem</div><div>\(messageProblem)</div><br><div style='font-weight:bold'>Customer Segments</div><div>\(messageCustomers)</div><br><div style='font-weight:bold'>Existing Alternatives</div><div>\(messageAlts)</div><br><div style='font-weight:bold'>Unique Value Proposition</div><div>\(messageUvp)</div>"
        let htmlStringSecond =
        "<br><div style='font-weight:bold'>Solution</div><div>\(messageSolution)</div><br><div style='font-weight:bold'>Channels and Growth</div><div>\(messageChannels)</div><br><div style='font-weight:bold'>Revenue Streams</div><div>\(messageRevenue)</div><br><div style='font-weight:bold'>Costs</div><div>\(messageCosts)</div><br><div style='font-weight:bold'>Key Metrics</div><div>\(messageMetrics)</div><br><div style='font-weight:bold'>Unfair Advantage</div><div>\(messageAdv)</div>"
        
        return htmlStringFirst + htmlStringSecond
    }
    
    // MARK: GroupsViewController helpers
    
    static func setUpGroupCell(cell: GroupCell, row: Int, count: Int, group: Group?) {
        let green: CGFloat = 200.0 - CGFloat(row + 1) / CGFloat(count) * 110.0
        let cellColor: UIColor = UIColor(red: 75/255.0, green: green/255.0, blue: 195/255.0, alpha: 1.0)
        
        cell.groupTitleLabel.backgroundColor = cellColor
        cell.groupTitleLabel.layer.masksToBounds = true
        
        if row == 0 {
            cell.groupTitleLabel.text = "Uncategorized"
        } else {
            cell.groupTitleLabel.text = group!.title
        }
    }
    
    // MARK: TextView helpers
    
    static let kBullet = "\u{25CF} "
    
    static func createAccessoryView(viewController: UIViewController) -> UIView {
        let accessoryView = UIView(frame: CGRectMake(0, 0, viewController.view.frame.width, 40))
        accessoryView.backgroundColor = UIColor(red: 1.0, green: 213/255.0, blue: 0, alpha: 1.0)
        
        let closeIcon = UIImageView(frame: CGRectMake(accessoryView.frame.width-40, 10, 20, 20))
        closeIcon.image = UIImage(named: "arrow-down")
        accessoryView.addSubview(closeIcon)
        
        let saveLabel = UILabel(frame: CGRectMake(0, 0, accessoryView.frame.width, accessoryView.frame.height))
        saveLabel.textAlignment = NSTextAlignment.Center
        saveLabel.text = "Save"
        saveLabel.textColor = UIColor.whiteColor()
        saveLabel.font = UIFont.boldSystemFontOfSize(16.0)
        accessoryView.addSubview(saveLabel)
        
        let closeButton = UIButton(frame: accessoryView.frame)
        closeButton.addTarget(viewController, action: "dismissKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        accessoryView.addSubview(closeButton)
        
        return accessoryView
    }
    
    static func createBulletAccessoryView(viewController: UIViewController) -> UIView {
        let accessoryView = UIView(frame: CGRectMake(0, 0, viewController.view.frame.width, 40))
        accessoryView.backgroundColor = UIColor(red: 1.0, green: 213/255.0, blue: 0, alpha: 1.0)
        
        let closeIcon = UIImageView(frame: CGRectMake(accessoryView.frame.width-40, 10, 20, 20))
        closeIcon.image = UIImage(named: "arrow-down")
        accessoryView.addSubview(closeIcon)
        
        let saveLabel = UILabel(frame: CGRectMake(0, 0, accessoryView.frame.width, accessoryView.frame.height))
        saveLabel.textAlignment = NSTextAlignment.Center
        saveLabel.text = "Save"
        saveLabel.textColor = UIColor.whiteColor()
        saveLabel.font = UIFont.boldSystemFontOfSize(16.0)
        accessoryView.addSubview(saveLabel)
        
        let bulletButton = UIButton(frame: CGRectMake(0, 0, 60, 40))
        bulletButton.addTarget(viewController, action: "toggleBullet:", forControlEvents: UIControlEvents.TouchUpInside)
        bulletButton.setBackgroundImage(UIImage(named: "bulletOff"), forState: UIControlState.Normal)
        accessoryView.addSubview(bulletButton)
        
        let closeButton = UIButton(frame: CGRectMake(80, 0, accessoryView.frame.width-80, accessoryView.frame.height))
        closeButton.addTarget(viewController, action: "dismissKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        accessoryView.addSubview(closeButton)
        
        return accessoryView
    }
    
    static func handleBulletToggleForTextView(textView: UITextView, sender: UIButton, bulletOn: Bool) {
        if bulletOn {
            sender.setBackgroundImage(UIImage(named: "bulletOff"), forState: UIControlState.Normal)
            if textView.selectedRange.location >= 2 {
                let startIndex = advance(textView.text.startIndex, textView.selectedRange.location - 2)
                let endIndex = advance(textView.text.startIndex, textView.selectedRange.location)
                let substring = textView.text.substringWithRange(Range<String.Index>(start: startIndex, end: endIndex))
                if substring == kBullet {
                    let beginning = textView.beginningOfDocument
                    let start = textView.positionFromPosition(beginning, offset: textView.selectedRange.location - 2)
                    let end = textView.positionFromPosition(beginning, offset: textView.selectedRange.location)
                    let textRange = textView.textRangeFromPosition(start, toPosition: end)

                    textView.replaceRange(textRange, withText: "")
                }
            }
        } else {
            sender.setBackgroundImage(UIImage(named: "bulletOn"), forState: UIControlState.Normal)
            if textView.text == "" {
                let textRange = textView.textRangeFromPosition(textView.endOfDocument, toPosition: textView.endOfDocument)
                textView.replaceRange(textRange, withText: kBullet)
            } else if textView.selectedRange.location > 0 {
                let index = advance(textView.text.startIndex, textView.selectedRange.location - 1)
                if textView.text[index] == "\n" {
                    let beginning = textView.beginningOfDocument
                    let selectedPosition = textView.positionFromPosition(beginning, offset: textView.selectedRange.location)
                    let textRange = textView.textRangeFromPosition(selectedPosition, toPosition: selectedPosition)
                    textView.replaceRange(textRange, withText: kBullet)
                }
            } else {
                // Selected index is at the very beginning of textView
                let beginning = textView.beginningOfDocument
                let textRange = textView.textRangeFromPosition(beginning, toPosition: beginning)
                textView.replaceRange(textRange, withText: kBullet)
            }
        }
    }
    
    static func handleTextView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String, withBulletOn bulletOn: Bool) -> Bool {
        if bulletOn && text == "\n" {
            
            let newLineBullet = "\n" + kBullet
            var textRange: UITextRange!
            if range.location == count(textView.text.utf16) {
                textRange = textView.textRangeFromPosition(textView.endOfDocument, toPosition: textView.endOfDocument)
            } else {
                let beginning = textView.beginningOfDocument
                let start = textView.positionFromPosition(beginning, offset: range.location)
                let end = textView.positionFromPosition(start!, offset: range.length)
                textRange = textView.textRangeFromPosition(start, toPosition: end)
            }
            textView.replaceRange(textRange, withText: newLineBullet)
            
            return false
        }
        return true
    }
}