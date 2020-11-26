//
//  NSObjectWrap.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import Foundation

struct NSObjectWrap<Base>: Codable where Base : NSObject {
    public let wrapValue: Base
    public init(_ value: Base) {
        wrapValue = value
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case type, value
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dynaType = try container.decode(DynaType.self, forKey: .type)
        let decodedData = try container.decode(Data.self, forKey: .value)
        let coder = try NSKeyedUnarchiver(forReadingFrom: decodedData)
        switch dynaType {
        case .type(let type, _):
            switch type {
            case let value as NSSecureCoding.Type: wrapValue = value.init(coder: coder) as! Base
            case let value as NSCoding.Type: wrapValue = value.init(coder: coder) as! Base
            default: fatalError()
            }
        default: fatalError()
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let dynaType = try DynaType.type(for: Self.lookup(type(of: wrapValue).self))
        try container.encode(dynaType, forKey: .type)
        switch wrapValue {
        case let value as NSSecureCoding:
            let coder = NSKeyedArchiver(requiringSecureCoding: true)
            value.encode(with: coder)
            try container.encode(coder.encodedData, forKey: .value)
        case let value as NSCoding:
            let coder = NSKeyedArchiver(requiringSecureCoding: false)
            value.encode(with: coder)
            try container.encode(coder.encodedData, forKey: .value)
        case let unrecognized: fatalError("\(unrecognized)")
        }
    }
    
    static func lookup<Metatype>(_ type: Any.Type) -> Metatype {
        switch "\(type)" {
        case "__NSTaggedDate": return NSDate.self as! Metatype
        default: return type as! Metatype
        }
    }
}
