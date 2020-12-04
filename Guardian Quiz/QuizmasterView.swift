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
      VStack(alignment: .leading, spacing: 50) {
        QuestionView(question: currentQuestion, showAnswer: showAnswersToQuizmaster)

        if (showAnswersToQuizmaster && sharedState.isSecondScreenVisible) {
          Button(action: {
            withAnimation {
              sharedState.showAnswersToPlayers = true
            }
          }, label: {
            HStack {
              Image(systemName: "tv")
              Text("Show answer to players")
            }
          })
        }

        Spacer()

        HStack {
          Button(action: {
            sharedState.showAnswersToPlayers = false
            sharedState.questionIndex = 0
          }, label: {
            Image(systemName: "backward.end.fill")
              .font(.title)
              .padding()
          })
          .disabled(sharedState.questionIndex == 0)

          Button(action: {
            sharedState.showAnswersToPlayers = false
            sharedState.questionIndex -= 1
          }, label: {
            Image(systemName: "backward.fill")
              .font(.title)
              .padding()
          })
          .disabled(sharedState.questionIndex == 0)
          Spacer()
          Button(action: {
            sharedState.showAnswersToPlayers = false
            sharedState.questionIndex += 1
          }, label: {
            Image(systemName: "forward.fill")
              .font(.title)
              .padding()
          })
          .disabled(sharedState.questionIndex == quiz.questions.count - 1)
        }

        Toggle(isOn: $showAnswersToQuizmaster, label: {
          HStack {
            Image(systemName: "eye")
            Text("See answers")
          }
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
