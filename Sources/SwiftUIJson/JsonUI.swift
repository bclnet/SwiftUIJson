//
//  JsonUI.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

// https://github.com/Cosmo/OpenSwiftUI
import SwiftUI

public protocol JsonView {
    var anyView: AnyView { get }
}

//public enum JsonUIError: Error {
//    case generic(message: String)
//}

public struct JsonUI: Codable {
    public var context = JsonContext()
    public let body: Any
    public var anyView: AnyView? { body as? AnyView }
    
    public init<Content>(view: Content, context: JsonContext) throws where Content : View {
        let _ = JsonUI.registered
        guard let value = view.body as? Encodable else { throw DynaTypeError.typeNotCodable("JsonUI", named: String(reflecting: view)) }
        self.context = context
        body = value
    }

    //: Codable
    enum CodingKeys: CodingKey {
        case _ui
    }
    public init(from decoder: Decoder) throws {
        guard let json = decoder.userInfo[.json] as? Data else { fatalError("json") }
        guard (decoder.userInfo[.jsonContext] as? JsonContext) != nil else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let nextContext = try container.decode(JsonContext.self, forKey: ._ui)
            let nextDecoder = JSONDecoder()
            nextDecoder.userInfo[.json] = json
            nextDecoder.userInfo[.jsonContext] = nextContext
            body = try nextDecoder.decode(JsonUI.self, from: json).body
            return
        }
        let value = try decoder.decodeDynaSuper()
        if let anyView = value as? AnyView {
            body = anyView
        } else {
            guard let view = value as? JsonView else { fatalError("init") }
            body = view.anyView
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(context, forKey: ._ui)
        try encoder.encodeDynaSuper(body)
    }
    
    // MARK: - Register
    public static let registered: Bool = registerDefault()
    
    public static func register<T>(_ type: T.Type, namespace: String? = nil) { DynaType.register(type, namespace: namespace) }
    
    public static func registerDefault() -> Bool {
        registerDefault_styles()
        registerDefault_views()
        #if os(macOS)
        registerDefault_OSX()
        registerDefault_OSX_iOS_tvOS()
        #elseif os(iOS)
        registerDefault_iOS()
        registerDefault_OSX_iOS_tvOS()
        #elseif os(tvOS)
        registerDefault_tvOS()
        registerDefault_OSX_iOS_tvOS()
        #elseif os(watchOS)
        registerDefault_watchOS()
        #endif
        return true
    }
    
    static func registerDefault_styles() {
        // PrimitiveButtonStyle
        register(BorderlessButtonStyle.self)
        register(DefaultButtonStyle.self)
        register(PlainButtonStyle.self)
        #if os(macOS)
        register(BorderedButtonStyle.self)
        register(CardButtonStyle.self)
        register(LinkButtonStyle.self)
        #endif
        
        // DatePickerStyle
        register(DatePickerStyleModifier<DefaultDatePickerStyle>.self, namespace: "SwiftUI")
        register(CompactDatePickerStyle.self)
        register(DefaultDatePickerStyle.self)
        register(GraphicalDatePickerStyle.self)
        register(WheelDatePickerStyle.self)
        #if os(macOS)
        register(FieldDatePickerStyle.self)
        register(StepperFieldDatePickerStyle.self)
        #endif
        
        // GroupBoxStyle
        register(DefaultGroupBoxStyle.self)
        
        // LabelStyle
        register(DefaultLabelStyle.self)
        register(IconOnlyLabelStyle.self)
        register(TitleOnlyLabelStyle.self)
        
        // ListStyle
        register(DefaultListStyle.self)
        register(GroupedListStyle.self)
        register(InsetGroupedListStyle.self)
        register(InsetListStyle.self)
        register(PlainListStyle.self)
        register(SidebarListStyle.self)
        #if os(macOS)
        register(CarouselListStyle.self)
        register(EllipticalListStyle.self)
        #endif

        // MenuStyle
        register(BorderlessButtonMenuStyle.self)
        register(DefaultMenuStyle.self)
        #if os(macOS)
        register(BorderedButtonMenuStyle.self)
        #endif
        
        // NavigationViewStyle
        register(DefaultNavigationViewStyle.self)
        register(DoubleColumnNavigationViewStyle.self)
        register(StackNavigationViewStyle.self)
        
        // PickerStyle
        register(DefaultPickerStyle.self)
        register(InlinePickerStyle.self)
        register(MenuPickerStyle.self)
        register(SegmentedPickerStyle.self)
        register(WheelPickerStyle.self)
        #if os(macOS)
        register(PopUpButtonPickerStyle.self)
        register(RadioGroupPickerStyle.self)
        #endif
        
        // ProgressViewStyle
        register(CircularProgressViewStyle.self)
        register(DefaultProgressViewStyle.self)
        register(LinearProgressViewStyle.self)
        
        // TabViewStyle
        register(DefaultTabViewStyle.self)
        register(PageTabViewStyle.self)
        #if os(macOS)
        register(CarouselTabViewStyle.self)
        #endif
        
        // TextFieldStyle
        register(DefaultTextFieldStyle.self)
        register(PlainTextFieldStyle.self)
        register(RoundedBorderTextFieldStyle.self)
        #if os(macOS)
        register(SquareBorderTextFieldStyle.self)
        #endif
        
        // ToggleStyle
        register(DefaultToggleStyle.self)
        register(SwitchToggleStyle.self)
        #if os(macOS)
        register(CheckboxToggleStyle.self)
        #endif
    }
    static func registerDefault_views() {
        // shapes
        register(Circle.self)
        // views
        register(_ConditionalContent<AnyView, AnyView>.self)
        register(_PaddingLayout.self)
        register(AnyView.self)
        register(Button<AnyView>.self)
        register(Color.self)
        register(ContextMenu<AnyView>.self)
        register(DatePicker<AnyView>.self)
        register(Divider.self)
        register(EmptyView.self)
//        register(EquatableView<Any>.self)
//        register(ForEach<AnyRandomAccessCollection, AnyHashable, AnyView>.self)
        register(Form<AnyView>.self)
        register(GeometryReader<AnyView>.self)
        register(Group<AnyView>.self)
        register(GroupBox<AnyView, AnyView>.self)
        register(HStack<AnyView>.self)
        register(Image.self)
        register(List<AnyHashable, AnyView>.self)
        register(ModifiedContent<AnyView, _PaddingLayout>.self)
        register(NavigationLink<AnyView, AnyView>.self)
        register(NavigationView<AnyView>.self)
        register(Never.self)
        register(Picker<AnyView, AnyHashable, AnyView>.self)
        register(ScrollView<AnyView>.self)
        register(Section<AnyView, AnyView, AnyView>.self)
        register(SecureField<AnyView>.self)
        register(Slider<AnyView, AnyView>.self)
        register(Spacer.self)
//        register(SubscriptionView<AnyPublisherType, AnyView>.self)
        register(Text.self)
        register(TextField<AnyView>.self)
        register(Toggle<AnyView>.self)
        register(TupleView<(JsonAnyView)>.self)
        register(TupleView<(JsonAnyView, JsonAnyView)>.self)
        register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        register(TupleView<(JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView, JsonAnyView)>.self)
        register(VStack<AnyView>.self)
        register(ZStack<AnyView>.self)
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            register(LazyHStack<AnyView>.self)
            register(LazyVStack<AnyView>.self)
        }
    }
    
    @available(OSX 10.15, *)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    static func registerDefault_OSX() {
        register(HSplitView<AnyView>.self)
        register(MenuButton<AnyView, AnyView>.self)
        register(PasteButton.self)
        register(TouchBar<AnyView>.self)
        register(VSplitView<AnyView>.self)
    }
    
    @available(iOS 13.0, *)
    @available(OSX, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    static func registerDefault_iOS() {
        register(EditButton.self)
    }
    
    @available(tvOS 13.0, *)
    @available(OSX, unavailable)
    @available(iOS, unavailable)
    @available(watchOS, unavailable)
    static func registerDefault_tvOS() {
    }
    
    @available(watchOS 6.0, *)
    @available(OSX, unavailable)
    @available(iOS, unavailable)
    @available(tvOS, unavailable)
    static func registerDefault_watchOS() {
    }
    
    @available(iOS 13.0, OSX 10.15, tvOS 13.0, *)
    @available(watchOS, unavailable)
    static func registerDefault_OSX_iOS_tvOS() {
        register(TabView<AnyHashable, AnyView>.self)
    }
}
