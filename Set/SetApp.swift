//
//  SetApp.swift
//  Set
//
//  Created by Ben Torvaney on 05/03/2022.
//

import SwiftUI

@main
struct SetApp: App {
    var body: some Scene {
        WindowGroup {
            SetView(game: SetGame())
        }
    }
}
