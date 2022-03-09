//
//  CardTheme.swift
//  Set
//
//  Created by Ben Torvaney on 09/03/2022.
//

import SwiftUI


protocol CardTheme: View {
    var card: Set.Card { get }
    
    var shape: S { get }
    var number: N { get }
    var color: C { get }
    var shading: Sh { get }
    
    associatedtype S: View
    associatedtype N: ViewModifier
    associatedtype C: ViewModifier
    associatedtype Sh: ViewModifier
}

extension CardTheme {
    var body: some View {
        shape
            .modifier(number)
            .modifier(color)
            .modifier(shading)
    }
}


struct DefaultTheme: CardTheme {
    var card: Set.Card
    
    var shape: some View {
        baseShape.aspectRatio(3, contentMode: .fit)
    }
    
    @ViewBuilder
    var baseShape: some View {
        switch card.shape {
        case .first:
            Diamond()
        case .second:
            Rectangle()
        case .third:
            RoundedRectangle(cornerRadius: 100)
        }
    }
    
    var number: some ViewModifier { CardNumber(level: card.number) }
    
    var color: some ViewModifier { CardColor(level: card.color) }
    
    var shading: some ViewModifier { CardShading(level: card.shading) }
    
    
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

