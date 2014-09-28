import SpriteKit
import Darwin

class Ball {

  var sprite:SKShapeNode
  var possessedBy:Int
  var shotBy:Int

  init() {
    let r:CGFloat = 5
    sprite = SKShapeNode(circleOfRadius: r)
    sprite.fillColor = SKColor.blueColor()

    let physicsBody = SKPhysicsBody(circleOfRadius: r)
    physicsBody.mass = 1
    physicsBody.affectedByGravity = false
    physicsBody.linearDamping = 0.5

    sprite.physicsBody = physicsBody

    // TODO this is fake
    possessedBy = 0
    shotBy = 0
  }

  func kick(power:Int, target:CGPoint) {
    var adjustedPower = power * 30
    var direction = CGVector(target.x - sprite.position.x,
                             target.y - sprite.position.y)
    direction = normalize(direction)
    direction.dx = direction.dx * CGFloat(adjustedPower)
    direction.dy = direction.dy * CGFloat(adjustedPower)
    println(direction.dx)
    println(direction.dy)
    //let magnitude = (direction.dx
    sprite.physicsBody?.applyForce(direction)
  }
  
  func reset(startingPlayerIndex: Int) {
    possessedBy = startingPlayerIndex
    // reset the ball state
  }

  func normalize(vector:CGVector) -> CGVector {
    let magnitude = sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
    return CGVector(vector.dx / magnitude, vector.dy / magnitude)
  }
}
