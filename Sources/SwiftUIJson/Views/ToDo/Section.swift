//
//  Section.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Section: Encodable where Parent : View, Content : View, Footer : View {
    public func encode(to encoder: Encoder) throws {
    }
}
