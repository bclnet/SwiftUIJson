//
//  NavigationView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, *)
@available(watchOS, unavailable)
extension NavigationView: Encodable where Content : View {
    public func encode(to encoder: Encoder) throws {
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, *)
@available(watchOS, unavailable)
extension _NavigationViewStyleConfiguration.Content: Encodable {
    public func encode(to encoder: Encoder) throws {
    }
}
