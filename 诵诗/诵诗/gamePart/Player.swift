//
//  Player.swift
//  Skywalker
//
//  Created by Jais Cheema on 30/4/17.
//  Copyright © 2017 Needle Apps. All rights reserved.
//

import Foundation

class Player {
    let identifier: String
    let displayName: String
    let isTemp: Bool
    
    init(identifier: String, displayName: String, isTemp: Bool = false) {
        self.identifier = identifier
        self.displayName = displayName
        self.isTemp = isTemp
    }
    
    convenience init() {
        self.init(identifier: RandomIdentifier(),
                  displayName: "Matching",
                  isTemp: true)
    }
    
    // Only used for the AI Players
    func takeAction(forState: GameState, index: Int) -> Action? {
        return nil
    }
}
