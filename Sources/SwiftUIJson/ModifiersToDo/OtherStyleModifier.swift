//
//  OtherStyleModifier.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

struct OtherStyleModifier<Style>: DynaConvertedDynaCodable, ViewModifier where Style: Codable {
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
        // PrimitiveButtonStyle
        DynaType.register(BorderlessButtonStyle.self)
        DynaType.register(DefaultButtonStyle.self)
        DynaType.register(PlainButtonStyle.self)
        #if os(macOS)
        DynaType.register(BorderedButtonStyle.self)
        DynaType.register(CardButtonStyle.self)
        DynaType.register(LinkButtonStyle.self)
        #endif
                
        // GroupBoxStyle
        DynaType.register(DefaultGroupBoxStyle.self)
        
        // IndexViewStyle
        DynaType.register(PageIndexViewStyle.self)
        
        // LabelStyle
        DynaType.register(DefaultLabelStyle.self)
        DynaType.register(IconOnlyLabelStyle.self)
        DynaType.register(TitleOnlyLabelStyle.self)
        
        // ListStyle
        DynaType.register(DefaultListStyle.self)
        DynaType.register(GroupedListStyle.self)
        DynaType.register(InsetGroupedListStyle.self)
        DynaType.register(InsetListStyle.self)
        DynaType.register(PlainListStyle.self)
        DynaType.register(SidebarListStyle.self)
        #if os(macOS)
        DynaType.register(CarouselListStyle.self)
        DynaType.register(EllipticalListStyle.self)
        #endif

        // MenuStyle
        DynaType.register(BorderlessButtonMenuStyle.self)
        DynaType.register(DefaultMenuStyle.self)
        #if os(macOS)
        DynaType.register(BorderedButtonMenuStyle.self)
        #endif
        
        // NavigationViewStyle
        DynaType.register(DefaultNavigationViewStyle.self)
        DynaType.register(DoubleColumnNavigationViewStyle.self)
        DynaType.register(StackNavigationViewStyle.self)
        
        // PickerStyle
        DynaType.register(DefaultPickerStyle.self)
        DynaType.register(InlinePickerStyle.self)
        DynaType.register(MenuPickerStyle.self)
        DynaType.register(SegmentedPickerStyle.self)
        DynaType.register(WheelPickerStyle.self)
        #if os(macOS)
        DynaType.register(PopUpButtonPickerStyle.self)
        DynaType.register(RadioGroupPickerStyle.self)
        #endif
        
        // ProgressViewStyle
        DynaType.register(CircularProgressViewStyle.self)
        DynaType.register(DefaultProgressViewStyle.self)
        DynaType.register(LinearProgressViewStyle.self)
        
        // TabViewStyle
        DynaType.register(DefaultTabViewStyle.self)
        DynaType.register(PageTabViewStyle.self)
        #if os(macOS)
        DynaType.register(CarouselTabViewStyle.self)
        #endif
                
        // TextFieldStyle
        DynaType.register(DefaultTextFieldStyle.self)
        DynaType.register(PlainTextFieldStyle.self)
        DynaType.register(RoundedBorderTextFieldStyle.self)
        #if os(macOS)
        DynaType.register(SquareBorderTextFieldStyle.self)
        #endif
        
        // ToggleStyle
        DynaType.register(DefaultToggleStyle.self)
        DynaType.register(SwitchToggleStyle.self)
        #if os(macOS)
        DynaType.register(CheckboxToggleStyle.self)
        #endif
    }
}
