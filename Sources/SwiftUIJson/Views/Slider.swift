//
//  Slider.swift (Range: -100...100, Step)
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Slider {
    public func hint<Content>(_ view: Content, start: Double) -> _StateWrapper<Self> where Content : View {
        _StateWrapper(body: self, state: ["start" : start])
    }
}

@available(iOS 13.0, OSX 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
extension Slider: IAnyView, DynaCodable where Label : View, Label : DynaCodable, ValueLabel : View, ValueLabel : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case value, from, till, step, onEditingChanged, maximumValueLabel, minimumValueLabel, label
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let value = try container.decode(Binding<Double>.self, forKey: .value)
        let from = try container.decode(Double.self, forKey: .from)
        let till = try container.decode(Double.self, forKey: .till)
        let step = try container.decodeIfPresent(Double.self, forKey: .step)
        let onEditingChanged = try container.decodeAction(Bool.self, forKey: .onEditingChanged)
        let maximumValueLabel = (try? container.decodeIfPresent(ValueLabel.self, forKey: .maximumValueLabel, dynaType: dynaType[1])) ?? (AnyView(EmptyView()) as! ValueLabel)
        let minimumValueLabel = (try? container.decodeIfPresent(ValueLabel.self, forKey: .minimumValueLabel, dynaType: dynaType[1])) ?? (AnyView(EmptyView()) as! ValueLabel)
        let label = try container.decode(Label.self, forKey: .label, dynaType: dynaType[0])
        if step == nil {
            self.init(value: value, in: from...till,
                      onEditingChanged: onEditingChanged,
                      minimumValueLabel: minimumValueLabel,
                      maximumValueLabel: maximumValueLabel,
                      label: { label })
        }
        else {
            self.init(value: value, in: from...till, step: step!,
                      onEditingChanged: onEditingChanged,
                      minimumValueLabel: minimumValueLabel,
                      maximumValueLabel: maximumValueLabel,
                      label: { label })
        }
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Slider", keys: ["_value", "discreteValueCount", "skipDistance", "onEditingChanged",
                                                   "hasCustomMinMaxValueLabels", "_maximumValueLabel", "_minimumValueLabel", "label",
                                                   "_style"])
        let m = Mirror.children(reflecting: self)
        let value = m["_value"]! as? Binding<Double>
        let discreteValueCount = m["discreteValueCount"]! as! Int
        let skipDistance = m["skipDistance"]! as! Double
        let onEditingChanged = m["onEditingChanged"]! as! (Bool) -> ()
        let hasCustomMinMaxValueLabels = m["hasCustomMinMaxValueLabels"]! as! Bool
        let maximumValueLabel = m["_maximumValueLabel"]! as! ValueLabel
        let minimumValueLabel = m["_minimumValueLabel"]! as! ValueLabel
        let label = m["label"]! as! Label
        let from: Double, till: Double, step: Double?
        if discreteValueCount == 0 {
            from = 0
            till = 100
            step = nil
        }
        else {
            from = 0
            till = 100 //Double(discreteValueCount - 1) * skipDistance
            step = 1.0 / skipDistance / till
        }
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(from, forKey: .from)
        try container.encode(till, forKey: .till)
        try container.encode(step, forKey: .step)
        try container.encodeAction(onEditingChanged, forKey: .onEditingChanged)
        if hasCustomMinMaxValueLabels {
            try container.encode(maximumValueLabel, forKey: .maximumValueLabel)
            try container.encode(minimumValueLabel, forKey: .minimumValueLabel)
        }
        try container.encode(label, forKey: .label)
    }
    //: Register
    static func register() {
        DynaType.register(Slider<AnyView, EmptyView>.self)
        DynaType.register(Slider<AnyView, AnyView>.self)
    }
}
