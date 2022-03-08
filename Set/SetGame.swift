//
//  SetGame.swift
//  Set
//
//  Created by Ben Torvaney on 05/03/2022.
//

import Foundation


class SetGame: ObservableObject {
    @Published private var game: Set
    private var selected: [Set.Card] = []
        
    var cards: [Card] {
        game.inPlay.map { Card(data: $0, isSelected: selected.contains($0)) }
    }
    
    var selectionIsMatch: Bool {
        selected.count == 3 && Set.allMatching(selected)
    }
    
    
    // MARK: (Re)Starting the game
    
    init() {
        game = Set()
    }
    
    func reset() {
        game = Set()
    }
    
    func deal() {
        game.deal()
    }
    
    
    // MARK: Selecting cards
    
    func select(card: Card) {
        switch game.match(cards: selected) {
        case .success:
            selected = []
        case .failure:
            selected = []
            selected.append(card.id)
        case .notEnoughCards(_):
            if let ix = selected.firstIndex(of: card.id) {
                selected.remove(at: ix)
            } else {
                selected.append(card.id)
            }
            
        // The following cases should never happen
        // Is there any way to enforce this in the type system?
        case .tooManyCards(_):
            selected = []
        case .duplicatedCards:
            selected = []
        case .invalidCards:
            selected = []
        }
    }
    
    struct Card: Identifiable, Hashable {
        // NOTE: could abstract things further with some idea of a "characteristic"?
        let data: Set.Card
        var isSelected: Bool
        
        var id: Set.Card { data }
    }
}
