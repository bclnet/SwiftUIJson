//
//  Accessibility.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

protocol AnyAccessibilityActionHandler {
    
}

struct AnyAccessibilityActionHandlerBox<Return>: AnyAccessibilityActionHandler {
    
}

struct AccessibilityVoidAction {
    
}

struct AccessibilityProperties: Convertible {
    let plist: PropertyList<AXViewTypeDescribingBox<ModifiedContent<Text, AccessibilityAttachmentModifier>>, AnyAccessibilityActionHandler>
    public init(any: Any) {
        Mirror.assert(any, name: "AccessibilityProperties", keys: ["plist"])
        plist = PropertyList(any: Mirror(reflecting: any).descendant("plist")!)
    }
}

struct AccessibilityAttachment: Convertible {
    let properties: AccessibilityProperties
    public init(any: Any) {
        Mirror.assert(any, name: "AccessibilityAttachment", keys: ["properties"])
        properties = AccessibilityProperties(any: Mirror(reflecting: any).descendant("properties")!)
    }
}

enum AccessibilityAdjustmentMethod: ConvertibleCodable {
    case stepper
    init(any: Any) {
        Mirror.assert(any, name: "AccessibilityAdjustmentMethod")
        switch String(reflecting: any) {
        case "SwiftUI.AccessibilityAdjustmentMethod.stepper": self = .stepper
        case let value: fatalError(value)
        }
    }
    //: Codable
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "stepper": self = .stepper
        case let value: fatalError(value)
        }
    }
    func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "AccessibilityAdjustmentMethod")
        var container = encoder.singleValueContainer()
        switch self {
        case .stepper: try container.encode("stepper")
        }
    }
}

struct AccessibilityAdjustableNumericValue: ConvertibleCodable {
    var value: Double
    let minValue: Double?
    let maxValue: Double?
    let adjustmentMethod: AccessibilityAdjustmentMethod?
    init(any: Any) {
        Mirror.assert(any, name: "AccessibilityAdjustableNumericValue", keys: ["value", "minValue", "maxValue", "adjustmentMethod"])
        let m = Mirror.children(reflecting: any)
        value = m["value"]! as! Double
        minValue = m["minValue"]! as? Double
        maxValue = m["maxValue"]! as? Double
        adjustmentMethod = Mirror.optionalAny(AccessibilityAdjustmentMethod.self, any: m["adjustmentMethod"]!)
    }
    //: Codable
    enum CodingKeys: CodingKey {
        case value, minValue, maxValue, adjustmentMethod
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(Double.self, forKey: .value)
        minValue = try? container.decodeIfPresent(Double.self, forKey: .minValue)
        maxValue = try? container.decodeIfPresent(Double.self, forKey: .maxValue)
        adjustmentMethod = try? container.decodeIfPresent(AccessibilityAdjustmentMethod.self, forKey: .adjustmentMethod)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encodeIfPresent(minValue, forKey: .minValue)
        try container.encodeIfPresent(maxValue, forKey: .maxValue)
        try container.encodeIfPresent(adjustmentMethod, forKey: .adjustmentMethod)
    }
}
