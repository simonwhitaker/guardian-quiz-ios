//
//  QuizLoader.swift
//  Guardian Quiz
//
//  Created by Simon on 04/12/2020.
//

import Foundation

func loadURL(url: URL) throws -> Quiz {
  let data = try Data(contentsOf: url)
  return try Quiz.fromJson(json: data)
}

func loadLatest() throws -> Quiz {
  // https://saturday-quiz.herokuapp.com/swagger/index.html
  return try loadURL(url: URL(string: "https://saturday-quiz.herokuapp.com/api/quiz")!)
}
