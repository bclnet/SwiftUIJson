//
//  Stepper.swift (Binding, Step)
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension Stepper {
    public func hint<Content>(_ view: Content, step: Double) -> _StateWrapper<Self> where Content : View {
        _StateWrapper(body: self, state: ["step" : step])
    }
}

@available(iOS 13.0, OSX 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension Stepper: IAnyView, DynaCodable where Label : View, Label : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case label, configuration, step
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let label = try container.decode(Label.self, forKey: .label, dynaType: dynaType[0])
        let configuration = try container.decode(StepperStyleConfiguration.self, forKey: .configuration)
        let step = try? container.decodeIfPresent(Double.self, forKey: .step)
        guard var accessibilityValue = configuration.accessibilityValue else {
            self.init(onIncrement: configuration.onIncrement, onDecrement: configuration.onDecrement, onEditingChanged: configuration.onEditingChanged, label: { label })
            return
        }
        let binding = Binding<Double>(get: { () -> Double in accessibilityValue.value }, set: { value in accessibilityValue.value = value })
        if accessibilityValue.minValue == nil || accessibilityValue.maxValue == nil {
            self.init(value: binding, step: step!, onEditingChanged: configuration.onEditingChanged, label: { label })
            return
        }
        self.init(value: binding, in: accessibilityValue.minValue!...accessibilityValue.maxValue!, step: 1, onEditingChanged: configuration.onEditingChanged, label: { label })
    }
    public func encode(to encoder: Encoder) throws {
//        let context = encoder.userInfo[.jsonContext] as! JsonContext
        Mirror.assert(self, name: "Stepper", keys: ["label", "configuration"])
        let m = Mirror.children(reflecting: self)
        let label = m["label"]! as! Label
        let configuration = StepperStyleConfiguration(any: m["configuration"]!)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(label, forKey: .label)
        try container.encode(configuration, forKey: .configuration)
        if configuration.accessibilityValue != nil {
//            let state = context[self]
//            if state.isEmpty {
//                throw JsonContextError.hintNotFound(name: "Stepper", message: "please hint the step amount")
//            }
//            let step = state["step"]! as! Double
            let step = 1
            try container.encode(step, forKey: .step)
        }
    }
    //: Register
    static func register() {
        DynaType.register(Stepper<EmptyView>.self)
        DynaType.register(Stepper<AnyView>.self)
    }
        
    struct StepperStyleConfiguration: Codable {
        let onIncrement: (() -> ())?
        let onDecrement: (() -> ())?
        let onEditingChanged: (Bool) -> ()
        let accessibilityValue: AccessibilityAdjustableNumericValue?
        init(any: Any) {
            Mirror.assert(any, name: "StepperStyleConfiguration", keys: ["onIncrement", "onDecrement", "onEditingChanged", "accessibilityValue"])
            let m = Mirror.children(reflecting: any)
            onIncrement = m["onIncrement"]! as? (() -> ())
            onDecrement = m["onDecrement"]! as? (() -> ())
            onEditingChanged = m["onEditingChanged"]! as! (Bool) -> ()
            accessibilityValue = Mirror.optionalAny(AccessibilityAdjustableNumericValue.self, any: m["accessibilityValue"]!)
        }
        //: Codable
        enum CodingKeys: CodingKey {
            case onIncrement, onDecrement, onEditingChanged, accessibilityValue
        }
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            onIncrement = try container.decodeActionIfPresent(forKey: .onIncrement)
            onDecrement = try container.decodeActionIfPresent(forKey: .onDecrement)
            onEditingChanged = try container.decodeAction(Bool.self, forKey: .onEditingChanged)
            accessibilityValue = try? container.decodeIfPresent(AccessibilityAdjustableNumericValue.self, forKey: .accessibilityValue)
        }
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeActionIfPresent(onIncrement, forKey: .onIncrement)
            try container.encodeActionIfPresent(onDecrement, forKey: .onDecrement)
            try container.encodeAction(onEditingChanged, forKey: .onEditingChanged)
            try container.encodeIfPresent(accessibilityValue, forKey: .accessibilityValue)
        }
    }
}
