//
//  JsonUI.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI
import Combine

public struct JsonUI: Codable {
    public let body: Any
    public var anyView: AnyView? { body as? AnyView }
    
    public init<Content>(view: Content) throws where Content : View {
        let _ = JsonUI.registered
        if Content.Body.self == Never.self { fatalError("NEVER") }
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
            let nextContext: JsonContext
            do {
                var container = try decoder.unkeyedContainer()
                nextContext = try container.decode(JsonContext.self)
            } catch {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                nextContext = try container.decode(JsonContext.self, forKey: ._ui)
            }
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
        if body is DynaUnkeyedContainer {
            var container = encoder.unkeyedContainer()
            try container.encode(context)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(context, forKey: ._ui)
        }
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
        __DesignTimeSelectionIdentifier.register()
        _StateWrapper<AnyView>.register()
        AnyViewModifier.register()
        EnvironmentValues.register()
        
        // modifiers
        if #available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *) {
            _AccessibilityIgnoresInvertColorsViewModifier.register()
        }
        _AlignmentWritingModifier.register()
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
        _PositionLayout.register()
        _RotationEffect.register()
        _SafeAreaIgnoringLayout.register()
        _ShadowEffect.register()
        #if os(macOS)
        _TouchBarModifier<AnyView>.register()
        #endif
        _TraitWritingModifier<NeverCodable>.register()
        _TransformEffect.register()
        AccessibilityAttachmentModifier.register()
        AddGestureModifier<Any>.register()
        ModifiedContent<AnyView, AnyViewModifier>.register()
        
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
        ModifierGesture<Any, Any>.register()
        
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
        #if !os(tvOS)
        ContextMenu<AnyView>.register()
        #endif
        #if !os(tvOS) && !os(watchOS)
        DatePicker<AnyView>.register()
        #endif
        Divider.register()
        #if os(iOS)
        EditButton.register()
        #endif
        EmptyView.register()
//        EquatableView<AnyView>.register()
        ForEach<AnyRandomAccessCollection<NeverCodable>, AnyHashable, AnyView>.register()
        Form<AnyView>.register()
        GeometryReader<AnyView>.register()
        Group<AnyView>.register()
        #if !os(tvOS) && !os(watchOS)
        if #available(iOS 14.0, macOS 10.15, *) {
            GroupBox<AnyView, AnyView>.register()
        }
        #endif
        #if os(macOS)
        HSplitView<AnyView>.register()
        #endif
        HStack<AnyView>.register()
        Image.register()
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            LazyHStack<AnyView>.register()
            LazyVStack<AnyView>.register()
            Link<AnyView>.register()
        }
        List<AnyHashable, AnyView>.register()
        #if os(macOS)
        MenuButton<AnyView, AnyView>.register()
        #endif
        NavigationLink<AnyView, AnyView>.register()
        #if !os(watchOS)
        NavigationView<AnyView>.register()
        #endif
        #if os(macOS)
        PasteButton.register()
        #endif
        Picker<AnyView, AnyHashable, AnyView>.register()
        ScrollView<AnyView>.register()
        Section<AnyView, AnyView, AnyView>.register()
        SecureField<Text>.register()
        #if !os(tvOS)
        Slider<AnyView, AnyView>.register()
        #endif
        Spacer.register()
        #if !os(tvOS) && !os(watchOS)
        Stepper<AnyView>.register()
        #endif
        SubscriptionView<PassthroughSubject<Any, Never>, AnyView>.register()
        #if !os(watchOS)
        TabView<AnyHashable, AnyView>.register()
        #endif
        Text.register()
        TextField<Text>.register()
        Toggle<AnyView>.register()
        #if os(macOS)
        TouchBar<AnyView>.register()
        VSplitView<AnyView>.register()
        #endif
        VStack<AnyView>.register()
        ZStack<AnyView>.register()
        return true
    }
}

