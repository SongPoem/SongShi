//
//  Extensions.swift
//  Skywalker
//
//  Created by Jais Cheema on 25/4/17.
//  Copyright © 2017 Needle Apps. All rights reserved.
//

import Foundation
import GameKit

func RandomIdentifier() -> String {
    return NSUUID().uuidString
}

extension GKTurnBasedParticipant {
    var mPlayer: Player {
        guard let _player = player, let playerId = _player.playerID else {
            return Player()
        }
        return Player(identifier: playerId,
                      displayName: _player.displayName ?? "Random")
    }
}

extension Array {
    func shift(withDistance distance: Int = 1) -> Array<Element> {
        let offsetIndex = distance >= 0 ?
            self.index(startIndex, offsetBy: distance, limitedBy: endIndex) :
            self.index(endIndex, offsetBy: distance, limitedBy: startIndex)
        
        guard let index = offsetIndex else { return self }
        return Array(self[index ..< endIndex] + self[startIndex ..< index])
    }
}
