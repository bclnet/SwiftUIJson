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
        (action, style) = try PType.find(actionAndType: "style", forKey: styleKey)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let styleKey = PType.typeKey(type: style)
        try container.encode(styleKey, forKey: .style)
    }
    //: Register
    static func register() {
        PType.register(PickerStyleWriter<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        PType.register(DefaultPickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(DefaultPickerStyle())) }])
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            PType.register(InlinePickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(InlinePickerStyle())) }])
        }
        #if !os(tvOS) && !os(watchOS)
        if #available(iOS 14.0, macOS 11.0, *) {
            PType.register(MenuPickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(MenuPickerStyle())) }])
        }
        #endif
        #if !os(watchOS)
        PType.register(SegmentedPickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(SegmentedPickerStyle())) }])
        #endif
        #if !os(macOS) && !os(tvOS)
        PType.register(WheelPickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(WheelPickerStyle())) }])
        #endif
        #if os(macOS)
        PType.register(PopUpButtonPickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(PopUpButtonPickerStyle())) }])
        PType.register(RadioGroupPickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.pickerStyle(RadioGroupPickerStyle())) }])
        #endif
    }
}
