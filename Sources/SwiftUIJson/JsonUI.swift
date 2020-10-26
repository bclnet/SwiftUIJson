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
    
    public static func register<T>(_ type: T.Type) { DynaType.register(type) }
    
    public static func registerDefault() -> Bool {
        registerDefault_all()
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
    
    static func registerDefault_all() {
        register(Circle.self)
        //
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
