//
//  ModalProtocol.swift
//  LeanLog
//
//  Created by Peter Simpson on 3/15/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import Foundation

protocol ModalDelegate {
    func minimizeView(sender: AnyObject) -> Void
    func maximizeView(sender: AnyObject) -> Void
    func dismissModalHandler(sender: AnyObject?) -> Void
}