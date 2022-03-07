//
//  ContentView.swift
//  Set
//
//  Created by Ben Torvaney on 05/03/2022.
//

import SwiftUI

struct SetView: View {
    var game: SetGame
    
    var body: some View {
        VStack {
            Text("Let's play Set!")
                .font(.title)
                .padding()
            Spacer()
            AspectVGrid(items: game.game.inPlay, aspectRatio: 1) { item in
                CardView(card: item)
            }
        }
    }
}



struct CardView: View {
    let card: Set.InPlayCard
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder()
            face
        }
        .padding()
    }
    
    @ViewBuilder
    var face: some View {
        VStack {
            ForEach(0..<number(card.card.number)) { _ in
                // TODO: implement this properly
                viewShape(card.card.shape)
                    .foregroundColor(color(card.card.color))
                    .opacity(shading(card.card.shading))
            }
        }.padding()
    }
    
    // TODO: make card appearance configurable in the ViewModel (via a theme?)
    
    @ViewBuilder
    func viewShape(_ triple: Set.Triple) -> some View {
        switch triple {
        case .first:
            Circle()
        case .second:
            Rectangle()
        case .third:
            RoundedRectangle(cornerRadius: 100)
                .aspectRatio(3, contentMode: .fit)
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
