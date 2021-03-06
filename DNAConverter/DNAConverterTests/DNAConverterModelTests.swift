//
//  DNAConverterModelTests.swift
//  DNAConverterTests
//
//  Created by am10 on 2020/01/04.
//  Copyright © 2020 am10. All rights reserved.
//

import XCTest
@testable import DNAConverter

final class DNAConverterModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testTwitterURL() {
        let model = DNAConverterModel()
        model.convertedText = nil
        XCTAssertNil(model.twitterURL)
        model.convertedText = ""
        XCTAssertNil(model.twitterURL)
        model.convertedText = "ATCG"
        XCTAssertNotNil(model.twitterURL)
    }

    func testIsEmptyTextWithText() {
        let model = DNAConverterModel()
        XCTAssertTrue(model.isEmptyText(""))
        XCTAssertTrue(model.isEmptyText(nil))
        XCTAssertFalse(model.isEmptyText("あいうえお"))
        XCTAssertFalse(model.isEmptyText("愛飢え男"))
        XCTAssertFalse(model.isEmptyText("12345"))
        XCTAssertFalse(model.isEmptyText("ABCDE"))
        XCTAssertFalse(model.isEmptyText(" "))
        XCTAssertFalse(model.isEmptyText("　"))
    }

    func testIsInvalidDNAWithText() {
        let model = DNAConverterModel()
        XCTAssertTrue(model.isInvalidDNA(""))
        XCTAssertTrue(model.isInvalidDNA(nil))
        XCTAssertTrue(model.isInvalidDNA("あいうえ"))
        XCTAssertTrue(model.isInvalidDNA("愛飢男"))
        XCTAssertTrue(model.isInvalidDNA("1234"))
        XCTAssertTrue(model.isInvalidDNA("ABCD"))
        XCTAssertTrue(model.isInvalidDNA("  "))
        XCTAssertTrue(model.isInvalidDNA("　　"))
        XCTAssertTrue(model.isInvalidDNA("AATTCCG"))
        XCTAssertFalse(model.isInvalidDNA("AATTCCGG"))
    }

    func testConvertToDNAWithText() {
        let model = DNAConverterModel()
        XCTAssertEqual(model.convertToDNA(""), .failure(.empty))
        XCTAssertEqual(model.convertToDNA(nil), .failure(.empty))
        XCTAssertEqual(model.convertToDNA("あいうえ"), .success("GCAGCAATCAACGCAGCAATCATAGCAGCAATCATCGCAGCAATCACA"))
        XCTAssertEqual(model.convertToDNA("愛飢男"), .success("GCTCCATACTCGGCCTCCAGCCACGCTGCTTACGTG"))
        XCTAssertEqual(model.convertToDNA("1234"), .success("AGATAGACAGAGAGTA"))
        XCTAssertEqual(model.convertToDNA("ABCD"), .success("TAATTAACTAAGTATA"))
        XCTAssertEqual(model.convertToDNA(" "), .success("ACAA"))
        XCTAssertEqual(model.convertToDNA("　"), .success("GCAGCAAACAAA"))
        XCTAssertEqual(model.convertToDNA("!\"#$%&'()-^@[;:],./\\=~|`{+*}<>?_"), .success("ACATACACACAGACTAACTTACTCACTGACCAACCTACGTTTGCTAAATTCGAGCGAGCCTTGTACGAACGCACGGTTGAAGGTTGGCTGGATCAATGCGACCGACCCTGGTAGGAAGGCAGGGTTGG"))
        XCTAssertEqual(model.convertToDNA("、。，．・：；？！゛゜´｀¨＾￣＿ヽヾゝゞ〃仝々〆〇ー―‐／＼～∥｜…‥"), .success("GCAGCAAACAATGCAGCAAACAACGCGGCGGACAGAGCGGCGGACAGCGCAGCAAGCGCGGCGGCGGACTCCGCGGCGGACTCGGCGGCGGACTGGGCGGCGGACAATGCAGCAACCTCGGCAGCAACCTGAGAACCGTAGCGGCGGTCAAAGAACCCCAGCGGCGGACGGCGCGGCGGGCCAGGCGGCGGACGGGGCAGCAAGCGGTGCAGCAAGCGGCGCAGCAACCTGTGCAGCAACCTGCGCAGCAAACAAGGCTACGCGCTGTGCAGCAAACATTGCAGCAAACATCGCAGCAAACATGGCAGCAAGCGGAGCACCAAACTTTGCACCAAACTAAGCGGCGGACAGGGCGGCGGACGGAGCGGCGGTCTGCGCACCACACCTTGCGGCGGTCTGAGCACCAAACCTCGCACCAAACCTT"))
        XCTAssertEqual(model.convertToDNA("‘’“”（）〔〕［］｛｝〈〉《》「」『』【】＋－±×÷＝≠＜＞≦≧∞∴"), .success("GCACCAAACTCAGCACCAAACTCTGCACCAAACTGAGCACCAAACTGTGCGGCGGACACAGCGGCGGACACTGCAGCAAACTTAGCAGCAAACTTTGCGGCGGACGCGGCGGCGGACGGTGCGGCGGTCTCGGCGGCGGTCTGTGCAGCAAACACAGCAGCAAACACTGCAGCAAACACCGCAGCAAACACGGCAGCAAACAGAGCAGCAAACAGTGCAGCAAACAGCGCAGCAAACAGGGCAGCAAACTAAGCAGCAAACTATGCGGCGGACACGGCGGCGGACAGTGAACCGATGAAGCTTGGAAGCGTGGCGGCGGACTGTGCACCACTCCAAGCGGCGGACTGAGCGGCGGACTGCGCACCACTCCTCGCACCACTCCTGGCACCACACTGCGCACCACACGTA"))
        XCTAssertEqual(model.convertToDNA("♂♀°′″℃￥＄￠￡％＃＆＊＠§☆★○●◎◇◆□■△▲▽▼※〒→←↑↓〓"), .success("GCACCTCTCAACGCACCTCTCAAAGAACCGAAGCACCAAACGACGCACCAAACGAGGCACCATACAAGGCGGCGGGCCTTGCGGCGGACATAGCGGCGGGCCAAGCGGCGGGCCATGCGGCGGACATTGCGGCGGACAAGGCGGCGGACATCGCGGCGGACACCGCGGCGGACCAAGAACCCTGGCACCTCACATCGCACCTCACATTGCACCTTGCACGGCACCTTGCAGGGCACCTTGCAGCGCACCTTGCATGGCACCTTGCATCGCACCTTCCCATGCACCTTCCCAAGCACCTTCCGAGGCACCTTCCGACGCACCTTCCGGTGCACCTTCCGGAGCACCAAACGCGGCAGCAAACTACGCACCATCCTACGCACCATCCTAAGCACCATCCTATGCACCATCCTAGGCAGCAAACTAG"))
        XCTAssertEqual(model.convertToDNA("∈∋⊆⊇⊂⊃∪∩∧∨￢⇒⇔∀∃∠⊥⌒∂∇≡≒≪≫√∽∝∵∫∬Å‰♯♭♪"), .success("GCACCACACACAGCACCACACACGGCACCACCCATCGCACCACCCATGGCACCACCCAACGCACCACCCAAGGCACCACACCCCGCACCACACCCTGCACCACACCTGGCACCACACCCAGCGGCGGGCCACGCACCATGCTACGCACCATGCTTAGCACCACACAAAGCACCACACAAGGCACCACACCAAGCACCACCCCTTGCACCAGACTACGCACCACACAACGCACCACACATGGCACCACTCCATGCACCACTCTACGCACCACTCCCCGCACCACTCCCGGCACCACACTCCGCACCACACGGTGCACCACACTGTGCACCACACGTTGCACCACACCCGGCACCACACCGAGCACCATACCCGGCACCAAACGAAGCACCTCTCCGGGCACCTCTCCGTGCACCTCTCCCC"))
        XCTAssertEqual(model.convertToDNA("ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθ"), .success("GAGCCTATGAGCCTACGAGCCTAGGAGCCTTAGAGCCTTTGAGCCTTCGAGCCTTGGAGCCTCAGAGCCTCTGAGCCTCCGAGCCTCGGAGCCTGAGAGCCTGTGAGCCTGCGAGCCTGGGAGCCCAAGAGCCCATGAGCCCAGGAGCCCTAGAGCCCTTGAGCCCTCGAGCCCTGGAGCCCCAGAGCCCCTGAGCCGATGAGCCGACGAGCCGAGGAGCCGTAGAGCCGTTGAGCCGTCGAGCCGTGGAGCCGCA"))
        XCTAssertEqual(model.convertToDNA("ικλμνξοπρστυφχψωАБВГДЕЁЖЗИЙКЛМНО"), .success("GAGCCGCTGAGCCGCCGAGCCGCGGAGCCGGAGAGCCGGTGAGCCGGCGAGCCGGGGAGGCAAAGAGGCAATGAGGCAAGGAGGCATAGAGGCATTGAGGCATCGAGGCATGGAGGCACAGAGGCACTGTAACTAAGTAACTATGTAACTACGTAACTAGGTAACTTAGTAACTTTGTAACAATGTAACTTCGTAACTTGGTAACTCAGTAACTCTGTAACTCCGTAACTCGGTAACTGAGTAACTGTGTAACTGC"))
        XCTAssertEqual(model.convertToDNA("ПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмн"), .success("GTAACTGGGTAACCAAGTAACCATGTAACCACGTAACCAGGTAACCTAGTAACCTTGTAACCTCGTAACCTGGTAACCCAGTAACCCTGTAACCCCGTAACCCGGTAACCGAGTAACCGTGTAACCGCGTAACCGGGTAACGAAGTAACGATGTAACGACGTAACGAGGTAACGTAGTAACGTTGTATCTATGTAACGTCGTAACGTGGTAACGCAGTAACGCTGTAACGCCGTAACGCGGTAACGGAGTAACGGT"))
        XCTAssertEqual(model.convertToDNA("опрстуфхцчшщъыьэюя"), .success("GTAACGGCGTAACGGGGTATCAAAGTATCAATGTATCAACGTATCAAGGTATCATAGTATCATTGTATCATCGTATCATGGTATCACAGTATCACTGTATCACCGTATCACGGTATCAGAGTATCAGTGTATCAGCGTATCAGG"))
        XCTAssertEqual(model.convertToDNA("─│┌┐┘└├┬┤┴┼━┃┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂"), .success("GCACCTTACAAAGCACCTTACAACGCACCTTACAGAGCACCTTACTAAGCACCTTACTCAGCACCTTACTTAGCACCTTACTGAGCACCTTACCGAGCACCTTACCTAGCACCTTACGTAGCACCTTACGGAGCACCTTACAATGCACCTTACAAGGCACCTTACAGGGCACCTTACTAGGCACCTTACTCGGCACCTTACTTGGCACCTTACCAGGCACCTTACGAGGCACCTTACCCGGCACCTTACGCGGCACCTTTCACGGCACCTTACCAAGCACCTTACCGGGCACCTTACCCAGCACCTTACGTGGCACCTTACGGGGCACCTTACTGTGCACCTTACGAAGCACCTTACCTTGCACCTTACGCAGCACCTTTCAAC"))
        XCTAssertEqual(model.convertToDNA("｡｢｣､･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ"), .success("GCGGCGGTCCATGCGGCGGTCCACGCGGCGGTCCAGGCGGCGGTCCTAGCGGCGGTCCTTGCGGCGGTCCTCGCGGCGGTCCTGGCGGCGGTCCCAGCGGCGGTCCCTGCGGCGGTCCCCGCGGCGGTCCCGGCGGCGGTCCGAGCGGCGGTCCGTGCGGCGGTCCGCGCGGCGGTCCGGGCGGCGGTCGAAGCGGCGGTCGATGCGGCGGTCGACGCGGCGGTCGAGGCGGCGGTCGTAGCGGCGGTCGTTGCGGCGGTCGTCGCGGCGGTCGTGGCGGCGGTCGCAGCGGCGGTCGCTGCGGCGGTCGCCGCGGCGGTCGCGGCGGCGGTCGGAGCGGCGGTCGGTGCGGCGGTCGGCGCGGCGGTCGGGGCGGCGGCCAAAGCGGCGGCCAATGCGGCGGCCAACGCGGCGGCCAAGGCGGCGGCCATAGCGGCGGCCATTGCGGCGGCCATCGCGGCGGCCATGGCGGCGGCCACAGCGGCGGCCACTGCGGCGGCCACCGCGGCGGCCACGGCGGCGGCCAGAGCGGCGGCCAGTGCGGCGGCCAGCGCGGCGGCCAGGGCGGCGGCCTAAGCGGCGGCCTATGCGGCGGCCTACGCGGCGGCCTAGGCGGCGGCCTTAGCGGCGGCCTTTGCGGCGGCCTTCGCGGCGGCCTTGGCGGCGGCCTCAGCGGCGGCCTCTGCGGCGGCCTCCGCGGCGGCCTCGGCGGCGGCCTGAGCGGCGGCCTGTGCGGCGGCCTGCGCGGCGGCCTGG"))
        XCTAssertEqual(model.convertToDNA("①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ㍉㌔"), .success("GCACCTATCCAAGCACCTATCCATGCACCTATCCACGCACCTATCCAGGCACCTATCCTAGCACCTATCCTTGCACCTATCCTCGCACCTATCCTGGCACCTATCCCAGCACCTATCCCTGCACCTATCCCCGCACCTATCCCGGCACCTATCCGAGCACCTATCCGTGCACCTATCCGCGCACCTATCCGGGCACCTATCGAAGCACCTATCGATGCACCTATCGACGCACCTATCGAGGCACCATTCCAAGCACCATTCCATGCACCATTCCACGCACCATTCCAGGCACCATTCCTAGCACCATTCCTTGCACCATTCCTCGCACCATTCCTGGCACCATTCCCAGCACCATTCCCTGCAGCAGTCACTGCAGCAGACTTA"))
        XCTAssertEqual(model.convertToDNA("㌢㍍㌘㌧㌃㌶㍑㍗㌍㌦㌣㌫㍊㌻㎜㎝㎞㎎㎏㏄㎡　㍻〝〟№㏍℡㊤㊥㊦㊧"), .success("GCAGCAGACCACGCAGCAGTCAGTGCAGCAGACTCAGCAGCAGACCTGGCAGCAGACAAGGCAGCAGACGTCGCAGCAGTCTATGCAGCAGTCTTGGCAGCAGACAGTGCAGCAGACCTCGCAGCAGACCAGGCAGCAGACCCGGCAGCAGTCACCGCAGCAGACGCGGCAGCAGCCTGAGCAGCAGCCTGTGCAGCAGCCTGCGCAGCAGCCAGCGCAGCAGCCAGGGCAGCAGGCATAGCAGCAGCCCATGCAGCAAACAAAGCAGCAGTCGCGGCAGCAAACTGTGCAGCAAACTGGGCACCATACTTCGCAGCAGGCAGTGCACCATACCATGCAGCACCCCTAGCAGCACCCCTTGCAGCACCCCTCGCAGCACCCCTG"))
        XCTAssertEqual(model.convertToDNA("㊨㈱㈲㈹㍾㍽㍼≒≡∫∮∑√⊥∠∟⊿∵∩∪"), .success("GCAGCACCCCCAGCAGCACACGATGCAGCACACGACGCAGCACACGCTGCAGCAGTCGGCGCAGCAGTCGGTGCAGCAGTCGGAGCACCACTCTACGCACCACTCCATGCACCACACCCGGCACCACACCGCGCACCACACTATGCACCACACTCCGCACCACCCCTTGCACCACACCAAGCACCACACTGGGCACCACCCGGGGCACCACACGTTGCACCACACCCTGCACCACACCCC"))
        XCTAssertEqual(model.convertToDNA("😀"), .success("GGAACTGGCTCACAAA"))
    }
    
    func testConvertToLanguageWithText() {
        let model = DNAConverterModel()
        XCTAssertEqual(model.convertToLanguage(""), .failure(.empty))
        XCTAssertEqual(model.convertToLanguage(nil), .failure(.empty))
        XCTAssertEqual(model.convertToLanguage("あいうえ"), .failure(.invalid))
        XCTAssertEqual(model.convertToLanguage("愛飢男"), .failure(.invalid))
        XCTAssertEqual(model.convertToLanguage("1234"), .failure(.invalid))
        XCTAssertEqual(model.convertToLanguage("ABCD"), .failure(.invalid))
        XCTAssertEqual(model.convertToLanguage(" "), .failure(.invalid))
        XCTAssertEqual(model.convertToLanguage("　"), .failure(.invalid))
        XCTAssertEqual(model.convertToLanguage("AATTCCG"), .failure(.invalid))
        XCTAssertEqual(model.convertToLanguage("GCAGCAATCAACGCAGCAATCATAGCAGCAATCATCGCAGCAATCACA"), .success("あいうえ"))
        XCTAssertEqual(model.convertToLanguage("GCTCCATACTCGGCCTCCAGCCACGCTGCTTACGTG"), .success("愛飢男"))
        XCTAssertEqual(model.convertToLanguage("AGATAGACAGAGAGTA"), .success("1234"))
        XCTAssertEqual(model.convertToLanguage("TAATTAACTAAGTATA"), .success("ABCD"))
        XCTAssertEqual(model.convertToLanguage("ACAA"), .success(" "))
        XCTAssertEqual(model.convertToLanguage("GCAGCAAACAAA"), .success("　"))
        XCTAssertEqual(model.convertToLanguage("ACATACACACAGACTAACTTACTCACTGACCAACCTACGTTTGCTAAATTCGAGCGAGCCTTGTACGAACGCACGGTTGAAGGTTGGCTGGATCAATGCGACCGACCCTGGTAGGAAGGCAGGGTTGG"), .success("!\"#$%&'()-^@[;:],./\\=~|`{+*}<>?_"))
        XCTAssertEqual(model.convertToLanguage("GCAGCAAACAATGCAGCAAACAACGCGGCGGACAGAGCGGCGGACAGCGCAGCAAGCGCGGCGGCGGACTCCGCGGCGGACTCGGCGGCGGACTGGGCGGCGGACAATGCAGCAACCTCGGCAGCAACCTGAGAACCGTAGCGGCGGTCAAAGAACCCCAGCGGCGGACGGCGCGGCGGGCCAGGCGGCGGACGGGGCAGCAAGCGGTGCAGCAAGCGGCGCAGCAACCTGTGCAGCAACCTGCGCAGCAAACAAGGCTACGCGCTGTGCAGCAAACATTGCAGCAAACATCGCAGCAAACATGGCAGCAAGCGGAGCACCAAACTTTGCACCAAACTAAGCGGCGGACAGGGCGGCGGACGGAGCGGCGGTCTGCGCACCACACCTTGCGGCGGTCTGAGCACCAAACCTCGCACCAAACCTT"), .success("、。，．・：；？！゛゜´｀¨＾￣＿ヽヾゝゞ〃仝々〆〇ー―‐／＼～∥｜…‥"))
        XCTAssertEqual(model.convertToLanguage("GCACCAAACTCAGCACCAAACTCTGCACCAAACTGAGCACCAAACTGTGCGGCGGACACAGCGGCGGACACTGCAGCAAACTTAGCAGCAAACTTTGCGGCGGACGCGGCGGCGGACGGTGCGGCGGTCTCGGCGGCGGTCTGTGCAGCAAACACAGCAGCAAACACTGCAGCAAACACCGCAGCAAACACGGCAGCAAACAGAGCAGCAAACAGTGCAGCAAACAGCGCAGCAAACAGGGCAGCAAACTAAGCAGCAAACTATGCGGCGGACACGGCGGCGGACAGTGAACCGATGAAGCTTGGAAGCGTGGCGGCGGACTGTGCACCACTCCAAGCGGCGGACTGAGCGGCGGACTGCGCACCACTCCTCGCACCACTCCTGGCACCACACTGCGCACCACACGTA"), .success("‘’“”（）〔〕［］｛｝〈〉《》「」『』【】＋－±×÷＝≠＜＞≦≧∞∴"))
        XCTAssertEqual(model.convertToLanguage("GCACCTCTCAACGCACCTCTCAAAGAACCGAAGCACCAAACGACGCACCAAACGAGGCACCATACAAGGCGGCGGGCCTTGCGGCGGACATAGCGGCGGGCCAAGCGGCGGGCCATGCGGCGGACATTGCGGCGGACAAGGCGGCGGACATCGCGGCGGACACCGCGGCGGACCAAGAACCCTGGCACCTCACATCGCACCTCACATTGCACCTTGCACGGCACCTTGCAGGGCACCTTGCAGCGCACCTTGCATGGCACCTTGCATCGCACCTTCCCATGCACCTTCCCAAGCACCTTCCGAGGCACCTTCCGACGCACCTTCCGGTGCACCTTCCGGAGCACCAAACGCGGCAGCAAACTACGCACCATCCTACGCACCATCCTAAGCACCATCCTATGCACCATCCTAGGCAGCAAACTAG"), .success("♂♀°′″℃￥＄￠￡％＃＆＊＠§☆★○●◎◇◆□■△▲▽▼※〒→←↑↓〓"))
        XCTAssertEqual(model.convertToLanguage("GCACCACACACAGCACCACACACGGCACCACCCATCGCACCACCCATGGCACCACCCAACGCACCACCCAAGGCACCACACCCCGCACCACACCCTGCACCACACCTGGCACCACACCCAGCGGCGGGCCACGCACCATGCTACGCACCATGCTTAGCACCACACAAAGCACCACACAAGGCACCACACCAAGCACCACCCCTTGCACCAGACTACGCACCACACAACGCACCACACATGGCACCACTCCATGCACCACTCTACGCACCACTCCCCGCACCACTCCCGGCACCACACTCCGCACCACACGGTGCACCACACTGTGCACCACACGTTGCACCACACCCGGCACCACACCGAGCACCATACCCGGCACCAAACGAAGCACCTCTCCGGGCACCTCTCCGTGCACCTCTCCCC"), .success("∈∋⊆⊇⊂⊃∪∩∧∨￢⇒⇔∀∃∠⊥⌒∂∇≡≒≪≫√∽∝∵∫∬Å‰♯♭♪"))
        XCTAssertEqual(model.convertToLanguage("GAGCCTATGAGCCTACGAGCCTAGGAGCCTTAGAGCCTTTGAGCCTTCGAGCCTTGGAGCCTCAGAGCCTCTGAGCCTCCGAGCCTCGGAGCCTGAGAGCCTGTGAGCCTGCGAGCCTGGGAGCCCAAGAGCCCATGAGCCCAGGAGCCCTAGAGCCCTTGAGCCCTCGAGCCCTGGAGCCCCAGAGCCCCTGAGCCGATGAGCCGACGAGCCGAGGAGCCGTAGAGCCGTTGAGCCGTCGAGCCGTGGAGCCGCA"), .success("ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθ"))
        XCTAssertEqual(model.convertToLanguage("GAGCCGCTGAGCCGCCGAGCCGCGGAGCCGGAGAGCCGGTGAGCCGGCGAGCCGGGGAGGCAAAGAGGCAATGAGGCAAGGAGGCATAGAGGCATTGAGGCATCGAGGCATGGAGGCACAGAGGCACTGTAACTAAGTAACTATGTAACTACGTAACTAGGTAACTTAGTAACTTTGTAACAATGTAACTTCGTAACTTGGTAACTCAGTAACTCTGTAACTCCGTAACTCGGTAACTGAGTAACTGTGTAACTGC"), .success("ικλμνξοπρστυφχψωАБВГДЕЁЖЗИЙКЛМНО"))
        XCTAssertEqual(model.convertToLanguage("GTAACTGGGTAACCAAGTAACCATGTAACCACGTAACCAGGTAACCTAGTAACCTTGTAACCTCGTAACCTGGTAACCCAGTAACCCTGTAACCCCGTAACCCGGTAACCGAGTAACCGTGTAACCGCGTAACCGGGTAACGAAGTAACGATGTAACGACGTAACGAGGTAACGTAGTAACGTTGTATCTATGTAACGTCGTAACGTGGTAACGCAGTAACGCTGTAACGCCGTAACGCGGTAACGGAGTAACGGT"), .success("ПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийклмн"))
        XCTAssertEqual(model.convertToLanguage("GTAACGGCGTAACGGGGTATCAAAGTATCAATGTATCAACGTATCAAGGTATCATAGTATCATTGTATCATCGTATCATGGTATCACAGTATCACTGTATCACCGTATCACGGTATCAGAGTATCAGTGTATCAGCGTATCAGG"), .success("опрстуфхцчшщъыьэюя"))
        XCTAssertEqual(model.convertToLanguage("GCACCTTACAAAGCACCTTACAACGCACCTTACAGAGCACCTTACTAAGCACCTTACTCAGCACCTTACTTAGCACCTTACTGAGCACCTTACCGAGCACCTTACCTAGCACCTTACGTAGCACCTTACGGAGCACCTTACAATGCACCTTACAAGGCACCTTACAGGGCACCTTACTAGGCACCTTACTCGGCACCTTACTTGGCACCTTACCAGGCACCTTACGAGGCACCTTACCCGGCACCTTACGCGGCACCTTTCACGGCACCTTACCAAGCACCTTACCGGGCACCTTACCCAGCACCTTACGTGGCACCTTACGGGGCACCTTACTGTGCACCTTACGAAGCACCTTACCTTGCACCTTACGCAGCACCTTTCAAC"), .success("─│┌┐┘└├┬┤┴┼━┃┏┓┛┗┣┳┫┻╋┠┯┨┷┿┝┰┥┸╂"))
        XCTAssertEqual(model.convertToLanguage("GCGGCGGTCCATGCGGCGGTCCACGCGGCGGTCCAGGCGGCGGTCCTAGCGGCGGTCCTTGCGGCGGTCCTCGCGGCGGTCCTGGCGGCGGTCCCAGCGGCGGTCCCTGCGGCGGTCCCCGCGGCGGTCCCGGCGGCGGTCCGAGCGGCGGTCCGTGCGGCGGTCCGCGCGGCGGTCCGGGCGGCGGTCGAAGCGGCGGTCGATGCGGCGGTCGACGCGGCGGTCGAGGCGGCGGTCGTAGCGGCGGTCGTTGCGGCGGTCGTCGCGGCGGTCGTGGCGGCGGTCGCAGCGGCGGTCGCTGCGGCGGTCGCCGCGGCGGTCGCGGCGGCGGTCGGAGCGGCGGTCGGTGCGGCGGTCGGCGCGGCGGTCGGGGCGGCGGCCAAAGCGGCGGCCAATGCGGCGGCCAACGCGGCGGCCAAGGCGGCGGCCATAGCGGCGGCCATTGCGGCGGCCATCGCGGCGGCCATGGCGGCGGCCACAGCGGCGGCCACTGCGGCGGCCACCGCGGCGGCCACGGCGGCGGCCAGAGCGGCGGCCAGTGCGGCGGCCAGCGCGGCGGCCAGGGCGGCGGCCTAAGCGGCGGCCTATGCGGCGGCCTACGCGGCGGCCTAGGCGGCGGCCTTAGCGGCGGCCTTTGCGGCGGCCTTCGCGGCGGCCTTGGCGGCGGCCTCAGCGGCGGCCTCTGCGGCGGCCTCCGCGGCGGCCTCGGCGGCGGCCTGAGCGGCGGCCTGTGCGGCGGCCTGCGCGGCGGCCTGG"), .success("｡｢｣､･ｦｧｨｩｪｫｬｭｮｯｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟ"))
        XCTAssertEqual(model.convertToLanguage("GCACCTATCCAAGCACCTATCCATGCACCTATCCACGCACCTATCCAGGCACCTATCCTAGCACCTATCCTTGCACCTATCCTCGCACCTATCCTGGCACCTATCCCAGCACCTATCCCTGCACCTATCCCCGCACCTATCCCGGCACCTATCCGAGCACCTATCCGTGCACCTATCCGCGCACCTATCCGGGCACCTATCGAAGCACCTATCGATGCACCTATCGACGCACCTATCGAGGCACCATTCCAAGCACCATTCCATGCACCATTCCACGCACCATTCCAGGCACCATTCCTAGCACCATTCCTTGCACCATTCCTCGCACCATTCCTGGCACCATTCCCAGCACCATTCCCTGCAGCAGTCACTGCAGCAGACTTA"), .success("①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ㍉㌔"))
        XCTAssertEqual(model.convertToLanguage("GCAGCAGACCACGCAGCAGTCAGTGCAGCAGACTCAGCAGCAGACCTGGCAGCAGACAAGGCAGCAGACGTCGCAGCAGTCTATGCAGCAGTCTTGGCAGCAGACAGTGCAGCAGACCTCGCAGCAGACCAGGCAGCAGACCCGGCAGCAGTCACCGCAGCAGACGCGGCAGCAGCCTGAGCAGCAGCCTGTGCAGCAGCCTGCGCAGCAGCCAGCGCAGCAGCCAGGGCAGCAGGCATAGCAGCAGCCCATGCAGCAAACAAAGCAGCAGTCGCGGCAGCAAACTGTGCAGCAAACTGGGCACCATACTTCGCAGCAGGCAGTGCACCATACCATGCAGCACCCCTAGCAGCACCCCTTGCAGCACCCCTCGCAGCACCCCTG"), .success("㌢㍍㌘㌧㌃㌶㍑㍗㌍㌦㌣㌫㍊㌻㎜㎝㎞㎎㎏㏄㎡　㍻〝〟№㏍℡㊤㊥㊦㊧"))
        XCTAssertEqual(model.convertToLanguage("GCAGCACCCCCAGCAGCACACGATGCAGCACACGACGCAGCACACGCTGCAGCAGTCGGCGCAGCAGTCGGTGCAGCAGTCGGAGCACCACTCTACGCACCACTCCATGCACCACACCCGGCACCACACCGCGCACCACACTATGCACCACACTCCGCACCACCCCTTGCACCACACCAAGCACCACACTGGGCACCACCCGGGGCACCACACGTTGCACCACACCCTGCACCACACCCC"), .success("㊨㈱㈲㈹㍾㍽㍼≒≡∫∮∑√⊥∠∟⊿∵∩∪"))
        XCTAssertEqual(model.convertToLanguage("GGAACTGGCTCACAAA"), .success("😀"))
    }
}
