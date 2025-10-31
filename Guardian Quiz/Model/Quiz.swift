//
//  Quiz.swift
//  Guardian Quiz
//
//  Created by Simon on 29/11/2020.
//

import Foundation

enum QuestionType: String, Codable {
    case normal = "NORMAL"
    case whatLinks = "WHAT_LINKS"
}

struct Question: Codable {
    let number: Int
    let type: QuestionType
    let question: String
    let whatLinks: [String]
    let answer: String
    
    /// Validates that the question has valid data
    var isValid: Bool {
        guard number > 0, !question.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !answer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        
        if type == .whatLinks {
            return !whatLinks.isEmpty && whatLinks.allSatisfy { 
                !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
            }
        }
        
        return true
    }
}

struct Quiz: Codable {
    var title: String? = ""
    let questions: [Question]
    
    /// Validates that the quiz has valid data
    var isValid: Bool {
        return !questions.isEmpty && questions.allSatisfy { $0.isValid }
    }
    
    static func fromJson(json: Data) throws -> Quiz {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let quiz = try decoder.decode(Quiz.self, from: json)
        
        guard quiz.isValid else {
            throw QuizLoadingError.parsingError(
                underlyingError: NSError(
                    domain: "QuizValidation", 
                    code: -1, 
                    userInfo: [NSLocalizedDescriptionKey: "Quiz contains invalid questions"]
                )
            )
        }
        
        return quiz
    }
}
