//
//  Text.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Text {
    
    class AnyTextStorage: Codable {
        let provider: String
        init(provider: String) {
            self.provider = provider
        }
        public func apply() -> Text { fatalError("Not Implemented") }
        //: Codable
        enum CodingKeys: CodingKey {
            case provider
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            provider = try container.decode(String.self, forKey: .provider)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(provider, forKey: .provider)
        }
    }
    
    class AttachmentTextStorage: AnyTextStorage {
        let image: Image
        init(any: Any, provider: String) {
            Mirror.assert(any, name: "AttachmentTextStorage", keys: ["image"])
            let m = Mirror.children(reflecting: any)
            image = m["image"]! as! Image
            super.init(provider: provider)
        }
        public override func apply() -> Text { Text(image) }
        //: Codable
        enum CodingKeys: CodingKey {
            case image
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            image = try container.decode(Image.self, forKey: .image)
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(image, forKey: .image)
            try super.encode(to: encoder)
        }
    }
    
    class LocalizedTextStorage: AnyTextStorage {
        let key: LocalizedStringKey
        let table: String?
        let bundle: Bundle?
        init(any: Any, provider: String) {
            Mirror.assert(any, name: "LocalizedTextStorage", keys: ["key", "table", "bundle"])
            let m = Mirror.children(reflecting: any)
            key = m["key"]! as! LocalizedStringKey
            table = m["table"]! as? String
            bundle = m["bundle"]! as? Bundle
            super.init(provider: provider)
        }
        public override func apply() -> Text { Text(key, tableName: table, bundle: bundle, comment: nil) }
        //: Codable
        enum CodingKeys: CodingKey {
            case text, table, bundle
        }
        public required init(from decoder: Decoder) throws {
            let context = decoder.userInfo[.jsonContext] as! JsonContext
            let container = try decoder.container(keyedBy: CodingKeys.self)
            key = LocalizedStringKey(try container.decode(String.self, forKey: .text, forContext: context))
            table = try? container.decodeIfPresent(String.self, forKey: .table, forContext: context)
            bundle = (try? container.decodeIfPresent(CodableWrap<Bundle>.self, forKey: .bundle))?.wrapValue
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(key.encodeValue, forKey: .text)
            try container.encodeIfPresent(table, forKey: .table)
            try container.encodeIfPresent(CodableWrap(bundle), forKey: .bundle)
            try super.encode(to: encoder)
        }
    }
    
    class FormatterTextStorage: AnyTextStorage {
        let object: NSObject
        let formatter: Formatter
        init(any: Any, provider: String) {
            Mirror.assert(any, name: "FormatterTextStorage", keys: ["object", "formatter"])
            let m = Mirror.children(reflecting: any)
            object = m["object"]! as! NSObject
            formatter = m["formatter"]! as! Formatter
            super.init(provider: provider)
        }
        public override func apply() -> Text { Text(object, formatter: formatter) }
        //: Codable
        enum CodingKeys: CodingKey {
            case object, formatter
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            object = try container.decode(NSObjectWrap<NSObject>.self, forKey: .object).wrapValue
            formatter = try container.decode(NSObjectWrap<Formatter>.self, forKey: .formatter).wrapValue
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(NSObjectWrap(object), forKey: .object)
            try container.encode(NSObjectWrap(formatter), forKey: .formatter)
            try super.encode(to: encoder)
        }
    }

    class DateTextStorage: AnyTextStorage {
        let storage: Storage
        init(any: Any, provider: String) {
            Mirror.assert(any, name: "DateTextStorage", keys: ["storage"])
            let m = Mirror.children(reflecting: any)
            storage = Storage(any: m["storage"]!)
            super.init(provider: provider)
        }
//        public override func apply() -> Text { Text(object, formatter: formatter) }
        //: Codable
        enum CodingKeys: CodingKey {
            case object, formatter
        }
        public required init(from decoder: Decoder) throws {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            object = try container.decode(NSObjectWrap<NSObject>.self, forKey: .object).wrapValue
//            formatter = try container.decode(NSObjectWrap<Formatter>.self, forKey: .formatter).wrapValue
//            try super.init(from: decoder)
            fatalError()
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
//            try container.encode(NSObjectWrap(object), forKey: .object)
//            try container.encode(NSObjectWrap(formatter), forKey: .formatter)
//            try super.encode(to: encoder)
        }
        
        struct Storage {
            let active: Bool
            let color: Color?
            init(active: Bool, color: Color?) {
                self.active = active
                self.color = color
            }
            init(any: Any) {
                Mirror.assert(any, name: "Storage", keys: ["active", "color"])
                let m = Mirror.children(reflecting: any)
                active = m["active"]! as! Bool
                color = m["color"]! as? Color
            }
        }
    }
}

extension Text {
    
    class AnyTextModifier: Codable {
        let provider: String
        init(provider: String) {
            self.provider = provider
        }
        public func apply(_ text: Text) -> Text { fatalError("Not Implemented") }
        //: Codable
        enum CodingKeys: CodingKey {
            case provider
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            provider = try container.decode(String.self, forKey: .provider)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(provider, forKey: .provider)
        }
    }
        
    class BoldTextModifier: AnyTextModifier {
        init(any: Any, provider: String) {
            Mirror.assert(any, name: "BoldTextModifier", keys: [])
            super.init(provider: provider)
        }
        public override func apply(_ text: Text) -> Text { text.bold() }
        //: Codable
        public required init(from decoder: Decoder) throws { try super.init(from: decoder) }
    }
    
    class StrikethroughTextModifier: AnyTextModifier {
        let lineStyle: LineStyle?
        init(any: Any, provider: String) {
            Mirror.assert(any, name: "StrikethroughTextModifier", keys: ["lineStyle"])
            lineStyle = LineStyle(any: Mirror.optional(any: Mirror(reflecting: any).descendant("lineStyle")!))
            super.init(provider: provider)
        }
        public override func apply(_ text: Text) -> Text { text.strikethrough(lineStyle?.active ?? true, color: lineStyle?.color) }
        //: Codable
        enum CodingKeys: CodingKey {
            case active, color
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let active = (try? container.decodeIfPresent(Bool.self, forKey: .active)) ?? true
            let color = try? container.decodeIfPresent(Color.self, forKey: .color)
            lineStyle = LineStyle(active: active, color: color)
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            guard let lineStyle = lineStyle else {
                try super.encode(to: encoder)
                return
            }
            var container = encoder.container(keyedBy: CodingKeys.self)
            if !lineStyle.active { try container.encode(lineStyle.active, forKey: .active) }
            try container.encodeIfPresent(lineStyle.color, forKey: .color)
            try super.encode(to: encoder)
        }
    }
    
    class UnderlineTextModifier: AnyTextModifier {
        let lineStyle: LineStyle?
        init(any: Any, provider: String) {
            Mirror.assert(any, name: "UnderlineTextModifier", keys: ["lineStyle"])
            lineStyle = LineStyle(any: Mirror.optional(any: Mirror(reflecting: any).descendant("lineStyle")!))
            super.init(provider: provider)
        }
        public override func apply(_ text: Text) -> Text { text.underline(lineStyle?.active ?? true, color: lineStyle?.color) }
        //: Codable
        enum CodingKeys: CodingKey {
            case active, color
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let active = (try? container.decodeIfPresent(Bool.self, forKey: .active)) ?? true
            let color = try? container.decodeIfPresent(Color.self, forKey: .color)
            lineStyle = LineStyle(active: active, color: color)
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            guard let lineStyle = lineStyle else {
                try super.encode(to: encoder)
                return
            }
            var container = encoder.container(keyedBy: CodingKeys.self)
            if !lineStyle.active { try container.encode(lineStyle.active, forKey: .active) }
            try container.encodeIfPresent(lineStyle.color, forKey: .color)
            try super.encode(to: encoder)
        }
    }
    
    struct LineStyle {
        let active: Bool
        let color: Color?
        init(active: Bool, color: Color?) {
            self.active = active
            self.color = color
        }
        init?(any: Any?) {
            guard let any = any else { return nil }
            Mirror.assert(any, name: "LineStyle", keys: ["active", "color"])
            let m = Mirror.children(reflecting: any)
            active = m["active"]! as! Bool
            color = m["color"]! as? Color
        }
    }
}

extension Text {

    enum Storage  {
        case text(String)
        case verbatim(String)
        case anyTextStorage(Any)
        init(any: Any) {
            Mirror.assert(any, name: "Storage", keys: ["verbatim", "anyTextStorage"], keyMatch: .single)
            let m = Mirror(reflecting: any).children.first!
            if "\(type(of: m.value))" == "LocalizedTextStorage" {
                let localized = LocalizedTextStorage(any: m.value, provider: "localized")
                if localized.table == nil && localized.bundle == nil {
                    self = .text(localized.key.encodeValue)
                    return
                }
            }
            switch m.label! {
            case "verbatim": self = .verbatim(m.value as! String)
            case "anyTextStorage": self = .anyTextStorage(m.value)
            case let unrecognized: fatalError(unrecognized)
            }
        }
    }
    
    enum Modifier: Codable {
        case color(Color?)
        case font(Font?)
        case italic
        case weight(Font.Weight?)
        case kerning(CoreGraphics.CGFloat)
        case tracking(CoreGraphics.CGFloat)
        case baseline(CoreGraphics.CGFloat)
        case anyTextModifier(Any)
        init(any: Any) {
            Mirror.assert(any, name: "Modifier", keys: ["color", "font", "weight", "kerning", "tracking", "baseline", "anyTextModifier"], keyMatch: .single)
            let m = Mirror(reflecting: any).children.first!
            switch m.label! {
            case "color": self = .color(m.value as? Color)
            case "font": self = .font(m.value as? Font)
            case "weight": self = .weight(m.value as? Font.Weight)
            case "kerning": self = .kerning(m.value as! CoreGraphics.CGFloat)
            case "tracking": self = .tracking(m.value as! CoreGraphics.CGFloat)
            case "baseline": self = .baseline(m.value as! CoreGraphics.CGFloat)
            case "anyTextModifier": self = .anyTextModifier(m.value)
            case let unrecognized: fatalError(unrecognized)
            }
        }
        func apply(_ text: Text) -> Text {
            switch self {
            case .color(let value): return text.foregroundColor(value)
            case .font(let value): return text.font(value)
            case .italic: return text.italic()
            case .weight(let value): return text.fontWeight(value)
            case .kerning(let value): return text.kerning(value)
            case .tracking(let value): return text.tracking(value)
            case .baseline(let value): return text.baselineOffset(value)
            case .anyTextModifier(let value): return (value as! AnyTextModifier).apply(text)
            }
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case color, font, italic, weight, kerning, tracking, baseline, rounded, any
        }
        public init(from decoder: Decoder) throws {
            let context = decoder.userInfo[.jsonContext] as! JsonContext, container = try decoder.container(keyedBy: CodingKeys.self)
            if container.contains(.color) { self = .color(try container.decodeOptional(Color.self, forKey: .color, forContext: context)) }
            else if container.contains(.font) { self = .font(try container.decodeOptional(Font.self, forKey: .font, forContext: context)) }
            else if container.contains(.italic) { self = .italic }
            else if container.contains(.weight) { self = .weight(try container.decodeOptional(Font.Weight.self, forKey: .weight, forContext: context)) }
            else if container.contains(.kerning) { self = .kerning(try container.decode(CoreGraphics.CGFloat.self, forKey: .kerning, forContext: context)) }
            else if container.contains(.tracking) { self = .tracking(try container.decode(CoreGraphics.CGFloat.self, forKey: .tracking, forContext: context)) }
            else if container.contains(.baseline) { self = .baseline(try container.decode(CoreGraphics.CGFloat.self, forKey: .baseline, forContext: context)) }
            else if container.contains(.any) {
                switch try container.decode(AnyTextModifier.self, forKey: .any).provider {
                case "bold": self = .anyTextModifier(try container.decode(BoldTextModifier.self, forKey: .any))
                case "strikethrough": self = .anyTextModifier(try container.decode(StrikethroughTextModifier.self, forKey: .any))
                case "underline": self = .anyTextModifier(try container.decode(UnderlineTextModifier.self, forKey: .any))
                case let unrecognized: fatalError(unrecognized)
                }
            }
            else { fatalError() }
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            switch self {
            case .color(let value): try container.encodeOptional(value, forKey: .color)
            case .font(let value): try container.encodeOptional(value, forKey: .font)
            case .italic: try container.encodeKey(forKey: .italic)
            case .weight(let value): try container.encodeOptional(value, forKey: .weight)
            case .kerning(let value): try container.encode(value, forKey: .kerning)
            case .tracking(let value): try container.encode(value, forKey: .tracking)
            case .baseline(let value): try container.encode(value, forKey: .baseline)
            case .anyTextModifier(let value):
                switch "\(type(of: value))" {
                case "BoldTextModifier": try container.encode(BoldTextModifier(any: value, provider: "bold"), forKey: .any)
                case "StrikethroughTextModifier": try container.encode(StrikethroughTextModifier(any: value, provider: "strikethrough"), forKey: .any)
                case "UnderlineTextModifier": try container.encode(UnderlineTextModifier(any: value, provider: "underline"), forKey: .any)
                case let unrecognized: fatalError(unrecognized)
                }
            }
        }
    }
    
}

extension Text: IAnyView, FullyCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case text, verbatim, any, modifiers
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws { try self.init(from: decoder) }
    public init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.jsonContext] as! JsonContext
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // storage
        if container.contains(.text) { self = Text(try container.decode(String.self, forKey: .text, forContext: context)) }
        else if container.contains(.verbatim) { self = Text(verbatim: try container.decode(String.self, forKey: .verbatim, forContext: context)) }
        else if container.contains(.any) {
            switch try container.decode(AnyTextStorage.self, forKey: .any).provider {
            case "attachment": self = try container.decode(AttachmentTextStorage.self, forKey: .any).apply()
            case "localized": self = try container.decode(LocalizedTextStorage.self, forKey: .any).apply()
            case "formatter": self = try container.decode(FormatterTextStorage.self, forKey: .any).apply()
            case "date": self = try container.decode(DateTextStorage.self, forKey: .any).apply()
            case let unrecognized: fatalError(unrecognized)
            }
        }
        else { fatalError() }
        // modifiers
        guard let modifiers = try? container.decodeIfPresent([Modifier].self, forKey: .modifiers) else { return }
        for modifier in modifiers {
            self = modifier.apply(self)
        }
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Text", keys: ["storage", "modifiers"])
        let m = Mirror(reflecting: self)
        let storage = Storage(any: m.descendant("storage")!)
        let modifiers = Mirror(reflecting: m.descendant("modifiers")!).children.map { s -> Modifier in
            switch String(reflecting: s.value) {
            case "SwiftUI.Text.Modifier.italic": return .italic
            default: return Modifier(any: s.value)
            }
        }
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch storage {
        case .text(let value): try container.encode(value, forKey: .text)
        case .verbatim(let value): try container.encode(value, forKey: .verbatim)
        case .anyTextStorage(let value):
            switch "\(type(of: value))" {
            case "AttachmentTextStorage": try container.encode(AttachmentTextStorage(any: value, provider: "attachment"), forKey: .any)
            case "LocalizedTextStorage": try container.encode(LocalizedTextStorage(any: value, provider: "localized"), forKey: .any)
            case "FormatterTextStorage": try container.encode(FormatterTextStorage(any: value, provider: "formatter"), forKey: .any)
            case "DateTextStorage": try container.encode(DateTextStorage(any: value, provider: "date"), forKey: .any)
            case let unrecognized: fatalError(unrecognized)
            }
        }
        if !modifiers.isEmpty { try container.encode(modifiers, forKey: .modifiers) }
    }
    //: Register
    static func register() {
        DynaType.register(Text.self)
    }
}

extension Text.TruncationMode: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "head": self = .head
        case "tail": self = .tail
        case "middle": self = .middle
        case let unrecognized: fatalError(unrecognized)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .head: try container.encode("head")
        case .tail: try container.encode("tail")
        case .middle: try container.encode("middle")
        case let unrecognized: fatalError("\(unrecognized)")
        }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text.Case: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "uppercase": self = .uppercase
        case "lowercase": self = .lowercase
        case let unrecognized: fatalError(unrecognized)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .uppercase: try container.encode("uppercase")
        case .lowercase: try container.encode("lowercase")
        case let unrecognized: fatalError("\(unrecognized)")
        }
    }
}

extension TextAlignment: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "leading": self = .leading
        case "center": self = .center
        case "trailing": self = .trailing
        case let unrecognized: fatalError(unrecognized)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .leading: try container.encode("leading")
        case .center: try container.encode("center")
        case .trailing: try container.encode("trailing")
        }
    }
}
