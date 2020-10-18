//
//  ModifiedContent.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

// MARK: - Preamble
public protocol JsonViewModifier {
    var anyView: AnyViewModifier { get }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct AnyViewModifier {
    public let base: Any
    public init(_ base: Any) {
        self.base = base
    }
}

// MARK: - First
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent: DynaCodable where Content : View, Content : DynaCodable, Modifier : ViewModifier, Modifier : Codable {
    //: Codable
    enum CodingKeys: CodingKey {
        case content, modifier
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType)
        let modifier = try container.decode(Modifier.self, forKey: .modifier)
        self.init(content: content, modifier: modifier)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.content, forKey: .content)
        try container.encode(self.modifier, forKey: .modifier)
    }
}

// MARK: - Accessibility
/// accessibilityAction(), accessibilityAction(named)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent {
//    public func accessibilityAction(_ actionKind: AccessibilityActionKind = .default, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier>
//    public func accessibilityAction(named name: Text, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier>
    
}
/// accessibilityAction(named), accessibilityAction(named)
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent {
//    public func accessibilityAction(named nameKey: LocalizedStringKey, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier>
//    public func accessibilityAction<S>(named name: S, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier> where S : StringProtocol
}


// MARK: - ViewModifier
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent where Content : ViewModifier, Modifier : ViewModifier {
}

// MARK: - DynamicViewContent
/// data
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent where Content : DynamicViewContent, Modifier : ViewModifier {
}

// MARK: - Scene
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Content : Scene, Modifier : _SceneModifier {
}

// MARK: - Accessibility 2
/// accessibilityHidden, accessibilityLabel, accessibilityValue, accessibilityHint, accessibilityInputLabels, accessibilityAddTraits, accessibilityRemoveTraits, accessibilityIdentifier, accessibilitySortPriority, accessibilityActivationPoint, accessibilityActivationPoint
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {
}

/// accessibilityLabel, accessibilityLabel, accessibilityValue, accessibilityValue, accessibilityHint, accessibilityHint, accessibilityInputLabels, accessibilityInputLabels,
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {
}

// MARK: - Accessibility Deprecated (todo)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {
    // todo
}

// MARK: - Accessibility 3
/// accessibilityScrollAction
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

}

// MARK: - Accessibility 3
/// accessibilityAdjustableAction
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {

}