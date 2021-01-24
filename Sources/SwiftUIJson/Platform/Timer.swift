//
//  Timer.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import Foundation

extension Timer.TimerPublisher: FullyCodable {
    //: Codable
    enum CodingKeys: CodingKey {
        case interval, tolerance, runLoop, mode, options
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(interval, forKey: .interval)
        try container.encodeIfPresent(tolerance, forKey: .tolerance)
        try container.encode(CodableWrap(runLoop), forKey: .runLoop)
        try container.encode(mode, forKey: .mode)
        try container.encodeIfPresent(options, forKey: .options)
    }
    public convenience init(from decoder: Decoder, for ptype: PType) throws { try self.init(from: decoder) }
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let interval = try container.decode(TimeInterval.self, forKey: .interval)
        let tolerance = try container.decodeIfPresent(TimeInterval.self, forKey: .tolerance)
        let runLoop = try container.decode(CodableWrap<RunLoop>.self, forKey: .runLoop).wrapValue
        let mode = try container.decode(RunLoop.Mode.self, forKey: .mode)
        let options = try container.decodeIfPresent(RunLoop.SchedulerOptions.self, forKey: .options)
        self.init(interval: interval, tolerance: tolerance, runLoop: runLoop, mode: mode, options: options)
    }
}

extension RunLoop: WrapableCodable {
    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .current: try container.encode("current")
        case .main: try container.encode("main")
        case let value: fatalError("\(value)")
        }
    }
    public var wrapValue: RunLoop { self }
    public static func decode(from decoder: Decoder) throws -> Self {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "current": return RunLoop.current as! Self
        case "main": return RunLoop.main as! Self
        case let value: fatalError(value)
        }
    }
}

extension RunLoop.Mode: Codable {
    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .default: try container.encode("default")
        case .common: try container.encode("common")
        case let value: fatalError("\(value)")
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "default": self = .default
        case "common": self = .common
        case let value: fatalError(value)
        }
    }
}

extension RunLoop.SchedulerOptions: Codable {
    //: Codable
    public func encode(to encoder: Encoder) throws {}
    public init(from decoder: Decoder) throws { fatalError("Not Supported") }
}
