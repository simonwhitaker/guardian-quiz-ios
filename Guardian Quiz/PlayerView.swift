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
    if let quiz = sharedState.quiz {
      let currentQuestion = quiz.questions[sharedState.questionIndex]
      HStack {
        VStack(alignment: .leading) {
          Spacer()
          QuestionView(question: currentQuestion, showAnswer: sharedState.showAnswersToPlayers)
          Spacer()
        }
        Spacer()
      }
      .padding(EdgeInsets(top: 50, leading: 50, bottom: 50, trailing: 50))
      .foregroundColor(.white)
      .background(Color.black)
    } else {
      Text("Quiz loading")
    }
  }
}

struct PlayerView_Previews: PreviewProvider {
  static var previews: some View {
    PlayerView()
      .environmentObject(SharedState())
  }
}
