//
//  DatePicker.swift (Incomplete)
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension DatePicker: IAnyView, DynaCodable where Label : View, Label : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case maximumDate, displayedComponents, label, selection, minimumDate
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let maximumDate = try? container.decodeIfPresent(Date.self, forKey: .maximumDate)
        let displayedComponents = try container.decode(DatePickerComponents.self, forKey: .displayedComponents)
        let label = try container.decode(Label.self, forKey: .label, dynaType: dynaType[0])
        let selection = try container.decode(Binding<Date>.self, forKey: .selection)
        let minimumDate = try? container.decodeIfPresent(Date.self, forKey: .minimumDate)
        if minimumDate == nil && maximumDate == nil { self.init(selection: selection, displayedComponents: displayedComponents, label: { label }) }
        else if minimumDate == nil && maximumDate == nil { self.init(selection: selection, in: minimumDate!...maximumDate!, displayedComponents: displayedComponents, label: { label }) }
        else if minimumDate != nil { self.init(selection: selection, in: minimumDate!..., displayedComponents: displayedComponents, label: { label }) }
        else if maximumDate != nil { self.init(selection: selection, in: ...maximumDate!, displayedComponents: displayedComponents, label: { label }) }
        else { fatalError() }
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "DatePicker", keys: ["maximumDate", "displayedComponents", "label", "selection", "minimumDate"])
        let m = Mirror.children(reflecting: self)
        let maximumDate = m["maximumDate"]! as? Date
        let displayedComponents = m["displayedComponents"]! as! DatePickerComponents
        let label = m["label"]! as! Label
        let selection = m["selection"]! as! Binding<Date>
        let minimumDate = m["minimumDate"]! as? Date
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(maximumDate, forKey: .maximumDate)
        try container.encode(displayedComponents, forKey: .displayedComponents)
        try container.encode(label, forKey: .label)
        try container.encode(selection, forKey: .selection)
        try container.encodeIfPresent(minimumDate, forKey: .minimumDate)
    }
    //: Register
    static func register() {
        DynaType.register(DatePicker<AnyView>.self)
    }
}

extension DatePickerComponents: Codable {
    public static let allCases: [Self] = [.hourAndMinute, .date]
    //: Codable
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: Self = []
        while !container.isAtEnd {
            switch try container.decode(String.self) {
            case "hourAndMinute": elements.insert(.hourAndMinute)
            case "date": elements.insert(.date)
            case let unrecognized: self.init(rawValue: RawValue(unrecognized)!); return
            }
        }
        self = elements
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for (_, element) in Self.allCases.enumerated() {
            if self.contains(element) {
                switch element {
                case .hourAndMinute: try container.encode("hourAndMinute")
                case .date: try container.encode("date")
                case let unrecognized: fatalError("\(unrecognized)")
//                default: try container.encode(String(rawValue)); return
                }
            }
        }
    }
}
