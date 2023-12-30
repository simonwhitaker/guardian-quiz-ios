//
//  QuizTests.swift
//  Guardian QuizTests
//
//  Created by Simon on 29/11/2020.
//

import XCTest
@testable import Guardian_Quiz

class QuizTests: XCTestCase {

    func testJSONParser() throws {
        let bundle = Bundle(for: type(of: self))
        let fixturePath = bundle.path(forResource: "quiz", ofType: "json")
        let data = try Data(contentsOf: URL(fileURLWithPath: fixturePath!))
        let quiz = try Quiz.fromJson(json: data)
        XCTAssertNotNil(quiz, "Quiz is not nil")
        XCTAssertEqual(quiz.title, "What links Oliver and Moulin Rouge? The Weekend quiz")
        XCTAssertEqual(quiz.questions.count, 15)
    }

    func testWhatLinksQuestions() throws {
        let num = 1
        let q = Question(number: num, type: .whatLinks, question: "foo; bar?; baz?", answer: "")
        let expected: [IndexedAnswerOption] = [
            IndexedAnswerOption(id: num<<8, value: "foo"),
            IndexedAnswerOption(id: num<<8 + 1, value: "bar?"),
            IndexedAnswerOption(id: num<<8 + 2, value: "baz")
        ]
        XCTAssertEqual(q.whatLinksOptions, expected)
    }
}
