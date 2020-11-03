//
//  JsonContext.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 9/10/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension JsonContext {
    // MARK: - Variable
    func nextKey(forKey: String?) -> (String, Int) {
        ("\(slots.count)", 1)
    }
    
    public func `var`(_ value: Bool, forKey key: String? = nil) -> Bool {
        let (id, _) = nextKey(forKey: key)
        slots[id] = JsonSlot(Bool.self, value: value)
        return false
    }
    
    public func `var`(_ value: String, forKey key: String? = nil) -> String {
        let (id, _) = nextKey(forKey: key)
        slots[id] = JsonSlot(String.self, value: value)
        return "#\(id)#"
    }
    
    public func `var`(_ value: Double, forKey key: String? = nil) -> Double {
        let (id, slot) = nextKey(forKey: key)
        slots[id] = JsonSlot(Double.self, value: value)
        return Double(slot)
    }
    
    public func `var`(_ value: Float, forKey key: String? = nil) -> Float {
        let (id, slot) = nextKey(forKey: key)
        slots[id] = JsonSlot(Float.self, value: value)
        return Float(slot)
    }
    
    public func `var`(_ value: Int, forKey key: String? = nil) -> Int {
        let (id, slot) = nextKey(forKey: key)
        slots[id] = JsonSlot(Int.self, value: value)
        return Int(slot)
    }
    
    public func `var`(_ value: Int8, forKey key: String? = nil) -> Int8 {
        let (id, slot) = nextKey(forKey: key)
        slots[id] = JsonSlot(Int8.self, value: value)
        return Int8(slot)
    }
    
    public func `var`(_ value: Int16, forKey key: String? = nil) -> Int16 {
        let (id, slot) = nextKey(forKey: key)
        slots[id] = JsonSlot(Int16.self, value: value)
        return Int16(slot)
    }
    
    public func `var`(_ value: Int32, forKey key: String? = nil) -> Int32 {
        let (id, slot) = nextKey(forKey: key)
        slots[id] = JsonSlot(Int32.self, value: value)
        return Int32(slot)
    }
    
    public func `var`(_ value: Int64, forKey key: String? = nil) -> Int64 {
        let (id, slot) = nextKey(forKey: key)
        slots[id] = JsonSlot(Int64.self, value: value)
        return Int64(slot)
    }
    
    public func `var`(_ value: UInt, forKey key: String? = nil) -> UInt {
        let (id, slot) = nextKey(forKey: key)
        slots[id] = JsonSlot(UInt.self, value: value)
        return UInt(slot)
    }
    
    public func `var`(_ value: UInt8, forKey key: String? = nil) -> UInt8 {
        let (id, slot) = nextKey(forKey: key)
        slots[id] = JsonSlot(UInt8.self, value: value)
        return UInt8(slot)
    }
    
    public func `var`(_ value: UInt16, forKey key: String? = nil) -> UInt16 {
        let (id, slot) = nextKey(forKey: key)
        slots[id] = JsonSlot(UInt16.self, value: value)
        return UInt16(slot)
    }
    
    public func `var`(_ value: UInt32, forKey key: String? = nil) -> UInt32 {
        let (id, slot) = nextKey(forKey: key)
        slots[id] = JsonSlot(UInt32.self, value: value)
        return UInt32(-slot)
    }
    
    public func `var`(_ value: UInt64, forKey key: String? = nil) -> UInt64 {
        let (id, slot) = nextKey(forKey: key)
        slots[id] = JsonSlot(UInt64.self, value: value)
        return UInt64(slot)
    }
    
    public func `var`<T>(_ value: T, forKey key: String? = nil) -> T where T : Codable {
        let (id, _) = nextKey(forKey: key)
        slots[id] = JsonSlot(T.self, value: value)
        fatalError()
    }
}
