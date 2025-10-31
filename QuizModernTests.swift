//
//  QuizModernTests.swift
//  Guardian Quiz
//
//  Modern test suite using Swift Testing framework
//

import Testing
@testable import Guardian_Quiz

@Suite("Quiz Functionality Tests")
struct QuizModernTests {
    
    @Test("JSON parsing works correctly")
    func testJSONParser() async throws {
        let bundle = Bundle(for: QuizTests.self)
        let fixturePath = try #require(bundle.path(forResource: "quiz", ofType: "json"))
        let data = try Data(contentsOf: URL(fileURLWithPath: fixturePath))
        
        let quiz = try Quiz.fromJson(json: data)
        
        #expect(quiz.title == "What links Oliver and Moulin Rouge? The Weekend quiz")
        #expect(quiz.questions.count == 15)
    }
    
    @Test("SharedState calculates total score correctly")
    func testScoreCalculation() {
        let questions = [
            Question(number: 1, type: .normal, question: "Test 1", whatLinks: [], answer: "Answer 1"),
            Question(number: 2, type: .normal, question: "Test 2", whatLinks: [], answer: "Answer 2")
        ]
        let quiz = Quiz(title: "Test Quiz", questions: questions)
        let sharedState = SharedState(quiz: quiz)
        
        // Test initial state
        #expect(sharedState.totalScore() == 0)
        
        // Test partial scoring
        sharedState.scores[0] = 1 // Half point
        sharedState.scores[1] = 2 // Full point
        #expect(sharedState.totalScore() == 1.5)
        
        // Test maximum scoring
        sharedState.scores[0] = 2
        sharedState.scores[1] = 2
        #expect(sharedState.totalScore() == 2.0)
    }
    
    @Test("Question type enumeration works correctly")
    func testQuestionTypes() {
        #expect(QuestionType.normal.rawValue == "NORMAL")
        #expect(QuestionType.whatLinks.rawValue == "WHAT_LINKS")
    }
}