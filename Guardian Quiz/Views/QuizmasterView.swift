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

    
    func loadQuiz() async {
        isLoading = true
        loadingError = nil
        
        do {
            let quiz = try await loadLatestQuiz()
            sharedState.quiz = quiz
            sharedState.scores = Array(repeating: 0, count: quiz.questions.count)
        } catch let error as QuizLoadingError {
            loadingError = error
        } catch {
            loadingError = .unknownError(underlyingError: error)
        }
        
        isLoading = false
    }

    func toggleScore() -> Void {
        guard let quiz = sharedState.quiz,
              sharedState.questionIndex < quiz.questions.count,
              sharedState.questionIndex >= 0 else { return }
        
        let idx = sharedState.questionIndex
        sharedState.scores[idx] = (sharedState.scores[idx] + 2) % 3
    }

    func scoreImageSystemName() -> String {
        guard let quiz = sharedState.quiz,
              sharedState.questionIndex < quiz.questions.count,
              sharedState.questionIndex >= 0 else { 
            return "questionmark.square.dashed" 
        }
        
        let idx = sharedState.questionIndex
        guard idx < sharedState.scores.count else { 
            return "questionmark.square.dashed" 
        }
        
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
        VStack {
            if isLoading {
                HStack(alignment: .center, spacing: 10) {
                    ProgressView()
                    Text("Loading quiz")
                }
            } else if let error = loadingError {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 48))
                        .foregroundColor(.orange)
                    
                    switch error {
                    case QuizLoadingError.httpError(let statusCode, let message):
                        Text("Server Error")
                            .font(.headline)
                        Text("HTTP \(statusCode): \(message)")
                            .multilineTextAlignment(.center)
                    case QuizLoadingError.parsingError:
                        Text("Data Error")
                            .font(.headline)
                        Text("Failed to parse quiz data")
                            .multilineTextAlignment(.center)
                    case QuizLoadingError.unknownError(let underlyingError):
                        Text("Connection Error")
                            .font(.headline)
                        Text(underlyingError.localizedDescription)
                            .multilineTextAlignment(.center)
                    }
                    
                    Button("Try Again") {
                        Task {
                            await loadQuiz()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            } else if let quiz = sharedState.quiz {
                if let currentQuestion = sharedState.currentQuestion {
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
                                .accessibilityLabel("Go to first question")

                                Button(action: {
                                    sharedState.showAnswersToPlayers = false
                                    sharedState.questionIndex -= 1
                                }, label: {
                                    Image(systemName: "backward")
                                        .font(.title)
                                        .padding()
                                })
                                .disabled(sharedState.questionIndex == 0)
                                .accessibilityLabel("Previous question")
                                
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
                                .accessibilityLabel("Next question")
                                
                                Button(action: toggleScore,
                                       label: {
                                    Image(systemName:scoreImageSystemName())
                                        .font(.title)
                                        .padding()
                                })
                                .disabled(!sharedState.isScoring)
                                .accessibilityLabel("Toggle score")
                            }
                            HStack {
                                Button(action: {
                                    Task {
                                        await loadQuiz()
                                    }
                                }) {
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
                } else {
                    Text("Invalid question index")
                        .foregroundColor(.red)
                        .padding()
                }
            } else {
                Button(action: {
                    Task {
                        await loadQuiz()
                    }
                }, label: {
                    Text("Load Quiz")
                })
            }
        }
        .task {
            if sharedState.quiz == nil {
                await loadQuiz()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuizmasterView()
            .environmentObject(SharedState(quiz: loadFixture()))
    }
}
