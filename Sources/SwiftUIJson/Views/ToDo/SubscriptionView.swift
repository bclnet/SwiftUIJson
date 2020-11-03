//
//  SubscriptionView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI
import Combine

extension SubscriptionView: Encodable where PublisherType : Combine.Publisher, Content : View, PublisherType.Failure == Never {
    public func encode(to encoder: Encoder) throws {
    }
}
