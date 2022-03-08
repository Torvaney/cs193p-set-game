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
        game.inPlay.map { Card(data: $0, selection: classifySelection($0)) }
    }
    
    var noMoreCards: Bool {
        game.noMoreCards
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
        // This is because the only place where cards are added is in .notEnoughCards
        // after `selected` has been checked for the existence of the card
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
        var selection: Selection
        
        var id: Set.Card { data }
    }
    
    enum Selection {
        case notSelected, pending, noMatch, isMatch
    }
    
    private func classifySelection(_ card: Set.Card) -> Selection {
        if !selected.contains(card) {
            return .notSelected
        } else if selected.count != 3 {
            return .pending
        } else if Set.allMatching(selected) {
            return .isMatch
        } else {
            return .noMatch
        }
    }
}
