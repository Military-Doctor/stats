//
//  StatsTouchbar.swift
//  Stats
//
//  Created by Junyi Hou on 1/13/21.
//  Copyright © 2021 Serhiy Mytrovtsiy. All rights reserved.
//

import Foundation
import ModuleKit

/*
                                      ┌────────────────────────────────────────┐
                                      │┌──────────────────────────────────────┐│
                                 ┌────┤│  enumerate touchbar of each modules  ││
     ┌─────────────────────┐     │    │└──────────────────────────────────────┘│
     │   User's Touchbar   │     │    │                    │                   │
     └─────────────────────┘     │    │                    ▼                   │
                ▲                │    │┌──────────────────────────────────────┐│
                │                │    ││  add valid touchbar identifier into  ││
 calling private API, presenting │    ││ `NSTouchbar.defaultItemIdentifiers`  ││
 `NSTouchbar` to user's Touchbar │    │└──────────────────────────────────────┘│
                │                │    │                    │                   │
                │                │    │                    │                   │
     ┌─────────────────────┐     │    │                    ▼                   │
     │ StatsTouchbarHelper │     │    │┌──────────────────────────────────────┐│
     └─────────────────────┘     │    ││    ! INCOMING TOUCHBAR CALLBACK !    ││
                ▲                │    │└──────────────────────────────────────┘│
                │                │    │                    ▲                   │
      return `NSTouchbar`        │    │                    │                   │
                │                │    │                    ▼                   │
     ┌─────────────────────┐     │    │┌──────────────────────────────────────┐│
     │    StatsTouchbar    │◀────┘    ││ call corresponding callback function ││
     └─────────────────────┘          ││that defined in each `module.touchbar`││
                                      │└──────────────────────────────────────┘│
                                      └────────────────────────────────────────┘
 */

extension NSTouchBarItem.Identifier {
    static let controlStripItem = NSTouchBarItem.Identifier("eu.exelban.Stats.controlStrip")
}

class StatsTouchbarHelper {
    // Singleton
    public static let shared = StatsTouchbarHelper()

    private init() {
    }

    @objc private func presentTouchBar() {
        let touchbar = StatsTouchBar(&modules)
        let alwaysInTouchbar = 0 // 1 or 0, it should be user configurable setting

        if #available(OSX 10.14, *) {
            NSTouchBar.presentSystemModalTouchBar(touchbar, placement: Int64(alwaysInTouchbar), systemTrayItemIdentifier: .controlStripItem)
        } else {
            NSTouchBar.presentSystemModalFunctionBar(touchbar, placement: Int64(alwaysInTouchbar), systemTrayItemIdentifier: .controlStripItem)
        }
    }

    func addTrayItem() {
        DFRSystemModalShowsCloseBoxWhenFrontMost(true)
        let item = NSCustomTouchBarItem(identifier: .controlStripItem)
        item.view = NSButton(title: "🦄", target: self, action: #selector(presentTouchBar))
        NSTouchBarItem.addSystemTrayItem(item)
        DFRElementSetControlStripPresenceForIdentifier(.controlStripItem, true)
    }
}

class StatsTouchbarButton: NSCustomTouchBarItem {
    private var title: String = "N/A"

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(identifier: NSTouchBarItem.Identifier, title: String) {
        super.init(identifier: identifier)
        Init(identifier: identifier, title: title, bkgColor: NSColor.black)
    }

    init(identifier: NSTouchBarItem.Identifier, title: String, bkgColor: NSColor) {
        super.init(identifier: identifier)
        Init(identifier: identifier, title: title, bkgColor: bkgColor)
    }

    private func Init(identifier: NSTouchBarItem.Identifier, title: String, bkgColor: NSColor) {
        let button = NSButton(title: title, target: self, action: #selector(handler(_:)))
        button.bezelColor = bkgColor
        self.title = title
        self.view = button
    }

    @objc func handler(_ sender: Any) {
        // TODO: callback
        print("Hello! I'm Button with title [" + self.title + "]")
    }
}

class StatsTouchbarLabeledTextView: NSView {

    init(label: String, text: String) {
        super.init(frame: NSRect(x: 0, y: 0, width: 500, height: 30))
        let labelView = NSTextField(frame: NSRect(x: 0, y: 18, width: 100, height: 12))
        labelView.stringValue = label
        labelView.font = NSFont.systemFont(ofSize: 7, weight: NSFont.Weight.medium)
        labelView.textColor = NSColor.white
        labelView.alignment = .left

        let textView = NSTextField(frame: NSRect(x: 0, y: 2, width: 100, height: 21))
        textView.stringValue = text
        textView.font = NSFont.systemFont(ofSize: 15, weight: NSFont.Weight.medium)
        textView.textColor = NSColor.white
        textView.alignment = .left

        self.addSubview(labelView)
        self.addSubview(textView)
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        //NSColor.darkGray.setFill()
        //dirtyRect.fill()
    }

}

class StatsTouchbarRectContainer: NSView {
    var color: NSColor = NSColor.systemYellow

    init(frame frameRect: NSRect, color nscolor: NSColor) {
        super.init(frame: frameRect)
        self.color = nscolor
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.color.setFill()
        dirtyRect.fill()
    }
}

class StatsTouchbarLabeledText: NSCustomTouchBarItem {

    public init(_ identifier: NSTouchBarItem.Identifier, _ label: String, _ text: String, _ widget: Widget_p) {
        super.init(identifier: identifier)
        // MAX HEIGHT: 30
        let container = StatsTouchbarRectContainer(frame: NSRect(x: 0, y: 0, width: 0, height: 30), color: NSColor.black)
        //let labeledTextView = StatsTouchbarLabeledTextView(label: label, text: text)

        container.setBoundsOrigin(NSPoint(x: 0, y: -4)) // make widget vertically centered

        container.addSubview(widget)
        self.view = container
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// TODO: Put following code to a new file
public class StatsTouchBar: NSTouchBar {

    // use identifier as index, getting Touchbar_p structure.
    var touchbarDict: [NSTouchBarItem.Identifier: Module] = [:]

    public init(_ moduleList: UnsafeMutablePointer<[Module]>) {
        super.init()
        delegate = self
        setTouchbar(moduleList)
    }

    required init?(coder: NSCoder) {
        // This particular touchbbar is always created programmatically.
        fatalError("init(coder:) has not been implemented")
    }

    // &modules that defined in global should be passed in argument `list`
    private func setTouchbar(_ list: UnsafeMutablePointer<[Module]>) {
        defaultItemIdentifiers.removeAll()
        for m in list.pointee {
            if m.touchbar != nil {
                self.touchbarDict[m.touchbar!.identifier] = m
                defaultItemIdentifiers.append(m.touchbar!.identifier)
            }
        }
    }
}

@available(OSX 10.12.2, *)
extension StatsTouchBar: NSTouchBarDelegate {
    public func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let label = touchbarDict[identifier]!.touchbar!.label
        let text = touchbarDict[identifier]!.touchbar!.text
        let widget = touchbarDict[identifier]?.widget
        return StatsTouchbarLabeledText(identifier, label, text, widget!)
        // return StatsTouchbarLabeledText(identifier, label, text, widget!)
        // return StatsTouchbarButton(identifier: identifier, title: label, bkgColor: NSColor.systemYellow)
        // TODO: Widget type recognize
    }
}
