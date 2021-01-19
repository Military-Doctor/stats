//
//  touchbar.swift
//  ModuleKit
//
//  Created by Junyi Hou on 1/19/21.
//  Copyright © 2021 Serhiy Mytrovtsiy. All rights reserved.
//

import Foundation
import AppKit

public protocol Touchbar_p {
    
    
    var identifier : NSTouchBarItem.Identifier  { get }
    var label      : String                     { get set }
    var view       : NSView!                    { get set }
    
    //init()
}
