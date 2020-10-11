//
//  _PullDownButton.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(OSX 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension _PullDownButton: Encodable where Label : View, Content : View {
    public func encode(to encoder: Encoder) throws {
    }
}

@available(OSX 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension _PullDownButtonContainer: Encodable where Label : View {
    public func encode(to encoder: Encoder) throws {
    }
}

@available(OSX 10.15, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension _PullDownButtonValue: Encodable where Style : _PullDownButtonStyle, Label : View {
    public func encode(to encoder: Encoder) throws {
    }
}
