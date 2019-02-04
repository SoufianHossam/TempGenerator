//
//  DropView.swift
//  TemplateCreator
//
//  Created by Soufian Hossam on 2/4/19.
//  Copyright © 2019 SICT. All rights reserved.
//

import Cocoa

class DropView: NSView {
    
    let filteringOptions = [NSPasteboard.ReadingOptionKey.urlReadingContentsConformToTypes: [kUTTypeText]]
    var files: [Template] = []
    var finalURLs: [NSURL] = []
    
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

    override func mouseDragged(with event: NSEvent) {
        guard finalURLs.count > 0 else { return }
        
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setDataProvider(self, forTypes: [kUTTypeURL as NSPasteboard.PasteboardType])
        
        let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
        let dragFrame = CGRect(x: event.locationInWindow.x, y: event.locationInWindow.y, width: 50, height: 55)
        draggingItem.setDraggingFrame(dragFrame, contents: NSWorkspace.shared.icon(forFileType: "swift"))
        
        beginDraggingSession(with: [draggingItem], event: event, source: self)
    }
}

extension DropView: NSDraggingSource {
    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        return NSDragOperation.generic
    }
}

extension DropView: NSPasteboardItemDataProvider {
    func pasteboard(_ pasteboard: NSPasteboard?, item: NSPasteboardItem, provideDataForType type:
        NSPasteboard.PasteboardType) {
        
        if let pasteboard = pasteboard, type.rawValue == String(describing: kUTTypeURL) {
            
            pasteboard.clearContents()
            pasteboard.writeObjects(finalURLs)
        }
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        (NSApplication.shared.delegate as! AppDelegate).closePopover(sender: self)
    }
}
