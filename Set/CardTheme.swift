//
//  CardTheme.swift
//  Set
//
//  Created by Ben Torvaney on 09/03/2022.
//

import SwiftUI


struct DefaultTheme: View {
    var card: Set.Card
    
    var body: some View {
        baseShape
            .aspectRatio(3, contentMode: .fit)
            .modifier(CardNumber(level: card.number))
            .modifier(CardColor(level: card.color))
    }
    
    @ViewBuilder
    var baseShape: some View {
        switch card.shape {
        case .first:
            // Repetition is inelegant, but outside of returning `some Shape`, I'm not sure how best to
            // avoid it. Is this *good enough* for this assignment?
            // What would be the idiomatic way to solve this? An extension on Shape, perhaps?
            applyShading(Diamond())
        case .second:
            applyShading(Squiggle())
        case .third:
            applyShading(RoundedRectangle(cornerRadius: 100))
        }
    }
    
    struct CardNumber: ViewModifier {
        var level: Triple
        
        @ViewBuilder
        func body(content: Content) -> some View {
            VStack {
                ForEach(0..<level.value, id: \.self) { _ in
                    content
                }
            }
        }
    }
    
    @ViewBuilder
    func applyShading<S>(_ content: S) -> some View where S: Shape {
        switch card.shading {
        case .first:
            content.stroke(lineWidth: 2)
        case .second:
            ZStack {
                content.opacity(0.3)
                content.stroke(lineWidth: 2)
            }
        case .third:
            content
        }
    }
    
    struct CardShading: TripleModifier {
        var level: Triple

        func first(_ content: Content) -> some View {
            content.opacity(0.2)
        }

        func second(_ content: Content) -> some View {
            content.opacity(0.6)
        }

        func third(_ content: Content) -> some View {
            content.opacity(1.0)
        }
    }

    struct CardColor: TripleModifier {
        var level: Triple

        func first(_ content: Content) -> some View {
            content.foregroundColor(.red)
        }

        func second(_ content: Content) -> some View {
            content.foregroundColor(.green)
        }

        func third(_ content: Content) -> some View {
            content.foregroundColor(.blue)
        }
    }
}

