//
//  _PagingView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension _PagingView: Encodable where Views : RandomAccessCollection, Views.Element : View, Views.Index : Hashable {
    public func encode(to encoder: Encoder) throws {
    }
}
