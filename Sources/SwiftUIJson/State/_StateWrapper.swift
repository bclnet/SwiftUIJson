//
//  _StateView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public protocol _AnyStateWrapper {
    var content: Any { get }
    var state: [AnyHashable:Any] { get }
}

public struct _StateWrapper<Content> : View, _AnyStateWrapper where Content : View {
    public var content: Any { body }
    public let body: Content
    public let state: [AnyHashable:Any]
    
    //: Register
    static func register() {
        PType.register(_StateWrapper<AnyView>.self)
    }
}
