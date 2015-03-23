//
//  SectionToggleButton.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/22/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import UIKit

class SectionToggleButton: UIButton {

    var toggleIcon = UIImageView()
    
    init(parentView: UIView) {
        self.toggleIcon.frame = CGRectMake(parentView.frame.width - 38, parentView.frame.height / 2 - 10, 20, 20)
        self.toggleIcon.image = UIImage(named: "arrow-down")
        super.init(frame: parentView.bounds)
        self.addSubview(self.toggleIcon)
    }

    required init(coder aDecoder: NSCoder) {
        self.toggleIcon = UIImageView(frame: CGRectMake(0, 0, 0, 0))
        super.init(coder: aDecoder)
    }

}
