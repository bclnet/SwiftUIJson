//
//  Color.swift (Incomplete)
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI
struct UnexpectedlyFoundNilError: Error {}

#if os(macOS)
typealias UXColor = NSColor
#else
typealias UXColor = UIColor
#endif

// MARK: - Preamble
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color {
    
    internal class AnyColorBox: Codable {
        let provider: String
        init(provider: String) {
            self.provider = provider
        }
        public func apply() -> Color {
            fatalError()
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case provider, value
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
}

// MARK: - First
extension Color {
    
    @available(iOS 14.0, macOS 11, tvOS 14.0, watchOS 7.0, *)
    internal class __NSCFType: AnyColorBox {
        let cgColor: CGColor
        init(any s: Any, provider: String) {
            cgColor = s as! CGColor
            super.init(provider: provider)
        }
        public override func apply() -> Color {
            Color(cgColor)
        }
        //: Codable
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: AnyColorBox.CodingKeys.self)
            let baseDecoder = try container.superDecoder(forKey: .value)
            cgColor = try CGColor.decode(from: baseDecoder)
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: AnyColorBox.CodingKeys.self)
            let baseEncoder = container.superEncoder(forKey: .value)
            try cgColor.encode(to: baseEncoder)
            try super.encode(to: encoder)
        }
    }
    
    internal class _Resolved: AnyColorBox {
        let red: Float
        let green: Float
        let blue: Float
        let opacity: Float
        init(any s: Any, provider: String) {
            let m = Mirror.children(reflecting: s)
            red = m["linearRed"] as! Float
            green = m["linearGreen"] as! Float
            blue = m["linearBlue"] as! Float
            opacity = m["opacity"] as! Float
            super.init(provider: provider)
        }
        public override func apply() -> Color {
            Color(.sRGBLinear, red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(opacity))
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case red, green, blue, opacity
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            red = try container.decode(Float.self, forKey: .red)
            green = try container.decode(Float.self, forKey: .green)
            blue = try container.decode(Float.self, forKey: .blue)
            opacity = try container.decode(Float.self, forKey: .opacity)
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(red, forKey: .red)
            try container.encode(green, forKey: .green)
            try container.encode(blue, forKey: .blue)
            try container.encode(opacity, forKey: .opacity)
            try super.encode(to: encoder)
        }
    }
    
    internal class DisplayP3: AnyColorBox {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        let opacity: Float
        init(any s: Any, provider: String) {
            let m = Mirror.children(reflecting: s)
            red = m["red"] as! CGFloat
            green = m["green"] as! CGFloat
            blue = m["blue"] as! CGFloat
            opacity = m["opacity"] as! Float
            super.init(provider: provider)
        }
        public override func apply() -> Color {
            Color(.displayP3, red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(opacity))
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case red, green, blue, opacity
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            red = try container.decode(CGFloat.self, forKey: .red)
            green = try container.decode(CGFloat.self, forKey: .green)
            blue = try container.decode(CGFloat.self, forKey: .blue)
            opacity = try container.decode(Float.self, forKey: .opacity)
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(red, forKey: .red)
            try container.encode(green, forKey: .green)
            try container.encode(blue, forKey: .blue)
            try container.encode(opacity, forKey: .opacity)
            try super.encode(to: encoder)
        }
    }
    
    internal class NamedColor: AnyColorBox {
        let name: String
        let bundle: Bundle?
        init(any s: Any, provider: String) {
            let m = Mirror.children(reflecting: s)
            name = m["name"] as! String
            bundle = m["bundle"] as? Bundle
            super.init(provider: provider)
        }
        public override func apply() -> Color {
            Color(name, bundle: bundle)
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case name, bundle
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            bundle = try container.decodeIfPresent(CodableBundle.self, forKey: .bundle)?.bundle
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encodeIfPresent(CodableBundle(bundle), forKey: .bundle)
            try super.encode(to: encoder)
        }
    }

    internal class PlatformColor: AnyColorBox {
        let color: UXColor
        init(any s: Any, provider: String) {
            color = s as! UXColor
            super.init(provider: provider)
        }
        public override func apply() -> Color {
            Color(color)
        }
        //: Codable
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: AnyColorBox.CodingKeys.self)
            let baseDecoder = try container.superDecoder(forKey: .value)
            color = try UXColor.decode(from: baseDecoder)
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: AnyColorBox.CodingKeys.self)
            let baseEncoder = container.superEncoder(forKey: .value)
            try color.encode(to: baseEncoder)
            try super.encode(to: encoder)
        }
    }
    
    internal class OpacityColor: AnyColorBox {
        let base: Color
        let opacity: Double
        init(any s: Any, provider: String) {
            let m = Mirror.children(reflecting: s)
            base = m["base"] as! Color
            opacity = m["opacity"] as! Double
            super.init(provider: provider)
        }
        public override func apply() -> Color {
            base.opacity(opacity)
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case base, opacity
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            base = try container.decode(Color.self, forKey: .base)
            opacity = try container.decode(Double.self, forKey: .opacity)
            try super.init(from: decoder)
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base, forKey: .base)
            try container.encode(opacity, forKey: .opacity)
            try super.encode(to: encoder)
        }
    }

}
    
//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color: Codable {
    //: Codable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value: String
        do { value = try container.decode(String.self) }
        catch { value = "" }
        switch value {
        case "clear": self = .clear
        case "black": self = .black
        case "white": self = .white
        case "gray": self = .gray
        case "red": self = .red
        case "green": self = .green
        case "blue": self = .blue
        case "orange": self = .orange
        case "yellow": self = .yellow
        case "pink": self = .pink
        case "purple": self = .purple
        case "primary": self = .primary
        case "secondary": self = .secondary
        default:
            let defaultFunc: () throws -> Color = {
                let provider = try container.decode(AnyColorBox.self).provider
                switch provider {
                case "system":
                    if #available(iOS 14.0, macOS 11, tvOS 14.0, watchOS 7.0, *) {
                        return try container.decode(__NSCFType.self).apply()
                    } else { fatalError() }
                case "resolved": return try container.decode(_Resolved.self).apply()
                case "displayP3": return try container.decode(DisplayP3.self).apply()
                case "named": return try container.decode(NamedColor.self).apply()
                case "platform": return try container.decode(PlatformColor.self).apply()
                case "opacity": return try container.decode(OpacityColor.self).apply()
                default: fatalError(value)
                }
            }
            self = try defaultFunc()
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .clear: try container.encode("clear")
        case .black: try container.encode("black")
        case .white: try container.encode("white")
        case .gray: try container.encode("gray")
        case .red: try container.encode("red")
        case .green: try container.encode("green")
        case .blue: try container.encode("blue")
        case .orange: try container.encode("orange")
        case .yellow: try container.encode("yellow")
        case .pink: try container.encode("pink")
        case .purple: try container.encode("purple")
        case .primary: try container.encode("primary")
        case .secondary: try container.encode("secondary")
        default:
            let defaultFunc = {
                let provider = Mirror(reflecting: self).descendant("provider", "base")!
                let providerName = "\(type(of: provider))"
                switch providerName {
                case "__NSCFType":
                    if #available(iOS 14.0, macOS 11, tvOS 14.0, watchOS 7.0, *) {
                        try container.encode(__NSCFType(any: provider, provider: "system"))
                    } else { fatalError() }
                case "_Resolved": try container.encode(_Resolved(any: provider, provider: "resolved"))
                case "DisplayP3": try container.encode(DisplayP3(any: provider, provider: "displayP3"))
                case "NamedColor": try container.encode(NamedColor(any: provider, provider: "named"))
                case "UICachedDeviceRGBColor", "UICachedDeviceWhiteColor": try container.encode(PlatformColor(any: provider, provider: "platform"))
                case "OpacityColor": try container.encode(OpacityColor(any: provider, provider: "opacity"))
                default: fatalError(providerName)
                }
            }
            try defaultFunc()
        }
    }
}

    
// MARK: - First

//@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
//extension Color.RGBColorSpace: Codable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let value = try container.decode(String.self)
//        switch value {
//        case "sRGB": self = .sRGB
//        case "sRGBLinear": self = .sRGBLinear
//        case "displayP3": self = .displayP3
//        default: fatalError(value)
//        }
//    }
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .sRGB: try container.encode("sRGB")
//        case .sRGBLinear: try container.encode("sRGBLinear")
//        case .displayP3: try container.encode("displayP3")
//        default: fatalError()
//        }
//    }
//}

extension CGColor {
    public static func decode(from decoder: Decoder) throws -> CGColor {
        try UXColor.decode(from: decoder).cgColor
    }
    public func encode(to encoder: Encoder) throws {
        #if os(macOS)
        let color = UXColor(cgColor: self)!
        #else
        let color = UXColor(cgColor: self)
        #endif
        try color.encode(to: encoder)
    }
}

extension UXColor {
    static func decode(from decoder: Decoder) throws -> UXColor {
        let container = try decoder.singleValueContainer()
        let decodedData = try container.decode(Data.self)
        let nsCoder = try NSKeyedUnarchiver(forReadingFrom: decodedData)
        guard let color = UXColor(coder: nsCoder) else { throw UnexpectedlyFoundNilError() }
        return color
    }
    func encode(to encoder: Encoder) throws {
        let nsCoder = NSKeyedArchiver(requiringSecureCoding: true)
        self.encode(with: nsCoder)
        var container = encoder.singleValueContainer()
        try container.encode(nsCoder.encodedData)
    }
}
