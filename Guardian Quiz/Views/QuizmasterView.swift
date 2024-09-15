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
                    sharedState.scores = Array(repeating: 0, count: quiz.questions.count)                }
            }
        }
    }

    func toggleScore() -> Void {
        let idx = sharedState.questionIndex
        sharedState.scores[idx] = (sharedState.scores[idx] + 2) % 3
    }

    func scoreImageSystemName() -> String {
        let idx = sharedState.questionIndex
        let score = sharedState.scores[idx]
        switch score {
        case 0:
            return "star"
        case 1:
            return "star.leadinghalf.filled"
        case 2:
            return "star.fill"
        default:
            return "questionmark.square.dashed"
        }
    }

    var body: some View {
        if isLoading {
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10) {
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
                QuestionView(
                    question: currentQuestion,
                    showAnswer: sharedState.isScoring
                )

                if (sharedState.isScoring && sharedState.isSecondScreenVisible) {
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
                
                VStack {
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
                        Button(action: toggleScore,
                               label: {
                            Image(systemName:scoreImageSystemName())
                                .font(.title)
                                .padding()
                        }).disabled(!sharedState.isScoring)
                    }
                    HStack {
                        Button(action: loadQuiz) {
                            Label("Reload", systemImage: "arrow.clockwise.circle")
                        }
                        Spacer()
                        Toggle("See answers",
                               systemImage: "eye",
                               isOn: $sharedState.isScoring
                        ).toggleStyle(.button)
                    }
                }
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
