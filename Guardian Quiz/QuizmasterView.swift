//
//  ContentView.swift
//  Guardian Quiz
//
//  Created by Simon on 29/11/2020.
//

import SwiftUI

struct QuizmasterView: View {
  @EnvironmentObject var sharedState: SharedState
  @State var loadingError: Error?
  @State var isLoading: Bool = false
  @State var showAnswersToQuizmaster: Bool = false

  var body: some View {
    if isLoading {
      Text("Loading...")
    } else if let error = loadingError {
      Text("Error: \(error.localizedDescription)")
    }
    else if let quiz = sharedState.quiz {
      let currentQuestion = quiz.questions[sharedState.questionIndex]
      VStack(alignment: .leading) {
        QuestionView(question: currentQuestion, showAnswer: showAnswersToQuizmaster)
          .padding(.bottom, 20)
        HStack {
          if (sharedState.questionIndex > 0) {
            Button(action: {
              sharedState.showAnswersToPlayers = false
              sharedState.questionIndex = 0
            }, label: {
              Text("First")
            })

            Button(action: {
              sharedState.showAnswersToPlayers = false
              sharedState.questionIndex -= 1
            }, label: {
              Text("Previous")
            })
          }
          Spacer()
          if (sharedState.questionIndex < quiz.questions.count - 1) {
            Button(action: {
              sharedState.showAnswersToPlayers = false
              sharedState.questionIndex += 1
            }, label: {
              Text("Next")
            })
          }
        }
        Toggle(isOn: $showAnswersToQuizmaster, label: {
          Text("Show answers to me")
        })
        Button(action: {
          withAnimation {
            sharedState.showAnswersToPlayers = true
          }
        }, label: {
          Text("Show answer to players")
        })
      }
      .padding()
    } else {
      Button(action: {
        do {
          isLoading = true
          sharedState.quiz = try loadLatest()
          isLoading = false
        } catch {
          loadingError = error
        }
      }, label: {
        Text("Load Quiz")
      })
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    QuizmasterView()
      .environmentObject(SharedState(quiz: loadFixture()))
  }
}
