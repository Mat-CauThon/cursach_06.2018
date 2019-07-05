//
//  KineletClass.swift
//  gamesMe
//
//  Created by Roman Mishchenko on 24.05.2018.
//  Copyright © 2018 Roman Mishchenko. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

public class KineletClass : Enemy
{
    var healthBar: SKSpriteNode!
    public var timer: Int = 500
    
    public func spawnKinelet(atPosition: CGPoint, scene: SKScene)
    {
        
        healthBar = SKSpriteNode.init(color: NSColor.red, size: CGSize(width: 80, height: 40))
        healthBar.position.y = 215
        healthBar.position.x = -130
       // healthBar.size.width = 80
       // healthBar.size.height = 40
        healthBar.anchorPoint.x = 0
        healthBar.xScale = 8.0
        scene.camera?.addChild(healthBar)
        
        let texture = SKTexture(imageNamed: "tp18")
        let size = CGSize(width: 120, height: 250)
        let portal = SKSpriteNode.init(texture: texture, size: size)
        portal.position = atPosition
        let animation:SKAction = SKAction(named: "teleport")!
        // let move = SKAction.moveBy(x: 0, y: 500, duration: 0)
        portal.run(animation)
        {
            scene.removeChildren(in: [portal])
            //self.kinelet = KineletClass.init(8.0)
            self.body.size = size
            self.body.physicsBody = SKPhysicsBody(rectangleOf: size)
            self.body.physicsBody?.affectedByGravity = true
            self.body.physicsBody?.allowsRotation = false
            self.body.position = atPosition
            self.body.name = "Kinelet"
            scene.addChild(self.body)
        }
        scene.addChild(portal)
        
    }
    
    
    public func kick(thePlayer: PlayerClass!, scene: SKScene!)
    {
        let distance = thePlayer.lowerTorso.position.x - body.position.x
        var whereMove:CGFloat = -400
        if(distance < 0)
        {
            body.xScale = abs(body.xScale)
            whereMove = 400
        }
        else
        {
            body.xScale = -abs(body.xScale)
        }
        if(abs(distance) >= range)
        {
            let animation: SKAction = SKAction(named: "kineletCast")!
            let moveShot = SKAction.moveBy(x: 0, y: 0, duration: 1)
            body.run(SKAction.group([animation, moveShot]))
        }
        else if(abs(distance) <= range && self.body.position.x >= 6000)
        {
            let texture = SKTexture(imageNamed: "tp18")
            let size = CGSize(width: 120, height: 250)
            let portal = SKSpriteNode.init(texture: texture, size: size)
            let portal2 = SKSpriteNode.init(texture: texture, size: size)
            portal.position = body.position
            let animation:SKAction = SKAction(named: "teleport")!
            
            portal.run(animation)
            {

                self.body.position.x = thePlayer.lowerTorso.position.x - 650
                scene?.removeChildren(in: [portal])
                
                portal2.position = self.body.position
                portal2.run(animation)
                {
                    self.body.position.x = thePlayer.lowerTorso.position.x - 650
                    scene?.removeChildren(in: [portal2])
                }
            }
            //portal.position.x -= 650
            
          
            scene.addChild(portal)
              scene.addChild(portal2)
        }
        else if(abs(distance) <= range && self.body.position.x <= 3000)
        {
            let texture = SKTexture(imageNamed: "tp18")
            let size = CGSize(width: 120, height: 250)
            let portal = SKSpriteNode.init(texture: texture, size: size)
            let portal2 = SKSpriteNode.init(texture: texture, size: size)
            portal.position = body.position
            let animation:SKAction = SKAction(named: "teleport")!
            
            portal.run(animation)
            {
                
                self.body.position.x = thePlayer.lowerTorso.position.x + 650
                scene?.removeChildren(in: [portal])
                
                portal2.position = self.body.position
                portal2.run(animation)
                {
                    self.body.position.x = thePlayer.lowerTorso.position.x + 650
                    scene?.removeChildren(in: [portal2])
                }
            }
            scene.addChild(portal)
            scene.addChild(portal2)
        }
        else if(abs(distance) <= range)
        {
            let animation: SKAction = SKAction(named: "kineletWalk")!
            let moveShot = SKAction.moveTo(x: thePlayer.lowerTorso.position.x + whereMove, duration: 1)
            body.run(SKAction.group([animation, moveShot]))
        }
        
    }
    init(_ currentHP : CGFloat, thePlayer: PlayerClass, scene: SKScene, position: CGPoint   )
    {
        super.init(currentHP, 600, SKSpriteNode(imageNamed: "Kinelet"))
        body.physicsBody?.categoryBitMask = physicsCategory.Enemy
     //   body.physicsBody?.contactTestBitMask = physicsCategory.Sword
       // body.zPosition = 1
      //  body.physicsBody?.collisionBitMask = physicsCategory.Kinelet
        spawnKinelet(atPosition: position, scene: scene)
    }
}
