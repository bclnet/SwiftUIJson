//
//  ScrollView.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

extension ScrollView: IAnyView, DynaCodable where Content : View, Content : DynaCodable {
    public var anyView: AnyView { AnyView(self) }
    
    //: Codable
    enum CodingKeys: CodingKey {
        case axes, showsIndicators, content
    }
    public func encode(to encoder: Encoder) throws {
        Mirror.assert(self, name: "ScrollView", keys: ["configuration", "content"])
        let m = Mirror.children(reflecting: self)
        let configuration = ScrollViewConfiguration(any: m["configuration"]!)
        let content = m["content"]! as! Content
        var container = encoder.container(keyedBy: CodingKeys.self)
        if configuration.axes != .vertical { try container.encode(configuration.axes, forKey: .axes) }
        if !configuration.showsIndicators { try container.encode(configuration.showsIndicators, forKey: .showsIndicators) }
        try container.encode(content, forKey: .content)
    }
    public init(from decoder: Decoder, for ptype: PType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let axes = (try? container.decodeIfPresent(Axis.Set.self, forKey: .axes)) ?? .vertical
        let showsIndicators = (try? container.decodeIfPresent(Bool.self, forKey: .showsIndicators)) ?? true
        let content = try container.decode(Content.self, forKey: .content, ptype: ptype[0])
        self.init(axes, showsIndicators: showsIndicators, content: { content })
    }

    //: Register
    static func register() {
        PType.register(ScrollView<AnyView>.self)
    }
    
    struct ScrollViewConfiguration {
        let axes: Axis.Set
        let showsIndicators: Bool
        let automaticallyAdjustsContentInsets: Bool
        let contentInsets: EdgeInsets
        let alwaysBounceAxes: Axis.Set
        init(any: Any) {
            Mirror.assert(any, name: "ScrollViewConfiguration", keys: ["axes", "showsIndicators", "automaticallyAdjustsContentInsets", "contentInsets", "alwaysBounceAxes"])
            let m = Mirror.children(reflecting: any)
            axes = m["axes"]! as! Axis.Set
            showsIndicators = m["showsIndicators"]! as! Bool
            automaticallyAdjustsContentInsets = m["automaticallyAdjustsContentInsets"]! as! Bool
            contentInsets = m["contentInsets"]! as! EdgeInsets
            alwaysBounceAxes = m["alwaysBounceAxes"]! as! Axis.Set
        }
    }
}

//extension _ScrollableLayoutView where Data : RandomAccessCollection, Layout : _ScrollableLayout, Data.Element : View, Data.Index : Hashable {}
//extension _ScrollView where Provider : _ScrollableContentProvider {}
//extension _ScrollViewRoot where P : _ScrollableContentProvider {}


@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension PinnedScrollableViews: CaseIterable, Codable {
    public static let allCases: [Self] = [.sectionHeaders, .sectionFooters]
    
    //: Codable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for (_, element) in Self.allCases.enumerated() {
            if self.contains(element) {
                switch element {
                case .sectionHeaders: try container.encode("sectionHeaders")
                case .sectionFooters: try container.encode("sectionFooters")
                case let value: fatalError("\(value)")
//                default: try container.encode(String(rawValue)); return
                }
            }
        }
    }
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var elements: Self = []
        while !container.isAtEnd {
            switch try container.decode(String.self) {
            case "sectionHeaders": elements.insert(.sectionHeaders)
            case "sectionFooters": elements.insert(.sectionFooters)
            case let value: self.init(rawValue: RawValue(value)!); return
            }
        }
        self = elements
    }
}