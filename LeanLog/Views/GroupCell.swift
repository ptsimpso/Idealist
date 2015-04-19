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
}

class GroupCell: UITableViewCell {
    
    @IBOutlet weak var groupTitleLabel: UILabel!
    var delegate: GroupCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func editPressed(sender: UIButton) {
        delegate.handleEditPressed(self)
    }
    @IBAction func deletePressed(sender: UIButton) {
        delegate.handleDeletePressed(self)
    }
}
