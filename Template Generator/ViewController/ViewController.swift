//
//  ViewController.swift
//  TempGenerator
//
//  Created by Soufian Hossam on 1/29/19.
//  Copyright © 2019 Soufian Hossam. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var dragView: DropView!
    @IBOutlet weak var sceneNameTF: NSTextField!
    @IBOutlet weak var messageLbl: NSTextField!
    @IBOutlet weak var generateBtn: NSButton!
    @IBOutlet weak var clearBtn: NSButton!
    
    static var instance: NSViewController {
        return NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "Template Generator") as! NSViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dragView.doneDropping = { [unowned self] in
            self.messageLbl.stringValue = "Dropped successfully"
            self.messageLbl.textColor = .green
        }
    }
    
    func generateTemplates(with name: String) -> [Template] {
        let templates: [Template] = dragView.files.map { $0.copy() as! Template }
        
        return templates.map {
            $0.name = $0.name.replacingOccurrences(of: "#..#", with: name)
            $0.content = $0.content.replacingOccurrences(of: "#..#", with: name)
            return $0
        }
    }
    
    func saveTemplates(_ templates: [Template], at url: URL) {
        
        templates.forEach { template in
            do {
                let destinationUrl = url.appendingPathComponent(template.name)
                try template.content.write(to: destinationUrl, atomically: true, encoding: .utf8)
                dragView.finalURLs.append(destinationUrl as NSURL)
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
        
        messageLbl.stringValue = "Drag updated templates"
        messageLbl.textColor = NSColor.yellow
        generateBtn.isEnabled = false
    }
    
    @IBAction func generateBtnHandler(_ sender: Any) {
        guard !sceneNameTF.stringValue.isEmpty else {
            showAlert(title: "", message: "Please enter scene name first")
            return
        }
        
        let files = generateTemplates(with: sceneNameTF.stringValue)
        
        guard !files.isEmpty else {
            showAlert(title: "", message: "Please drop some template files into the app first")
            return
        }

        let tempURL = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first!
        saveTemplates(files, at: tempURL)
        
        clearBtn.isEnabled = true
        sceneNameTF.isEnabled = false
    }
    
    @IBAction func resetBtnHandler(_ sender: Any) {
        dragView.files = []
        dragView.finalURLs = []
        sceneNameTF.stringValue = ""
        messageLbl.stringValue = "Drop templates here"
        messageLbl.textColor = NSColor.labelColor
        generateBtn.isEnabled = true
        sceneNameTF.isEnabled = true
        clearBtn.isEnabled = false
    }
    
    @IBAction func clearBtnHandler(_ sender: Any) {
        dragView.finalURLs = []
        sceneNameTF.stringValue = ""
        messageLbl.stringValue = "Dropped successfully"
        messageLbl.textColor = NSColor.green
        generateBtn.isEnabled = true
        sceneNameTF.isEnabled = true
    }
}



