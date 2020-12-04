//
//  SharedState.swift
//  Guardian Quiz
//
//  Created by Simon on 29/11/2020.
//

import Foundation
import Combine

final class SharedState: ObservableObject {
  @Published var isSecondScreenVisible = false
  @Published var quiz: Quiz?
  @Published var questionIndex: Int = 0
  @Published var showAnswersToPlayers: Bool = false

  init () {}

  init(quiz: Quiz) {
    self.quiz = quiz
  }
}
