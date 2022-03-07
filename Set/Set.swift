//
//  Set.swift
//  Set
//
//  Created by Ben Torvaney on 05/03/2022.
//

import Foundation


struct Set {
    private(set) var deck: [Card]
    private(set) var inPlay: [InPlayCard]
    private(set) var matched: [[Card]]
    
    init() {
        
        // Initialise the deck at random
        deck = []
        
        // Apparently Swift doesn't have a Cartesian Product function?!
        for color in Triple.allCases {
            for number in Triple.allCases {
                for shape in Triple.allCases {
                    for shading in Triple.allCases {
                        // There absolutely *must* be a better way than this?!
                        deck.append(Card(
                            color: color,
                            number: number,
                            shape: shape,
                            shading: shading
                        ))
                    }
                }
            }
        }
        
        deck.shuffle()
        
        inPlay = []
        matched = []
        
        self.deal(12)
    }
    
    // MARK: Dealing cards
    
    // External users can only ever deal 3 cards at a time
    // However, internal use can deal an arbitrary number of cards
    private mutating func deal(_ n: Int) {
        let (dealt, remaining) = self.deck.cleave(at: n)
        
        inPlay.append(contentsOf: dealt.map { InPlayCard(card: $0) })
        deck = remaining
    }
    
    mutating func deal() {
        deal(3)
    }
    
    
    // MARK: Matching cards
    
    private var selected: [Card] {
        inPlay
            .filter { $0.isSelected }
            .map { $0.card }
    }
    
    mutating func select(card: Card) -> SelectResult {
        // NOTE: doesn't quite meet the requirements (see points 8-10)
        if selected.count == 3 {        // > 3 selected should be impossible
            if allMatching(selected) {
                
                // 8 (a): as per the rules of Set, replace those 3 matching Set cards with new ones from the deck
                self.matched.append(selected)
                inPlay.removeAll(where: { $0.isSelected })
                deal()
                
                // 8 (c) and (d):
                // if the touched card was not part of the matching Set, then select that card
                // if the touched card was part of a matching Set, then select no card
                if let ix = inPlay.firstIndex(of: InPlayCard(card: card)) {
                    inPlay[ix].select()
                }
                
                return .matched
                
            } else {
                // 9: When any card is touched and there are already 3 non-matching Set cards selected,
                // deselect those 3 non-matching cards and select the touched-on card
                deselectAll()
                return .matchFailed
            }
        } else {
            // fewer than 3 matching cards => select the card
            // NOTE: some duplication here - should we pull this out into another function?
            if let ix = inPlay.firstIndex(of: InPlayCard(card: card)) {
                inPlay[ix].select()
            }
            return .selectedCard
        }
    }
    
    private mutating func deselectAll() {
        inPlay = inPlay.map { $0.deselected() }
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
    
    struct InPlayCard: Identifiable, Hashable {
        let card: Card
        var isSelected: Bool = false
        
        mutating func select() {
            isSelected = true
        }
        
        mutating func deselect() {
            isSelected = false
        }
        
        func selected() -> InPlayCard {
            InPlayCard(card: card, isSelected: true)
        }
        
        func deselected() -> InPlayCard {
            InPlayCard(card: card, isSelected: false)
        }
        
        var id: Card { card }
    }
    
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
    
    enum Triple: Identifiable, CaseIterable {
        case first
        case second
        case third
        
        var id: Self { self }
    }
}
