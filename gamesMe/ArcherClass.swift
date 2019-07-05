//
//  ArcherClass.swift
//  gamesMe
//
//  Created by Roman Mishchenko on 20.05.2018.
//  Copyright © 2018 Roman Mishchenko. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

public class ArcherClass: Enemy
{
    public var timer = 200
    public func refreshTimer()
    {
        timer = 200
    }
    override public func kick(thePlayer: PlayerClass!)
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
            let animation: SKAction = SKAction(named: "archerShot")!
            let moveShot = SKAction.moveBy(x: xPlus, y: 0, duration: 1)
            body.run(SKAction.group([animation, moveShot]))
            // distance = thePlayer.lowerTorso.position.x - body.position.x
        }
        else if(abs(distance) <= 200)
        {
            let animation: SKAction = SKAction(named: "archerShot")!
            let moveShot = SKAction.moveBy(x: -xPlus, y: 0, duration: 6)
            body.run(SKAction.group([animation, moveShot]))
        }
        else
        {
            let animation: SKAction = SKAction(named: "archerShot")!
            
            body.run(SKAction.group([animation]))
        }
    }
    
    
    init() {
        super.init(250, 500, SKSpriteNode(imageNamed: "archer")
        )
    }
}
