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
        case label, discreteValueCount, onEditingChanged, value, maximumValueLabel, minimumValueLabel, skipDistance
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let label = try container.decode(Label.self, forKey: .label, dynaType: dynaType[0])
        let discreteValueCount = try container.decode(Int.self, forKey: .discreteValueCount)
        let onEditingChanged = try container.decodeAction(Bool.self, forKey: .onEditingChanged)
        let value = try container.decode(Binding<Double>.self, forKey: .value)
        let maximumValueLabel = try container.decodeIfPresent(ValueLabel.self, forKey: .maximumValueLabel, dynaType: dynaType[1]) ?? (EmptyView() as! ValueLabel)
        let minimumValueLabel = try container.decodeIfPresent(ValueLabel.self, forKey: .minimumValueLabel, dynaType: dynaType[1]) ?? (EmptyView() as! ValueLabel)
        let skipDistance = try container.decode(Double.self, forKey: .skipDistance)
        let step = 1.0 / skipDistance / Double(discreteValueCount - 1)
        let from: Double = 0
        let till: Double = Double(discreteValueCount - 1)
        self.init(value: value, in: from...till, step: step,
                  onEditingChanged: onEditingChanged,
                  minimumValueLabel: minimumValueLabel,
                  maximumValueLabel: maximumValueLabel,
                  label: { label })
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "Slider", keys: ["_style", "label", "discreteValueCount", "onEditingChanged", "_value", "_maximumValueLabel", "_minimumValueLabel", "hasCustomMinMaxValueLabels", "skipDistance"])
        let m = Mirror.children(reflecting: self)
        let label = m["label"]! as! Label
        let discreteValueCount = m["discreteValueCount"]! as! Int
        let onEditingChanged = m["onEditingChanged"]! as! (Bool) -> ()
        let value = m["_value"]! as? Binding<Double>
        let maximumValueLabel = m["_maximumValueLabel"]! as! ValueLabel
        let minimumValueLabel = m["_minimumValueLabel"]! as! ValueLabel
        let hasCustomMinMaxValueLabels = m["hasCustomMinMaxValueLabels"]! as! Bool
        let skipDistance = m["skipDistance"]! as! Double
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(label, forKey: .label)
        try container.encode(discreteValueCount, forKey: .discreteValueCount)
        try container.encodeAction(onEditingChanged, forKey: .onEditingChanged)
        try container.encode(value, forKey: .value)
        if hasCustomMinMaxValueLabels {
            try container.encode(maximumValueLabel, forKey: .maximumValueLabel)
            try container.encode(minimumValueLabel, forKey: .minimumValueLabel)
        }
        try container.encode(skipDistance, forKey: .skipDistance)
    }
    //: Register
    static func register() {
        DynaType.register(Slider<AnyView, EmptyView>.self)
        DynaType.register(Slider<AnyView, AnyView>.self)
    }
}
