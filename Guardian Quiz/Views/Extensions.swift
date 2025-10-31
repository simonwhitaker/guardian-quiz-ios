//
//  Extensions.swift
//  Guardian Quiz
//
//  Utility extensions for safer code
//

import Foundation

extension Array {
    /// Safe array subscript that returns nil instead of crashing
    subscript(safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
}

extension SharedState {
    /// Safe access to current question
    var currentQuestion: Question? {
        guard let quiz = quiz,
              let question = quiz.questions[safe: questionIndex] else { 
            return nil 
        }
        return question
    }
    
    /// Safe access to current score
    var currentScore: Int8 {
        guard let score = scores[safe: questionIndex] else { 
            return 0 
        }
        return score
    }
}