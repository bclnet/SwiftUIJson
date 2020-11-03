//
//  NSItemProvider.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 8/22/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import Foundation

extension NSItemProvider: WrapableCodeable {
    enum ItemProviderError: Error {
        case error(description: String)
    }
    public var wrapValue: NSItemProvider { self }
    public static func decode(from decoder: Decoder) throws -> Self {
        let itemProvider = NSItemProvider()
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            let key = try container.decode(String.self).components(separatedBy: ":")
            switch key[1] {
            case "": break
            case "data":
                let data:Data? = key.count == 2 ? try container.decode(Data?.self) : nil
                let error: ItemProviderError? = key.count == 3 ? .error(description: try container.decode(String.self)) : nil
                itemProvider.registerDataRepresentation(forTypeIdentifier: key[0], visibility: .all) { handler in
                    handler(data, error)
                    return nil
                }
            case "item":
                let coder = try NSKeyedUnarchiver(forReadingFrom: try container.decode(Data.self))
                let data:NSSecureCoding? = coder.decodeObject() as? NSSecureCoding
                let error: ItemProviderError? = key.count == 3 ? .error(description: try container.decode(String.self)) : nil
                itemProvider.registerItem(forTypeIdentifier: key[0]) { handler, _, _ in
                    handler?(data, error)
                }
            case let unrecognized: fatalError(unrecognized)
            }
        }
        return itemProvider as! Self
    }
    
    public func encode(to encoder: Encoder) throws {
        let group = DispatchGroup()
        var container = encoder.unkeyedContainer()
        for id in registeredTypeIdentifiers {
            if id == "" {
                try container.encode("\(id):")
                continue
            }
            var key: String!, item: NSSecureCoding?, data: Data?, error: Error?
            group.enter()
            loadDataRepresentation(forTypeIdentifier: id) { d, e in
                key = "\(id):data"
                data = d; error = e
                group.leave()
            }
            //            loadItem(forTypeIdentifier: id, options: nil) { d, e in
            //                key = "\(id):item"
            //                item = d; error = e
            //                group.leave()
            //            }
            group.wait()
            try container.encode(error == nil ? key! : "\(key!):error")
            if item != nil {
                let coder = NSKeyedArchiver(requiringSecureCoding: false)
                coder.encode(item)
                try container.encode(coder.encodedData)
            }
            else if data != nil { try container.encode(data!) }
            else { try container.encodeNil() }
        }
    }
    
    struct _CodingKey: CodingKey {
        let stringValue: String
        let intValue: Int?
        init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = Int(stringValue)
        }
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }
    
    /*
     //import CoreServices
     static func decodeType2(id: String) -> NSItemProvider {
     switch id as CFString {
     case kUTTypeDYN: return NSItemProvider()
     case kUTTypeFileURL: return NSItemProvider(contentsOf: URL(fileURLWithPath: ""))!
     case kUTTypeURL: return NSItemProvider(contentsOf: URL(string: ""))!
     case kUTTypeUTF8PlainText: return NSItemProvider(object: "" as NSString)
     case let unrecognized: fatalError(id)
     }
     }
     
     //let kUTTypeDYN: CFString = "dyn.age8u"
     static func encodeType2(id: String, data: NSSecureCoding) throws {
     switch id as CFString {
     // missing
     case kUTTypeDYN: break
     // item
     case kUTTypeItem: break
     case kUTTypeContent: break
     case kUTTypeCompositeContent: break
     case kUTTypeMessage: break
     case kUTTypeContact: break
     case kUTTypeArchive: break
     case kUTTypeDiskImage: break
     // data
     case kUTTypeData: break
     case kUTTypeDirectory: break
     case kUTTypeResolvable: break
     case kUTTypeSymLink: break
     case kUTTypeExecutable: break
     case kUTTypeMountPoint: break
     case kUTTypeAliasFile: break
     case kUTTypeAliasRecord: break
     case kUTTypeURLBookmarkData: break
     // url
     case kUTTypeURL, kUTTypeFileURL:
     switch data {
     case let data as Data:
     let m = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [Any]
     let obj = (url: m[0] as! CFString, file: m[1] as! CFString, unk2: m[2] as! [AnyHashable:Any])
     print(obj)
     case let unrecognized: fatalError("\(type(of: data))")
     }
     break
     // text
     case kUTTypeText: break
     case kUTTypePlainText: break
     case kUTTypeUTF8PlainText: break
     case kUTTypeUTF16ExternalPlainText: break
     case kUTTypeUTF16PlainText: break
     case kUTTypeDelimitedText: break
     case kUTTypeCommaSeparatedText: break
     case kUTTypeTabSeparatedText: break
     case kUTTypeUTF8TabSeparatedText: break
     case kUTTypeRTF: break
     // xml
     case kUTTypeHTML: break
     case kUTTypeXML: break
     // source
     case kUTTypeSourceCode: break
     case kUTTypeAssemblyLanguageSource: break
     case kUTTypeCSource: break
     case kUTTypeObjectiveCSource: break
     case kUTTypeSwiftSource: break
     case kUTTypeCPlusPlusSource: break
     case kUTTypeObjectiveCPlusPlusSource: break
     case kUTTypeCHeader: break
     case kUTTypeCPlusPlusHeader: break
     case kUTTypeJavaSource: break
     // script
     case kUTTypeScript: break
     case kUTTypeAppleScript: break
     case kUTTypeOSAScript: break
     case kUTTypeOSAScriptBundle: break
     case kUTTypeJavaScript: break
     case kUTTypeShellScript: break
     case kUTTypePerlScript: break
     case kUTTypePythonScript: break
     case kUTTypeRubyScript: break
     case kUTTypePHPScript: break
     // property
     case kUTTypeJSON: break
     case kUTTypePropertyList: break
     case kUTTypeXMLPropertyList: break
     case kUTTypeBinaryPropertyList: break
     // document
     case kUTTypePDF: break
     case kUTTypeRTFD: break
     case kUTTypeFlatRTFD: break
     case kUTTypeTXNTextAndMultimediaData: break
     case kUTTypeWebArchive: break
     // image
     case kUTTypeImage:
     let myImage: UIImage?
     switch data {
     case let image as UIImage:
     myImage = image
     case let data as Data:
     myImage = UIImage(data: data)
     case let url as URL:
     myImage = UIImage(contentsOfFile: url.path)
     case let unrecognized:
     print("Unexpected data:", type(of: data))
     myImage = nil
     }
     print(myImage?.description ?? "{nil}")
     break
     case kUTTypeJPEG: break
     case kUTTypeJPEG2000: break
     case kUTTypeTIFF: break
     case kUTTypePICT: break
     case kUTTypeGIF: break
     case kUTTypePNG: break
     case kUTTypeQuickTimeImage: break
     case kUTTypeAppleICNS: break
     case kUTTypeBMP: break
     case kUTTypeICO: break
     case kUTTypeRawImage: break
     case kUTTypeScalableVectorGraphics: break
     case kUTTypeLivePhoto: break
     // media
     case kUTTypeAudiovisualContent: break
     case kUTTypeMovie: break
     case kUTTypeVideo: break
     case kUTTypeAudio: break
     case kUTTypeQuickTimeMovie: break
     case kUTTypeMPEG: break
     case kUTTypeMPEG2Video: break
     case kUTTypeMPEG2TransportStream: break
     case kUTTypeMP3: break
     case kUTTypeMPEG4: break
     case kUTTypeMPEG4Audio: break
     case kUTTypeAppleProtectedMPEG4Audio: break
     case kUTTypeAppleProtectedMPEG4Video: break
     case kUTTypeAVIMovie: break
     case kUTTypeAudioInterchangeFileFormat: break
     case kUTTypeWaveformAudio: break
     case kUTTypeMIDIAudio: break
     // play list
     case kUTTypePlaylist: break
     case kUTTypeM3UPlaylist: break
     // package
     case kUTTypeFolder: break
     case kUTTypeVolume: break
     case kUTTypePackage: break
     case kUTTypeBundle: break
     case kUTTypePluginBundle: break
     case kUTTypeSpotlightImporter: break
     case kUTTypeQuickLookGenerator: break
     case kUTTypeXPCService: break
     case kUTTypeFramework: break
     // executable
     case kUTTypeApplication: break
     case kUTTypeApplicationBundle: break
     case kUTTypeApplicationFile: break
     case kUTTypeUnixExecutable: break
     case kUTTypeWindowsExecutable: break
     case kUTTypeJavaClass: break
     case kUTTypeJavaArchive: break
     case kUTTypeSystemPreferencesPane: break
     // zip
     case kUTTypeGNUZipArchive: break
     case kUTTypeBzip2Archive: break
     case kUTTypeZipArchive: break
     // database
     case kUTTypeSpreadsheet: break
     case kUTTypePresentation: break
     case kUTTypeDatabase: break
     // message type
     case kUTTypeVCard: break
     case kUTTypeToDoItem: break
     case kUTTypeCalendarEvent: break
     case kUTTypeEmailMessage: break
     // locations
     case kUTTypeInternetLocation: break
     // other
     case kUTTypeInkText: break
     case kUTTypeFont: break
     case kUTTypeBookmark: break
     case kUTType3DContent: break
     case kUTTypePKCS12: break
     case kUTTypeX509Certificate: break
     case kUTTypeElectronicPublication: break
     case kUTTypeLog: break
     case let unrecognized: fatalError(id)
     }
     }
     */
}
