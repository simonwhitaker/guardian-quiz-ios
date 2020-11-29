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

  @Published var quiz: Quiz

  init() {
    let fixturePath = Bundle.main.path(forResource: "quiz", ofType: "json")

    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: fixturePath!))
      self.quiz = try Quiz.fromJson(json: data)
    } catch {
      self.quiz = Quiz(title: "", date: Date(), questions: [])
    }
  }
}
