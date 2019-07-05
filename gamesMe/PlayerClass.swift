//
//  PlayerClass.swift
//  Kursach
//
//  Created by Roman Mishchenko on 20.05.2018.
//  Copyright © 2018 Roman Mishchenko. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit

public class PlayerClass
{
    public var health: CGFloat = 1.0
    public var water: CGFloat = 0.4
    public var regenereteNumber: CGFloat = 0.0001
    public var leftWall: CGFloat = -430
    public var rightWall: CGFloat = 100000
    public var howMushWaterINeew:CGFloat = 0.0002
    public var canDo = false
    public var canJump = true
    private var canKick = true
    private let upperArmAngleDeg: CGFloat = 105
    private let lowerArmAngleDeg: CGFloat = -10
    private let swordAngleDeg: CGFloat = 140
    private let upperLegFrontAngleDeg: CGFloat = 0
    private let upperLegBackAngleDeg: CGFloat = 0
    private let lowerLegFrontAngleDeg: CGFloat = 0
    private let lowerLegBackAngleDeg: CGFloat = 0
    private var animationWalk: Bool = true
    public var rotate: Character! = "l"
    
    
    public var lowerTorso: SKNode!
    public var upperTorso: SKNode!
    public var upperArmFront: SKNode!
    public var lowerArmFront: SKNode!
    public var upperArmBack: SKNode!
    public var lowerArmBack: SKNode!
    public var head: SKNode!
    public var upperLegFront: SKNode!
    public var lowerLegFront: SKNode!
    public var upperLegBack: SKNode!
    public var lowerLegBack: SKNode!
    public var fistFront: SKNode!
    public var fistBack: SKNode!
    public var fistLegFront: SKNode!
    public var fistLegBack: SKNode!
    public var goNAX: SKNode!
    public var sword: SKNode!
    
    public func plJump()
    {
        if(self.canJump)
        {
            self.canJump = false
            jump()
        }
    }
    
    private func jump()
    {
        let loc: CGPoint = goNAX.position
        
        var plusX = loc.x/5
        if(rotate == "r")
        {
            plusX = -plusX
            if(self.lowerTorso.xScale > 0)
            {
                self.lowerTorso.xScale = -self.lowerTorso.xScale
            }
        }
        else
        {
            if(self.lowerTorso.xScale < 0)
            {
                self.lowerTorso.xScale = -self.lowerTorso.xScale
            }
        }
        
        
        
        var location: CGPoint! = loc
        location.x = 100000 * plusX
        location.y = 100000
        
        let moveLegFrontTo = SKAction.reach(to: location, rootNode: upperLegFront, duration: 0.1)
        let restoreFrontLeg = SKAction.run
        {
            self.upperLegFront.run(SKAction.rotate(toAngle: self.upperLegFrontAngleDeg * 3.14 / 180, duration: 0.1))
            self.lowerLegFront.run(SKAction.rotate(toAngle: self.lowerLegFrontAngleDeg * 3.14 / 180, duration: 0.1))
        }
        
        location.x = 100000 * plusX
        location.y = 100000
        
        let moveLegBackTo = SKAction.reach(to: location, rootNode: upperLegBack, duration: 0.1)
        let restoreBackLeg = SKAction.run
        {
            
            self.upperLegBack.run(SKAction.rotate(toAngle: self.upperLegBackAngleDeg * 3.14 / 180, duration: 0.1))
            
            self.lowerLegBack.run(SKAction.rotate(toAngle: self.lowerLegBackAngleDeg * 3.14 / 180, duration: 0.1))
        }
        
        var moveAction = SKAction.moveBy(x: 0, y: 10*abs(plusX), duration: 0.2)
        
        lowerTorso.run(moveAction)
        
        fistLegFront.run(SKAction.sequence([moveLegFrontTo,restoreFrontLeg]))
        fistLegBack.run(SKAction.sequence([moveLegBackTo,restoreBackLeg]))
        moveAction = SKAction.moveBy(x: 0, y: -10*abs(plusX), duration: 0.3)
        lowerTorso.run(moveAction)
        
       // self.canJump = true
        
    }
    
    public func leftMove()
    {
        self.canKick = false
        self.rotate = "r"
        move()
        self.canKick = true
    }
    public func rightMove()
    {
        self.canKick = false
        self.rotate = "l"
        move()
        self.canKick = true
    }
    private func move()
    {
        let loc: CGPoint = goNAX.position
        
        var plusX = loc.x/5
        if(rotate == "r")
        {
            plusX = -plusX
            if(self.lowerTorso.xScale > 0)
            {
                self.lowerTorso.xScale = -self.lowerTorso.xScale
            }
        }
        else
        {
            if(self.lowerTorso.xScale < 0)
            {
                self.lowerTorso.xScale = -self.lowerTorso.xScale
            }
        }
        
        
        var location: CGPoint! = loc
        location.x = 100000 * plusX
        location.y = 100000
        
        let moveLegFrontTo = SKAction.reach(to: location, rootNode: upperLegFront, duration: 0.4)
        let restoreFrontLeg = SKAction.run
        {
            self.upperLegFront.run(SKAction.rotate(toAngle: self.upperLegFrontAngleDeg * 3.14 / 180, duration: 0.6))
            self.lowerLegFront.run(SKAction.rotate(toAngle: self.lowerLegFrontAngleDeg * 3.14 / 180, duration: 0.6))
        }
        
        let moveLegBackTo = SKAction.reach(to: location, rootNode: upperLegBack, duration: 0.4)
        let restoreBackLeg = SKAction.run
        {
            
            self.upperLegBack.run(SKAction.rotate(toAngle: self.upperLegBackAngleDeg * 3.14 / 180, duration: 0.5))
            
            self.lowerLegBack.run(SKAction.rotate(toAngle: self.lowerLegBackAngleDeg * 3.14 / 180, duration: 0.5))
        }
        
        let moveAction = SKAction.moveBy(x: plusX, y: 0, duration: 0.2)
        lowerTorso.run(moveAction)
        
        if(animationWalk)
        {
            fistLegFront.run(SKAction.sequence([moveLegFrontTo,restoreFrontLeg]))
            
            fistLegBack.run(SKAction.sequence([moveLegBackTo,restoreBackLeg]))
            {
                self.animationWalk = true
            }
        }
        animationWalk = false
        
    }
    public func punch()
    {
        if(canKick)
        {
            canKick = false
            punchAt()
            canKick = true
        }
    }
    private func punchAt()
    {
        // 1
        var location: CGPoint = upperTorso.position
        if(rotate == "l")
        {
            location.x = 100000
            location.y = 100000
        }
        else
        {
            location.x = -100000
            location.y = 100000
        }
        
        
        let punch = SKAction.reach(to: location, rootNode: upperArmFront, duration: 0.1)
        // 2
        let restore = SKAction.run
        {
            self.upperArmFront.run(SKAction.rotate(toAngle: self.upperArmAngleDeg * 3.14 / 180, duration: 0.1))
            self.lowerArmFront.run(SKAction.rotate(toAngle: self.lowerArmAngleDeg * 3.14 / 180, duration: 0.1))
            //  self.sword.run(SKAction.rotate(toAngle: self.swordAngleDeg * 3.14 / 180, duration: 0.1))
        }
        
        // 3
        fistFront.run(SKAction.sequence([punch, restore]))
    }
    init()
    {
        
    }
    
}
