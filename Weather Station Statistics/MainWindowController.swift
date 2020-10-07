//
//  ToolBarViewController.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 17/07/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import Cocoa

class MainWindowController: NSWindowController {
    
    var viewController: MainViewController {
        get {
            return self.window!.contentViewController! as! MainViewController
        }
    }
    @IBAction func LoadPressed(_ sender: NSToolbarItem) {
        self.viewController.ModePopUpButton.item(withTitle: "Home")?.isEnabled = false
        self.viewController.ModePopUpButton.selectItem(withTitle: "Monthly")
        self.viewController.db.set()
    }
}
