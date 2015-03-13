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
    
    @IBOutlet weak var dotProblem: UIView!
    @IBOutlet weak var dotCustomers: UIView!
    @IBOutlet weak var dotAlts: UIView!
    @IBOutlet weak var dotUvp: UIView!
    @IBOutlet weak var dotSolution: UIView!
    @IBOutlet weak var dotChannels: UIView!
    @IBOutlet weak var dotRevenue: UIView!
    @IBOutlet weak var dotCosts: UIView!
    @IBOutlet weak var dotMetrics: UIView!
    @IBOutlet weak var dotAdvantage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
