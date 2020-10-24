//
//  Font.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

#if os(macOS)
typealias UXFont = NSFont
#else
typealias UXFont = UIFont
#endif

// MARK: - Preamble
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font {
    
    internal class AnyFontBox: Codable {
        let provider: String
        init(provider: String) {
            self.provider = provider
        }
        public func apply() -> Font {
            fatalError()
        }
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
    
    internal class AnyModifier: Codable {
        required init(any s: Any) { }
        public func apply(_ font: Font) -> Font {
            font
        }
        //: Codable
        public required init(from decoder: Decoder) throws { }
        public func encode(to encoder: Encoder) throws { }
    }
    
    internal class ModifierProvider<Modifier: AnyModifier>: Codable {
        let provider: String
        let base: Font
        let modifier: Modifier
        init(any s: Any, provider: String) {
            let mirror = Mirror(reflecting: s)
            base = mirror.descendant("base")! as! Font
            modifier = Modifier(any: mirror.descendant("modifier")!)
            self.provider = provider
        }
        public func apply() -> Font {
            modifier.apply(base)
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case base, modifier, provider
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            base = try container.decode(Font.self, forKey: .base)
            modifier = try container.decodeIfPresent(Modifier.self, forKey: .modifier) ?? Modifier(any: 0)
            provider = try container.decode(String.self, forKey: .provider)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base, forKey: .base)
            if !Mirror(reflecting: modifier).children.isEmpty {
                try container.encode(modifier, forKey: .modifier)
            }
            try container.encode(provider, forKey: .provider)
        }
    }
    
}


// MARK: - First
/// custom(:size), custom(:size:relativeTo), custom(:fixedSize)
/// init()
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font {
    
    internal class NamedProvider: AnyFontBox {
        let name: String
        let size: CGFloat
        let textStyle: TextStyle?
        init(any s: Any, provider: String) {
            let base = Mirror.children(reflecting: s)
            name = base["name"] as! String
            size = base["size"] as! CGFloat
            textStyle = base["textStyle"] as? TextStyle
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
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            size = try container.decode(CGFloat.self, forKey: .size)
            textStyle = try container.decodeIfPresent(TextStyle.self, forKey: .textStyle)
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(size, forKey: .size)
            try container.encodeIfPresent(textStyle, forKey: .textStyle)
            try super.encode(to: encoder)
        }
    }
    
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    internal class PlatformFontProvider: AnyFontBox {
        let font: UXFont //try: CTFont
        let fontSize: CGFloat
        init(any s: Any, provider: String) {
            let base = Mirror.children(reflecting: s)
            font = base["font"] as! UXFont //try: CTFont
            fontSize = font.pointSize
            super.init(provider: provider)
        }
        public override func apply() -> Font {
            Font(font)
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case font, size
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let fontName = try container.decode(String.self, forKey: .font)
            fontSize = try container.decode(CGFloat.self, forKey: .size)
            font = CTFontCreateWithName(fontName as CFString, fontSize, nil) //: UXFont(name: fontName, size: pointSize) ?? UXFont.systemFont(ofSize: pointSize)
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(font.familyName, forKey: .font)
            try container.encode(font.pointSize, forKey: .size)
            try super.encode(to: encoder)
        }
    }
    
}

// MARK: - Second
/// system(size:weight:design)
/// Design
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font {
    
    internal class SystemProvider: AnyFontBox {
        let size: CGFloat
        let weight: Weight
        let design: Design
        init(any s: Any, provider: String) {
            let base = Mirror.children(reflecting: s)
            size = base["size"] as! CGFloat
            weight = base["weight"] as! Weight
            design = base["design"] as! Design
            super.init(provider: provider)
        }
        public override func apply() -> Font {
            Font.system(size: size, weight: weight, design: design)
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case size, weight, design
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            size = try container.decode(CGFloat.self, forKey: .size)
            weight = try container.decodeIfPresent(Weight.self, forKey: .weight) ?? .regular
            design = try container.decodeIfPresent(Design.self, forKey: .design) ?? .default
            super.init(provider: "system")
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(size, forKey: .size)
            if weight != .regular { try container.encode(weight, forKey: .weight) }
            if design != .default { try container.encode(design, forKey: .design) }
            try super.encode(to: encoder)
        }
    }
    
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font.Design: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "default": self = .default
        case "rounded": self = .rounded
        default:
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
        default:
            let defaultFunc: () -> Void = { fatalError() }
            if #available(watchOS 7.0, *) {
                switch self {
                case .serif: try container.encode("serif")
                case .monospaced: try container.encode("monospaced")
                default: defaultFunc()
                }
            } else { defaultFunc() }
        }
    }
}

// MARK: - Third
/// largeTitle, title, title2, title3, headline, subheadline, body, callout, footnote, caption, caption2
/// system(:design)
/// TextStyle
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font: Codable {
    //: Codable
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
        default:
            let defaultFunc: () throws -> Font = {
                let provider = try container.decode(AnyFontBox.self).provider
                switch provider {
                case "system": return try container.decode(SystemProvider.self).apply()
                case "textStyle": return try container.decode(TextStyleProvider.self).apply()
                case "named": return try container.decode(NamedProvider.self).apply()
                case "platform": return try container.decode(PlatformFontProvider.self).apply()
                case "modifier<italic>": return try container.decode(ModifierProvider<ItalicModifier>.self).apply()
                case "modifier<lowercaseSmallCaps>": return try container.decode(ModifierProvider<LowercaseSmallCapsModifier>.self).apply()
                case "modifier<uppercaseSmallCaps>": return try container.decode(ModifierProvider<UppercaseSmallCapsModifier>.self).apply()
                case "modifier<monospacedDigit>": return try container.decode(ModifierProvider<MonospacedDigitModifier>.self).apply()
                case "modifier<weight>": return try container.decode(ModifierProvider<WeightModifier>.self).apply()
                case "modifier<bold>": return try container.decode(ModifierProvider<BoldModifier>.self).apply()
                case "modifier<leading>":
                    if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                        return try container.decode(ModifierProvider<LeadingModifier>.self).apply()
                    } else { fatalError() }
                default: fatalError(value)
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
        default:
            let defaultFunc = {
                let provider = Mirror(reflecting: self).descendant("provider", "base")!
                let providerName = "\(type(of: provider))"
                switch providerName {
                case "SystemProvider": try container.encode(SystemProvider(any: provider, provider: "system"))
                case "TextStyleProvider": try container.encode(TextStyleProvider(any: provider, provider: "textStyle"))
                case "NamedProvider": try container.encode(NamedProvider(any: provider, provider: "named"))
                case "PlatformFontProvider": try container.encode(PlatformFontProvider(any: provider, provider: "platform"))
                case "ModifierProvider<ItalicModifier>": try container.encode(ModifierProvider<ItalicModifier>(any: provider, provider: "modifier<italic>"))
                case "ModifierProvider<LowercaseSmallCapsModifier>": try container.encode(ModifierProvider<LowercaseSmallCapsModifier>(any: provider, provider: "modifier<lowercaseSmallCaps>"))
                case "ModifierProvider<UppercaseSmallCapsModifier>": try container.encode(ModifierProvider<UppercaseSmallCapsModifier>(any: provider, provider: "modifier<uppercaseSmallCaps>"))
                case "ModifierProvider<MonospacedDigitModifier>": try container.encode(ModifierProvider<MonospacedDigitModifier>(any: provider, provider: "modifier<monospacedDigit>"))
                case "ModifierProvider<WeightModifier>": try container.encode(ModifierProvider<WeightModifier>(any: provider, provider: "modifier<weight>"))
                case "ModifierProvider<BoldModifier>": try container.encode(ModifierProvider<BoldModifier>(any: provider, provider: "modifier<bold>"))
                case "ModifierProvider<LeadingModifier>":
                    if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                        try container.encode(ModifierProvider<LeadingModifier>(any: provider, provider: "modifier<leading>"))
                    } else { fatalError() }
                default: fatalError(providerName)
                }
            }
            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                switch self {
                case .title2: try container.encode("title2")
                case .title3: try container.encode("title3")
                case .caption2: try container.encode("caption2")
                default: try defaultFunc()
                }
            } else { try defaultFunc() }
        }
    }
    
    internal class TextStyleProvider: AnyFontBox {
        let style: TextStyle
        let design: Design
        let weight: Weight?
        init(any s: Any, provider: String) {
            let base = Mirror.children(reflecting: s)
            style = base["style"] as! TextStyle
            design = base["design"] as! Design
            weight = base["weight"] as? Weight
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
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            style = try container.decode(TextStyle.self, forKey: .style)
            design = try container.decode(Design.self, forKey: .design)
            weight = try container.decodeIfPresent(Weight.self, forKey: .weight)
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(style, forKey: .style)
            try container.encode(design, forKey: .design)
            try container.encodeIfPresent(weight, forKey: .weight)
            try super.encode(to: encoder)
        }
    }
    
}
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font.TextStyle: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "largeTitle": self = .largeTitle
        case "title": self = .title
        case "headline": self = .headline
        case "subheadline": self = .subheadline
        case "body": self = .body
        case "callout": self = .callout
        case "footnote": self = .footnote
        case "caption": self = .caption
        default:
            let defaultFunc = { fatalError(value) }
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
        default:
            let defaultFunc = { fatalError() }
            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                switch self {
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
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font {
    
    internal class ItalicModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font {
            font.italic()
        }
    }
    
    internal class LowercaseSmallCapsModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font {
            font.lowercaseSmallCaps()
        }
    }
    
    internal class UppercaseSmallCapsModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font {
            font.uppercaseSmallCaps()
        }
    }
    
    internal class MonospacedDigitModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font {
            font.monospacedDigit()
        }
    }
    
    internal class WeightModifier: AnyModifier {
        let weight: Weight
        required init(any s: Any) {
            weight = Mirror(reflecting: s).descendant("weight")! as! Weight
            super.init(any: s)
        }
        public override func apply(_ font: Font) -> Font {
            font.weight(weight)
        }
        //: Codable
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            weight = try container.decode(Weight.self)
            super.init(any: 0)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(weight)
        }
    }
    
    internal class BoldModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font {
            font.bold()
        }
    }
    
    @available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
    internal class LeadingModifier: AnyModifier {
        let leading: Leading
        required init(any s: Any) {
            leading = Mirror(reflecting: s).descendant("leading")! as! Leading
            super.init(any: s)
        }
        public override func apply(_ font: Font) -> Font {
            font.leading(leading)
        }
        //: Codable
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            leading = try container.decode(Leading.self)
            super.init(any: 0)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(leading)
        }
    }
    
}
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font.Weight: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "ultraLight": self = .ultraLight
        case "thin": self = .thin
        case "light": self = .light
        case "regular": self = .regular
        case "medium": self = .medium
        case "semibold": self = .semibold
        case "bold": self = .bold
        case "heavy": self = .heavy
        case "black": self = .black
        default: fatalError(value)
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
        default: fatalError()
        }
    }
}
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension Font.Leading: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "standard": self = .standard
        case "tight": self = .tight
        case "loose": self = .loose
        default: fatalError(value)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .standard: try container.encode("standard")
        case .tight: try container.encode("tight")
        case .loose: try container.encode("loose")
        default: fatalError()
        }
    }
}
