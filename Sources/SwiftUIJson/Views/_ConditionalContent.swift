//
//  _ConditionalContent.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension _ConditionalContent: JsonView, DynaCodable where TrueContent : View, TrueContent : DynaCodable, FalseContent : View, FalseContent : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case `true`, `false`
    }
    public init(from decoder: Decoder, for dynaType: DynaType, depth: Int) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let trueContent = try container.decodeIfPresent(TrueContent.self, forKey: .true, dynaType: dynaType, depth: depth + 1)
        let falseContent = try container.decodeIfPresent(FalseContent.self, forKey: .false, dynaType: dynaType[0], depth: depth + 1)
        if trueContent != nil { self = ViewBuilder.buildEither(first: trueContent!) }
        else if falseContent != nil { self = ViewBuilder.buildEither(second: falseContent!) }
        else { throw DynaTypeError.typeParseError(named: "") }
    }
    public func encode(to encoder: Encoder) throws {
        let storage = Storage(any: Mirror(reflecting: self).descendant("storage")!)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(storage.trueContent, forKey: .true)
        try container.encodeIfPresent(storage.falseContent, forKey: .false)
    }
    
    internal class Storage {
        let trueContent: TrueContent?
        let falseContent: FalseContent?
        init(any s: Any) {
            let base = Mirror.single(reflecting: s)
            trueContent = base.label == "trueContent" ? base.value as? TrueContent : nil
            falseContent = base.label == "falseContent" ? base.value as? FalseContent : nil
        }
    }
}
