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
        print("encode")
        let view = self.content
        let context = JsonContext[view]
        do {
            data = try JsonUI.encode(view: view, context: context)
        } catch DynaTypeError.typeNotCodable(let named) {
            data = "typeNotCodable named:\(named)".data(using: .utf8)!
        } catch {
            data = error.localizedDescription.data(using: .utf8)!
        }
        JsonContext.remove(view)
        
        // content2
        print("decode")
        do {
            let jsonUI = try JsonUI(from: data)
            content2 = jsonUI.anyView ?? AnyView(Text("notAnyView"))
        } catch DynaTypeError.typeNotFound {
            content2 = AnyView(Text("typeNotFound"))
        } catch DynaTypeError.typeParseError {
            content2 = AnyView(Text("typeParseError"))
        } catch DynaTypeError.typeNameError(let actual, let expected) {
            content2 = AnyView(Text("typeNameError actual:\(actual) expected:\(expected)"))
        } catch DynaTypeError.typeNotCodable(let named) {
            content2 = AnyView(Text("typeNotCodable named:\(named)"))
        } catch {
            content2 = AnyView(Text("error:\(error.localizedDescription)"))
            //data = error.localizedDescription.data(using: .utf8)! + "\n".data(using: .utf8)! + data
        }
        print("Done")
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
                ScrollView {
                    HStack {
                        Text(String(data: data, encoding: .utf8)!)
                        Spacer()
                    }
                    .padding()
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

//struct JsonDebugView_Previews: PreviewProvider {
//    static var previews: some View {
//        JsonPreview {
//            SampleView()
//        }
//    }
//}
