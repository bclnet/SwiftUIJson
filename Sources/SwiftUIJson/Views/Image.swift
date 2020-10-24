//
//  Image.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

#if os(macOS)
public typealias UXImage = NSImage
#else
public typealias UXImage = UIImage
#endif

// MARK: - Preamble
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {
    internal class AnyImageBox: Codable {
        public func apply() -> Image {
            fatalError()
        }
    }
}

// MARK: - First
extension Image {
    
    internal struct Location {
        let system: Bool
        let bundle: Bundle?
        init(system: Bool, bundle: Bundle?) {
            self.system = system
            self.bundle = bundle
        }
        init(any s: Any) {
            system = String(reflecting: s) == "SwiftUI.Image.Location.system"
            let m = Mirror.children(reflecting: s)
            bundle = m["bundle"] as? Bundle
        }
    }
    
    internal class NamedImageProvider: AnyImageBox {
        let label: Text?
        let location: Location
        let name: String
        let decorative: Bool
//        let backupLocation: Any
        init(any s: Any) {
            let m = Mirror.children(reflecting: s)
            label = m["label"]! as? Text
            location = Location(any: m["location"]!)
            name = m["name"]! as! String
            decorative = m["decorative"]! as! Bool
//            backupLocation = m["backupLocation"]!
            super.init()
        }
        public override func apply() -> Image {
            if location.system { return Image(systemName: name) }
            if decorative { return Image(decorative: name, bundle: location.bundle) }
            if label != nil { return Image(name, bundle: location.bundle, label: label!) }
            return Image(name, bundle: location.bundle)
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case label, system, bundle, name, decorative
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            label = try container.decodeIfPresent(Text.self, forKey: .label)
            location = Location(
                system: try container.decodeIfPresent(Bool.self, forKey: .system) ?? false,
                bundle: try container.decodeIfPresent(CodableBundle.self, forKey: .bundle)?.bundle)
            name = try container.decode(String.self, forKey: .name)
            decorative = try container.decodeIfPresent(Bool.self, forKey: .decorative) ?? false
            super.init()
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(label, forKey: .label)
            if location.system { try container.encode(location.system, forKey: .system) }
            try container.encodeIfPresent(CodableBundle(location.bundle), forKey: .bundle)
            try container.encode(name, forKey: .name)
            if decorative { try container.encode(decorative, forKey: .decorative) }
        }
    }

    internal class RenderingModeProvider: AnyImageBox {
        let base: Image
        let renderingMode: TemplateRenderingMode
        init(any s: Any) {
            let m = Mirror.children(reflecting: s)
            base = m["base"]! as! Image
            renderingMode = m["renderingMode"]! as! TemplateRenderingMode
            super.init()
        }
        public override func apply() -> Image {
            base.renderingMode(renderingMode)
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case base, mode
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            base = try container.decode(Image.self, forKey: .base)
            renderingMode = try container.decodeIfPresent(TemplateRenderingMode.self, forKey: .mode) ?? .original
            super.init()
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base, forKey: .base)
            if renderingMode != .original { try container.encode(renderingMode, forKey: .mode) }
        }
    }
    
    internal class InterpolationProvider: AnyImageBox {
        let base: Image
        let interpolation: Interpolation
        init(any s: Any) {
            let m = Mirror.children(reflecting: s)
            base = m["base"]! as! Image
            interpolation = m["interpolation"]! as! Interpolation
            super.init()
        }
        public override func apply() -> Image {
            base.interpolation(interpolation)
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case base, interpolation
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            base = try container.decode(Image.self, forKey: .base)
            interpolation = try container.decodeIfPresent(Interpolation.self, forKey: .interpolation) ?? .none
            super.init()
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base, forKey: .base)
            if interpolation != .none { try container.encode(interpolation, forKey: .interpolation) }
        }
    }
    
    internal class AntialiasedProvider: AnyImageBox {
        let base: Image
        let isAntialiased: Bool
        init(any s: Any) {
            let m = Mirror.children(reflecting: s)
            base = m["base"]! as! Image
            isAntialiased = m["isAntialiased"]! as! Bool
            super.init()
        }
        public override func apply() -> Image {
            base.antialiased(isAntialiased)
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case base, antialiased
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            base = try container.decode(Image.self, forKey: .base)
            isAntialiased = try container.decodeIfPresent(Bool.self, forKey: .antialiased) ?? true
            super.init()
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base, forKey: .base)
            if !isAntialiased { try container.encode(isAntialiased, forKey: .antialiased) }
        }
    }
    
    internal class CGImageProvider: AnyImageBox {
        let image: CGImage
        let label: Text?
        let decorative: Bool
        let scale: CGFloat
        let orientation: Orientation
        init(any s: Any) {
            let m = Mirror.children(reflecting: s)
            image = m["image"]! as! CGImage
            label = m["label"]! as? Text
            decorative = m["decorative"]! as! Bool
            scale = m["scale"] as! CGFloat
            orientation = m["orientation"] as! Orientation
            super.init()
        }
        public override func apply() -> Image {
            decorative
                ? Image(decorative: image, scale: scale, orientation: orientation)
                : Image(image, scale: scale, orientation: orientation, label: label!)
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case image, label, decorative, scale, orientation
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let baseDecoder = try container.superDecoder(forKey: .image)
            image = try CGImage.decode(from: baseDecoder)
            label = try container.decodeIfPresent(Text.self, forKey: .label)
            decorative = try container.decodeIfPresent(Bool.self, forKey: .decorative) ?? false
            scale = try container.decodeIfPresent(CGFloat.self, forKey: .scale) ?? 0
            orientation = try container.decodeIfPresent(Orientation.self, forKey: .orientation) ?? .up
            super.init()
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            let baseEncoder = container.superEncoder(forKey: .image)
            try image.encode(to: baseEncoder)
            try container.encode(label, forKey: .label)
            if decorative { try container.encode(decorative, forKey: .decorative) }
            if scale != 0 { try container.encode(scale, forKey: .scale) }
            if orientation != .up { try container.encode(orientation, forKey: .orientation) }
        }
    }
    
    internal class PlatformProvider: AnyImageBox {
        let image: UXImage
        init(any s: Any) {
            image = s as! UXImage
            super.init()
        }
        public override func apply() -> Image {
            Image(uiImage: image)
        }
        //: Codable
        public required init(from decoder: Decoder) throws {
            image = try UXImage.decode(from: decoder)
            super.init()
        }
        public override func encode(to encoder: Encoder) throws {
            try image.encode(to: encoder)
        }
    }
    
    internal class ResizableProvider: AnyImageBox {
        let base: Image
        let resizingMode: ResizingMode
        let capInsets: EdgeInsets
        init(any s: Any) {
            let m = Mirror.children(reflecting: s)
            base = m["base"]! as! Image
            capInsets = m["capInsets"]! as! EdgeInsets
            resizingMode = m["resizingMode"]! as! ResizingMode
            super.init()
        }
        public override func apply() -> Image {
            base.resizable(capInsets: capInsets, resizingMode: resizingMode)
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case base, capInsets, resizingMode
        }
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            base = try container.decode(Image.self, forKey: .base)
            capInsets = try container.decodeIfPresent(EdgeInsets.self, forKey: .capInsets) ?? EdgeInsets()
            resizingMode = try container.decodeIfPresent(ResizingMode.self, forKey: .resizingMode) ?? .stretch
            super.init()
        }
        public override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(base, forKey: .base)
            if !capInsets.isEmpty { try container.encode(capInsets, forKey: .capInsets) }
            if resizingMode != .stretch { try container.encode(resizingMode, forKey: .resizingMode) }
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image: JsonView, DynaFullCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case named, mode, interpolation, antialiased, cgimage, platform, resizable
    }
    public init(from decoder: Decoder, for dynaType: DynaType, depth: Int) throws { try self.init(from: decoder) }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var provider: AnyImageBox!
        for key in container.allKeys {
            switch key {
            case .named: provider = try container.decode(NamedImageProvider.self, forKey: key)
            case .mode: provider = try container.decode(RenderingModeProvider.self, forKey: key)
            case .interpolation: provider = try container.decode(InterpolationProvider.self, forKey: key)
            case .antialiased: provider = try container.decode(AntialiasedProvider.self, forKey: key)
            case .cgimage: provider = try container.decode(CGImageProvider.self, forKey: key)
            case .platform: provider = try container.decode(PlatformProvider.self, forKey: key)
            case .resizable: provider = try container.decode(ResizableProvider.self, forKey: key)
            }
        }
        self = provider.apply()
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let provider = Mirror(reflecting: self).descendant("provider", "base")!
        let providerName = "\(type(of: provider))"
        switch providerName {
        case "NamedImageProvider": try container.encode(NamedImageProvider(any: provider), forKey: .named)
        case "RenderingModeProvider": try container.encode(RenderingModeProvider(any: provider), forKey: .mode)
        case "InterpolationProvider": try container.encode(InterpolationProvider(any: provider), forKey: .interpolation)
        case "AntialiasedProvider": try container.encode(AntialiasedProvider(any: provider), forKey: .antialiased)
        case "CGImageProvider": try container.encode(CGImageProvider(any: provider), forKey: .cgimage)
        case "UIImage", "NSImage": try container.encode(PlatformProvider(any: provider), forKey: .platform)
        case "ResizableProvider": try container.encode(ResizableProvider(any: provider), forKey: .resizable)
        default: fatalError(providerName)
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.Orientation: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "up": self = .up
        case "upMirrored": self = .upMirrored
        case "down": self = .down
        case "downMirrored": self = .downMirrored
        case "left": self = .left
        case "leftMirrored": self = .leftMirrored
        case "right": self = .right
        case "rightMirrored": self = .rightMirrored
        default: fatalError()
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .up: try container.encode("up")
        case .upMirrored: try container.encode("upMirrored")
        case .down: try container.encode("down")
        case .downMirrored: try container.encode("downMirrored")
        case .left: try container.encode("left")
        case .leftMirrored: try container.encode("leftMirrored")
        case .right: try container.encode("right")
        case .rightMirrored: try container.encode("rightMirrored")
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.TemplateRenderingMode: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "template": self = .template
        case "original": self = .original
        default: fatalError()
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .template: try container.encode("template")
        case .original: try container.encode("original")
        default: fatalError()
        }
    }
}

//@available(macOS 11.0, *)
//extension Image.Scale: Codable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        switch try container.decode(String.self) {
//        case "small": self = .small
//        case "medium": self = .medium
//        case "large": self = .large
//        default: fatalError()
//        }
//    }
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        switch self {
//        case .small: try container.encode("small")
//        case .medium: try container.encode("medium")
//        case .large: try container.encode("large")
//        default: fatalError()
//        }
//    }
//}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.Interpolation: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "none": self = .none
        case "low": self = .low
        case "medium": self = .medium
        case "high": self = .high
        default: fatalError()
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .none: try container.encode("none")
        case .low: try container.encode("low")
        case .medium: try container.encode("medium")
        case .high: try container.encode("high")
        default: fatalError()
        }
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image.ResizingMode: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "tile": self = .tile
        case "stretch": self = .stretch
        default: fatalError()
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .tile: try container.encode("tile")
        case .stretch: try container.encode("stretch")
        default: fatalError()
        }
    }
}

extension CGImage {
    public static func decode(from decoder: Decoder) throws -> CGImage {
        try UXImage.decode(from: decoder).cgImage!
    }
    public func encode(to encoder: Encoder) throws {
        #if os(macOS)
        let image = UXImage(cgImage: self)!
        #else
        let image = UXImage(cgImage: self)
        #endif
        try image.encode(to: encoder)
    }
}

// https://github.com/hyperoslo/Cache
extension UXImage {
    #if os(macOS)
    var hasAlpha: Bool {
        var imageRect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        guard let imageRef = cgImage(forProposedRect: &imageRect, context: nil, hints: nil) else { return false }
        switch imageRef.alphaInfo {
        case .none, .noneSkipFirst, .noneSkipLast: return false
        default: return true
        }
    }
    func getData() -> Data? {
        guard let data = tiffRepresentation else { return nil }
        let imageFileType: NSBitmapImageRep.FileType = hasAlpha ? .png : .jpeg
        return NSBitmapImageRep(data: data)?.representation(using: imageFileType, properties: [:])
    }
    #else
    var hasAlpha: Bool {
        guard let alpha = cgImage?.alphaInfo else { return false }
        switch alpha {
        case .none, .noneSkipFirst, .noneSkipLast: return false
        default: return true
        }
    }
    func getData() -> Data? {
        hasAlpha
            ? pngData()
            : jpegData(compressionQuality: 1.0)
    }
    #endif
    public static func decode(from decoder: Decoder) throws -> UXImage {
        let container = try decoder.singleValueContainer()
        let data = try container.decode(Data.self)
        return UXImage(data: data) ?? UXImage()
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.getData() ?? Data())
    }
}
