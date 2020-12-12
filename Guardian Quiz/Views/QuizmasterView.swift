//
//  ContentView.swift
//  Guardian Quiz
//
//  Created by Simon on 29/11/2020.
//

import SwiftUI

struct QuizmasterView: View {
  @EnvironmentObject var sharedState: SharedState
  @State var loadingError: QuizLoadingError?
  @State var isLoading: Bool = false
  @State var showAnswersToQuizmaster: Bool = false


  func loadQuiz() -> Void {
    isLoading = true
    loadLatestQuiz() { result in
      DispatchQueue.main.async {
        isLoading = false
        switch result {
        case .failure(let error):
          loadingError = error
        case .success(let quiz):
          sharedState.quiz = quiz
        }
      }
    }
  }

  var body: some View {
    if isLoading {
      HStack {
        ProgressView()
        Text("Loading quiz")
      }
    } else if let error = loadingError {
      switch error {
      case QuizLoadingError.httpError(let statusCode, let message):
        Text("HTTP Error \(statusCode): \(message)").padding()
      default:
        Text("Error: \(error.localizedDescription)").padding()
      }
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
            Image(systemName: "backward.end")
              .font(.title)
              .padding()
          })
          .disabled(sharedState.questionIndex == 0)

          Button(action: {
            sharedState.showAnswersToPlayers = false
            sharedState.questionIndex -= 1
          }, label: {
            Image(systemName: "backward")
              .font(.title)
              .padding()
          })
          .disabled(sharedState.questionIndex == 0)
          Spacer()
          Button(action: {
            sharedState.showAnswersToPlayers = false
            sharedState.questionIndex += 1
          }, label: {
            Image(systemName: "forward")
              .font(.title)
              .padding()
          })
          .disabled(sharedState.questionIndex == quiz.questions.count - 1)
        }

        Toggle(isOn: $showAnswersToQuizmaster, label: {
          Text("See answers")
        })
      }
      .padding()
    }

    if sharedState.quiz == nil && !isLoading {
      Button(action: loadQuiz, label: {
        Text("Load Quiz")
      }).onAppear(perform: {
        loadQuiz()
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
