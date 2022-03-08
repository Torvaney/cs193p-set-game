//
//  Set.swift
//  Set
//
//  Created by Ben Torvaney on 05/03/2022.
//

import Foundation


struct Set {
    private var deck: [Card]
    private(set) var inPlay: [Card]
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
        
        self.deal(n: 12)
    }
    
    
    // MARK: Dealing cards
    
    // External users can only ever deal 3 cards at a time
    // However, internal use (i.e. starting the game)
    // can deal an arbitrary number of cards
    private mutating func deal(n: Int) {
        let (dealt, remaining) = self.deck.cleave(at: n)
        
        inPlay.append(contentsOf: dealt)
        deck = remaining
    }
    
    mutating func deal() {
        deal(n: 3)
    }
    
    
    // MARK: Matching cards
    
    mutating func match(cards: [Card]) -> MatchResult {
        // The first 4 cases should never happen, but it's up to the
        // ViewModel to avoid it
        
        if cards.count < 3 {
            return .notEnoughCards(cards.count)
        }
        
        else if cards.count > 3 {
            return .tooManyCards(cards.count)
        }
        
        else if !cards.allDifferent({ $0 }) {
            return .duplicatedCards
        }
        
        // Should only match cards that are in play
        else if !cards.allSatisfy({ inPlay.contains($0) }) {
            return .invalidCards
        }
        
        else if Set.allMatching(cards) {
            // NOTE: this code on it's own has the potential to introduce a
            // subtle bug
            // If the cards supplied to the `match` argument aren't all
            // in inPlay, then cards could be erroneously added to matched
            // The preceding checks should take care of this
            // Perhaps there's a nicer way that could avoid the need for these checks entirely?
            inPlay.removeAll(where: { cards.contains($0) })
            matched.append(cards)
            deal()
            return .success
        } else {
            return .failure
        }
    }
    
    enum MatchResult {
        case success, failure, invalidCards, duplicatedCards
        case notEnoughCards(_ n: Int)
        case tooManyCards(_ n: Int)
    }
    
    static func allMatching(_ cards: [Card]) -> Bool {
        let characteristics: [(Card) -> Triple] = [
            { $0.color },
            { $0.number },
            { $0.shape },
            { $0.shading },
        ]
        
        return characteristics.allSatisfy { (cards.allEqual($0) || cards.allDifferent($0)) }
    }
    
    
    // MARK: Cards
    
    struct Card: Identifiable, Hashable {
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
