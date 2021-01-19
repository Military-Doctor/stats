//
//  StatsTouchbar.swift
//  Stats
//
//  Created by Junyi Hou on 1/13/21.
//  Copyright © 2021 Serhiy Mytrovtsiy. All rights reserved.
//

import Foundation
import ModuleKit

class StatsTouchbarWindow:NSWindow, NSWindowDelegate{
   
    private let viewController: StatsTouchbarViewController = StatsTouchbarViewController()
    
    init() {
        super.init(
            contentRect: NSMakeRect(200,200,100,100),
            styleMask: [.closable, .resizable, .titled],
            backing: .buffered,
            defer: true
        )
        
        self.contentViewController = self.viewController
        self.titlebarAppearsTransparent = true
        
        self.center()
        self.setIsVisible(true)
        
        let windowController = NSWindowController()
        windowController.window = self
        windowController.loadWindow()
    }
    
    public func setTouchbar(){
        // `modules` is a global variable!!!
        viewController.setTouchbar(&modules)
    }
    
}

extension NSTouchBarItem.Identifier {
    static let controlStripItem = NSTouchBarItem.Identifier("eu.exelban.Stats.controlStrip")
}

class StatsTouchbarViewController: NSViewController{
    var identifiers = [NSTouchBarItem.Identifier]()
    let touchBarController = TouchBarController.shared
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.view = NSView(frame: NSRect(x: 10, y: 10, width: 100, height: 100))
        
        touchBarController.addTrayItem()
        // touchbar will be created after calling touchBarController.setTouchbar() by upper class
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTouchbar(_ list: UnsafeMutablePointer<[Module]>){
        touchBarController.setTouchbar(list)
    }
}

class TouchBarController: NSObject, NSTouchBarDelegate{
    
    // Singleton
    static let shared = TouchBarController()
    
    // touchbar items
    var items : [NSTouchBarItem.Identifier] = []
    
    // use identifier as an index, get Touchbar_p structure.
    var touchbarDict : [NSTouchBarItem.Identifier:Touchbar_p]=[:]
    
    var touchBar:NSTouchBar!
    
    private override init(){
        super.init()
    }
    
    public func setTouchbar(_ list: UnsafeMutablePointer<[Module]>){
        for m in list.pointee {
            if m.touchbar != nil{
                self.touchbarDict[m.touchbar!.identifier] = m.touchbar!
                items.append(m.touchbar!.identifier)
            }
        }
        reload()
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        for i in items {
            if identifier == i {
                let item = NSCustomTouchBarItem(identifier: i)
                let osField = NSTextField()
                osField.alignment = .left
                osField.font = NSFont.systemFont(ofSize: 12, weight: .semibold)
                osField.textColor = NSColor(hexString: "#FFFFFF", alpha: 0.8)
                osField.stringValue = touchbarDict[i]!.label
                osField.isSelectable = true
                item.view = osField
                return item
            }
        }
        return nil
    }
    
    @objc private func pressTouchBar(){
        print("!!!!!")
    }
    
    func reload(){
        touchBar = nil
        touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = items
    }
    
    func presentSystemModal(_ touchBar: NSTouchBar!, placement: Int64, systemTrayItemIdentifier identifier: NSTouchBarItem.Identifier!) {
        if #available(OSX 10.14, *) {
            NSTouchBar.presentSystemModalTouchBar(touchBar, placement: placement, systemTrayItemIdentifier: identifier)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(touchBar, placement: placement, systemTrayItemIdentifier: identifier)
        }
    }
    
    @objc private func presentTouchBar() {
        presentSystemModal(touchBar, placement: 1, systemTrayItemIdentifier: .controlStripItem)
    }

    func addTrayItem(){
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        let item = NSCustomTouchBarItem(identifier: .controlStripItem)
        item.view = NSButton(title:"🦄" , target: self, action: #selector(presentTouchBar))
        NSTouchBarItem.addSystemTrayItem(item)
        DFRElementSetControlStripPresenceForIdentifier(.controlStripItem, true)
    }
}
