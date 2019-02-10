//
//  NSViewController + Extensions.swift
//  Temp Generator
//
//  Created by Soufian Hossam on 2/10/19.
//  Copyright © 2019 Soufian Hossam. All rights reserved.
//

import Cocoa

extension NSViewController {
    func showAlert(title: String, message: String) {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .critical
        alert.addButton(withTitle: "Ok")
        alert.beginSheetModal(for: self.view.window!)
    }
}
