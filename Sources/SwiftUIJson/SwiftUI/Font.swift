//
//  Font.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Font: Codable {
    // MARK - Codable
    enum CodingKeys: CodingKey {
        case type
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value: String
        do { value = try container.decode(String.self) }
        catch { value = "" }
        switch value {
        case "largeTitle": self = .largeTitle
        case "title": self = .title
        case "title2": self = .title2
        case "title3": self = .title3
        case "headline": self = .headline
        case "subheadline": self = .subheadline
        case "body": self = .body
        case "callout": self = .callout
        case "footnote": self = .footnote
        case "caption": self = .caption
        case "caption2": self = .caption2
        default:
            let provider = try container.decode(AnyFontBox.self).provider
            switch provider {
            case "system": self = try container.decode(SystemProvider.self).apply()
            case "textStyle": self = try container.decode(TextStyleProvider.self).apply()
            case "named": self = try container.decode(NamedProvider.self).apply()
            case "platformFont": self = try container.decode(PlatformFontProvider.self).apply()
            case "modifier<italic>": self = try container.decode(ModifierProvider<ItalicModifier>.self).apply()
            case "modifier<lowercaseSmallCaps>": self = try container.decode(ModifierProvider<LowercaseSmallCapsModifier>.self).apply()
            case "modifier<uppercaseSmallCaps>": self = try container.decode(ModifierProvider<UppercaseSmallCapsModifier>.self).apply()
            case "modifier<monospacedDigit>": self = try container.decode(ModifierProvider<MonospacedDigitModifier>.self).apply()
            case "modifier<weight>": self = try container.decode(ModifierProvider<WeightModifier>.self).apply()
            case "modifier<bold>": self = try container.decode(ModifierProvider<BoldModifier>.self).apply()
            case "modifier<leading>": self = try container.decode(ModifierProvider<LeadingModifier>.self).apply()
            default: fatalError()
            }
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .largeTitle: try container.encode("largeTitle")
        case .title: try container.encode("title")
        case .title2: try container.encode("title2")
        case .title3: try container.encode("title3")
        case .headline: try container.encode("headline")
        case .subheadline: try container.encode("subheadline")
        case .body: try container.encode("body")
        case .callout: try container.encode("callout")
        case .footnote: try container.encode("footnote")
        case .caption: try container.encode("caption")
        case .caption2: try container.encode("caption2")
        default:
            let provider = Mirror(reflecting: self).descendant("provider", "base")!
            let providerName = "\(type(of: provider))" //; print("\(providerName)| \(provider)")
            switch providerName {
            case "SystemProvider": try container.encode(SystemProvider(provider, provider: "system"))
            case "TextStyleProvider": try container.encode(TextStyleProvider(provider, provider: "textStyle"))
            case "NamedProvider": try container.encode(NamedProvider(provider, provider: "named"))
            case "PlatformFontProvider": try container.encode(PlatformFontProvider(provider, provider: "platformFont"))
            case "ModifierProvider<ItalicModifier>": try container.encode(ModifierProvider<ItalicModifier>(provider, provider: "modifier<italic>"))
            case "ModifierProvider<LowercaseSmallCapsModifier>": try container.encode(ModifierProvider<LowercaseSmallCapsModifier>(provider, provider: "modifier<lowercaseSmallCaps>"))
            case "ModifierProvider<UppercaseSmallCapsModifier>": try container.encode(ModifierProvider<UppercaseSmallCapsModifier>(provider, provider: "modifier<uppercaseSmallCaps>"))
            case "ModifierProvider<MonospacedDigitModifier>": try container.encode(ModifierProvider<MonospacedDigitModifier>(provider, provider: "modifier<monospacedDigit>"))
            case "ModifierProvider<WeightModifier>": try container.encode(ModifierProvider<WeightModifier>(provider, provider: "modifier<weight>"))
            case "ModifierProvider<BoldModifier>": try container.encode(ModifierProvider<BoldModifier>(provider, provider: "modifier<bold>"))
            case "ModifierProvider<LeadingModifier>": try container.encode(ModifierProvider<LeadingModifier>(provider, provider: "modifier<leading>"))
            default: fatalError(providerName)
            }
        }
    }
    
    // MARK - AnyFontBox
    
    internal class AnyFontBox: Codable {
        let provider: String
        init(provider: String) {
            self.provider = provider
        }
        public func apply() -> Font { fatalError() }
        // MARK - Codable
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
    
    internal class SystemProvider: AnyFontBox {
        let size: CGFloat
        let weight: Weight
        let design: Design
        init(_ s: Any, provider: String) {
            let base = Mirror.children(reflecting: s)
            size = base["size"] as! CGFloat
            weight = base["weight"] as! Weight
            design = base["design"] as! Design
            super.init(provider: provider)
        }
        public override func apply() -> Font { Font.system(size: size, weight: weight, design: design) }
        // MARK - Codable
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
    
    internal class TextStyleProvider: AnyFontBox {
        let style: TextStyle
        let design: Design
        let weight: Weight?
        init(_ s: Any, provider: String) {
            let base = Mirror.children(reflecting: s)
            style = base["style"] as! TextStyle
            design = base["design"] as! Design
            weight = base["weight"] as? Weight
            super.init(provider: provider)
        }
        public override func apply() -> Font { weight == nil ? Font.system(style, design: design) : Font.system(style, design: design) }
        // MARK - Codable
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
    
    internal class NamedProvider: AnyFontBox {
        let name: String
        let size: CGFloat
        let textStyle: TextStyle?
        init(_ s: Any, provider: String) {
            let base = Mirror.children(reflecting: s)
            name = base["name"] as! String
            size = base["size"] as! CGFloat
            textStyle = base["textStyle"] as? TextStyle
            super.init(provider: provider)
        }
        public override func apply() -> Font { textStyle != nil ? Font.custom(name, size: size, relativeTo: textStyle!) : Font.custom(name, fixedSize: size) }
        // MARK - Codable
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
    
    internal class PlatformFontProvider: AnyFontBox {
        let font: UIFont
        let fontSize: CGFloat
        init(_ s: Any, provider: String) {
            let base = Mirror.children(reflecting: s)
            font = base["font"] as! UIFont
            fontSize = font.pointSize
            super.init(provider: provider)
        }
        public override func apply() -> Font { Font(font) }
        // MARK - Codable
        enum CodingKeys: CodingKey {
            case font, size
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let fontName = try container.decode(String.self, forKey: .font)
            fontSize = try container.decode(CGFloat.self, forKey: .size)
            font = CTFontCreateWithName(fontName as CFString, fontSize, nil)
            //font = UIFont(name: fontName, size: pointSize) ?? UIFont.systemFont(ofSize: pointSize)
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(font.familyName, forKey: .font)
            try container.encode(font.pointSize, forKey: .size)
            try super.encode(to: encoder)
        }
    }
    
    // MARK - ModifierProvider
    
    internal class AnyModifier: Codable {
        required init(_ s: Any) { }
        public func apply(_ font: Font) -> Font { font }
        // MARK - Codable
        public required init(from decoder: Decoder) throws { }
        public func encode(to encoder: Encoder) throws { }
    }
    
    internal class ModifierProvider<Modifier: AnyModifier>: Codable {
        let provider: String
        let base: Font
        let modifier: Modifier
        init(_ s: Any, provider: String) {
            let mirror = Mirror(reflecting: s)
            base = mirror.descendant("base")! as! Font
            modifier = Modifier(mirror.descendant("modifier")!)
            self.provider = provider
        }
        public func apply() -> Font { modifier.apply(base) }
        // MARK - Codable
        enum CodingKeys: CodingKey {
            case base, modifier, provider
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            base = try container.decode(Font.self, forKey: .base)
            modifier = try container.decodeIfPresent(Modifier.self, forKey: .modifier) ?? Modifier(0)
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
    
    internal class ItalicModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font { font.italic() }
    }
    
    internal class LowercaseSmallCapsModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font { font.lowercaseSmallCaps() }
    }
    
    internal class UppercaseSmallCapsModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font { font.uppercaseSmallCaps() }
    }
    
    internal class MonospacedDigitModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font { font.monospacedDigit() }
    }
    
    internal class WeightModifier: AnyModifier {
        let weight: Weight
        required init(_ s: Any) {
            weight = Mirror(reflecting: s).descendant("weight")! as! Weight
            super.init(s)
        }
        public override func apply(_ font: Font) -> Font { font.weight(weight) }
        // MARK - Codable
        public required init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            weight = try container.decode(Weight.self)
            super.init(0)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(weight)
        }
    }
    
    internal class BoldModifier: AnyModifier {
        public override func apply(_ font: Font) -> Font { font.bold() }
    }
    
    internal class LeadingModifier: AnyModifier {
        let leading: Leading
        required init(_ s: Any) {
            leading = Mirror(reflecting: s).descendant("leading")! as! Leading
            super.init(s)
        }
        public override func apply(_ font: Font) -> Font { font.leading(leading) }
        // MARK - Codable
        public required init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            leading = try container.decode(Leading.self)
            super.init(0)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(leading)
        }
    }
}

extension Font.TextStyle: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "largeTitle": self = .largeTitle
        case "title": self = .title
        case "title2": self = .title2
        case "title3": self = .title3
        case "headline": self = .headline
        case "subheadline": self = .subheadline
        case "body": self = .body
        case "callout": self = .callout
        case "footnote": self = .footnote
        case "caption": self = .caption
        case "caption2": self = .caption2
        default: fatalError(value)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .largeTitle: try container.encode("largeTitle")
        case .title: try container.encode("title")
        case .title2: try container.encode("title2")
        case .title3: try container.encode("title3")
        case .headline: try container.encode("headline")
        case .subheadline: try container.encode("subheadline")
        case .body: try container.encode("body")
        case .callout: try container.encode("callout")
        case .footnote: try container.encode("footnote")
        case .caption: try container.encode("caption")
        case .caption2: try container.encode("caption2")
        default: fatalError()
        }
    }
}

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

extension Font.Design: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case "default": self = .default
        case "serif": self = .serif
        case "rounded": self = .rounded
        case "monospaced": self = .monospaced
        default: fatalError(value)
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .default: try container.encode("default")
        case .serif: try container.encode("serif")
        case .rounded: try container.encode("rounded")
        case .monospaced: try container.encode("monospaced")
        default: fatalError()
        }
    }
}
