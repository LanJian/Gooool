//
//  Player.swift
//  Gooool
//
//  Created by MooMou on 9/27/14.
//  Copyright (c) 2014 MooMou. All rights reserved.
//
import Foundation
import SpriteKit

let THRESHOLD: CGFloat = 10.0
let BLOCK_THRESHOLD = 15.0
let MODIFIER = 0.5
let GOAL_POSITION = CGPoint(x: -1.0, y: -1.0)

class Action {
  enum ACTION {
    case Path
    case Pass
    case Shoot
  }
  
  let actionType: ACTION
  let startPosition: CGPoint
  let endPositiion: CGPoint
  
  init(actionType: ACTION, startPosition: CGPoint, endPosition: CGPoint) {
    self.actionType = actionType
    self.startPosition = startPosition
    self.endPositiion = endPosition
  }
}

class Player {
  let sprite: SKShapeNode
  let id: Int
  
  // Only 3 basic variables to determine player action
  var speed: CGFloat = 10, power = 10, skill = 10
  
  var velocity: CGVector = CGVector(-1.0, -1.0)
  
  var mCurrentAction: Action?
  
  // Player instruction
  private var actionQueue: Array<Action> = []
  
  init(id: Int) {
    self.sprite = SKShapeNode()
    self.id = id
  }
  
  func distanceBetween(to: CGPoint, from: CGPoint) -> CGFloat {
    return sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
  }
  
  func addActionToQueue(action: Action) {
    actionQueue.append(action)
  }
  
  func clearActionQueue() {
    actionQueue.removeAll(keepCapacity: true)
  }
  
  func getPosition() -> CGPoint {
    return self.sprite.position
  }
  
  func respond(currentTime: CFTimeInterval, ball: Ball, players: Array<Player>) {
    // If I have the ball - do the attacking action
    if (ball.possessedBy == self.id) {
      ball.kick(self.power, currentAction.endPosition)
    } else if (ball.shotBy % 2 != self.id % 2) {
      // modifyt the direction vector to run toward the ball
      if (distanceToBall < BLOCK_THRESHOLD) {
        velocity.x += (ball.position.x - sprite.position.x) * speed
        velocity.y += (ball.position.y - sprite.position.y) * speed
      }
    } else if (ball.possessedBy % 2 == self.id % 2) {
      // our team has the ball - run toward the goal?
    } else {
      // other team  has the ball and is NOT shot - run to the person I should be marking
      let opponentId = self.id % 2 == 0 ? self.id - 1 : self.id + 1
      let opponentPosition = players[opponentId].getPosition()
      
      velocity.dx += (opponentPosition.x - sprite.position.x) * speed
      velocity.dy += (opponentPosition.y - sprite.position.Y) * speed
    }
  }
  
  // Global run method to do the simulation of the player
  func update(currentTime: CFTimeInterval, ball: Ball, players: Array<Player>) {
    let distanceToBall = distanceBetween(ball.position, from: sprite.position)
    
    // If previous action is not done yet
    if let currentAction = mCurrentAction {
      let distanceToAction = distanceBetween(currentAction.endPositiion, from: sprite.position)
      
      switch currentAction.actionType {
      case .Pass:
        ball.kick(self.power, currentAction.endPositiion)
        mCurrentAction = nil
      case .Shoot:
        ball.kick(self.power, currentAction.endPositiion)
        mCurrentAction = nil
      case .Path:
        if (distanceToAction < THRESHOLD) {
          mCurrentAction = nil
        } else { // Move toward the ball
          velocity.dx += (currentAction.endPositiion.x - sprite.position.x) * speed
          velocity.dy += (currentAction.endPositiion.y - sprite.position.y) * speed
        }
      }
    } else if (actionQueue.count != 0) {
      mCurrentAction = actionQueue.first
    } else {
      self.respond(currentTime, ball, players)
    }
    
    sprite.position.x += velocity.dx
    sprite.position.y += velocity.dy
  }
}

class GoalKeeper: Player {
  override func respond(currentTime: CFTimeInterval, ball: Ball, players: Array<Player>) {
  }
}
