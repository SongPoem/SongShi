//
//  GameCenterMatch.swift
//  Skywalker
//
//  Created by Jais Cheema on 25/4/17.
//  Copyright © 2017 Needle Apps. All rights reserved.
//

import Foundation
import GameKit

class GameCenterMatch: Match {
    private(set) var turnBasedMatch: GKTurnBasedMatch
    
    override var currentPlayerIndex: Int? {
        guard let currentParticipant = self.turnBasedMatch.currentParticipant else { return nil }
        return self.turnBasedMatch.participants!.index(of: currentParticipant)
    }
    
    override var isServer: Bool {
        guard let currentIndex = self.currentPlayerIndex else { return false }
        return localPlayerIdentifier == self.players[currentIndex].identifier
    }
    
    init(turnBasedMatch: GKTurnBasedMatch) {
        self.turnBasedMatch = turnBasedMatch
        let players = (turnBasedMatch.participants ?? []).map { $0.mPlayer }
        super.init(identifier: turnBasedMatch.matchID ?? RandomIdentifier(),
                   players: players,
                   localPlayerIdentifier: GKLocalPlayer.localPlayer().playerID!,
                   matchData: turnBasedMatch.matchData)
    }
    
    override func saveTurn(nextPlayerIndex: Int?) {
        if let index = nextPlayerIndex {
            let nextParticipants = nextParticipantArray(nextPlayerIndex: index)
            self.turnBasedMatch.endTurn(withNextParticipants: nextParticipants, turnTimeout: 0, match: matchData, completionHandler: nil)
        } else {
            self.turnBasedMatch.saveCurrentTurn(withMatch: matchData, completionHandler: nil)
        }
    }
    
    override func endMatch(withResults results: [Int : Result]) {
        for (index, participant) in (self.turnBasedMatch.participants ?? []).enumerated() {
            guard let result = results[index] else { continue }
            participant.matchOutcome = result.matchOutcome
        }
        self.turnBasedMatch.endMatchInTurn(withMatch: matchData, completionHandler: nil)
    }
    
    func update(turnBasedMatch: GKTurnBasedMatch) {
        let maxTimeInterval = self.actions.map { $0.timeInterval }.max() ?? 0
        let updatedActions = ActionsFrom(matchData: turnBasedMatch.matchData ?? Data())
        let newActions = updatedActions.filter { $0.timeInterval > maxTimeInterval }
        self.turnBasedMatch = turnBasedMatch
        self.actions = updatedActions
        self.game.add(actions: newActions)
        // update the players
    }
    
    func nextParticipantArray(nextPlayerIndex: Int) -> [GKTurnBasedParticipant] {
        let participants = self.turnBasedMatch.participants ?? []
        return participants.shift(withDistance: nextPlayerIndex)
    }
}
