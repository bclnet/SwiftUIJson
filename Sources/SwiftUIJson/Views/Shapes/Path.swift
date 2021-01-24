//
//  Path.swift
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Path: IAnyShape, DynaCodable {
    public var anyShape: AnyShape { AnyShape(self) }
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case path
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let description = (try? container.decodeIfPresent(String.self, forKey: .path)) ?? ""
        self = Path(description) ?? Path()
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let type = String(String(reflecting: Mirror(reflecting: self).descendant("storage")!).split(separator: "(")[0])
        if type != "SwiftUI.Path.Storage.empty" { try container.encode(description, forKey: .path) }
    }
    //: Register
    static func register() {
        PType.register(Path.self)
    }
}

#if false
extension Path: IAnyShape, DynaCodable {
    public var anyShape: AnyShape { AnyShape(self) }
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case empty, path, rect, roundedRect, ellipse
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch container.allKeys.first {
        case .empty: self.init()
        case .path: self.init(try CGMutablePath.decode(from: try container.superDecoder(forKey: .path)))
        case .rect: self.init(try container.decode(CGRect.self, forKey: .rect))
        case .roundedRect:
            let roundedRect = try container.decode(FixedRoundedRect.self, forKey: .roundedRect)
            self.init(roundedRect: roundedRect.rect, cornerSize: roundedRect.cornerSize, style: roundedRect.style)
        case .ellipse: self.init(ellipseIn: try container.decode(CGRect.self, forKey: .ellipse))
        default: fatalError()
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.description, forKey: .path)
        Mirror.assert(self, name: "Path", keys: ["storage"])
        let storage = Storage(any: Mirror(reflecting: self).descendant("storage")!)
        switch storage {
        case .empty: try container.encode("empty", forKey: .empty)
        case .path(let path): try path.cgPath.encode(to: container.superEncoder(forKey: .path))
        case .rect(let rect): try container.encode(rect, forKey: .rect)
        case .roundedRect(let roundedRect): try container.encode(roundedRect, forKey: .roundedRect)
        case .ellipse(let ellipse): try container.encode(ellipse, forKey: .ellipse)
        }
    }
    //: Register
    static func register() {
        PType.register(Path.self)
    }
    
    internal enum Storage {
        case empty
        case path(PathBox)
        case rect(CGRect)
        case roundedRect(FixedRoundedRect)
        case ellipse(CGRect)
        init(any: Any) {
            Mirror.assert(any, name: "Storage", keys: ["path", "rect", "roundedRect", "ellipse"], keyMatch: .any)
            let m = Mirror.children(reflecting: any)
            switch String(String(reflecting: any).split(separator: "(")[0]) {
            case "SwiftUI.Path.Storage.empty": self = .empty
            case "SwiftUI.Path.Storage.path": self = .path(PathBox(any: m["path"]!))
            case "SwiftUI.Path.Storage.rect": self = .rect(m["rect"]! as! CGRect)
            case "SwiftUI.Path.Storage.roundedRect": self = .roundedRect(FixedRoundedRect(any: m["roundedRect"]!))
            case "SwiftUI.Path.Storage.ellipse": self = .ellipse(m["ellipse"]! as! CGRect)
            case let value: fatalError(value)
            }
        }
    }
    
    internal class PathBox {
        let bounds: Any
        let cgPath: CGMutablePath
        init(any: Any) {
            Mirror.assert(any, name: "PathBox", keys: ["bounds", "cgPath"])
            let m = Mirror.children(reflecting: any)
            bounds = m["bounds"]!
            cgPath = m["cgPath"]! as! CGMutablePath
        }
    }
}

extension CGMutablePath {
    //: Codable
    enum CodingKeys: CodingKey {
        case bounds, cgPath
    }
    public static func decode(from decoder: Decoder) throws -> CGMutablePath {
        let path = CGMutablePath()
        var type: String?, points = [CGPoint]()
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            var baseContainer = try container.nestedUnkeyedContainer()
            type = nil; points.removeAll()
            while !baseContainer.isAtEnd {
                if type == nil {
                    type = try baseContainer.decode(String.self)
                    continue
                }
                points.append(try baseContainer.decode(CGPoint.self))
            }
            switch type {
            case "move": path.move(to: points[0])
            case "addLine": path.addLine(to: points[0])
            case "addQuadCurve": path.addQuadCurve(to: points[0], control: points[1])
            case "addCurve": path.addCurve(to: points[0], control1: points[1], control2: points[2])
            case "close": path.closeSubpath()
            case let value: fatalError(value!)
            }
        }
        return path
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        self.applyWithBlock { unsafeElement in
            let element = unsafeElement.pointee
            switch element.type {
            case .moveToPoint:
                var baseContainer = container.nestedUnkeyedContainer()
                try! baseContainer.encode("move")
                try! baseContainer.encode(element.points[0])
            case .addLineToPoint:
                var baseContainer = container.nestedUnkeyedContainer()
                try! baseContainer.encode("addLine")
                try! baseContainer.encode(element.points[0])
            case .addQuadCurveToPoint:
                var baseContainer = container.nestedUnkeyedContainer()
                try! baseContainer.encode("addQuadCurve")
                try! baseContainer.encode(element.points[0])
                try! baseContainer.encode(element.points[1])
            case .addCurveToPoint:
                var baseContainer = container.nestedUnkeyedContainer()
                try! baseContainer.encode("addCurve")
                try! baseContainer.encode(element.points[0])
                try! baseContainer.encode(element.points[1])
                try! baseContainer.encode(element.points[2])
            case .closeSubpath:
                var baseContainer = container.nestedUnkeyedContainer()
                try! baseContainer.encode("close")
            case let value: fatalError("\(value)")
            }
        }
    }
}
#endif
