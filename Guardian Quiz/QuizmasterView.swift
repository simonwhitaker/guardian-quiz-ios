//
//  ContentView.swift
//  Guardian Quiz
//
//  Created by Simon on 29/11/2020.
//

import SwiftUI

struct QuizmasterView: View {
  @EnvironmentObject var sharedState: SharedState

  var body: some View {
    VStack(alignment: .leading) {
      QuestionView(question: sharedState.currentQuestion)
        .padding(.bottom, 20)
      HStack {
        if (sharedState.questionIndex > 0) {
          Button(action: {
            sharedState.questionIndex -= 1
          }, label: {
            Text("Previous")
          })
        }
        Spacer()
        if (sharedState.questionIndex < sharedState.quiz.questions.count - 1) {
          Button(action: {
            sharedState.questionIndex += 1
          }, label: {
            Text("Next")
          })
        }
      }
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    QuizmasterView()
      .environmentObject(SharedState())
  }
}
