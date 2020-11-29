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
    Text("This is the quizmaster view")
      .padding()
    Text("Second screen is " + (sharedState.isSecondScreenVisible ? "visible" : "hidden"))
      .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    QuizmasterView()
      .environmentObject(SharedState())
  }
}
