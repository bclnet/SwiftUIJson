//
//  Binding.swift (Incomplete)
//  Glyph
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI
extension Binding: FullyCodable {
    //: Codable
    public init(from decoder: Decoder, for dynaType: DynaType) throws { try self.init(from: decoder) }
    public init(from decoder: Decoder) throws {
        let base: Binding<Value?>
        switch "\(Value.self)" {
        case "Date": base = Binding<Date?>.constant(Date()) as! Binding<Value?>
        case "Bool": base = Binding<Bool?>.constant(true) as! Binding<Value?>
        case "Double": base = Binding<Double?>.constant(0) as! Binding<Value?>
        case "AnyHashable": base = Binding<AnyHashable?>.constant(1) as! Binding<Value?>
        case let unrecognized: fatalError("\(unrecognized)")
        }
        self.init(base)!
    }
    public func encode(to encoder: Encoder) throws {
    }
}
