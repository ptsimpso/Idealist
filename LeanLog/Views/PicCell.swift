//
//  PicCell.swift
//  LeanLog
//
//  Created by Peter Simpson on 4/19/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit

protocol PicCellDelegate {
    func handleCheckPressed(sender: PicCell) -> Void
    func handleTrashPressed(sender: PicCell) -> Void
}

class PicCell: UICollectionViewCell {
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    var delegate: PicCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkButton.layer.borderWidth = 1.0
        checkButton.layer.borderColor = UIColor(red: 68/255.0, green: 188/255.0, blue: 201/255.0, alpha: 1.0).CGColor
        trashButton.layer.borderWidth = 1.0
        trashButton.layer.borderColor = UIColor(red: 246/255.0, green: 53/255.0, blue: 0/255.0, alpha: 1.0).CGColor
    }
    @IBAction func checkPressed(sender: UIButton) {
        if let delegate = delegate {
            delegate.handleCheckPressed(self)
        }
    }
    @IBAction func trashPressed(sender: UIButton) {
        if let delegate = delegate {
            delegate.handleTrashPressed(self)
        }
    }
}
