//
//  VersionTest.swift
//  DNAConverterTests
//
//  Created by am10 on 2020/01/24.
//  Copyright © 2020 am10. All rights reserved.
//

import XCTest
@testable import DNAConverter

final class VersionTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testVersionGreaterThanMethod_when_major_is_greater() {
        XCTAssertTrue(Version(version: "2.0.0") > Version(version: "1.1.1"))
        XCTAssertTrue(Version(version: "2.0.1") > Version(version: "1.1.1"))
        XCTAssertTrue(Version(version: "2.0.2") > Version(version: "1.1.1"))
        XCTAssertTrue(Version(version: "2.1.0") > Version(version: "1.1.1"))
        XCTAssertTrue(Version(version: "2.1.1") > Version(version: "1.1.1"))
        XCTAssertTrue(Version(version: "2.1.2") > Version(version: "1.1.1"))
        XCTAssertTrue(Version(version: "2.2.0") > Version(version: "1.1.1"))
        XCTAssertTrue(Version(version: "2.2.1") > Version(version: "1.1.1"))
        XCTAssertTrue(Version(version: "2.2.2") > Version(version: "1.1.1"))
    }

    func testVersionGreaterThanMethod_when_major_is_equal() {
        XCTAssertFalse(Version(version: "1.0.0") > Version(version: "1.1.1"))
        XCTAssertFalse(Version(version: "1.0.1") > Version(version: "1.1.1"))
        XCTAssertFalse(Version(version: "1.0.2") > Version(version: "1.1.1"))
        XCTAssertFalse(Version(version: "1.1.0") > Version(version: "1.1.1"))
        XCTAssertFalse(Version(version: "1.1.1") > Version(version: "1.1.1"))
        XCTAssertTrue(Version(version: "1.1.2") > Version(version: "1.1.1"))
        XCTAssertTrue(Version(version: "1.2.0") > Version(version: "1.1.1"))
        XCTAssertTrue(Version(version: "1.2.1") > Version(version: "1.1.1"))
        XCTAssertTrue(Version(version: "1.2.2") > Version(version: "1.1.1"))
    }

    func testVersionGreaterThanMethod_when_major_is_less() {
        XCTAssertFalse(Version(version: "0.0.0") > Version(version: "1.1.1"))
        XCTAssertFalse(Version(version: "0.0.1") > Version(version: "1.1.1"))
        XCTAssertFalse(Version(version: "0.0.2") > Version(version: "1.1.1"))
        XCTAssertFalse(Version(version: "0.1.0") > Version(version: "1.1.1"))
        XCTAssertFalse(Version(version: "0.1.1") > Version(version: "1.1.1"))
        XCTAssertFalse(Version(version: "0.1.2") > Version(version: "1.1.1"))
        XCTAssertFalse(Version(version: "0.2.0") > Version(version: "1.1.1"))
        XCTAssertFalse(Version(version: "0.2.1") > Version(version: "1.1.1"))
        XCTAssertFalse(Version(version: "0.2.2") > Version(version: "1.1.1"))
    }
}
