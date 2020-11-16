//
//  PickerStyleWriter.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct PickerStyleWriter<Style>: JsonViewModifier, ConvertibleCodable where Style: Codable {
    let style: Any
    let action: ((AnyView) -> AnyView)!
    public init(any: Any) {
        Mirror.assert(any, name: "PickerStyleWriter", keys: ["style"])
        style = Mirror(reflecting: any).descendant("style")!
        action = nil
    }
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView {
        action(AnyView(content))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case style
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let styleKey = try container.decode(String.self, forKey: .style)
        (action, style) = try DynaType.find(actionAndType: "style", forKey: styleKey)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let styleKey = DynaType.typeKey(type: style)
        try container.encode(styleKey, forKey: .style)
    }
    //: Register
    static func register() {
        DynaType.register(PickerStyleWriter<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        DynaType.register(DefaultPickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(DefaultPickerStyle())) }])
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            DynaType.register(InlinePickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(InlinePickerStyle())) }])
        }
        #if !os(tvOS) && !os(watchOS)
        if #available(iOS 14.0, macOS 11.0, *) {
            DynaType.register(MenuPickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(MenuPickerStyle())) }])
        }
        #endif
        #if !os(watchOS)
        DynaType.register(SegmentedPickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(SegmentedPickerStyle())) }])
        #endif
        #if !os(macOS) && !os(tvOS)
        DynaType.register(WheelPickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(WheelPickerStyle())) }])
        #endif
        #if os(macOS)
        DynaType.register(PopUpButtonPickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(PopUpButtonPickerStyle())) }])
        DynaType.register(RadioGroupPickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(RadioGroupPickerStyle())) }])
        #endif
    }
}
