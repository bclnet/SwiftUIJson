//
//  ScrollView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension ScrollView: Encodable where Content : View {
    public func encode(to encoder: Encoder) throws {
    }
}

extension _ScrollableLayoutView: Encodable where Data : RandomAccessCollection, Layout : _ScrollableLayout, Data.Element : View, Data.Index : Hashable {
    public func encode(to encoder: Encoder) throws {
    }
}

extension _ScrollView: Encodable where Provider : _ScrollableContentProvider {
    public func encode(to encoder: Encoder) throws {
    }
}

extension _ScrollViewRoot: Encodable where P : _ScrollableContentProvider {
    public func encode(to encoder: Encoder) throws {
    }
}
