//
//  DatePickerStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct DatePickerStyleModifier<Style>: DynaConvert, Codable, ViewModifier where Style : DatePickerStyle {
    let style: Style
    public init(any: Any) {
        style = Mirror(reflecting: any).descendant("style")! as! Style
    }
    public func body(content: Content) -> some View {
        content.datePickerStyle(style)
    }
    //: Codable
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        style = try container.decodeAny(Style.self)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encodeAny(style)
    }
}
//
//extension DefaultDatePickerStyle: Codable {
//    public init(from decoder: Decoder) throws {
////        let container = try decoder.singleValueContainer()
//        self.init()
//    }
//    public func encode(to encoder: Encoder) throws {
////        var container = encoder.singleValueContainer()
//    }
//}
