//
//  ItemSelection.swift
//  Skywalker
//
//  Created by Jais Cheema on 30/4/17.
//  Copyright © 2017 Needle Apps. All rights reserved.
//

import Foundation

enum GameSelection: Int {
    case rock = 1
    case paper = 2
    case scissors = 3
    case spock = 4
    case lizard = 5
    
    func compare(against: GameSelection) -> Result {
        guard self != against else { return .tie }
        
        let pairs: [(GameSelection, GameSelection)] = [
            (.paper, .rock),
            (.scissors, .paper),
            (.rock, .scissors),
            (.lizard, .spock),
            (.scissors, .lizard),
            (.rock, .lizard),
            (.spock, .rock),
            (.spock, .scissors),
            (.lizard, .paper),
            (.paper, .spock)
        ]
        
        let winningPair = pairs.first { $0.0 == self && $0.1 == against }
        return winningPair == nil ? .lost : .won
    }
}
