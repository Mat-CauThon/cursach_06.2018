//
//  DialogClass.swift
//  gamesMe
//
//  Created by Roman Mishchenko on 20.05.2018.
//  Copyright © 2018 Roman Mishchenko. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

class DialogClass
{
    //Печать текста (Диалоги)
  //  private var helloWorld: String//["W","h","e","r","e"," ","a","m"," ","I","?",".",".",".",".",".","W","h","o"," ","a","m"," ","I","?"]""
    public var text: [String] = []

    private var labelText = ""

    public let labelNode = SKLabelNode()

    private var calls : Int = 0

    private var timer : Timer!



     @objc func updateLabelText()
    {
        
        labelText += text[calls]
        labelNode.text = labelText
        calls += 1
        
        if calls == text.count
        {
            timer.invalidate()
        }
    }

    public func writeText(textToPrint: String)
    {
        for char in textToPrint.characters
        {
            text.append(String(char))
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.updateLabelText), userInfo: nil, repeats: true)
        labelNode.text = labelText
        labelNode.fontSize = 36
        labelNode.fontColor = NSColor.green
        labelNode.fontName = "Helvetica"
    }
    init(_ textToPrint: String = Dialog[dialogPointer])
    {
        dialogPointer += 1
        writeText(textToPrint: textToPrint)
    }
    deinit
    {
        // проведение деинициализации
    }
}
