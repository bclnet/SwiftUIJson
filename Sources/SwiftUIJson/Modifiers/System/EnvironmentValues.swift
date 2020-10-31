//
//  EnvironmentValues.swift
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI
import CoreData

//// MARK: - Style:5161
//extension Environment {}
//// MARK: - Style:5259
//extension EnvironmentKey {}
//// MARK: - Style:5277
//extension EnvironmentObject {}
//// MARK: - Style:5387
//extension EnvironmentValues {}

// MARK: - Style:5437
extension EnvironmentValues {
    static func find<Root, Value>(keyPath: KeyPath<Root, Value>) -> String! {
        switch keyPath {
        case \EnvironmentValues.disableAutocorrection: return "disableAutocorrection"
        case \EnvironmentValues.sizeCategory: return "sizeCategory"
        case \EnvironmentValues.managedObjectContext: return "managedObjectContext"
        case \EnvironmentValues.undoManager: return "undoManager"
        case \EnvironmentValues.layoutDirection: return "layoutDirection"
        case \EnvironmentValues.redactionReasons: return "redactionReasons"
        case \EnvironmentValues.scenePhase: return "scenePhase"
        case \EnvironmentValues.defaultMinListRowHeight: return "defaultMinListRowHeight"
        case \EnvironmentValues.defaultMinListHeaderHeight: return "defaultMinListHeaderHeight"
        case \EnvironmentValues.isEnabled: return "isEnabled"
        case \EnvironmentValues.isFocused: return "isFocused"
        case \EnvironmentValues.font: return "font"
        case \EnvironmentValues.displayScale: return "displayScale"
        case \EnvironmentValues.imageScale: return "imageScale"
        case \EnvironmentValues.pixelLength: return "pixelLength"
        case \EnvironmentValues.legibilityWeight: return "legibilityWeight"
        case \EnvironmentValues.locale: return "locale"
        case \EnvironmentValues.calendar: return "calendar"
        case \EnvironmentValues.timeZone: return "timeZone"
        case \EnvironmentValues.colorScheme: return "colorScheme"
        case \EnvironmentValues.colorSchemeContrast: return "colorSchemeContrast"
        case \EnvironmentValues.horizontalSizeClass: return "horizontalSizeClass"
        case \EnvironmentValues.verticalSizeClass: return "verticalSizeClass"
        case \EnvironmentValues.accessibilityEnabled: return "accessibilityEnabled"
        case \EnvironmentValues.accessibilityDifferentiateWithoutColor: return "accessibilityDifferentiateWithoutColor"
        case \EnvironmentValues.accessibilityReduceTransparency: return "accessibilityReduceTransparency"
        case \EnvironmentValues.accessibilityReduceMotion: return "accessibilityReduceMotion"
        case \EnvironmentValues.accessibilityInvertColors: return "accessibilityInvertColors"
        case \EnvironmentValues.accessibilityShowButtonShapes: return "accessibilityShowButtonShapes"
        case \EnvironmentValues.openURL: return "openURL"
        case \EnvironmentValues.multilineTextAlignment: return "multilineTextAlignment"
        case \EnvironmentValues.truncationMode: return "truncationMode"
        case \EnvironmentValues.lineSpacing: return "lineSpacing"
        case \EnvironmentValues.allowsTightening: return "allowsTightening"
        case \EnvironmentValues.lineLimit: return "lineLimit"
        case \EnvironmentValues.minimumScaleFactor: return "minimumScaleFactor"
        case \EnvironmentValues.textCase: return "textCase"
        case \EnvironmentValues.editMode: return "editMode"
        case \EnvironmentValues.presentationMode: return "presentationMode"
        default: return nil
        }
    }
    //: Register
    // MARK: - Style:5387
    static func register() {
        DynaType.register(EnvironmentValues.self)
        // MARK: - Style:5437
        if #available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 999, *) {
            DynaType.register(WritableKeyPath<EnvironmentValues, Bool?>.self, actions: ["disableAutocorrection": { () -> WritableKeyPath<EnvironmentValues, Bool?> in \.disableAutocorrection }])
        }
        // MARK: - Style:5449
        DynaType.register(WritableKeyPath<EnvironmentValues, ContentSizeCategory>.self, actions: ["sizeCategory": { () -> WritableKeyPath<EnvironmentValues, ContentSizeCategory> in \.sizeCategory }])
        // MARK: - Style:5458
        DynaType.register(WritableKeyPath<EnvironmentValues, NSManagedObjectContext>.self, actions: ["managedObjectContext": { () -> WritableKeyPath<EnvironmentValues, NSManagedObjectContext> in \.managedObjectContext }])
        // MARK: - Style:5464
        DynaType.register(KeyPath<EnvironmentValues, UndoManager?>.self, actions: ["undoManager": { () -> KeyPath<EnvironmentValues, UndoManager?> in \.undoManager }])
        // MARK: - Style:5475
        DynaType.register(WritableKeyPath<EnvironmentValues, LayoutDirection>.self, actions: ["layoutDirection": { () -> WritableKeyPath<EnvironmentValues, LayoutDirection> in \.layoutDirection }])
        // MARK: - Style:5485
        DynaType.register(WritableKeyPath<EnvironmentValues, RedactionReasons>.self, actions: ["redactionReasons": { () -> WritableKeyPath<EnvironmentValues, RedactionReasons> in \.redactionReasons }])
        // MARK: - Style:5492
        DynaType.register(WritableKeyPath<EnvironmentValues, ScenePhase>.self, actions: ["scenePhase": { () -> WritableKeyPath<EnvironmentValues, ScenePhase> in \.scenePhase }])
        // MARK: - Style:6605
        DynaType.register(WritableKeyPath<EnvironmentValues, CGFloat>.self, actions: ["defaultMinListRowHeight": { () -> WritableKeyPath<EnvironmentValues, CGFloat> in \.defaultMinListRowHeight }])
        DynaType.register(WritableKeyPath<EnvironmentValues, CGFloat?>.self, actions: ["defaultMinListHeaderHeight": { () -> WritableKeyPath<EnvironmentValues, CGFloat?> in \.defaultMinListHeaderHeight }])
        // MARK: - Style:5517
        DynaType.register(WritableKeyPath<EnvironmentValues, Bool>.self, actions: ["isEnabled": { () -> WritableKeyPath<EnvironmentValues, Bool> in \.isEnabled }])
        // MARK: - Style:5527
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            DynaType.register(KeyPath<EnvironmentValues, Bool>.self, actions: ["isFocused": { () -> KeyPath<EnvironmentValues, Bool> in \.isFocused }])
        }
        // MARK: - Style:5536
        DynaType.register(WritableKeyPath<EnvironmentValues, Font?>.self, actions: ["font": { () -> WritableKeyPath<EnvironmentValues, Font?> in \.font }])
        DynaType.register(WritableKeyPath<EnvironmentValues, CGFloat>.self, actions: ["displayScale": { () -> WritableKeyPath<EnvironmentValues, CGFloat> in \.displayScale }])
        if #available(iOS 13.0, macOS 11.0, tvOS 13.0, watchOS 6.0, *) {
            DynaType.register(WritableKeyPath<EnvironmentValues, Image.Scale>.self, actions: ["imageScale": { () -> WritableKeyPath<EnvironmentValues, Image.Scale> in \.imageScale }])
        }
        DynaType.register(WritableKeyPath<EnvironmentValues, CGFloat>.self, actions: ["pixelLength": { () -> KeyPath<EnvironmentValues, CGFloat> in \.pixelLength }])
        DynaType.register(WritableKeyPath<EnvironmentValues, LegibilityWeight?>.self, actions: ["legibilityWeight": { () -> WritableKeyPath<EnvironmentValues, LegibilityWeight?> in \.legibilityWeight }])
        DynaType.register(WritableKeyPath<EnvironmentValues, Locale>.self, actions: ["locale": { () -> WritableKeyPath<EnvironmentValues, Locale> in \.locale }])
        DynaType.register(WritableKeyPath<EnvironmentValues, Calendar>.self, actions: ["calendar": { () -> WritableKeyPath<EnvironmentValues, Calendar> in \.calendar }])
        DynaType.register(WritableKeyPath<EnvironmentValues, TimeZone>.self, actions: ["timeZone": { () -> WritableKeyPath<EnvironmentValues, TimeZone> in \.timeZone }])
        DynaType.register(WritableKeyPath<EnvironmentValues, ColorScheme>.self, actions: ["colorScheme": { () -> WritableKeyPath<EnvironmentValues, ColorScheme> in \.colorScheme }])
        DynaType.register(KeyPath<EnvironmentValues, ColorSchemeContrast>.self, actions: ["colorSchemeContrast": { () -> KeyPath<EnvironmentValues, ColorSchemeContrast> in \.colorSchemeContrast }])
        // MARK: - Style:5595
        if #available(iOS 13.0, macOS 999, tvOS 999, watchOS 999, *) {
            DynaType.register(WritableKeyPath<EnvironmentValues, UserInterfaceSizeClass?>.self, actions: [
                "horizontalSizeClass": { () -> WritableKeyPath<EnvironmentValues, UserInterfaceSizeClass?> in \.horizontalSizeClass },
                "verticalSizeClass": { () -> WritableKeyPath<EnvironmentValues, UserInterfaceSizeClass?> in \.verticalSizeClass }
            ])
        }
        // MARK: - Style:5614
        DynaType.register(WritableKeyPath<EnvironmentValues, Bool>.self, actions: ["accessibilityEnabled": { () -> WritableKeyPath<EnvironmentValues, Bool> in \.accessibilityEnabled }])
        // MARK: - Style:5622
        DynaType.register(KeyPath<EnvironmentValues, Bool>.self, actions: [
            "accessibilityDifferentiateWithoutColor": { () -> KeyPath<EnvironmentValues, Bool> in \.accessibilityDifferentiateWithoutColor },
            "accessibilityReduceTransparency": { () -> KeyPath<EnvironmentValues, Bool> in \.accessibilityReduceTransparency },
            "accessibilityReduceMotion": { () -> KeyPath<EnvironmentValues, Bool> in \.accessibilityReduceMotion },
            "accessibilityInvertColors": { () -> KeyPath<EnvironmentValues, Bool> in \.accessibilityInvertColors },
            "accessibilityShowButtonShapes": { () -> KeyPath<EnvironmentValues, Bool> in \.accessibilityShowButtonShapes },
        ])
        // MARK: - Style:5658
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            DynaType.register(KeyPath<EnvironmentValues, OpenURLAction>.self, actions: ["openURL": { () -> KeyPath<EnvironmentValues, OpenURLAction> in \.openURL }])
        }
        // MARK: - Style:5665
        DynaType.register(WritableKeyPath<EnvironmentValues, TextAlignment>.self, actions: ["multilineTextAlignment": { () -> WritableKeyPath<EnvironmentValues, TextAlignment> in \.multilineTextAlignment }])
        DynaType.register(WritableKeyPath<EnvironmentValues, Text.TruncationMode>.self, actions: ["truncationMode": { () -> WritableKeyPath<EnvironmentValues, Text.TruncationMode> in \.truncationMode }])
        DynaType.register(WritableKeyPath<EnvironmentValues, CGFloat>.self, actions: ["lineSpacing": { () -> WritableKeyPath<EnvironmentValues, CGFloat> in \.lineSpacing }])
        DynaType.register(WritableKeyPath<EnvironmentValues, Bool>.self, actions: ["allowsTightening": { () -> WritableKeyPath<EnvironmentValues, Bool> in \.allowsTightening }])
        DynaType.register(WritableKeyPath<EnvironmentValues, Int?>.self, actions: ["lineLimit": { () -> WritableKeyPath<EnvironmentValues, Int?> in \.lineLimit }])
        DynaType.register(WritableKeyPath<EnvironmentValues, CGFloat>.self, actions: ["minimumScaleFactor": { () -> WritableKeyPath<EnvironmentValues, CGFloat> in \.minimumScaleFactor }])
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            DynaType.register(WritableKeyPath<EnvironmentValues, Text.Case?>.self, actions: ["textCase": { () -> WritableKeyPath<EnvironmentValues, Text.Case?> in \.textCase }])
        }
        // MARK: - Style:5738
        if #available(iOS 13.0, macOS 999, tvOS 13.0, watchOS 999, *) {
            DynaType.register(WritableKeyPath<EnvironmentValues, Binding<EditMode>?>.self, actions: ["editMode": { () -> WritableKeyPath<EnvironmentValues, Binding<EditMode>?> in \.editMode }])
        }
        // MARK: - Style:5750
        DynaType.register(KeyPath<EnvironmentValues, Binding<PresentationMode>>.self, actions: ["presentationMode": { () -> KeyPath<EnvironmentValues, Binding<PresentationMode>> in \.presentationMode }])
    }
}

// MARK: - Style:5759
/// resolve
extension EnvironmentalModifier {
    //TODO:
}
