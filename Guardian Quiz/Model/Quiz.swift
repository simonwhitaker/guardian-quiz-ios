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

struct IndexedAnswerOption: Identifiable {
    let id: Int
    let value: String
}

struct Question: Codable {
    let number: Int
    let type: QuestionType
    let question: String
    let answer: String
    
    var whatLinksOptions: [IndexedAnswerOption] {
        return question.split(separator: ";").enumerated().map { (i, s) in
            let trimmed = s.trimmingCharacters(in: .whitespacesAndNewlines)
            return IndexedAnswerOption(id: number << 8 + i, value: trimmed)
        }
    }
}

struct Quiz: Codable {
    var title: String? = ""
    let questions: [Question]
    
    static func fromJson(json: Data) throws -> Quiz {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Quiz.self, from: json)
    }
}
