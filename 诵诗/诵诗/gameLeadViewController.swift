//
//  gameLeadViewController.swift
//  诵诗
//
//  Created by yuannnn on 2017/7/30.
//  Copyright © 2017年 mac. All rights reserved.
//

import UIKit
import GameKit

class gameLeadViewController: UIViewController {
    @IBOutlet weak var twoPlayerButton: UIButton!
    
    @IBOutlet weak var feihua: UIButton!
    var match: Match?
    
    var isLoggedIn: Bool = false {
        didSet {
            self.twoPlayerButton.isEnabled = isLoggedIn
        }
    }
    
    @IBAction func twoPlayerGame() {
        createMatch(players: 2)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        match?.endMatch(withResults: [0:Result.lost,1:Result.lost])
    }
    
    //以上新家
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.register(self as GKLocalPlayerListener)
        localPlayer.authenticateHandler = { (gameLeadViewController, error) in
            guard let vc = gameLeadViewController else {
                self.isLoggedIn = localPlayer.isAuthenticated
                return
            }
            self.present(vc, animated: true, completion: nil)
        }
        //登录一次以后就自动登录了
        self.isLoggedIn = localPlayer.isAuthenticated
        
        
    }
    
    @IBAction func localGame() {
        let players = [
            Player(identifier: "local", displayName: "You"),
            AIPlayer(identifier: "ai1", displayName: "Some Dude"),
            ]
        self.match = LocalMatch(identifier: "test",
                                players: players,
                                localPlayerIdentifier: "local",
                                matchData: nil)
        self.performSegue(withIdentifier: "StartGame", sender: self)
    }
    
    func createMatch(players: Int) {
        guard isLoggedIn else { return }
        
        let matchRequest = GKMatchRequest()
        matchRequest.defaultNumberOfPlayers = players
        matchRequest.maxPlayers = players
        matchRequest.minPlayers = players
        let controller = GKTurnBasedMatchmakerViewController(matchRequest: matchRequest)
        controller.showExistingMatches = false
        controller.turnBasedMatchmakerDelegate = self as GKTurnBasedMatchmakerViewControllerDelegate
        self.present(controller, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartGame", let viewController = segue.destination as? gamemViewController, match != nil  {
            viewController.game = match!.game
        }
    }

    
    
}

extension gameLeadViewController: GKTurnBasedMatchmakerViewControllerDelegate {
    func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
//        self.dismiss(animated: true, completion: nil)
    }
    
    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
        print(error.localizedDescription)
//        self.dismiss(animated: true, completion: nil)
    }
}

extension gameLeadViewController: GKLocalPlayerListener {
    func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
//        guard let currentMatch = self.match else {
            let currentMatch = self.match
            self.dismiss(animated: true) {
                self.match = GameCenterMatch(turnBasedMatch: match)
                self.performSegue(withIdentifier: "StartGame", sender: self)
            }
//            return
//        }
        if let gameCenterMatch = self.match as? GameCenterMatch, match.matchID == currentMatch?.identifier {
            gameCenterMatch.update(turnBasedMatch: match)
        }
        // How to handle if the match we recevied updates is not the active one
    }
    
    func player(_ player: GKPlayer, didRequestMatchWithOtherPlayers playersToInvite: [GKPlayer]) {
        print("Did Request match with other players")
    }
    
    func player(_ player: GKPlayer, matchEnded match: GKTurnBasedMatch) {
        print("Match ended")
    }
    
    
    
}
