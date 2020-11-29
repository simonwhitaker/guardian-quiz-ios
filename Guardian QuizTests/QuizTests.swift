//
//  QuizTests.swift
//  Guardian QuizTests
//
//  Created by Simon on 29/11/2020.
//

import XCTest
@testable import Guardian_Quiz

class QuizTests: XCTestCase {

  func testExample() throws {
    let fixturePath = Bundle.main.path(forResource: "quiz", ofType: "json")
    let data = try Data(contentsOf: URL(fileURLWithPath: fixturePath!))
    let quiz = try Quiz.fromJson(json: data)
    XCTAssertNotNil(quiz, "Quiz is not nil")
    XCTAssertEqual(quiz.title, "What links Oliver and Moulin Rouge? The Weekend quiz")
  }
}
