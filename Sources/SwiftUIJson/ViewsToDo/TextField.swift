//
//  TextField.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension TextField: JsonView {
    public var anyView: AnyView { AnyView(self) }
}

extension TextField: Encodable where Label : View {
    public func encode(to encoder: Encoder) throws {
    }
}

extension _TextFieldStyleLabel: Encodable {
    public func encode(to encoder: Encoder) throws {
    }
}
