//
//  Font.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

#if os(macOS)
public typealias UXFont = NSFont
#else
public typealias UXFont = UIFont
#endif

extension Font {
    class AnyFontBox: Codable {
        let provider: String
        init(provider: String) {
            self.provider = provider
        }
        public func apply() -> Font { fatalError("Not Implemented") }

        //: Codable
        enum CodingKeys: CodingKey {
            case provider
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(provider, forKey: .provider)
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            provider = try container.decode(String.self, forKey: .provider)
        }
    }
    
    class NamedProvider: AnyFontBox {
        let name: String
        let size: CGFloat
        let textStyle: TextStyle?
        init(any: Any, provider: String) {
            Mirror.assert(any, name: "NamedProvider", keys: ["name", "size", "textStyle"])
            let base = Mirror.children(reflecting: any)
            name = base["name"]! as! String
            size = base["size"]! as! CGFloat
            textStyle = base["textStyle"]! as? TextStyle
            super.init(provider: provider)
        }
        public override func apply() -> Font {
            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                return textStyle != nil
                    ? Font.custom(name, size: size, relativeTo: textStyle!)
                    : Font.custom(name, fixedSize: size)
            } else { return Font.custom(name, size: size) }
        }
        
        //: Codable
        enum CodingKeys: CodingKey {
            case name, size, textStyle
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(size, forKey: .size)
            try container.encodeIfPresent(textStyle, forKey: .textStyle)
            try super.encode(to: encoder)
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            size = try container.decode(CGFloat.self, forKey: .size)
            textStyle = try? container.decodeIfPresent(TextStyle.self, forKey: .textStyle)
            try super.init(from: decoder)
        }
    }
    
    class PlatformFontProvider: AnyFontBox {
        let font: UXFont
        init(any: Any, provider: String) {
            Mirror.assert(any, name: "PlatformFontProvider", keys: ["font"])
            let base = Mirror.children(reflecting: any)
            font = base["font"]! as! UXFont
            super.init(provider: provider)
        }
        public override func apply() -> Font { Font(font) }

        //: Codable
        enum CodingKeys: CodingKey {
            case font, size
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(font.familyName, forKey: .font)
            try container.encode(font.pointSize, forKey: .size)
            try super.encode(to: encoder)
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let familyName = try container.decode(String.self, forKey: .font)
            pointSize = try container.decode(CGFloat.self, forKey: .size)
            font = CTFontCreateWithName(familyName as CFString, pointSize, nil)
            //: UXFont(name: fontName, size: pointSize) ?? UXFont.systemFont(ofSize: pointSize)
            try super.init(from: decoder)
        }
    }
    
    class SystemProvider: AnyFontBox {
        let size: CGFloat
        let weight: Weight
        let design: Design
        init(any: Any, provider: String) {
            Mirror.assert(any, name: "SystemProvider", keys: ["size", "weight", "design"])
            let base = Mirror.children(reflecting: any)
            size = base["size"]! as! CGFloat
            weight = base["weight"]! as! Weight
            design = base["design"]! as! Design
            super.init(provider: provider)
        }
        public override func apply() -> Font { Font.system(size: size, weight: weight, design: design) }

        //: Codable
        enum CodingKeys: CodingKey {
            case size, weight, design
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(size, forKey: .size)
            if weight != .regular { try container.encode(weight, forKey: .weight) }
            if design != .default { try container.encode(design, forKey: .design) }
            try super.encode(to: encoder)
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            size = try container.decode(CGFloat.self, forKey: .size)
            weight = (try? container.decodeIfPresent(Weight.self, forKey: .weight)) ?? .regular
            design = (try? container.decodeIfPresent(Design.self, forKey: .design)) ?? .default
            super.init(provider: "system")
        }
    }
    
    class TextStyleProvider: AnyFontBox {
        let style: TextStyle
        let design: Design
        let weight: Weight?
        init(any: Any, provider: String) {
            Mirror.assert(any, name: "TextStyleProvider", keys: ["size", "design", "weight"])
            let m = Mirror.children(reflecting: any)
            style = m["style"]! as! TextStyle
            design = m["design"]! as! Design
            weight = m["weight"]! as? Weight
            super.init(provider: provider)
        }
        public override func apply() -> Font {
            weight == nil
                ? Font.system(style, design: design)
                : Font.system(style, design: design) //TODO: need to fix
        }

        //: Codable
        enum CodingKeys: CodingKey {
            case style, design, weight
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(style, forKey: .style)
            try container.encode(design, forKey: .design)
            try container.encodeIfPresent(weight, forKey: .weight)
            try super.encode(to: encoder)
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            style = try container.decode(TextStyle.self, forKey: .style)
            design = try container.decode(Design.self, forKey: .design)
            weight = try? container.decodeIfPresent(Weight.self, forKey: .weight)
            try super.init(from: decoder)
        }
    }

    class ModifierProvider<Modifier: AnyModifier>: Codable {
        let provider: String
        let base: Font
        let modifier: Modifier
        init(any: Any, provider: String) {
            Mirror.assert(any, name: "ModifierProvider", keys: ["base", "modifier"])
            let mirror = Mirror(reflecting: any)
            base = mirror.descendant("base")! as! Font
            modifier = Modifier(any: mirror.descendant("modifier")!)
            self.provider = provider
        }
        public func apply() -> Font { modifier.apply(base) }

        //: Codable
        enum CodingKeys: CodingKey {
            case base, modifier, provider
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base, forKey: .base)
            if !Mirror(reflecting: modifier).children.isEmpty { try container.encode(modifier, forKey: .modifier) }
            try container.encode(provider, forKey: .provider)
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            base = try container.decode(Font.self, forKey: .base)
            modifier = (try? container.decodeIfPresent(Modifier.self, forKey: .modifier)) ?? Modifier(any: 0)
            provider = try container.decode(String.self, forKey: .provider)
        }
    }

    class AnyModifier: Codable {
        required init(any s: Any) { }
        public func apply(_ font: Font) -> Font { fatalError("Not Implemented") }

        //: Codable
        public func encode(to encoder: Encoder) throws { }
        public required init(from decoder: Decoder) throws { }
    }
    
    class ItalicModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font { font.italic() }
    }
    
    class LowercaseSmallCapsModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font { font.lowercaseSmallCaps() }
    }
    
    class UppercaseSmallCapsModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font { font.uppercaseSmallCaps() }
    }
    
    class MonospacedDigitModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font { font.monospacedDigit() }
    }
    
    class WeightModifier: AnyModifier {
        let weight: Weight
        required init(any: Any) {
            Mirror.assert(any, name: "WeightModifier", keys: ["weight"])
            weight = Mirror(reflecting: any).descendant("weight")! as! Weight
            super.init(any: any)
        }
        public override func apply(_ font: Font) -> Font { font.weight(weight) }
        
        //: Codable
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(weight)
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            weight = try container.decode(Weight.self)
            super.init(any: 0)
        }
    }
    
    class BoldModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font { font.bold() }
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    class LeadingModifier: AnyModifier {
        let leading: Leading
        required init(any: Any) {
            Mirror.assert(any, name: "LeadingModifier", keys: ["leading"])
            leading = Mirror(reflecting: any).descendant("leading")! as! Leading
            super.init(any: any)
        }
        public override func apply(_ font: Font) -> Font { font.leading(leading) }

        //: Codable
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(leading)
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            leading = try container.decode(Leading.self)
            super.init(any: 0)
        }
    }
}

// MARK: - First
/// custom(:size), custom(:size:relativeTo), custom(:fixedSize)
/// init()

// MARK: - Second
/// system(size:weight:design)
/// Design

// MARK: - Third
/// largeTitle, title, title2, title3, headline, subheadline, body, callout, footnote, caption, caption2
/// system(:design)
/// TextStyle
extension Font: Codable {
    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .largeTitle: try container.encode("largeTitle")
        case .title: try container.encode("title")
        case .headline: try container.encode("headline")
        case .subheadline: try container.encode("subheadline")
        case .body: try container.encode("body")
        case .callout: try container.encode("callout")
        case .footnote: try container.encode("footnote")
        case .caption: try container.encode("caption")
        case let value:
            let defaultFunc = {
                let provider = Mirror(reflecting: self).descendant("provider", "base")!
                switch String(describing: type(of: provider)) {
                case "SystemProvider": try container.encode(SystemProvider(any: provider, provider: "system"))
                case "TextStyleProvider": try container.encode(TextStyleProvider(any: provider, provider: "textStyle"))
                case "NamedProvider": try container.encode(NamedProvider(any: provider, provider: "named"))
                case "PlatformFontProvider": try container.encode(PlatformFontProvider(any: provider, provider: "platform"))
                case "ModifierProvider<ItalicModifier>": try container.encode(ModifierProvider<ItalicModifier>(any: provider, provider: "italic"))
                case "ModifierProvider<LowercaseSmallCapsModifier>": try container.encode(ModifierProvider<LowercaseSmallCapsModifier>(any: provider, provider: "lowercaseSmallCaps"))
                case "ModifierProvider<UppercaseSmallCapsModifier>": try container.encode(ModifierProvider<UppercaseSmallCapsModifier>(any: provider, provider: "uppercaseSmallCaps"))
                case "ModifierProvider<MonospacedDigitModifier>": try container.encode(ModifierProvider<MonospacedDigitModifier>(any: provider, provider: "monospacedDigit"))
                case "ModifierProvider<WeightModifier>": try container.encode(ModifierProvider<WeightModifier>(any: provider, provider: "weight"))
                case "ModifierProvider<BoldModifier>": try container.encode(ModifierProvider<BoldModifier>(any: provider, provider: "bold"))
                case "ModifierProvider<LeadingModifier>":
                    if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                        try container.encode(ModifierProvider<LeadingModifier>(any: provider, provider: "leading"))
                    } else { fatalError() }
                case let value: fatalError(value)
                }
            }
            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                switch value {
                case .title2: try container.encode("title2")
                case .title3: try container.encode("title3")
                case .caption2: try container.encode("caption2")
                default: try defaultFunc()
                }
            } else { try defaultFunc() }
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value: String
        do { value = try container.decode(String.self) }
        catch { value = "" }
        switch value {
        case "largeTitle": self = .largeTitle
        case "title": self = .title
        case "headline": self = .headline
        case "subheadline": self = .subheadline
        case "body": self = .body
        case "callout": self = .callout
        case "footnote": self = .footnote
        case "caption": self = .caption
        case let value:
            let defaultFunc: () throws -> Font = {
                switch try container.decode(AnyFontBox.self).provider {
                case "system": return try container.decode(SystemProvider.self).apply()
                case "textStyle": return try container.decode(TextStyleProvider.self).apply()
                case "named": return try container.decode(NamedProvider.self).apply()
                case "platform": return try container.decode(PlatformFontProvider.self).apply()
                case "italic>": return try container.decode(ModifierProvider<ItalicModifier>.self).apply()
                case "lowercaseSmallCaps": return try container.decode(ModifierProvider<LowercaseSmallCapsModifier>.self).apply()
                case "uppercaseSmallCaps": return try container.decode(ModifierProvider<UppercaseSmallCapsModifier>.self).apply()
                case "monospacedDigit": return try container.decode(ModifierProvider<MonospacedDigitModifier>.self).apply()
                case "weight": return try container.decode(ModifierProvider<WeightModifier>.self).apply()
                case "bold": return try container.decode(ModifierProvider<BoldModifier>.self).apply()
                case "leading":
                    if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                        return try container.decode(ModifierProvider<LeadingModifier>.self).apply()
                    } else { fatalError() }
                case let value: fatalError(value)
                }
            }
            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                switch value {
                case "title2": self = .title2
                case "title3": self = .title3
                case "caption2": self = .caption2
                default: self = try defaultFunc()
                }
            } else { self = try defaultFunc() }
        }
    }
}

extension Font.Design: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "default": self = .default
        case "rounded": self = .rounded
        case let value:
            let defaultFunc = { fatalError(value) }
            if #available(watchOS 7.0, *) {
                switch value {
                case "serif": self = .serif
                case "monospaced": self = .monospaced
                default: defaultFunc()
                }
            } else { defaultFunc() }
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .default: try container.encode("default")
        case .rounded: try container.encode("rounded")
        case let value:
            let defaultFunc: () -> Void = { fatalError("\(value)") }
            if #available(watchOS 7.0, *) {
                switch value {
                case .serif: try container.encode("serif")
                case .monospaced: try container.encode("monospaced")
                default: defaultFunc()
                }
            } else { defaultFunc() }
        }
    }
}

extension Font.TextStyle: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "largeTitle": self = .largeTitle
        case "title": self = .title
        case "headline": self = .headline
        case "subheadline": self = .subheadline
        case "body": self = .body
        case "callout": self = .callout
        case "footnote": self = .footnote
        case "caption": self = .caption
        case let value:
            let defaultFunc = { fatalError() }
            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                switch value {
                case "title2": self = .title2
                case "title3": self = .title3
                case "caption2": self = .caption2
                default: defaultFunc()
                }
            } else { defaultFunc() }
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .largeTitle: try container.encode("largeTitle")
        case .title: try container.encode("title")
        case .headline: try container.encode("headline")
        case .subheadline: try container.encode("subheadline")
        case .body: try container.encode("body")
        case .callout: try container.encode("callout")
        case .footnote: try container.encode("footnote")
        case .caption: try container.encode("caption")
        case let value:
            let defaultFunc = { fatalError() }
            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                switch value {
                case .title2: try container.encode("title2")
                case .title3: try container.encode("title3")
                case .caption2: try container.encode("caption2")
                default: defaultFunc()
                }
            } else { defaultFunc() }
        }
    }
}

// MARK: - Fourth
/// italic(), smallCaps(), lowercaseSmallCaps(), uppercaseSmallCaps(), monospacedDigit(), weight(), bold(), leading()
/// Weight
/// Leading

extension Font.Weight: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "ultraLight": self = .ultraLight
        case "thin": self = .thin
        case "light": self = .light
        case "regular": self = .regular
        case "medium": self = .medium
        case "semibold": self = .semibold
        case "bold": self = .bold
        case "heavy": self = .heavy
        case "black": self = .black
        case let value: Font.Weight(value)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .ultraLight: try container.encode("ultraLight")
        case .thin: try container.encode("thin")
        case .light: try container.encode("light")
        case .regular: try container.encode("regular")
        case .medium: try container.encode("medium")
        case .semibold: try container.encode("semibold")
        case .bold: try container.encode("bold")
        case .heavy: try container.encode("heavy")
        case .black: try container.encode("black")
        case let value: try container.encode(self)
        }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Font.Leading: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "standard": self = .standard
        case "tight": self = .tight
        case "loose": self = .loose
        case let value: fatalError(value)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .standard: try container.encode("standard")
        case .tight: try container.encode("tight")
        case .loose: try container.encode("loose")
        case let value: fatalError("\(value)")
        }
    }
}
