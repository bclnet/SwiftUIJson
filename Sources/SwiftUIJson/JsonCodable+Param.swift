//
//  JsonCodable.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 9/10/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Bool {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> Bool where Content : View {
        JsonContext[view].var(self, forKey: key)
    }
}

extension StringProtocol {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> String where Content : View {
        JsonContext[view].var("\(self)", forKey: key)
    }
}

extension Double {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> Double where Content : View {
        JsonContext[view].var(self, forKey: key)
    }
}

extension Float {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> Float where Content : View {
        JsonContext[view].var(self, forKey: key)
    }
}

extension Int {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> Int where Content : View {
        JsonContext[view].var(self, forKey: key)
    }
}

extension Int8 {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> Int8 where Content : View {
        JsonContext[view].var(self, forKey: key)
    }
}

extension Int16 {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> Int16 where Content : View {
        JsonContext[view].var(self, forKey: key)
    }
}

extension Int32 {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> Int32 where Content : View {
        JsonContext[view].var(self, forKey: key)
    }
}

extension Int64 {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> Int64 where Content : View {
        JsonContext[view].var(self, forKey: key)
    }
}

extension UInt {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> UInt where Content : View {
        JsonContext[view].var(self, forKey: key)
    }
}

extension UInt8 {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> UInt8 where Content : View {
        JsonContext[view].var(self, forKey: key)
    }
}

extension UInt16 {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> UInt16 where Content : View {
        JsonContext[view].var(self, forKey: key)
    }
}

extension UInt32 {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> UInt32 where Content : View {
        JsonContext[view].var(self, forKey: key)
    }
}

extension UInt64 {
    public func `var`<Content>(_ view: Content, forKey key: String? = nil) -> UInt64 where Content : View {
        JsonContext[view].var(self, forKey: key)
    }
}
