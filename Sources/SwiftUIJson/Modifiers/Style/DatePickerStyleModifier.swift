//
//  DatePickerStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct DatePickerStyleModifier<Style>: JsonViewModifier, ConvertibleCodable where Style: Codable {
    let style: Any
    let action: ((AnyView) -> AnyView)?
    public init(any: Any) {
        Mirror.assert(any, name: "DatePickerStyleModifier", keys: ["style"])
        style = Mirror(reflecting: any).descendant("style")!
        action = nil
    }
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView {
        action!(AnyView(content))
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
        PType.register(DatePickerStyleModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        #if !os(tvOS) && !os(watchOS)
        if #available(iOS 14.0, macCatalyst 13.4, macOS 10.15.4, *) {
            PType.register(CompactDatePickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.datePickerStyle(CompactDatePickerStyle())) }])
        }
        PType.register(DefaultDatePickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.datePickerStyle(DefaultDatePickerStyle())) }])
        if #available(iOS 14.0, macOS 10.15, *) {
            PType.register(GraphicalDatePickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.datePickerStyle(GraphicalDatePickerStyle())) }])
        }
        #endif
        #if !os(tvOS) && !os(watchOS) && !os(macOS)
        PType.register(WheelDatePickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.datePickerStyle(WheelDatePickerStyle())) }])
        #endif
        #if os(macOS)
        PType.register(FieldDatePickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.datePickerStyle(FieldDatePickerStyle())) }])
        PType.register(StepperFieldDatePickerStyle.self, actions: ["style": { (content: AnyView) in AnyView(content.datePickerStyle(StepperFieldDatePickerStyle())) }])
        #endif
    }
}
