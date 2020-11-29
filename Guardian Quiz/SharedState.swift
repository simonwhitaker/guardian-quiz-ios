//
//  SharedState.swift
//  Guardian Quiz
//
//  Created by Simon on 29/11/2020.
//

import Foundation
import Combine

final class SharedState: ObservableObject {
  @Published var isSecondScreenVisible = false
}
