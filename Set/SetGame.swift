//
//  SetGame.swift
//  Set
//
//  Created by Ben Torvaney on 05/03/2022.
//

import Foundation


class SetGame: ObservableObject {
    @Published var game: Set
    
    init() {
        game = Set()
    }
    
    func reset() {
        game = Set()
    }
}
