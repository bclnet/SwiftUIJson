//
//  _ConditionalContent.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension _ConditionalContent: IAnyView, DynaCodable where TrueContent : View, TrueContent : DynaCodable, FalseContent : View, FalseContent : DynaCodable {
    public var anyView: AnyView { AnyView(self) }

    internal class Storage {
        let trueContent: TrueContent?
        let falseContent: FalseContent?
        init(any s: Any) {
            let m = Mirror.single(reflecting: s)
            trueContent = m.label == "trueContent" ? m.value as? TrueContent : nil
            falseContent = m.label == "falseContent" ? m.value as? FalseContent : nil
        }
    }

    //: Codable
    enum CodingKeys: CodingKey {
        case `true`, `false`
    }
    public func encode(to encoder: Encoder) throws {
        let storage = Storage(any: Mirror(reflecting: self).descendant("storage")!)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(storage.trueContent, forKey: .true)
        try container.encodeIfPresent(storage.falseContent, forKey: .false)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let trueContent = try? container.decodeIfPresent(TrueContent.self, forKey: .true, ptype: ptype[0])
        let falseContent = try? container.decodeIfPresent(FalseContent.self, forKey: .false, ptype: ptype[1])
        if trueContent != nil { self = ViewBuilder.buildEither(first: trueContent!) }
        else if falseContent != nil { self = ViewBuilder.buildEither(second: falseContent!) }
        else { throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "_ConditionalContent not true or false")) }
    }

    //: Register
    static func register() {
        PType.register(_ConditionalContent<AnyView, AnyView>.self)
    }
}
