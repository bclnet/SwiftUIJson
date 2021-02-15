//
//  AnyShape.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public protocol IAnyShape: IAnyView {
    var anyShape: AnyShape { get }
}

public struct AnyShape: Shape, DynaCodable {
    public func path(in rect: CGRect) -> Path { storage.path(rect) }
    public var body: AnyView { storage.view }
    let storage: AnyShapeStorage
    public init<V>(_ shape: V) where V : Shape {
        storage = AnyShapeStorage(shape: shape, view: AnyView(shape), path: shape.path)
    }

    internal class AnyShapeStorage {
        let shape: Any
        let view: AnyView
        let path: (CGRect) -> Path
        init(shape: Any, view: AnyView, path: @escaping (CGRect) -> Path) {
            self.shape = shape
            self.view = view
            self.path = path
        }
    }

    public typealias Body = AnyView

    //: Codable
    public func encode(to encoder: Encoder) throws {
        guard let context = encoder.userInfo[.jsonContext] as? JsonContext else { fatalError(".jsonContext") }
        try context.encodeDynaSuper(storage.shape, to: encoder)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        guard let context = decoder.userInfo[.jsonContext] as? JsonContext else { fatalError(".jsonContext") }
        let shape = try context.dynaSuperInit(from: decoder, for: ptype) as! IAnyShape
        self = shape.anyShape
    }

    //: Register
    static func register() {
        PType.register(AnyShape.self)
    }
}
