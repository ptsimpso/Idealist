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
        
        cell.dotAdvantage.hidden = true
        cell.dotAlts.hidden = true
        cell.dotChannels.hidden = true
        cell.dotCosts.hidden = true
        cell.dotCustomers.hidden = true
        cell.dotMetrics.hidden = true
        cell.dotProblem.hidden = true
        cell.dotRevenue.hidden = true
        cell.dotSolution.hidden = true
        cell.dotUvp.hidden = true
        
        if let problem = idea.problem {
            if problem != "" {
                cell.dotProblem.hidden = false
            }
        }
        if let customer = idea.customerSegments {
            if customer != "" {
                cell.dotCustomers.hidden = false
            }
        }
        if let alts = idea.alternatives {
            if alts != "" {
                cell.dotAlts.hidden = false
            }
        }
        if let uvp = idea.uvp {
            if uvp != "" {
                cell.dotUvp.hidden = false
            }
        }
        if let solution = idea.solution {
            if solution != "" {
                cell.dotSolution.hidden = false
            }
        }
        if let channels = idea.channels {
            if channels != "" {
                cell.dotChannels.hidden = false
            }
        }
        if let revenue = idea.revenue {
            if revenue != "" {
                cell.dotRevenue.hidden = false
            }
        }
        if let costs = idea.costs {
            if costs != "" {
                cell.dotCosts.hidden = false
            }
        }
        if let metrics = idea.metrics {
            if metrics != "" {
                cell.dotMetrics.hidden = false
            }
        }
        if let unfairAdv = idea.unfairAdv {
            if unfairAdv != "" {
                cell.dotAdvantage.hidden = false
            }
        }
    }
    
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
            categoryOpt = idea.solution
        case 5:
            categoryOpt = idea.channels
        case 6:
            categoryOpt = idea.revenue
        case 7:
            categoryOpt = idea.costs
        case 8:
            categoryOpt = idea.metrics
        case 9:
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
    
    static func setUpDetailsDots(detailsVC: DetailsViewController, idea: Idea) {
        detailsVC.dotAdvantage.hidden = true
        detailsVC.dotAlts.hidden = true
        detailsVC.dotChannels.hidden = true
        detailsVC.dotCosts.hidden = true
        detailsVC.dotCustomers.hidden = true
        detailsVC.dotMetrics.hidden = true
        detailsVC.dotProblem.hidden = true
        detailsVC.dotRevenue.hidden = true
        detailsVC.dotSolution.hidden = true
        detailsVC.dotUvp.hidden = true
        
        if let problem = idea.problem {
            if problem != "" {
                detailsVC.dotProblem.hidden = false
            }
        }
        if let customer = idea.customerSegments {
            if customer != "" {
                detailsVC.dotCustomers.hidden = false
            }
        }
        if let alts = idea.alternatives {
            if alts != "" {
                detailsVC.dotAlts.hidden = false
            }
        }
        if let uvp = idea.uvp {
            if uvp != "" {
                detailsVC.dotUvp.hidden = false
            }
        }
        if let solution = idea.solution {
            if solution != "" {
                detailsVC.dotSolution.hidden = false
            }
        }
        if let channels = idea.channels {
            if channels != "" {
                detailsVC.dotChannels.hidden = false
            }
        }
        if let revenue = idea.revenue {
            if revenue != "" {
                detailsVC.dotRevenue.hidden = false
            }
        }
        if let costs = idea.costs {
            if costs != "" {
                detailsVC.dotCosts.hidden = false
            }
        }
        if let metrics = idea.metrics {
            if metrics != "" {
                detailsVC.dotMetrics.hidden = false
            }
        }
        if let unfairAdv = idea.unfairAdv {
            if unfairAdv != "" {
                detailsVC.dotAdvantage.hidden = false
            }
        }
    }
    
    static func createAccessoryView(viewController: UIViewController) -> UIView {
        let accessoryView = UIView(frame: CGRectMake(0, 0, viewController.view.frame.width, 40))
        accessoryView.backgroundColor = UIColor(red: 1.0, green: 213/255.0, blue: 0, alpha: 1.0)
        
        let closeIcon = UIImageView(frame: CGRectMake(accessoryView.frame.width-40, 10, 20, 20))
        closeIcon.image = UIImage(named: "arrow-down")
        accessoryView.addSubview(closeIcon)
        
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
        
        let bulletButton = UIButton(frame: CGRectMake(0, 0, 60, 40))
        bulletButton.addTarget(viewController, action: "toggleBullet:", forControlEvents: UIControlEvents.TouchUpInside)
        bulletButton.setBackgroundImage(UIImage(named: "bulletOff"), forState: UIControlState.Normal)
        accessoryView.addSubview(bulletButton)
        
        let closeButton = UIButton(frame: CGRectMake(accessoryView.frame.width-100, 0, 100, accessoryView.frame.height))
        closeButton.addTarget(viewController, action: "dismissKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
        accessoryView.addSubview(closeButton)
        
        return accessoryView
    }
    
    static func handleBulletToggleForTextView(textView: UITextView, sender: UIButton, bulletOn: Bool) {
        let bullet = "\u{25CF} "
        if bulletOn {
            sender.setBackgroundImage(UIImage(named: "bulletOff"), forState: UIControlState.Normal)
            if textView.text.utf16Count >= 2 && textView.selectedRange.location >= 2 {
                let startIndex = advance(textView.text.startIndex, textView.selectedRange.location - 2)
                let endIndex = advance(textView.text.startIndex, textView.selectedRange.location)
                let substring = textView.text.substringWithRange(Range<String.Index>(start: startIndex, end: endIndex))
                if substring == "\u{25CF} " {
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
                textView.replaceRange(textRange, withText: bullet)
            } else {
                let index = advance(textView.text.startIndex, textView.selectedRange.location - 1)
                if textView.text[index] == "\n" {
                    let beginning = textView.beginningOfDocument
                    let selectedPosition = textView.positionFromPosition(beginning, offset: textView.selectedRange.location)
                    let textRange = textView.textRangeFromPosition(selectedPosition, toPosition: selectedPosition)

                    textView.replaceRange(textRange, withText: bullet)
                }
            }
        }
    }
    
    static func handleTextView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String, withBulletOn bulletOn: Bool) -> Bool {
        if bulletOn && text == "\n" {
            
            let newLineBullet = "\n\u{25CF} "
            var textRange: UITextRange!
            if range.location == textView.text.utf16Count {
                textRange = textView.textRangeFromPosition(textView.endOfDocument, toPosition: textView.endOfDocument)
            } else {
                let beginning = textView.beginningOfDocument
                let start = textView.positionFromPosition(beginning, offset: range.location)
                let end = textView.positionFromPosition(start!, offset: range.length)
                textRange = textView.textRangeFromPosition(start, toPosition: end)
            }
            textView.replaceRange(textRange, withText: newLineBullet)
//            let cursor = NSMakeRange(range.location + newLineBullet.utf16Count, 0)
//            textView.selectedRange = cursor
//            textView.scrollRangeToVisible(textView.selectedRange)
            
            return false
        }
        return true
    }
}