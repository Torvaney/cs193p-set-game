//
//  TripleModifier.swift
//  Set
//
//  Created by Ben Torvaney on 09/03/2022.
//

import SwiftUI


protocol TripleModifier: ViewModifier {
    var level: Triple { get }
    
    func first(_ content: Content) -> V1
    func second(_ content: Content) -> V2
    func third(_ content: Content) -> V3
    
    associatedtype V1: View
    associatedtype V2: View
    associatedtype V3: View
}

extension TripleModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        switch level {
        case .first:
            first(content)
        case .second:
            second(content)
        case .third:
            third(content)
        }
    }
}
