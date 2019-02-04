//
//  ViewController.swift
//  TemplateCreator
//
//  Created by Soufian Hossam on 1/29/19.
//  Copyright © 2019 SICT. All rights reserved.
//

import Cocoa

class DropView: NSView {
    
    let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes: [kUTTypeText]]
    var files: [Template] = []
    
    var doneDropping: (() -> Void)?
    
    override func awakeFromNib() {
        registerForDraggedTypes([NSPasteboard.PasteboardType.URL])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let pasteBoard = sender.draggingPasteboard
        
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options: filteringOptions) as? [URL], urls.count > 0 {
            return .copy
        }
        return NSDragOperation()
    }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        let pasteBoard = draggingInfo.draggingPasteboard
        
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options: filteringOptions) as? [URL], urls.count > 0 {
            
            urls.forEach { url in
                do {
                    let template = Template()
                    template.content = try String(contentsOf: url)
                    template.name = url.lastPathComponent
                    files.append(template)
                } catch let error {
                    printView(error.localizedDescription)
                }
            }
            doneDropping?()
            return true
        }
        return false
    }
}

class Template {
    var name: String = ""
    var content: String = ""
}


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

class ViewController: NSViewController {
    
    @IBOutlet weak var dragView: DropView!
    @IBOutlet weak var sceneNameTF: NSTextField!
    @IBOutlet weak var messageLbl: NSTextField!
    
    static var instance: NSViewController {
        return NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "Template Generator") as! NSViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dragView.doneDropping = { [unowned self] in
            self.messageLbl.stringValue = "Dropped Successfully"
            self.messageLbl.textColor = .green
        }
    }
    
    func generateTemplates(with name: String) -> [Template] {
        return dragView.files.map {
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
            }
            catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func saveBtnHandler(_ sender: Any) {
        guard !sceneNameTF.stringValue.isEmpty else {
            showAlert(title: "", message: "Please enter scene name first")
            return
        }
        
        let files = generateTemplates(with: sceneNameTF.stringValue)
        
        guard !files.isEmpty else {
            showAlert(title: "", message: "Please drop some template files into the app first")
            return
        }
        
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true
        openPanel.level = .modalPanel
        
        (NSApplication.shared.delegate as! AppDelegate).closePopover(sender: self)
        
        openPanel.begin { [unowned self] result -> Void in
            if result == NSApplication.ModalResponse.OK {
                self.sceneNameTF.stringValue = ""
                self.saveTemplates(files, at: openPanel.url!)
            }
        }
    }
    
    @IBAction func clearBtnHandler(_ sender: Any) {
        dragView.files = []
        sceneNameTF.stringValue = ""
        messageLbl.stringValue = "Drop templates here"
        messageLbl.textColor = NSColor.labelColor
    }
}
