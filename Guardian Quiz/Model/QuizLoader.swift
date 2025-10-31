//
//  QuizLoader.swift
//  Guardian Quiz
//
//  Created by Simon on 04/12/2020.
//

import Foundation

enum QuizLoadingError: Error {
    case httpError(statusCode: Int, message: String)
    case parsingError(underlyingError: Error)
    case unknownError(underlyingError: Error)
}

// The error type returned by the quiz server. Declaring it as a Codable struct
// so we can pass it to JSONDecoder.
struct QuizServerError: Codable {
    var errorMessage: String
}

// Removed custom ResultType - Swift's built-in Result type or async/await pattern is preferred

func loadQuizFromURL(url: URL) async throws -> Quiz {
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 20.0)
    
    do {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw QuizLoadingError.unknownError(underlyingError: URLError(.badServerResponse))
        }
        
        if httpResponse.statusCode == 200 {
            return try Quiz.fromJson(json: data)
        } else {
            do {
                let errorData = try JSONDecoder().decode(QuizServerError.self, from: data)
                throw QuizLoadingError.httpError(statusCode: httpResponse.statusCode, message: errorData.errorMessage)
            } catch {
                throw QuizLoadingError.httpError(statusCode: httpResponse.statusCode, message: "Unknown error")
            }
        }
    } catch let error as QuizLoadingError {
        throw error
    } catch {
        throw QuizLoadingError.unknownError(underlyingError: error)
    }
}

func loadLatestQuiz() async throws -> Quiz {
    // https://eaton-bitrot.koyeb.app/swagger/index.html
    let urlString = "https://eaton-bitrot.koyeb.app/api/quiz"
    guard let url = URL(string: urlString) else {
        throw QuizLoadingError.unknownError(underlyingError: URLError(.badURL))
    }
    return try await loadQuizFromURL(url: url)
}

func loadFixture() -> Quiz {
    let fixturePath = Bundle.main.path(forResource: "quiz", ofType: "json")
    
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: fixturePath!))
        return try Quiz.fromJson(json: data)
    } catch {
        return Quiz(questions: [])
    }
}
