//
//  Enemy.swift
//  Kursach
//
//  Created by Roman Mishchenko on 20.05.2018.
//  Copyright © 2018 Roman Mishchenko. All rights reserved.
//


import Foundation
import SpriteKit
import GameplayKit

public class Enemy
{
    
    public var hp: CGFloat
  //  public var cost: Int
    public var isAlive: Bool
    public var body: SKSpriteNode!
    public var range: CGFloat
    public var rotate: CGFloat!
   // private var move: Bool
    
    
    
    public func kick(thePlayer: PlayerClass!)
    {
        
        let distance = thePlayer.lowerTorso.position.x - body.position.x
        var xPlus:CGFloat = 3
        if(distance < 0)
        {
            body.xScale = abs(body.xScale)
            xPlus = -3
        }
        else
        {
            body.xScale = -abs(body.xScale)
            // move = true
        }
        if(abs(distance) >= range)
        {
            let moveAction = SKAction.moveBy(x: xPlus, y: 0, duration: 1)
            body.run(moveAction)
            // distance = thePlayer.lowerTorso.position.x - body.position.x
        }
        else
        {
            let moveKick = SKAction.moveBy(x: xPlus, y: 5, duration: 0.1)
            body.run(moveKick)
        }
        
       
    }
    
    init(_ currentHP : CGFloat = 350, _ currentRange: CGFloat = 200, _ currentNode: SKSpriteNode = SKSpriteNode(imageNamed: "testEnemy")/*, _ currentCost: Int = 3*/)
    {
        hp = currentHP
        range = currentRange
        body = currentNode
        isAlive = true
        body.size.width = 150
        body.size.height = 150
      //  cost = currentCost
       // body.position.x = 600
       // move = false
    }
}
