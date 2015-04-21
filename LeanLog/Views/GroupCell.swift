//
//  GroupCell.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/13/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit

protocol GroupCellDelegate {
    func handleEditPressed(sender: GroupCell) -> Void
    func handleDeletePressed(sender: GroupCell) -> Void
    func handleCheckPressed(sender: GroupCell) -> Void
}

class GroupCell: UITableViewCell {
    @IBOutlet weak var checkButton: UIButton?
    @IBOutlet weak var groupTitleLabel: UILabel!
    var delegate: GroupCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let checkButton = checkButton {
            checkButton.layer.borderWidth = 1.0
            checkButton.layer.borderColor = UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0).CGColor
        }
    }

    @IBAction func checkPressed(sender: UIButton) {
        if let delegate = delegate {
            delegate.handleCheckPressed(self)
        }
    }
    @IBAction func editPressed(sender: UIButton) {
        if let delegate = delegate {
            delegate.handleEditPressed(self)
        }
    }
    @IBAction func deletePressed(sender: UIButton) {
        if let delegate = delegate {
            delegate.handleDeletePressed(self)
        }
    }
}
