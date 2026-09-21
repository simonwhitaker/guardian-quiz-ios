//
//  QuizTests.swift
//  Guardian QuizTests
//
//  Created by Simon on 29/11/2020.
//

import Foundation
import Testing

/// Anchor class used to locate the test bundle, which contains the quiz.json fixture.
private final class TestBundleAnchor {}

struct QuizTests {

    @Test func `JSON parser loads the fixture quiz`() throws {
        let bundle = Bundle(for: TestBundleAnchor.self)
        let fixturePath = try #require(bundle.path(forResource: "quiz", ofType: "json"))
        let data = try Data(contentsOf: URL(fileURLWithPath: fixturePath))

        let quiz = try Quiz.fromJson(json: data)

        #expect(quiz.title == "What links Oliver and Moulin Rouge? The Weekend quiz")
        #expect(quiz.questions.count == 15)
    }

    @Test func `SharedState calculates total score correctly`() {
        let questions = [
            Question(number: 1, type: .normal, question: "Test 1", whatLinks: [], answer: "Answer 1"),
            Question(number: 2, type: .normal, question: "Test 2", whatLinks: [], answer: "Answer 2")
        ]
        let quiz = Quiz(id: "test/quiz", title: "Test Quiz", questions: questions)
        let sharedState = SharedState(quiz: quiz)

        // Initial state
        #expect(sharedState.totalScore() == 0)

        // Partial scoring: scores are stored in half-points
        sharedState.scores[0] = 1
        sharedState.scores[1] = 2
        #expect(sharedState.totalScore() == 1.5)

        // Maximum scoring
        sharedState.scores[0] = 2
        sharedState.scores[1] = 2
        #expect(sharedState.totalScore() == 2.0)
    }

    @Test func `Question type raw values match the quiz JSON format`() {
        #expect(QuestionType.normal.rawValue == "NORMAL")
        #expect(QuestionType.whatLinks.rawValue == "WHAT_LINKS")
    }
}
