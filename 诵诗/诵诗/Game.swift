//
//  Game.swift
//  Skywalker
//
//  Created by Jais Cheema on 25/4/17.
//  Copyright © 2017 Needle Apps. All rights reserved.
//

import Foundation
import QuartzCore

enum GameStatus {
    case notStarted
    case awaitingStartingPlayer
    case awaitingPlay
    case turnComplete
    case finished(results: [Int: Result])
}

struct GameState {
    var currentPlayerIndex: Int?
    var status: GameStatus
    var playerChoices: [Int: GameSelection]
    var playerScore: [Int]
    
    init() {
        self.currentPlayerIndex = nil
        self.status = .notStarted
        self.playerChoices = [:]
        self.playerScore = [0,0]
    }
}

let GameNotificationName = Notification.Name(rawValue: "GameNotification")

class Game {
    let match: Match
    var state: GameState
    
    var actions: [Action] = []
    var hasUnprocessedAction: Bool { return self.actions.count > 0 }
    
    // Methods delegated to Match
    var players: [Player] { return match.players }
    var localPlayerIdentifier: String { return match.localPlayerIdentifier }
    var isServer: Bool { return match.isServer }
    
    init(match: Match) {
        self.match = match
        self.state = GameState()
        match.actions.sorted { $0.0.timeInterval < $0.1.timeInterval }.forEach { self.add(action: $0) }
    }
    
    func start() {
        let updater = CADisplayLink(target: self, selector: #selector(self.process))
        if #available(iOS 10.0, *) {
            updater.preferredFramesPerSecond = 60
        }
        updater.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
    }
    
    @objc func process() {
        if hasUnprocessedAction {
            let action = actions.removeFirst()
            self.state = action.applyTo(gameState: state)
            NotificationCenter.default.post(name: GameNotificationName, object: action)
        }
        
//        guard !hasUnprocessedAction && isServer else { return }

        let currentTime = Date().timeIntervalSince1970
        switch self.state.status {
        case .notStarted:
            self.add(action: StartGame(timeInterval: currentTime))
        case .awaitingStartingPlayer:
            self.add(action: SetCurrentPlayer(timeInterval: currentTime, playerIndex: 0))
        case .turnComplete:
            guard let nextPlayerIndex = self.nextPlayer() else { return }
//            if self.state.playerChoices.count == self.players.count {//两人都选中了
//                guard let firstPlayerSelection = self.state.playerChoices[0],
//                    let secondPlayerSelection = self.state.playerChoices[1] else { return }
//                let result = firstPlayerSelection.compare(against: secondPlayerSelection)
//                let results = [ 0: result, 1: result.opposite ]
            if state.playerScore[0] == 10 || state.playerScore[1]==10 {//本局完成
                var result = Result.lost
                if state.playerScore[0] == 10 && state.playerScore[1] == 10{
                    result = Result.tie
                }
                else if state.playerScore[0] == 10{
                    result = Result.won
                }
                let results = [ 0: result, 1: result.opposite ]
                self.add(action: SetResults(timeInterval: currentTime, results: results))
            } else {
                    self.add(action: SetCurrentPlayer(timeInterval: currentTime, playerIndex: nextPlayerIndex))
            }
        default: break
        }
    }
    
    func add(action: Action) {
        self.actions.append(action)
    }
    
    func add(actions: [Action]) {
        self.actions.append(contentsOf: actions)
    }
    
    func nextPlayer() -> Int? {
        guard let currentIndex = state.currentPlayerIndex else { return nil }
        let playerIndexes: [Int] = Array<Int>(0..<players.count)
        return playerIndexes.shift(withDistance: currentIndex + 1).first
    }
}
