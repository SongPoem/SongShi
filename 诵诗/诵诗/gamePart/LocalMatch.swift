//
//  LocalMatch.swift
//  Skywalker
//
//  Created by Jais Cheema on 1/5/17.
//  Copyright © 2017 Needle Apps. All rights reserved.
//

import Foundation

class AIPlayer: Player {
    override func takeAction(forState state: GameState, index: Int) -> Action? {
        guard state.currentPlayerIndex == index else { return nil }
        switch state.status {
        case .awaitingPlay:
            let selection: GameSelection = .spock
            return ChoiceAction(timeInterval: Date().timeIntervalSince1970)
        default:
            return nil
        }
    }
}

class LocalMatch: Match {
    private var _currentPlayerIndex: Int? = 0
    override var currentPlayerIndex: Int? { return _currentPlayerIndex }

    override func saveTurn(nextPlayerIndex: Int?) {
        if let index = nextPlayerIndex {
            self._currentPlayerIndex = index
            if let action = self.players[index].takeAction(forState: self.game.state, index: index) {
                self.game.add(action: action)
            }
        }
        // persist this in the local db
    }
    
    override func endMatch(withResults results: [Int : Result]) {
        // persist this in the local db
    }
}
