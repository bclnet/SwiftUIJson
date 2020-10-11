//
//  SwiftUI.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
@available(OSX, unavailable)
@available(watchOS, unavailable)
extension _UIHostingView: Encodable where Content : View {
    public func encode(to encoder: Encoder) throws {
        fatalError("_UIHostingView")
    }
}

@available(iOS 13.0, tvOS 13.0, *)
@available(OSX, unavailable)
@available(watchOS, unavailable)
extension UIHostingController: Encodable where Content : View {
    public func encode(to encoder: Encoder) throws {
        fatalError("UIHostingController")
    }
}
