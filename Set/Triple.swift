//
//  Triple.swift
//  Set
//
//  Created by Ben Torvaney on 09/03/2022.
//

import Foundation


enum Triple: Identifiable, CaseIterable {
    case first
    case second
    case third
    
    var id: Self { self }
    
    var value: Int {
        switch self {
        case .first:
            return 1
        case .second:
            return 2
        case .third:
            return 3
        }
    }
}
