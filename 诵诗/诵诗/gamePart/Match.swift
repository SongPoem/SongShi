//
//  Match.swift
//  Skywalker
//
//  Created by Jais Cheema on 23/4/17.
//  Copyright © 2017 Needle Apps. All rights reserved.
//

import Foundation
import GameKit

func ActionsFrom(matchData: Data) -> [Action] {
    guard let actions = NSKeyedUnarchiver.unarchiveObject(with: matchData) as? [Action] else {
        return []
    }
    return actions
}

enum Result: Int {
    case won = 1
    case lost = 2
    case tie = 3
    
    var opposite: Result {
        switch self {
        case .won:
            return .lost
        case .lost:
            return .won
        case .tie:
            return .tie
        }
    }
    
    var matchOutcome: GKTurnBasedMatchOutcome {
        switch self {
        case .won:
           return .won
        case .lost:
            return .lost
        case .tie:
            return .tied
        }
    }
}

class Match {
    let identifier: String
    let localPlayerIdentifier: String
    var players: [Player]
    var actions: [Action]
   
    var currentPlayerIndex: Int? { return nil }
    var isServer: Bool { return true }
    var matchData: Data { return NSKeyedArchiver.archivedData(withRootObject: self.actions) }
    
    private var _game: Game?
    var game: Game {
        if _game == nil {
            _game = Game(match: self)
        }
        return _game!
    }
    
    init(identifier: String, players: [Player], localPlayerIdentifier: String, matchData: Data?) {
        self.identifier = identifier
        self.players = players
        self.localPlayerIdentifier = localPlayerIdentifier
        self.actions = ActionsFrom(matchData: matchData ?? Data())
        NotificationCenter.default.addObserver(self, selector: #selector(handleGameEvent), name: GameNotificationName, object: nil)
    }
    
    func saveTurn(nextPlayerIndex: Int? = nil) {}
    func endMatch(withResults results: [Int: Result]) {}
    
    @objc func handleGameEvent(_ notification: Notification) {
        if let action = notification.object as? Action {
            guard !self.actions.contains(action) else { return }
            self.actions.append(action)
            
            switch action {
            case let currentAction as SetCurrentPlayer:
                if self.currentPlayerIndex != currentAction.playerIndex {
                    self.saveTurn(nextPlayerIndex: currentAction.playerIndex)
                } else {
                    self.saveTurn()
                }
            case let currentAction as SetResults:
                self.endMatch(withResults: currentAction.results)
            default:
                self.saveTurn()
            }
        }
    }
}
