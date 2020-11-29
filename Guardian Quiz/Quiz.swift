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
  let answer: String
}

struct Quiz: Codable {
  let title: String
  let date: Date
  let questions: [Question]

  static func fromJson(json: Data) throws -> Quiz {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try decoder.decode(Quiz.self, from: json)
  }
}
