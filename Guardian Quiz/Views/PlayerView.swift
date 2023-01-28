//
//  PlayerView.swift
//  Guardian Quiz
//
//  Created by Simon on 29/11/2020.
//

import SwiftUI

struct PlayerView: View {
  @EnvironmentObject var sharedState: SharedState

  var body: some View {
    GeometryReader { geometry in
      let scaleFactor = geometry.size.width / 720.0

      if let quiz = sharedState.quiz {
        let currentQuestion = quiz.questions[sharedState.questionIndex]
        VStack(alignment: .leading) {
          QuestionView(
            question: currentQuestion,
            showAnswer: sharedState.showAnswersToPlayers,
            scaleFactor: scaleFactor
          )
            .padding(50 * scaleFactor)
        }
      }
      else {
        Text("Quiz loading").font(Font.system(size: 24 * scaleFactor))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .background(Color.black).ignoresSafeArea()
    .foregroundColor(.white)
  }
}

struct PlayerView_Previews: PreviewProvider {
  static var previews: some View {
    PlayerView()
      .environmentObject(SharedState(quiz: loadFixture(), showAnswersToPlayers: true))
      .previewLayout(.fixed(width: 1920, height: 1080))
    PlayerView()
      .environmentObject(SharedState())
      .previewLayout(.fixed(width: 1920, height: 1080))
  }
}
