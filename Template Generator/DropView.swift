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
        let dragFrame = CGRect(x: event.locationInWindow.x - 40, y: event.locationInWindow.y, width: 52, height: 52)
        
        let image = NSWorkspace.shared.icon(forFileType: "swift").resized(to: NSSize(width: 52, height: 52))
        draggingItem.setDraggingFrame(dragFrame, contents: image)
        
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

extension NSImage {
    func resized(to newSize: NSSize) -> NSImage? {
        if let bitmapRep = NSBitmapImageRep(
            bitmapDataPlanes: nil, pixelsWide: Int(newSize.width), pixelsHigh: Int(newSize.height),
            bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
            colorSpaceName: .calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0
            ) {
            bitmapRep.size = newSize
            NSGraphicsContext.saveGraphicsState()
            NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmapRep)
            draw(in: NSRect(x: 0, y: 0, width: newSize.width, height: newSize.height), from: .zero, operation: .copy, fraction: 1.0)
            NSGraphicsContext.restoreGraphicsState()
            
            let resizedImage = NSImage(size: newSize)
            resizedImage.addRepresentation(bitmapRep)
            return resizedImage
        }
        
        return nil
    }
}
