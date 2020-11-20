//
//  JsonView.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public protocol JsonView: DynaCodable {
    var base: BaseView { get }
}

public struct BaseView  {
    public let anyView: (Any) -> AnyView
    public init<Content>(_ type: Content.Type) where Content : View {
        DynaType.register(type)
        anyView = { view in AnyView(view as! Content) }
    }
}
