//
//  QuestionView.swift
//  Guardian Quiz
//
//  Created by Simon on 29/11/2020.
//

import SwiftUI

let titlePadding = EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)

struct QuestionView: View {
  var question: Question

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      if question.type == .whatLinks {
        HStack {
          Text("Question \(question.number): What Links?")
        }
        ForEach(question.whatLinksOptions) { opt in
          HStack(alignment: .top, spacing: 20) {
            Text("-")
            Text(opt.value)
          }
          .font(.title)
        }
      } else {
        Text("Question \(question.number)")
        Text(question.question)
          .font(.title)
      }
    }
  }
}

struct QuestionView_Previews: PreviewProvider {
  static var previews: some View {
    QuestionView(question: Question(number: 1, type: .normal, question: "Foo Bar Baz Wibble jidsji dsji djsi dsji djsi djsi disj Boom", answer: "Bar"))
    QuestionView(question: Question(number: 1, type: .whatLinks, question: "Foo; Bar; Baz; Wibble jidsji dsji djsi dsji djsi djsi disj Boom", answer: "Bar"))
  }
}
