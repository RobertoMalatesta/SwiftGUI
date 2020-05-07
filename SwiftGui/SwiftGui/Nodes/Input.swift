//
//  Input.swift
//  SwiftGui
//
//  Created by Erick Jung on 26/10/2019.
//  Copyright © 2019 Erick Jung. All rights reserved.
//

import Foundation
import SwiftGuiCore

public func InputText(_ title: String = "",
                      textState: String,
                      placeHolder: String? = nil,
                      maxLength: Int = 256,
                      flags: ImGuiInputTextFlags = .none,
                      onChange: ((String) -> Void)? = nil) -> GuiNode {
    
    GuiNode(tag: #function).onRender { _ in

        var _value = textState.cChars(with: maxLength)
        
        if let placeHolder = placeHolder {

            if igInputTextWithHint(title.cStr(), placeHolder, &_value, maxLength, flags.rawValue, nil, nil) {
                onChange?(String(cString: _value))
            }

        } else {
            
            if igInputText(title.cStr(), &_value, maxLength, flags.rawValue, nil, nil) {
                onChange?(String(cString: _value))
            }
        }
    }
}

public func InputTextMultiline(id: String,
                               textState: String,
                               size: SGSize = .zero,
                               flags: ImGuiInputTextFlags = .none,
                               onChange: ((String) -> Void)? = nil) -> GuiNode {
    
    GuiNode(tag: #function).onRender { _ in
        
        var _value = textState.cChars(with: textState.count + 2048)
        if igInputTextMultiline(id.cStr(), &_value, _value.count, size.convertToVec2(), flags.rawValue, { (data) -> Int32 in

            return 0

        }, nil) {

            onChange?(String(cString: _value))
        }
    }
}


public func InputFloat(_ title: String,
                       valueState: Float,
                       step: Float = 0,
                       stepFast: Float = 0,
                       format: String,
                       flags: ImGuiInputTextFlags = .none,
                       onChange: ((Float) -> Void)? = nil) -> GuiNode {
    
    GuiNode(tag: #function).onRender { _ in

        var _value = Float32(valueState)
        if igInputFloat(title.cStr(), &_value, step, stepFast, format, flags.rawValue) {
            onChange?(Float(_value))
        }
    }
}

public func InputInt(_ title: String,
                     valueState: Int,
                     step: Int = 1,
                     stepFast: Int = 100,
                     flags: ImGuiInputTextFlags = .none,
                     onChange: ((Int) -> Void)? = nil) -> GuiNode {
    
    GuiNode(tag: #function).onRender { _ in

        var _value = Int32(valueState)
        if igInputInt(title.cStr(), &_value, Int32(step), Int32(stepFast), flags.rawValue) {
            onChange?(Int(_value))
        }
    }
}
