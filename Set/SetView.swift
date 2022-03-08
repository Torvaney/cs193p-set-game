//
//  ContentView.swift
//  Set
//
//  Created by Ben Torvaney on 05/03/2022.
//

import SwiftUI

struct SetView: View {
    @ObservedObject var game: SetGame
    
    var body: some View {
        VStack {
            Text("Let's play Set!")
                .font(.title)
                .padding()
            Spacer()
            AspectVGrid(items: game.cards, aspectRatio: 1) { item in
                // TODO: need to enforce a minimum size on each card to ensure readability is maintained
                CardView(item) { game.select(card: item) }
            }
            Divider()
            ControlPanel(game: game)
        }
    }
}


struct ControlPanel: View {
    @ObservedObject var game: SetGame
    
    var body: some View {
        HStack {
            Button("3 more cards, please!") { game.deal() }
                .disabled(game.noMoreCards)
            Spacer()
            Button("New game") { game.reset() }
        }.padding(.horizontal)
    }
}



struct CardView: View {
    let card: SetGame.Card
    let onTap: () -> Void
    
    init(_ card: SetGame.Card, onTap: @escaping () -> Void) {
        self.card = card
        self.onTap = onTap
    }
    
    var body: some View {
        ZStack {
            background
            face
        }
        .padding(5)
        .onTapGesture {
            onTap()
        }
    }
    
    @ViewBuilder
    var background: some View {
        ZStack {
            let baseShape = RoundedRectangle(cornerRadius: 5)
            let border = baseShape.strokeBorder(lineWidth: 2)
            
            baseShape
                .foregroundColor(selectionColor ?? .white)
                .opacity(0.1)
            border
                .foregroundColor(selectionColor ?? .gray)
        }
    }
    
    var selectionColor: Color? {
        switch card.selection {
        case .notSelected:
            return nil
        case .isMatch:
            return .green
        case .pending:
            return .blue
        case .noMatch:
            return .red
        }
    }
    
    // TODO: below this all needs to be sorted out...
    
    @ViewBuilder
    var face: some View {
        VStack {
            ForEach(0..<number(card.data.number)) { _ in
                // TODO: implement this properly
                viewShape(card.data.shape)
                    .aspectRatio(3, contentMode: .fit)
                    .foregroundColor(color(card.data.color))
                    .opacity(shading(card.data.shading))
            }
        }
        .padding(15)
    }
        
    @ViewBuilder
    func viewShape(_ triple: Set.Triple) -> some View {
        switch triple {
        case .first:
            Diamond()
        case .second:
            Rectangle()
        case .third:
            RoundedRectangle(cornerRadius: 100)
        }
    }
    
    // Should this be a method on triple?
    func switchTriple<X>(_ triple: Set.Triple, _ first: X, _ second: X, _ third: X) -> X {
        switch triple {
        case .first: return first
        case .second: return second
        case .third: return third
        }
    }
    
    // Really, each of these should be a some View, right?
    func number(_ triple: Set.Triple) -> Int {
        switchTriple(triple, 1, 2, 3)
    }
    
    func color(_ triple: Set.Triple) -> Color {
        switchTriple(triple, .red, .green, .blue)
    }
    
    func shading(_ triple: Set.Triple) -> Double {
        switchTriple(triple, 0.1, 0.5, 1.0)
    }
    
}


// Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetView(game: SetGame())
    }
}
