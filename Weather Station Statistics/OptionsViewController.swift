//
//  OptionsViewController.swift
//  Weather Station Statistics
//
//  Created by Yuval Weinstein on 05/03/2019.
//  Copyright © 2019 Yuval Weinstein. All rights reserved.
//

import Foundation
import Cocoa

enum ControlType {
    case Text
    case CheckButton
}



class OptionsViewController: NSViewController {
    
    private var controls: Dictionary<String, ControlType>!
    private var order: [String]!
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?, controls: Dictionary<String, ControlType>, order: [String]) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.controls = controls
        self.order = order
    }
    
    
    
    private func addNewTextField(loc: Int, key: String){
        let rect = self.view.frame
        let text = key + ":"
        let labelWidth = text.width(withConstrainedHeight: 15, font: NSFont.systemFont(ofSize: 15))
        let label = NSTextField(frame: NSMakeRect(10, rect.height - CGFloat(loc * 30) - 8, labelWidth, 20))
        label.stringValue = text
        label.isEditable = false
        label.isSelectable = false
        label.isBezeled = false
        label.isBordered = false
        label.drawsBackground = false
        let textField = NSTextField(frame: NSMakeRect(rect.width/2, rect.height - CGFloat(loc * 30) - 5, rect.width/2 - 5, 20))
        self.view.addSubview(label)
        self.view.addSubview(textField)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
    }
    
}


extension String {
    func height(withConstrainedWidth width: CGFloat, font: NSFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: NSFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
