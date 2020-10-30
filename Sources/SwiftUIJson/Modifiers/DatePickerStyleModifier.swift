//
//  DatePickerStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct DatePickerStyleModifier<Style>: JsonViewModifier, DynaConvertedCodable where Style: Codable {
    let style: Any
    public init(any: Any) {
        style = Mirror(reflecting: any).descendant("style")!
    }
    public func body(content: AnyView) -> AnyView {
        return AnyView(content.datePickerStyle(CompactDatePickerStyle()))
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case style
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let styleKey = try container.decode(String.self, forKey: .style)
        style = try DynaType.typeParse(forKey: styleKey)
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
        DynaType.register(CompactDatePickerStyle.self)
        DynaType.register(DefaultDatePickerStyle.self)
        DynaType.register(GraphicalDatePickerStyle.self)
        DynaType.register(WheelDatePickerStyle.self)
        #if os(macOS)
        DynaType.register(FieldDatePickerStyle.self)
        DynaType.register(StepperFieldDatePickerStyle.self)
        #endif
    }
}

extension CompactDatePickerStyle: Codable {
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
