//
//  DatePickerStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public struct DatePickerStyleModifier<Style>: ViewModifier, Codable where Style : DatePickerStyle, Style : Codable {
    let style: Style
    public init(style: Style) {
        self.style = style
    }
    public func body(content: Content) -> some View {
        content.datePickerStyle(style)
    }
    //: Codable
    public init(from decoder: Decoder) throws {
        fatalError()
    }
    public func encode(to encoder: Encoder) throws {
    }
}

extension DefaultDatePickerStyle: Codable {
    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
        self.init()
    }
    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
    }
}
