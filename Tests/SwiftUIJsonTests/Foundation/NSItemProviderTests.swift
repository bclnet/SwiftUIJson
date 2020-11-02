import XCTest
@testable import SwiftUIJson

final class NSItemProviderTests: XCTestCase {

    func testEmpty() throws {
        let expected = NSItemProvider(), actual = try Self.rebuild(expected)
        XCTAssertEqual(actual.registeredTypeIdentifiers, expected.registeredTypeIdentifiers)
    }
    
    func testContentsOf() throws {
        var expected:NSItemProvider, actual:NSItemProvider
        expected = NSItemProvider(contentsOf: URL(string: "https://apple.com"))!; actual = try Self.rebuild(expected)
        XCTAssertEqual(actual.registeredTypeIdentifiers, expected.registeredTypeIdentifiers)
        expected = NSItemProvider(contentsOf: URL(fileURLWithPath: ""))!; actual = try Self.rebuild(expected)
        XCTAssertEqual(actual.registeredTypeIdentifiers, expected.registeredTypeIdentifiers)
    }
    
    func testString() throws {
        let expected = NSItemProvider(object: "Test" as NSString), actual = try Self.rebuild(expected)
        XCTAssertEqual(actual.registeredTypeIdentifiers, expected.registeredTypeIdentifiers)
    }
    
    class TestObject: NSObject, NSItemProviderWriting {
        static var writableTypeIdentifiersForItemProvider: [String] { [""] }
        
        func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
            Progress(totalUnitCount: 1)
        }
    }
    
    func testObject() throws {
        let expected = NSItemProvider(object: TestObject()), actual = try Self.rebuild(expected)
        XCTAssertEqual(actual.registeredTypeIdentifiers, expected.registeredTypeIdentifiers)
    }

    static var allTests = [
        ("testEmpty", testEmpty),
        ("testContentsOf", testContentsOf),
        ("testString", testString),
    ]
    
    static func rebuild(_ value: NSItemProvider) throws -> NSItemProvider {
        let data = try JSONEncoder().encode(CodableWrap(value))
        return try JSONDecoder().decode(CodableWrap<NSItemProvider>.self, from: data).wrapValue
    }
}
