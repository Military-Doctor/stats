//
//  StatsTouchbar.swift
//  Stats
//
//  Created by Junyi Hou on 1/13/21.
//  Copyright © 2021 Serhiy Mytrovtsiy. All rights reserved.
//

import Foundation

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
}

extension NSTouchBarItem.Identifier {
    static let itemA = NSTouchBarItem.Identifier("eu.exelban.Stats.itemA")
    static let itemB = NSTouchBarItem.Identifier("eu.exelban.Stats.itemB")
    static let itemC = NSTouchBarItem.Identifier("eu.exelban.Stats.itemC")
}

extension NSTouchBarItem.Identifier {
    static let controlStripItem = NSTouchBarItem.Identifier("eu.exelban.Stats.controlStrip")
}

class StatsTouchbarViewController: NSViewController{
    let touchBarController = TouchBarController.shared
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.view = NSView(frame: NSRect(x: 10, y: 10, width: 100, height: 100))
        
        touchBarController.create()
        touchBarController.addTrayItem()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TouchBarController: NSObject, NSTouchBarDelegate{
    // Singleton
    static let shared = TouchBarController()
    var items : [NSTouchBarItem.Identifier] = []
    
    var touchBar:NSTouchBar!
    
    private override init(){
        super.init()
    }
    func makeSecondaryTouchBar(tLane _tLane:NSTouchBarItem.Identifier) -> NSTouchBar {
        let mainBar = NSTouchBar()
        mainBar.delegate = self
        mainBar.defaultItemIdentifiers = [_tLane]
        return mainBar
    }
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        if identifier == .itemA{
            let item = NSCustomTouchBarItem(identifier: .itemA)
            let osField = NSTextField()
            osField.alignment = .left
            osField.font = NSFont.systemFont(ofSize: 12, weight: .semibold)
            osField.textColor = NSColor(hexString: "#FFFFFF", alpha: 0.7)
            osField.stringValue = "CPU"
            osField.isSelectable = true
            item.view = osField
            return item
        }else if identifier == .itemB{
            let item = NSCustomTouchBarItem(identifier: .itemB)
            let osField = NSTextField()
            osField.alignment = .left
            osField.font = NSFont.systemFont(ofSize: 12, weight: .semibold)
            osField.textColor = NSColor(hexString: "#FFFFFF", alpha: 0.7)
            osField.stringValue = "GPU"
            osField.isSelectable = true
            item.view = osField
            return item
        }else if identifier == .itemC{
            let item = NSCustomTouchBarItem(identifier: .itemC)
            let osField = NSTextField()
            osField.alignment = .left
            osField.font = NSFont.systemFont(ofSize: 12, weight: .semibold)
            osField.textColor = NSColor(hexString: "#FFFFFF", alpha: 0.7)
            osField.stringValue = "RAM"
            osField.isSelectable = true
            item.view = osField
            return item
        }else{
            return nil
        }
    }
    
    func presentSystemModal(_ touchBar: NSTouchBar!, placement: Int64, systemTrayItemIdentifier identifier: NSTouchBarItem.Identifier!) {
        if #available(OSX 10.14, *) {
            NSTouchBar.presentSystemModalTouchBar(touchBar, placement: placement, systemTrayItemIdentifier: identifier)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(touchBar, placement: placement, systemTrayItemIdentifier: identifier)
        }
    }
    
    @objc private func pressTouchBar(){
        print("!!!!!")
    }
    
    @objc private func presentTouchBar() {
        presentSystemModal(touchBar, placement: 1, systemTrayItemIdentifier: .controlStripItem)
    }
    
    // first create
    func create(){
    
        items.append(.itemA)
        items.append(.fixedSpaceSmall)
        items.append(.itemB)
        items.append(.itemC)
        touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = items
    }
    
    // second addTrayItem
    func addTrayItem(){
        DFRSystemModalShowsCloseBoxWhenFrontMost(false)
        let item = NSCustomTouchBarItem(identifier: .controlStripItem)
        item.view = NSButton(title:"🦄" , target: self, action: #selector(presentTouchBar))
        NSTouchBarItem.addSystemTrayItem(item)
        DFRElementSetControlStripPresenceForIdentifier(.controlStripItem, true)
    }
}
