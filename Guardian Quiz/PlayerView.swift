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
    HStack {
      VStack(alignment: .leading) {
        Spacer()
        QuestionView(question: sharedState.currentQuestion)
        Spacer()
      }
      Spacer()
    }
    .padding(EdgeInsets(top: 50, leading: 50, bottom: 50, trailing: 50))
    .foregroundColor(.white)
    .background(Color.black)
  }
}

struct PlayerView_Previews: PreviewProvider {
  static var previews: some View {
    PlayerView()
      .environmentObject(SharedState())
  }
}
