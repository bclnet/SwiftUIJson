//
//  JsonPreview.swift
//  SwiftUIJson
//
//  Created by Sky Morey on 9/10/20.
//  Copyright © 2020 Sky Morey. All rights reserved.
//

import SwiftUI

public struct JsonPreview<Content>: View where Content: View {
    
    /// The json preview's content.
    public let content: Content

    /// The json preview's content.
    public let content2: AnyView
    
    /// The json preview's data.
    public var data: Data
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        
        // data
        let view = self.content
        let context = JsonContext[view]
        defer {
            JsonContext.remove(view)
        }
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            data = try encoder.encode(JsonUI(view: view, context: context))
        } catch DynaTypeError.typeNotCodable(let mode, let named) {
            data = "typeNotCodable mode: \(mode) named: \(named)".data(using: .utf8)!
            content2 = AnyView(Text("ERROR"))
            return
        } catch {
            data = "\(error)".data(using: .utf8)!
            content2 = AnyView(Text("ERROR"))
            return
        }
        
        // content2
        do {
            let decoder = JSONDecoder()
            decoder.userInfo[.json] = data
            let jsonUI = try decoder.decode(JsonUI.self, from: data)
            content2 = jsonUI.anyView ?? AnyView(Text("ERROR:notAnyView"))
        } catch DynaTypeError.typeNotFound {
            content2 = AnyView(Text("ERROR:typeNotFound"))
        } catch DynaTypeError.typeParseError {
            content2 = AnyView(Text("ERROR:typeParseError"))
        } catch DynaTypeError.typeNameError(let actual, let expected) {
            content2 = AnyView(Text("ERROR:typeNameError actual: \(actual) expected: \(expected)"))
        } catch DynaTypeError.typeNotCodable(let mode, let key) {
            content2 = AnyView(Text("ERROR:typeNotCodable mode: \(mode) named: \(key)"))
        } catch {
            content2 = AnyView(Text("ERROR:\(error)" as String))
            //data = "\(error)\n".data(using: .utf8)! + data
            return
        }
    }
            
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    content
                        .frame(width: geometry.size.width / 2, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black, lineWidth: 4)
                        )
                    content2
                        .frame(width: geometry.size.width / 2, height: geometry.size.height * 0.7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black, lineWidth: 4)
                        )
                }
                Spacer()
                ZStack {
                    ScrollView {
                        HStack {
                            Text(String(data: data, encoding: .utf8)!)
                            Spacer()
                        }
                        .padding()
                    }
                    VStack {
                        HStack(alignment: .top) {
                            Spacer()
                            Button(action: {
                                #if os(macOS)
                                NSPasteboard.general.setString(String(data: data, encoding: .utf8)!, forType: .string)
                                #else
                                UIPasteboard.general.string = String(data: data, encoding: .utf8)!
                                #endif
                                print("copied to clipboard")
                            }, label: {
                                if #available(macOS 11.0, *) {
                                    Image(systemName: "doc.text")
                                        .font(Font.system(.title))
                                } else {
                                    Image("")
                                        .font(Font.system(.title))
                                }
                            })
                        }
                        .padding()
                        Spacer()
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.3 - 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black, lineWidth: 4)
                )
            }
        }
        .padding()
    }
}
