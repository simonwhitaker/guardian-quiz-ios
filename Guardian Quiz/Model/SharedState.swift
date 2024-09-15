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
    @Published var isScoring = false
    @Published var quiz: Quiz?
    @Published var questionIndex: Int = 0
    @Published var showAnswersToPlayers: Bool = false
    @Published var scores: [Int8] = []

    init () {}
    
    init(quiz: Quiz, showAnswersToPlayers: Bool = false) {
        self.quiz = quiz
        self.showAnswersToPlayers = showAnswersToPlayers
        self.scores = Array(repeating: 0, count: quiz.questions.count)
    }

    func totalScore() -> Decimal {
        return Decimal.init(self.scores.reduce(0, +)) / 2
    }
}
