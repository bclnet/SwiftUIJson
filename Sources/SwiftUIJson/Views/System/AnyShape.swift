//
//  AnyView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public protocol IAnyShape {
    var anyShape: AnyShape { get }
}

public struct AnyShape: Shape, DynaCodable {

    public func path(in rect: CGRect) -> Path {
        fatalError("Never")
    }

    let view: AnyView
    public init<V>(_ view: V) where V : View {
        self.view = AnyView(view)
    }
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        guard let context = decoder.userInfo[.jsonContext] as? JsonContext else { fatalError(".jsonContext") }
        let shape = try context.dynaSuperInit(from: decoder, for: dynaType) as! IAnyShape
        self = shape.anyShape
    }
    public func encode(to encoder: Encoder) throws { fatalError("Never") }
    //: Register
    static func register() {
        DynaType.register(AnyShape.self)
    }

    public var body: AnyView { view }
    
    public typealias Body = AnyView
}
