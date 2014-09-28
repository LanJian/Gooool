//
//  GameSystem.swift
//  Gooool
//
//  Created by MooMou on 9/27/14.
//  Copyright (c) 2014 MooMou. All rights reserved.
//

import Foundation
import SpriteKit

// The arbitrator of the game. Decides who has possession of the ball, etc.
class GameSystem {
  // Constantts
  let START_OFFSET_X: CGFloat = 0.25
  let START_OFFSET_Y: CGFloat = 0.20
  
  let players: Array<Player>
  let ball: Ball
  
  var team1Score = 0, team2Score = 0
  var mPreviousTime: CFTimeInterval? = nil

  init(teamSize: Int) {
    players = []
    ball = Ball()
    
    for i in 1...teamSize * 2 {
      players.append(Player(id:i))
    }
    
    println("Player init: %s", players.count)
  }
  
  private func determineBallPossession() {
    
  }
  
  private func determineBallScore() -> Int? {
    return nil
  }
  
  // after the game resets, need to explicitly call this function to start again
  func start(scene: SKScene) {
    let sceneHeight = scene.frame.height, sceneWidth = scene.frame.width
    let midX = CGRectGetMidX(scene.frame), midY = CGRectGetMidY(scene.frame)
    
    ball.sprite.position = CGPoint(x:midX, y:midY)
    scene.addChild(ball.sprite)
    
    for (index, player) in enumerate(players) {
      
      if index % 2 == 0 {
        let cgIndex: CGFloat = index == 0 ? 0 : CGFloat(index) / 2.0
        
        player.sprite.position = CGPoint(x: midX - START_OFFSET_X * sceneWidth,
          y: sceneHeight * START_OFFSET_Y * cgIndex + sceneHeight * 0.30)
      } else {
        let cgIndex: CGFloat = index == 1 ? 0.0 : CGFloat(index - 1.0) / 2.0
        
        player.sprite.position = CGPoint(x: midX + START_OFFSET_X * sceneWidth,
          y: sceneHeight * START_OFFSET_Y * cgIndex + sceneHeight * 0.30)
      }
      scene.addChild(player.sprite)
    }
    
    // Let the even side have the ball.
    ball.possessedBy = 0;
  }
  
  func update(currentTime: CFTimeInterval) {
    if let previousTime = mPreviousTime {
      
      let timeDelta = currentTime - previousTime
      if let startSide = determineBallScore() {
        // reset the game state here
        for player in players {
          player.reset()
        }
        ball.reset(startSide)
      } else {
        // Players interact with the ball so specific ball update call.
        for player in players {
          player.update(timeDelta, ball: ball, players: players)
        }
      }
      
    }
    mPreviousTime = currentTime
  }
}