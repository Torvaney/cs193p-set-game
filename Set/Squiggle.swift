//
//  Squiggle.swift
//  Set
//
//  Created by Ben Torvaney on 21/03/2022.
//

import SwiftUI

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        
        var p = Path()
        
        // Top line
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX/3, y: rect.minY))
        p.addLine(to: CGPoint(x: 2*rect.maxX/3, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        
        // Bottom line
        p.addLine(to: CGPoint(x: 2*rect.maxX/3, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX/3, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        return p
    }
}

struct Squiggle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Squiggle()
            Squiggle()
            Squiggle()
        }
    }
}
