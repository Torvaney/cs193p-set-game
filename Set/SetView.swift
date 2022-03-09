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
            Text("Matched \(game.progress.0) sets (\(game.progress.1) remaining)")
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
    var face: some View {
        DefaultTheme(card: card.data).padding(15)
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
}


// Previews

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetView(game: SetGame())
    }
}
