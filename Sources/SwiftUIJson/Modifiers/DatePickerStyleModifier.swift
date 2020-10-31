//
//  DatePickerStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct DatePickerStyleModifier<Style>: JsonViewModifier, DynaConvertedCodable where Style: Codable {
    let style: Any
    let datePickerStyle: Any?
    public init(any: Any) {
        style = Mirror(reflecting: any).descendant("style")!
        datePickerStyle = nil
    }
    //: JsonViewModifier
    public func body(content: AnyView) -> AnyView {
        (datePickerStyle as! ((AnyView) -> AnyView))(AnyView(content))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case style
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        (datePickerStyle, style) = try DynaType.find(actionAndType: "datePickerStyle", forKey: try container.decode(String.self, forKey: .style))
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(DynaType.typeKey(type: style), forKey: .style)
    }
    //: Register
    static func register() {
        DynaType.register(DatePickerStyleModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        DynaType.register(CompactDatePickerStyle.self, actions: ["datePickerStyle": { (content: AnyView) in AnyView(content.datePickerStyle(CompactDatePickerStyle())) }])
        DynaType.register(DefaultDatePickerStyle.self, actions: ["datePickerStyle": { (content: AnyView) in AnyView(content.datePickerStyle(DefaultDatePickerStyle())) }])
        DynaType.register(GraphicalDatePickerStyle.self, actions: ["datePickerStyle": { (content: AnyView) in AnyView(content.datePickerStyle(GraphicalDatePickerStyle())) }])
        DynaType.register(WheelDatePickerStyle.self, actions: ["datePickerStyle": { (content: AnyView) in AnyView(content.datePickerStyle(WheelDatePickerStyle())) }])
        #if os(macOS)
        DynaType.register(FieldDatePickerStyle.self, actions: ["datePickerStyle": { (content: AnyView) in AnyView(content.datePickerStyle(FieldDatePickerStyle())) }])
        DynaType.register(StepperFieldDatePickerStyle.self, actions: ["datePickerStyle": { (content: AnyView) in AnyView(content.datePickerStyle(StepperFieldDatePickerStyle())) }])
        #endif
    }
}
