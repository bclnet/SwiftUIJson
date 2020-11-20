//
//  JsonUI.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public struct JsonUI: Codable {
    public let body: Any
    public var anyView: AnyView? { body as? AnyView }
    
    public init<Content>(view: Content) throws where Content : View {
        let _ = JsonUI.registered
        if Content.Body.self == Never.self {
            fatalError("NEVER")
        }
        guard let value = view as? Encodable else {
            guard let value2 = view.body as? Encodable else {
                throw DynaTypeError.typeNotCodable("JsonUI", key: DynaType.typeKey(for: view.body))
            }
            body = value2
            return
        }
        body = value
    }
    


    //: Codable
    enum CodingKeys: CodingKey {
        case _ui
    }
    public init(from decoder: Decoder) throws {
        guard let json = decoder.userInfo[.json] as? Data else { fatalError(".json") }
        guard decoder.userInfo[.jsonContext] as? JsonContext != nil else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let nextContext = try container.decode(JsonContext.self, forKey: ._ui)
            let nextDecoder = JSONDecoder()
            nextDecoder.userInfo[.json] = json
            nextDecoder.userInfo[.jsonContext] = nextContext
            body = try nextDecoder.decode(JsonUI.self, from: json).body
            return
        }
        guard let context = decoder.userInfo[.jsonContext] as? JsonContext else { fatalError(".jsonContext") }
        let value = try context.decodeDynaSuper(from: decoder)
        body = AnyView.any(value)
    }
    public func encode(to encoder: Encoder) throws {
        guard let context = encoder.userInfo[.jsonContext] as? JsonContext else { fatalError(".jsonContext") }
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(context, forKey: ._ui)
        try context.encodeDynaSuper(body, to: encoder)
    }
    
    // MARK: - Register
    public static let registered: Bool = registerDefault()
    
    public static func registerDefault() -> Bool {
        // modifiers:styles
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            _TabViewStyleWriter<NeverCodable>.register()
        }
        ButtonStyleModifier<NeverCodable>.register()
        DatePickerStyleModifier<NeverCodable>.register()
        GroupBoxStyleModifier<NeverCodable>.register()
        IndexViewStyleModifier<NeverCodable>.register()
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            LabelStyleStyleModifier<NeverCodable>.register()
        }
        ListStyleModifier<NeverCodable>.register()
        #if !os(tvOS) && !os(watchOS)
        if #available(iOS 14.0, macOS 11.0, *) {
            MenuStyleModifier<NeverCodable>.register()
        }
        #endif
        NavigationViewStyleModifier<NeverCodable>.register()
        PickerStyleWriter<NeverCodable>.register()
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            ProgressViewStyleModifier<NeverCodable>.register()
        }
        TextFieldStyleStyleModifier<NeverCodable>.register()
        ToggleStyleModifier<NeverCodable>.register()
        
        // modifiers:system
        _StateWrapper<AnyView>.register()
        AnyViewModifier.register()
        EnvironmentValues.register()
        
        // modifiers
        __DesignTimeSelectionIdentifier.register()
        if #available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *) {
            _AccessibilityIgnoresInvertColorsViewModifier.register()
        }
        _AllowsHitTestingModifier.register()
        _AppearanceActionModifier.register()
        _BackgroundModifier<AnyView>.register()
        _ClipEffect<AnyShape>.register()
        _ContextMenuContainer.register()
        _DraggingModifier.register()
        _EnvironmentKeyWritingModifier<NeverCodable?>.register()
        _FrameLayout.register()
        _IdentifiedModifier<__DesignTimeSelectionIdentifier>.register()
        _OffsetEffect.register()
        _OverlayModifier<AnyView>.register()
        _PaddingLayout.register()
        _RotationEffect.register()
        _SafeAreaIgnoringLayout.register()
        _ShadowEffect.register()
        _TraitWritingModifier<NeverCodable>.register()
        AccessibilityAttachmentModifier.register()
        ModifiedContent<AnyView, AnyViewModifier>.register()
        ModifierGesture<Any, Any>.register()
        
        // swiftui:shapestyles
        AngularGradient.register()
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            BackgroundStyle.register()
        }
        ForegroundStyle.register()
        ImagePaint.register()
        LinearGradient.register()
        RadialGradient.register()
        #if os(macOS)
        SelectionShapeStyle.register()
        SeparatorShapeStyle.register()
        #endif
        // swiftui
        Color.register()
        
        // views:shapes
        _ShapeView<AnyShape, AngularGradient>.register()
        _SizedShape<AnyShape>.register()
        _StrokedShape<AnyShape>.register()
        _TrimmedShape<AnyShape>.register()
        Capsule.register()
        Circle.register()
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            ContainerRelativeShape.register()
        }
        Ellipse.register()
        OffsetShape<AnyShape>.register()
        Path.register()
        Rectangle.register()
        RotatedShape<AnyShape>.register()
        RoundedRectangle.register()
        ScaledShape<AnyShape>.register()
        TransformedShape<AnyShape>.register()
        
        // views:system
        _ConditionalContent<AnyView, AnyView>.register()
        _VariadicView.register()
        AnyView.register()
        //:tree
        TupleView<(AnyView)>.register()
        
        // views
        Button<AnyView>.register()
        ContextMenu<AnyView>.register()
        DatePicker<AnyView>.register()
        Divider.register()
        #if os(iOS)
        EditButton.register()
        #endif
        EmptyView.register()
//        DynaType.register(EquatableView<Any>.self)
        ForEach<AnyRandomAccessCollection<Any>, AnyHashable, AnyView>.register()
        DynaType.register(Form<AnyView>.self)
        DynaType.register(GeometryReader<AnyView>.self)
        DynaType.register(Group<AnyView>.self)
        DynaType.register(GroupBox<AnyView, AnyView>.self)
        #if os(macOS)
        HSplitView<AnyView>.register()
        #endif
        HStack<AnyView>.register()
        Image.register()
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            LazyHStack<AnyView>.register()
            LazyVStack<AnyView>.register()
        }
        DynaType.register(List<AnyHashable, AnyView>.self)
        DynaType.register(NavigationLink<AnyView, AnyView>.self)
        DynaType.register(NavigationView<AnyView>.self)
        DynaType.register(Never.self)
        Picker<AnyView, AnyHashable, AnyView>.register()
        Slider<AnyView, AnyView>.register()
        Spacer.register()
        Stepper<AnyView>.register()
        DynaType.register(ScrollView<AnyView>.self)
        DynaType.register(Section<AnyView, AnyView, AnyView>.self)
        DynaType.register(SecureField<AnyView>.self)
//        register(SubscriptionView<AnyPublisherType, AnyView>.self)
        Text.register()
        DynaType.register(TextField<AnyView>.self)
        Toggle<AnyView>.register()
        VStack<AnyView>.register()
        #if os(macOS)
        VSplitView<AnyView>.register()
        #endif
        ZStack<AnyView>.register()
        #if os(watchOS)
        if #available(iOS 13.0, OSX 10.15, tvOS 13.0, *) {
            DynaType.register(TabView<AnyHashable, AnyView>.self)
        }
        #endif
        #if os(macOS)
        DynaType.register(HSplitView<AnyView>.self)
        DynaType.register(MenuButton<AnyView, AnyView>.self)
        DynaType.register(PasteButton.self)
        DynaType.register(TouchBar<AnyView>.self)
        DynaType.register(VSplitView<AnyView>.self)
        #endif
        
        return true
    }
}

