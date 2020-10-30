//
//  JsonUI.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public struct JsonUI: Codable {
    public var context = JsonContext()
    public let body: Any
    public var anyView: AnyView? { body as? AnyView }
    
    public init<Content>(view: Content, context: JsonContext) throws where Content : View {
        let _ = JsonUI.registered
        guard let value = view.body as? Encodable else { throw DynaTypeError.typeNotCodable("JsonUI", key: DynaType.typeKey(for: view)) }
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
    
    public static func registerDefault() -> Bool {
        // styles
        DatePickerStyleModifier<NeverCodable>.register()
        OtherStyleModifier<NeverCodable>.register()
        ModifierGesture<Any, Any>.register()
        _EnvironmentKeyWritingModifier<Any?>.register()
        IndexViewStyleModifier<PageIndexViewStyle>.register()
        _TraitWritingModifier<ItemProviderTraitKey>.register()
        // shapes
        Circle.register()
        // views
        _ConditionalContent<AnyView, AnyView>.register()
        _PaddingLayout.register()
        AnyView.register()
//        AnyViewModifier.register()
        DynaType.register(Button<AnyView>.self)
        Color.register()
        DynaType.register(ContextMenu<AnyView>.self)
        DynaType.register(DatePicker<AnyView>.self)
        Divider.register()
        EmptyView.register()
//        DynaType.register(EquatableView<Any>.self)
//        DynaType.register(ForEach<AnyRandomAccessCollection, AnyHashable, AnyView>.self)
        DynaType.register(Form<AnyView>.self)
        DynaType.register(GeometryReader<AnyView>.self)
        DynaType.register(Group<AnyView>.self)
        DynaType.register(GroupBox<AnyView, AnyView>.self)
        HStack<AnyView>.register()
        Image.register()
        DynaType.register(List<AnyHashable, AnyView>.self)
        ModifiedContent<AnyView, AnyViewModifier>.register()
        DynaType.register(NavigationLink<AnyView, AnyView>.self)
        DynaType.register(NavigationView<AnyView>.self)
        DynaType.register(Never.self)
        DynaType.register(Picker<AnyView, AnyHashable, AnyView>.self)
        DynaType.register(ScrollView<AnyView>.self)
        DynaType.register(Section<AnyView, AnyView, AnyView>.self)
        DynaType.register(SecureField<AnyView>.self)
        DynaType.register(Slider<AnyView, AnyView>.self)
        Spacer.register()
//        register(SubscriptionView<AnyPublisherType, AnyView>.self)
        Text.register()
        DynaType.register(TextField<AnyView>.self)
        DynaType.register(Toggle<AnyView>.self)
        TupleView<(JsonAnyView)>.register()
        VStack<AnyView>.register()
        ZStack<AnyView>.register()
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            LazyHStack<AnyView>.register()
            LazyVStack<AnyView>.register()
        }
        if #available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 999, *) {
            DynaType.register(TabView<AnyHashable, AnyView>.self)
        }
        #if os(macOS)
        DynaType.register(HSplitView<AnyView>.self)
        DynaType.register(MenuButton<AnyView, AnyView>.self)
        DynaType.register(PasteButton.self)
        DynaType.register(TouchBar<AnyView>.self)
        DynaType.register(VSplitView<AnyView>.self)
        #elseif os(iOS)
        DynaType.register(EditButton.self)
        #endif
        
        return true
    }
}
