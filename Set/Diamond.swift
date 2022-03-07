//
//  Diamond.swift
//  Set
//
//  Created by Ben Torvaney on 07/03/2022.
//

import SwiftUI

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return p
    }
}

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Diamond()
            Diamond().padding()
            Diamond().stroke()
        }
    }
}
