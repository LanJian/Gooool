import SpriteKit
import Darwin

class Ball {

  var sprite:SKShapeNode

  init() {
    let foo:CGFloat = 5
    sprite = SKShapeNode(circleOfRadius: foo)
    sprite.fillColor = SKColor.blueColor()

    let physicsBody = SKPhysicsBody(circleOfRadius: foo)
    physicsBody.mass = 1
    physicsBody.affectedByGravity = false
    physicsBody.linearDamping = 0.5

    sprite.physicsBody = physicsBody
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

  func normalize(vector:CGVector) -> CGVector {
    let magnitude = sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
    return CGVector(vector.dx / magnitude, vector.dy / magnitude)
  }
}
