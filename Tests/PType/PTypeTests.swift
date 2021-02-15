import XCTest
@testable import SwiftUIJson

final class PTypeTests: XCTestCase {
    
    func testTypeKey_test() {
        // standard type
        XCTAssertEqual(PType.typeKey(typeOf<String>()), "#String")
        XCTAssertEqual(PType.typeKey(typeOf<String?>()), "#String?")
        XCTAssertEqual(PType.typeKey(typeOf<Edge>()), ":Edge")
        XCTAssertEqual(PType.typeKey(typeOf<Edge.Set>()), ":Edge.Set")

        // tuple type
        XCTAssertEqual(PType.typeKey(typeOf<Tuple2<String, String>>()), "(#String,#String)")
        XCTAssertEqual(PType.typeKey(typeOf<Tuple2<String, String>?>()), "(#String,#String)?")
        XCTAssertEqual(PType.typeKey(typeOf<Tuple2<Tuple2<String, String>, String>>()), "((#String,#String),#String)")
        XCTAssertEqual(PType.typeKey(typeOf<Tuple2<List<String>, String>>()), "(#List<#String>,#String)")

        // generic type
        XCTAssertEqual(PType.typeKey(typeOf<List<String>>()), "#List<#String>")
    }

    func testRegister_test() {
        // standard type
        PType.register(PTypeTest.self)
        assertXCTAssertEqualEquals(PType.find("kotlinx.ptype.PTypeTest")?.key, "kotlinx.ptype.PTypeTest")

        // generic type
        PType.register(List<Any>.self)
        XCTAssertEqual(PType.find("#List<#String>")?.key, "#List<#String>")
    }

    func testTypeFor_test() {
        // standard type
        XCTAssertEqual(PType.typeFor(typeOf<String>())?.key, "#String")

        // tuple type
        XCTAssertEqual(PType.typeFor(typeOf<Tuple2<String, String>>())?.key, "(#String,#String)")

        // generic type
        XCTAssertEqual(PType.typeFor(typeOf<List<String>>())?.key, "#List<#String>")
    }

    func testFind_test() {
        // standard type
        XCTAssertEqual(PType.find("#String")?.key, "#String")

        // tuple type
        XCTAssertEqual(PType.find("(#String,#String)")?.key, "(#String,#String)")

        // generic type
        XCTAssertEqual(PType.find("#List<#String>")?.key, "#List<#String>")
    }

    func testSerialize_test() {
        // standard type
        XCTAssertEqual(Json.encodeToString(PTypeSerializer, PType.find("#String")), "\"#String\"")
        XCTAssertEqual(Json.encodeToString(PTypeWithNilSerializer, PTypeWithNil(PType.find("#String"), false)), "\"#String\"")
        XCTAssertEqual(Json.encodeToString(PTypeWithNilSerializer, PTypeWithNil(PType.find("#String"), true)), "\"#String:nil\"")

        // tuple type
        XCTAssertEqual(Json.encodeToString(PTypeSerializer, PType.find("(#String,#String)")), "\"(#String,#String)\"")
        XCTAssertEqual(Json.encodeToString(PTypeWithNilSerializer, PTypeWithNil(PType.find("(#String,#String)"), false)), "\"(#String,#String)\"")
        XCTAssertEqual(Json.encodeToString(PTypeWithNilSerializer, PTypeWithNil(PType.find("(#String,#String)"), true)), "\"(#String,#String):nil\"")

        // generic type
        XCTAssertEqual(Json.encodeToString(PTypeSerializer, PType.find("#List<#String>")), "\"#List<#String>\"")
        XCTAssertEqual(Json.encodeToString(PTypeWithNilSerializer, PTypeWithNil(PType.find("#List<#String>"), false)), "\"#List<#String>\"")
        XCTAssertEqual(Json.encodeToString(PTypeWithNilSerializer, PTypeWithNil(PType.find("#List<#String>"), true)), "\"#List<#String>:nil\"")
    }

    static var allTests = [
        ("testTypeKey_test", testTypeKey_test),
        ("testRegister_test", testRegister_test),
        ("testTypeFor_test", testTypeFor_test),
        ("testFind_test", testFind_test),
        ("testSerialize_test", testSerialize_test),
    ]
}
