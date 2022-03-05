//
//  Set.swift
//  Set
//
//  Created by Ben Torvaney on 05/03/2022.
//

import Foundation


struct Set {
    var deck: [Card]
    var inPlay: [Card]
    var selected: [Card]  // NOTE: should this be a 3-tuple, instead?
    var matched: [[Card]]
    
    init() {
        deck = [
            Card(color: .first, number: .first, shape: .first, shading: .first),
            Card(color: .second, number: .second, shape: .second, shading: .second),
            Card(color: .third, number: .third, shape: .third, shading: .third),
        ]
        deck.shuffle()
        
        inPlay = []
        selected = []
        matched = []
        
        self.deal(12)
    }
    
    // MARK: Dealing cards
    
    // External users can only ever deal 3 cards at a time
    // However, internal use can deal an arbitrary number of cards
    private mutating func deal(_ n: Int) {
        let (dealt, remaining) = self.deck.cleave(at: n)
        
        inPlay.append(contentsOf: dealt)
        deck = remaining
    }
    
    mutating func deal() {
        deal(3)
    }
    
    
    // MARK: Matching cards
    
    mutating func select(at: Int) -> SelectResult {
        // NOTE: doesn't quite meet the requirements (see points 8-10)
        
        if (selected.count == 3) {
            if allMatching(selected) {
                matched.append(self.selected)
                selected = []
                deal()
                return .matched
            } else {
                inPlay.append(contentsOf: self.selected)
                selected = []
                return .matchFailed
            }
        } else {
            let card = inPlay.remove(at: at)
            selected.append(card)
            return .selectedCard
        }
    }

    private func allMatching(_ cards: [Card]) -> Bool {
        let characteristics: [(Card) -> Triple] = [
            { $0.color },
            { $0.number },
            { $0.shape },
            { $0.shading },
        ]
        
        return characteristics.allSatisfy { (cards.allEqual($0) || cards.allDifferent($0)) }
    }
    
    enum SelectResult {
        case matched, matchFailed, selectedCard
    }
    
    
    // MARK: Cards
    
    // NOTE: should Card go in the ViewModel?
    // i.e. should we be able to play Set! for any arbitrary type of card?
    // what kind of methods would that require?
    struct Card: Identifiable, Hashable {
        // NOTE: could abstract things further with some idea of a "characteristic"?
        let color: Triple
        let number: Triple
        let shape: Triple
        let shading: Triple
        
        var id: Self { self }
    }
    
    enum Triple: Identifiable {
        case first, second, third
        
        var id: Self { self }
    }
}
