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
    public func body(content: AnyView) -> AnyView {
        (datePickerStyle as! ((AnyView) -> AnyView))(AnyView(content))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case style
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let styleKey = try container.decode(String.self, forKey: .style)
        (style, datePickerStyle) = try DynaType.findType(forKey: styleKey, withAction: "datePickerStyle")
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let styleKey = DynaType.typeKey(type: style)
        try container.encode(styleKey, forKey: .style)
    }
    //: Register
    static func register() {
        // DatePickerStyle
//        DynaType.registerFactory(any: [DefaultDatePickerStyle.self], namespace: "SwiftUI") { (a: DefaultDatePickerStyle) in
//            func factory<A>(_ a: A) -> Any.Type { DatePickerStyleModifier<A.Type>.self }
//            return factory(a)
//        }
        DynaType.register(DatePickerStyleModifier<NeverCodable>.self, any: [NeverCodable.self], namespace: "SwiftUI")
        DynaType.register(CompactDatePickerStyle.self, actions: ["datePickerStyle" : { (content: AnyView) in AnyView(content.datePickerStyle(CompactDatePickerStyle())) }])
        DynaType.register(DefaultDatePickerStyle.self, actions: ["datePickerStyle" : { (content: AnyView) in AnyView(content.datePickerStyle(DefaultDatePickerStyle())) }])
        DynaType.register(GraphicalDatePickerStyle.self, actions: ["datePickerStyle" : { (content: AnyView) in AnyView(content.datePickerStyle(GraphicalDatePickerStyle())) }])
        DynaType.register(WheelDatePickerStyle.self, actions: ["datePickerStyle" : { (content: AnyView) in AnyView(content.datePickerStyle(WheelDatePickerStyle())) }])
        #if os(macOS)
        DynaType.register(FieldDatePickerStyle.self, actions: ["datePickerStyle" : { (content: AnyView) in AnyView(content.datePickerStyle(FieldDatePickerStyle())) }])
        DynaType.register(StepperFieldDatePickerStyle.self, actions: ["datePickerStyle" : { (content: AnyView) in AnyView(content.datePickerStyle(StepperFieldDatePickerStyle())) }])
        #endif
    }
}


public protocol JsonDatePickerStyle: DatePickerStyle {
}
    

extension CompactDatePickerStyle: JsonDatePickerStyle, Codable {
    public init(from decoder: Decoder) throws { self.init() }
    public func encode(to encoder: Encoder) throws {}
}
extension DefaultDatePickerStyle: Codable {
    public init(from decoder: Decoder) throws { self.init() }
    public func encode(to encoder: Encoder) throws {}
}
extension GraphicalDatePickerStyle: Codable {
    public init(from decoder: Decoder) throws { self.init() }
    public func encode(to encoder: Encoder) throws {}
}
extension WheelDatePickerStyle: Codable {
    public init(from decoder: Decoder) throws { self.init() }
    public func encode(to encoder: Encoder) throws {}
}
#if os(macOS)
extension FieldDatePickerStyle: Codable {
    public init(from decoder: Decoder) throws { self.init() }
    public func encode(to encoder: Encoder) throws {}
}
extension StepperFieldDatePickerStyle: Codable {
    public init(from decoder: Decoder) throws { self.init() }
    public func encode(to encoder: Encoder) throws {}
}
#endif
