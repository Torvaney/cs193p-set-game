//
//  ArrayExtension.swift
//  Set
//
//  Created by Ben Torvaney on 05/03/2022.
//

import Foundation


extension Array {
    func cleave(at: Int) -> ([Element], [Element]) {
        // Split an array at a given index into 2 arrays
        // The first array contains elements up to and including `n`
        // The second array contains the elements after `n`
        (Array(self.prefix(at)), Array(self.dropFirst(at)))
    }
    
    func allEqual<X>(_ f: (Element) -> X) -> Bool where X: Equatable {
        if let head = self.first {
            return self
                .dropFirst()
                .map(f)
                .allSatisfy { $0 == f(head) }
        } else {
            return true
        }
    }
    
    func allDifferent<X>(_ f: (Element) -> X) -> Bool where X: Hashable {
        Swift.Set(self.map(f)).count == self.count
    }
}
