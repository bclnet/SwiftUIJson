import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(BundleTests.allTests),
        testCase(NSItemProviderTests.allTests),
    ]
}
#endif
