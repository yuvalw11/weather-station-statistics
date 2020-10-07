//
//  IPConfigViewController.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 27/06/2020.
//  Copyright © 2020 Yuval Weinstein. All rights reserved.
//

import Foundation
import Cocoa

class IPConfigViewController: NSViewController {
    
    @IBOutlet weak var automaticConfigRadioButton: NSButton!
    @IBOutlet weak var ManualConfigRadioButton: NSButton!
    @IBOutlet weak var manualIPTextBox: NSTextField!
    
    @IBAction func finishedPressed(_ sender: Any) {
        if self.automaticConfigRadioButton.state == .on {
            ApplicationSetup.wsIP = "10.0.0.100"
            self.manualIPTextBox.isEnabled = false
        } else {
            ApplicationSetup.wsIP = self.manualIPTextBox.stringValue
        }
        let viewController = NSApplication.shared.windows.first!.contentViewController as! MainViewController
        viewController.performWSConnecting()
        self.dismiss(self)
    }
    
    @IBAction func CancelPressed(_ sender: Any) {
        self.dismiss(self)
    }
    
    @IBAction func IPConfigPressed(_ sender: Any) {
        if self.automaticConfigRadioButton.state == .on {
            self.manualIPTextBox.isEnabled = false
        } else {
            self.manualIPTextBox.isEnabled = true
        }
    }
    
}
