//
//  DatePickerStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI



struct DatePickerStyleModifier<Style>: DynaConvertedDynaCodable, ViewModifier where Style: Codable {
    let style: Any
    public init(any: Any) {
        style = Mirror(reflecting: any).descendant("style")!
    }
    public func body(content: Content) -> some View {
//        content.datePickerStyle(style)
        EmptyView()
    }
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
//        var container = try decoder.unkeyedContainer()
//        style = try DynaType.typeParse(forKey: try container.decode(String.self))
        fatalError()
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(DynaType.typeKey(for: style))
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

extension DefaultDatePickerStyle: Codable {
    public init(from decoder: Decoder) throws { fatalError() }
    public func encode(to encoder: Encoder) throws {}
}
extension CompactDatePickerStyle: Codable {
    public init(from decoder: Decoder) throws { fatalError() }
    public func encode(to encoder: Encoder) throws {}
}
