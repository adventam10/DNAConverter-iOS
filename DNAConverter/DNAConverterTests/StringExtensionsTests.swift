//
//  StringExtensionsTests.swift
//  DNAConverterTests
//
//  Created by am10 on 2020/01/04.
//  Copyright © 2020 am10. All rights reserved.
//

import XCTest
@testable import DNAConverter

final class StringExtensionsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testHexadecimal() {
        XCTAssertNotNil("ABCDEF".hexadecimal)
        XCTAssertNotNil("1234567890".hexadecimal)
        XCTAssertNotNil("あい120H".hexadecimal)
        XCTAssertNil("あいうえお".hexadecimal)
        XCTAssertNil("愛飢え男".hexadecimal)
        XCTAssertNil("".hexadecimal)
    }

    func testHex() {
        XCTAssertEqual("あいうえお".hex, "E38182E38184E38186E38188E3818A")
        XCTAssertEqual("ABCDE".hex, "4142434445")
        XCTAssertEqual("12345".hex, "3132333435")
        XCTAssertEqual("愛飢え男".hex, "E6849BE9A3A2E38188E794B7")
        XCTAssertEqual("".hex, "")
        
    }

    func testIsOnlyStructuredBy() {
        let nucleotide = "ATCG"
        XCTAssertFalse("あいうえお".isOnly(structuredBy: nucleotide))
        XCTAssertTrue("".isOnly(structuredBy: nucleotide))
        XCTAssertFalse("atcg".isOnly(structuredBy: nucleotide))
        XCTAssertTrue("AATTCCGGATG".isOnly(structuredBy: nucleotide))
    }

    func testSplitIntoWithLength() {
        let length = 2
        XCTAssertEqual("AATTCCGG".splitInto(length).count, 4)
        XCTAssertEqual("AATTCCG".splitInto(length).count, 4)
        XCTAssertEqual("AACC".splitInto(length).count, 2)
    }
}
