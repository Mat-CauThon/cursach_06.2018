//
//  InterectivableLabelNode.swift
//  gamesMe
//
//  Created by Roman Mishchenko on 20.05.2018.
//  Copyright © 2018 Roman Mishchenko. All rights reserved.
//

import SpriteKit

class InteractiveLabelNode: SKNode
{
    
    var text = ""
    {
        didSet
        {
            updateLabelsArray()
            assignActions()
        }
    }
    
    var delayToShow: CGFloat = 0.3
    var lifeSpan: CGFloat = 1.0
    
    private var labels = [SKLabelNode]()
    
    init(with newText: String)
    {
        text = newText
        super.init()
        
        updateLabelsArray()
        assignActions()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    func updateLabelsArray()
    {
        if (labels.count > 0)
        {
            for label in labels
            {
                label.removeFromParent()
            }
            labels.removeAll()
        }
        
        if (text.characters.count > 0)
        {
            var newX: CGFloat = 0.0
            
            for char in text.characters
            {
                let charAsString = String(char)
                if charAsString != " "
                {
                    let newCharNode = SKLabelNode(text: charAsString)
                    newCharNode.horizontalAlignmentMode = .left
                    
                    newCharNode.color = NSColor.red
                    newCharNode.position.x = newX
                    newCharNode.alpha = 0
                    
                    self.addChild(newCharNode)
                    labels.append(newCharNode)
                    
                    newX += newCharNode.frame.width
                }
                else
                {
                    newX += 10
                }
            }
        }
    }
    
    func assignActions()
    {
        var newDelay: CGFloat = 0
        for label in labels
        {
            var newActions = [SKAction]()
            if newDelay > 0
            {
                let delayAction = SKAction.wait(forDuration: TimeInterval(newDelay))
                newActions.append(delayAction)
            }
            let fadeInAction = SKAction.fadeIn(withDuration: 0.2)
            newActions.append(fadeInAction)
            let lifespanAction = SKAction.wait(forDuration: TimeInterval(lifeSpan))
            newActions.append(lifespanAction)
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.2)
            newActions.append(fadeOutAction)
            let actionSequence = SKAction.sequence(newActions)
            
            label.run(actionSequence)
            newDelay += delayToShow
            
        }
    }
    
}
