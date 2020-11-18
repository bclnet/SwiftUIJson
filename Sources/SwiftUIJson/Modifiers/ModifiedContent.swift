//
//  ModifiedContent.swift (Incomplete)
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

// MARK: - First
extension ModifiedContent: IAnyView, DynaCodable where Content : View, Content : DynaCodable, Modifier : ViewModifier {
    public var anyView: AnyView { AnyView(self) }
    //: Codable
    enum CodingKeys: CodingKey {
        case content, modifier
    }
    public init(from decoder: Decoder, for dynaType: DynaType) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let content = try container.decode(Content.self, forKey: .content, dynaType: dynaType[0])
        let modifier = try container.decode(AnyViewModifier.self, forKey: .modifier, dynaType: dynaType[1]) as! Modifier
        self.init(content: content, modifier: modifier)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try container.encodeAny(AnyViewModifier(modifier), forKey: .modifier)
    }
    //: Register
    static func register() {
        DynaType.register(ModifiedContent<AnyView, AnyViewModifier>.self)
    }
}

//extension _ViewModifier_Content {}

//// MARK: - Accessibility
///// accessibilityAction(), accessibilityAction(named)
//extension ModifiedContent {
////    public func accessibilityAction(_ actionKind: AccessibilityActionKind = .default, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier>
////    public func accessibilityAction(named name: Text, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier>
//    
//}
///// accessibilityAction(named), accessibilityAction(named)
//@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
//extension ModifiedContent {
////    public func accessibilityAction(named nameKey: LocalizedStringKey, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier>
////    public func accessibilityAction<S>(named name: S, _ handler: @escaping () -> Void) -> ModifiedContent<Content, Modifier> where S : StringProtocol
//}
//
//
//// MARK: - ViewModifier
//extension ModifiedContent where Content : ViewModifier, Modifier : ViewModifier {
//}
//
//// MARK: - DynamicViewContent
///// data
//extension ModifiedContent where Content : DynamicViewContent, Modifier : ViewModifier {
//}
//
//// MARK: - Scene
//extension ModifiedContent where Content : Scene, Modifier : _SceneModifier {
//}
//
//// MARK: - Accessibility 2
///// accessibilityHidden, accessibilityLabel, accessibilityValue, accessibilityHint, accessibilityInputLabels, accessibilityAddTraits, accessibilityRemoveTraits, accessibilityIdentifier, accessibilitySortPriority, accessibilityActivationPoint, accessibilityActivationPoint
//@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
//extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {
//}
//
///// accessibilityLabel, accessibilityLabel, accessibilityValue, accessibilityValue, accessibilityHint, accessibilityHint, accessibilityInputLabels, accessibilityInputLabels,
//@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
//extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {
//}
//
//// MARK: - Accessibility Deprecated (todo)
//extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {
//    // todo
//}
//
//// MARK: - Accessibility 3
///// accessibilityScrollAction
//extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {
//
//}
//
//// MARK: - Accessibility 3
///// accessibilityAdjustableAction
//extension ModifiedContent where Modifier == AccessibilityAttachmentModifier {
//
//}
