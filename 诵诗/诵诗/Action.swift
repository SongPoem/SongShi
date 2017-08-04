//
//  Action.swift
//  Skywalker
//
//  Created by Jais Cheema on 23/4/17.
//  Copyright © 2017 Needle Apps. All rights reserved.
//

import Foundation

let TimeIntervalkey = "t"
let PlayerIndexKey  = "p"
let ResultsKey      = "r"
let ValueKey        = "v"

class Action: NSObject, NSCoding {
    let timeInterval: TimeInterval
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        let timeInterval = aDecoder.decodeDouble(forKey: TimeIntervalkey)
        self.timeInterval = timeInterval
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.timeInterval, forKey: TimeIntervalkey)
    }
    
    func applyTo(gameState: GameState) -> GameState {
        return gameState
    }
    
    public static func ==(lhs: Action, rhs: Action) -> Bool {
        return lhs.timeInterval == rhs.timeInterval
    }
}

class StartGame: Action {
    override func applyTo(gameState: GameState) -> GameState {
        var newGameState = gameState
        newGameState.status = .awaitingStartingPlayer
        return newGameState
    }
    
    override var description: String {
        return "StartGame"
    }
}

class PlayerIndexAction: Action {
    let playerIndex: Int
    
    init(timeInterval: TimeInterval, playerIndex: Int) {
        self.playerIndex = playerIndex
        super.init(timeInterval: timeInterval)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.playerIndex = aDecoder.decodeInteger(forKey: PlayerIndexKey)
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(playerIndex, forKey: PlayerIndexKey)
    }
}

class SetCurrentPlayer: PlayerIndexAction {
    override var description: String {
        return "SetCurrentPlayer: \(playerIndex)"
    }
    
    override func applyTo(gameState: GameState) -> GameState {
        var newGameState = gameState
        newGameState.currentPlayerIndex = playerIndex
        newGameState.status = .awaitingPlay
        return newGameState
    }
}

class ChoiceAction: Action {
//    let value: GameSelection
    
    override init(timeInterval: TimeInterval) {
//        self.value = value
        super.init(timeInterval: timeInterval)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let intValue = aDecoder.decodeInteger(forKey: ValueKey)
        guard let selection = GameSelection(rawValue: intValue) else { return nil }
//        self.value = selection
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
//        aCoder.encode(value.rawValue, forKey: ValueKey)//不知道这句话有什么用！！！！！
    }
    
    override var description: String {
//        return "MakeSelection: \(value.rawValue)"
        return "MakeSelection:"
    }
    
    override func applyTo(gameState: GameState) -> GameState {
        guard let index = gameState.currentPlayerIndex else { return gameState }
        var newGameState = gameState
//        newGameState.playerChoices[index] = value
        newGameState.status = .turnComplete
        return newGameState
    }
}

class SetResults: Action {
    let results: [Int: Result]
    
    init(timeInterval: TimeInterval, results: [Int: Result]) {
        self.results = results
        super.init(timeInterval: timeInterval)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let rawValues = aDecoder.decodeObject(forKey: ResultsKey) as? [[Int]] else { return nil }
        var tempResults: [Int: Result] = [:]
        for rawValue in rawValues {
            guard let key = rawValue.first, let value = rawValue.last else { continue }
            guard let resultValue = Result(rawValue: value) else { continue }
            tempResults[key] = resultValue
        }
        self.results = tempResults
        super.init(coder: aDecoder)
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        let rawValue = self.results.map { [$0.key, $0.value.rawValue] }
        aCoder.encode(rawValue, forKey: ResultsKey)
    }
    
    override func applyTo(gameState: GameState) -> GameState {
        var newGameState = gameState
        newGameState.currentPlayerIndex = nil
        newGameState.status = .finished(results: results)
        return newGameState
    }
}
