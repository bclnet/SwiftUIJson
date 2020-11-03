//
//  Text.swift (Incomplete)(Mirror)
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

// MARK: - Preamble
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text {

    @frozen internal enum Storage  {
        case verbatim(String)
        case anyTextStorage(AnyTextStorage)
        init(any s: Mirror.Child) {
            switch s.label! {
            case "verbatim": self = .verbatim(s.value as! String)
            case "anyTextStorage": self = .anyTextStorage(AnyTextStorage(any: s.value))
            case let unrecognized: fatalError(unrecognized)
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
        init(any s: Mirror.Child) {
            let m = Mirror.single(reflecting: s.value)
            switch m.label! {
            case "color": self = .color(m.value as? Color)
            case "font": self = .font(m.value as? Font)
            case "italic": self = .italic
            case "weight": self = .weight(m.value as? Font.Weight)
            case "kerning": self = .kerning(m.value as! CoreGraphics.CGFloat)
            case "tracking": self = .tracking(m.value as! CoreGraphics.CGFloat)
            case "baseline": self = .baseline(m.value as! CoreGraphics.CGFloat)
            case "rounded": self = .rounded
            case "anyTextModifier": self = .anyTextModifier(AnyTextModifier(any: m.value))
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
//            case .rounded: return text
//            case .anyTextModifier(let value): return text
            case let unrecognized: fatalError("\(unrecognized)")
            }
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case color, font, italic, weight, kerning, tracking, baseline, rounded, anyTextModifier
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
            else if container.contains(.rounded) { self = .rounded }
            else if container.contains(.anyTextModifier) { self = .anyTextModifier(try container.decode(AnyTextModifier.self, forKey: .anyTextModifier)) }
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
            case .rounded: try container.encodeKey(forKey: .rounded)
            case .anyTextModifier(let value): try container.encode(value, forKey: .anyTextModifier)
            }
        }
    }
    
    internal class AnyTextStorage: Codable {
        let key: LocalizedStringKey
        let table: String?
        let bundle: Bundle?
        init(any s: Any) {
            let m = Mirror.children(reflecting: s)
            self.key = m["key"]! as! LocalizedStringKey
            self.table = m["table"]! as? String
            self.bundle = m["bundle"]! as? Bundle
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case text, table, bundle
        }
        public required init(from decoder: Decoder) throws {
            let context = decoder.userInfo[.jsonContext] as! JsonContext
            let container = try decoder.container(keyedBy: CodingKeys.self)
            key = LocalizedStringKey(try container.decode(String.self, forKey: .text, forContext: context))
            table = try container.decodeIfPresent(String.self, forKey: .table, forContext: context)
            bundle = try container.decodeIfPresent(CodableWrap<Bundle>.self, forKey: .bundle)?.wrapValue
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(key.encodeValue, forKey: .text)
            try container.encodeIfPresent(table, forKey: .table)
            try container.encodeIfPresent(CodableWrap(bundle), forKey: .bundle)
        }
    }
    
    internal class AnyTextModifier: Codable {
        init(any s: Any) {
            fatalError("AnyTextModifier")
            //let mirror = [String: Any](reflecting: s)
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case text
        }
        public required init(from decoder: Decoder) throws {}
        public func encode(to encoder: Encoder) throws {}
    }
    
}

// MARK: - First
/// init(verbatim), init(S)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text: JsonView, DynaFullCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case verbatim, text, anyText, modifiers
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws { try self.init(from: decoder) }
    public init(from decoder: Decoder) throws {
        let context = decoder.userInfo[.jsonContext] as! JsonContext
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // storage
        if container.contains(.verbatim) { self = Text(verbatim: try container.decode(String.self, forKey: .verbatim, forContext: context)) }
        else if container.contains(.text) { self = Text(try container.decode(String.self, forKey: .text, forContext: context)) }
        else if container.contains(.anyText) {
            let anyText = try container.decode(AnyTextStorage.self, forKey: .anyText)
            self = Text(anyText.key, tableName: anyText.table, bundle: anyText.bundle, comment: nil)
        }
        else { fatalError() }
        // modifiers
        guard let modifiers = try container.decodeIfPresent([Modifier].self, forKey: .modifiers) else { return }
        for modifier in modifiers {
            self = modifier.apply(self)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let m = Mirror.children(reflecting: self)
        // storage
        let storage = Storage(any: m.child(named: "storage"))
        switch storage {
        case .verbatim(let text): try container.encode(text, forKey: .verbatim)
        case .anyTextStorage(let anyText):
            if anyText.table == nil && anyText.bundle == nil { try container.encode(anyText.key.encodeValue, forKey: .text) }
            else { try container.encode(anyText, forKey: .anyText) }
        }
        // modifiers
        let modifiers = m.children(named: "modifiers").map { Modifier(any: $0) }
        if !modifiers.isEmpty {
            try container.encode(modifiers, forKey: .modifiers)
        }
    }
    //: Register
    static func register() {
        DynaType.register(Text.self)
    }
}

// MARK: - Second
/// init(Image)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text {
}

// MARK: - Third
/// init<Subject>(:formatter), init<Subject>(:formatter)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text {
}


// MARK: - Fourth
/// DateStyle
/// init(:style), init(ClosedRange<Date>), init(DateInterval)
//@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
//extension Text.DateStyle: Codable { // BUILT-IN
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        switch try container.decode(String.self) {
//        case "time": self = .time
//        case "date": self = .date
//        case "relative": self = .relative
//        case "offset": self = .offset
//        case "timer": self = .timer
//        default: fatalError(try container.decode(String.self))
//        }
//    }
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .time: try container.encode("time")
//        case .date: try container.encode("date")
//        case .relative: try container.encode("relative")
//        case .offset: try container.encode("offset")
//        case .timer: try container.encode("timer")
//        case let unrecognized: fatalError(unrecognized)
//        }
//    }
//}
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Text {
}


// MARK: - Fifth
/// init(:tableName:bundle:comment)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text {
}

// MARK: - Sixth
/// {none}

// MARK: - Seventh
/// TruncationMode
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
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


// MARK: - Eight
/// foregroundColor, font, fontWeight, bold, italic, strikethrough, underline, kerning, tracking, baselineOffset
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Text {
}

// MARK: - Ninth
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
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
