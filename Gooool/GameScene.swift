//
//  GameScene.swift
//  Gooool
//
//  Created by MooMou on 9/27/14.
//  Copyright (c) 2014 MooMou. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  var ball = Ball()

  override func didMoveToView(view: SKView) {
    /* Setup your scene here */
      //ball = Ball()
      ball.sprite.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))

      self.addChild(ball.sprite)
  }
  
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    /* Called when a touch begins */
    
    for touch: AnyObject in touches {
      let location = touch.locationInNode(self)
      
      //let sprite = SKSpriteNode(imageNamed:"Spaceship")
      
      //sprite.xScale = 0.5
      //sprite.yScale = 0.5
      //sprite.position = location
      
      //let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
      
      //sprite.runAction(SKAction.repeatActionForever(action))
      ball.kick(100, target: location)
    }
  }
   
  override func update(currentTime: CFTimeInterval) {
    /* Called before each frame is rendered */
  }
}
