//
//  Text.swift (Incomplete)
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text: JsonView, DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    @frozen internal enum Storage  {
        case verbatim(String)
        case anyTextStorage(AnyTextStorage)
        init(_ s: Mirror.Child) {
            switch s.label! {
            case "verbatim": self = .verbatim(s.value as! String)
            case "anyTextStorage": self = .anyTextStorage(AnyTextStorage(s.value))
            default: fatalError(s.label!)
            }
        }
    }
    @frozen internal enum Modifier: Codable {
        case color(Color?)
        case font(Font?)
        case italic
        case weight(Font.Weight?)
        case kerning(CoreGraphics.CGFloat)
        case tracking(CoreGraphics.CGFloat)
        case baseline(CoreGraphics.CGFloat)
        case rounded
        case anyTextModifier(AnyTextModifier)
        init(_ s: Mirror.Child) {
            let mirror = Mirror.single(reflecting: s.value)
            switch mirror.label! {
            case "color": self = .color(mirror.value as? Color)
            case "font": self = .font(mirror.value as? Font)
            case "italic": self = .italic
            case "weight": self = .weight(mirror.value as? Font.Weight)
            case "kerning": self = .kerning(mirror.value as! CoreGraphics.CGFloat)
            case "tracking": self = .tracking(mirror.value as! CoreGraphics.CGFloat)
            case "baseline": self = .baseline(mirror.value as! CoreGraphics.CGFloat)
            case "rounded": self = .rounded
            case "anyTextModifier": self = .anyTextModifier(AnyTextModifier(mirror.value))
            default: fatalError(mirror.label!)
            }
        }
        // MARK - Apply
        func apply(_ text: Text) -> Text {
            switch self {
            case .color(let value): return text.foregroundColor(value)
            case .font(let value): return text.font(value)
            case .italic: return text.italic()
            case .weight(let value): return text.fontWeight(value)
            case .kerning(let value): return text.kerning(value)
            case .tracking(let value): return text.tracking(value)
            case .baseline(let value): return text.baselineOffset(value)
//            case .rounded: return text
//            case .anyTextModifier(let value): return text
            default: fatalError("\(self)")
            }
        }
        // MARK - Codable
        enum CodingKeys: CodingKey {
            case color, font, italic, weight, kerning, tracking, baseline, rounded, anyTextModifier
        }
        public init(from decoder: Decoder) throws {
            let context = decoder.userInfo[.jsonContext] as! JsonContext
            let container = try decoder.container(keyedBy: CodingKeys.self)
            if container.contains(.color) { self = .color(try container.decodeOptional(Color.self, forKey: .color, forContext: context)) }
            else if container.contains(.font) { self = .font(try container.decodeOptional(Font.self, forKey: .font, forContext: context)) }
            else if container.contains(.italic) { self = .italic }
            else if container.contains(.weight) { self = .weight(try container.decodeOptional(Font.Weight.self, forKey: .weight, forContext: context)) }
            else if container.contains(.kerning) { self = .kerning(try container.decode(CoreGraphics.CGFloat.self, forKey: .kerning, forContext: context)) }
            else if container.contains(.tracking) { self = .tracking(try container.decode(CoreGraphics.CGFloat.self, forKey: .tracking, forContext: context)) }
            else if container.contains(.baseline) { self = .baseline(try container.decode(CoreGraphics.CGFloat.self, forKey: .baseline, forContext: context)) }
            else if container.contains(.rounded) { self = .rounded }
            else if container.contains(.anyTextModifier) { self = .anyTextModifier(try container.decode(AnyTextModifier.self, forKey: .anyTextModifier)) }
            else { throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid Text!")) }
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
            case .rounded: try container.encodeKey(forKey: .rounded)
            case .anyTextModifier(let value): try container.encode(value, forKey: .anyTextModifier)
            }
        }
    }
    internal class AnyTextStorage: Codable {
        let key: LocalizedStringKey
        let table: String?
        let bundle: Bundle?
        init(_ s: Any) {
            let mirror = Mirror.children(reflecting: s)
            self.key = mirror["key"] as! LocalizedStringKey
            self.table = mirror["table"] as? String
            self.bundle = mirror["bundle"] as? Bundle
        }
        // MARK - Codable
        enum CodingKeys: CodingKey {
            case text, table, bundle
        }
        public required init(from decoder: Decoder) throws {
            let context = decoder.userInfo[.jsonContext] as! JsonContext
            let container = try decoder.container(keyedBy: CodingKeys.self)
            key = LocalizedStringKey(try container.decode(String.self, forKey: .text, forContext: context))
            table = try container.decodeIfPresent(String.self, forKey: .table, forContext: context)
            bundle = container.contains(.bundle) ? Bundle() : nil
            //bundle = container.contains(.bundle) ? Bundle.encode() : nil
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(key.encodeValue, forKey: .text)
            try container.encodeIfPresent(table, forKey: .table)
            try container.encodeIfPresent(bundle, forKey: .bundle)
            //throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Invalid employee!"))
        }
    }
    internal class AnyTextModifier: Codable {
        init(_ s: Any) {
            fatalError("AnyTextModifier")
            //let mirror = [String: Any](reflecting: s)
        }
        // MARK - Codable
        enum CodingKeys: CodingKey {
            case text
        }
        public required init(from decoder: Decoder) throws {
        }
        public func encode(to encoder: Encoder) throws {
        }
    }
    
    // MARK - Codable
    enum CodingKeys: CodingKey {
        case verbatim, text, anyText, modifiers
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let context = decoder.userInfo[.jsonContext] as! JsonContext
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // storage
        if container.contains(.verbatim) { self = Text(verbatim: try container.decode(String.self, forKey: .verbatim, forContext: context)) }
        else if container.contains(.text) { self = Text(try container.decode(String.self, forKey: .text, forContext: context)) }
        else if container.contains(.anyText) {
            let anyText = try container.decode(AnyTextStorage.self, forKey: .anyText)
            self = Text(anyText.key, tableName: anyText.table, bundle: anyText.bundle, comment: nil)
        }
        else { throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Invalid Text!")) }
        // modifiers
        guard let modifiers = try container.decodeIfPresent([Modifier].self, forKey: .modifiers) else { return }
        for modifier in modifiers {
            self = modifier.apply(self)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let mirror = Mirror.children(reflecting: self)
        // storage
        let storage = Storage(mirror.child(named: "storage"))
        switch storage {
        case .verbatim(let text): try container.encode(text, forKey: .verbatim)
        case .anyTextStorage(let anyText):
            if anyText.table == nil && anyText.bundle == nil { try container.encode(anyText.key.encodeValue, forKey: .text) }
            else { try container.encode(anyText, forKey: .anyText) }
        }
        // modifiers
        let modifiers = mirror.children(named: "modifiers").map { Modifier($0) }
        if !modifiers.isEmpty {
            try container.encode(modifiers, forKey: .modifiers)
        }
    }
}
