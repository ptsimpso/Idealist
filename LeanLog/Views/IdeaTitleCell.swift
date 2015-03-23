//
//  IdeaTitleCell.swift
//  LeanLog
//
//  Created by Peter Simpson on 2/26/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit

class IdeaTitleCell: UITableViewCell {

    @IBOutlet weak var ideaTitleLabel: UILabel!
    @IBOutlet weak var stripeView: UIView!
    @IBOutlet weak var barView: UIView!
    
    @IBOutlet var dotArray: [UIView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dotArray.sort({ (first: UIView, second: UIView) -> Bool in
            if first.frame.origin.y == second.frame.origin.y {
                return first.frame.origin.x < second.frame.origin.x
            } else {
                return first.frame.origin.y < second.frame.origin.y
            }
        })
    }

}
