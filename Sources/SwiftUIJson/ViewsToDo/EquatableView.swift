//
//  EquatableView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension EquatableView: Encodable where Content : Equatable, Content : View {
    public func encode(to encoder: Encoder) throws {
    }
}
