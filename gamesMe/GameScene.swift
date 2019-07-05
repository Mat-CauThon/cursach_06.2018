//
//  GameScene.swift
//  gamesMe
//
//  Created by Roman Mishchenko on 20.05.2018.
//  Copyright © 2018 Roman Mishchenko. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate
{
   // private var spinnyNode : SKShapeNode?
    var songLocationName: [String] = ["main"]
    var healthBar: SKSpriteNode!
    var waterBar: SKSpriteNode!
    var waterBarBG: SKSpriteNode!
    var thePlayer: PlayerClass! = PlayerClass.init()
    var dialogScene: SKNode!
    var enemies: [Enemy] = []
    var archers: [ArcherClass] = []
    var audio: SKAudioNode!
    var audioPlayer: AVAudioPlayer!
    var typeWriterLabel: SKLabelNode!
    var floor: SKNode!
    var letter: DialogClass = DialogClass.init()
    var coins: [SKSpriteNode] = []
    var missile: [SKSpriteNode] = []
    var objects: [SKSpriteNode] = []
    var questLabel: SKLabelNode!
    var kinelet: KineletClass!
    var kineletBar: SKSpriteNode!
  
    //Одиночные звуки
    func playSound(resourse: String) {
        
        let audioFilePath = Bundle.main.path(forResource: resourse, ofType: "wav")
        if audioFilePath != nil
        {
            
            let audioFileUrl = NSURL.fileURL(withPath: audioFilePath!)
            
            do
            {
                try audioPlayer = AVAudioPlayer(contentsOf: audioFileUrl)
            }
            catch{}
            audioPlayer.play()
            
        } else {
            print("audio file is not found")
        }
    }

  
//water spawn
    func spawnWater(atPosition: CGPoint)// -> [SKSpriteNode]
    {
        print("COINS")
        let texture: SKTexture = SKTexture(imageNamed: "WaterCoin")
        let size: CGSize = CGSize.init(width: 30, height: 30)
        //avar coins: [SKSpriteNode] = []
       
            let coin = SKSpriteNode(texture: texture, size: size)
            coin.physicsBody = SKPhysicsBody(circleOfRadius: 15)
            coin.physicsBody?.allowsRotation = false
            coin.physicsBody?.affectedByGravity = false
            coin.zPosition = 99
            coin.physicsBody?.categoryBitMask = physicsCategory.Coins
            coin.physicsBody?.contactTestBitMask = physicsCategory.WaterBar
            coin.physicsBody?.collisionBitMask = physicsCategory.WaterBar
            coin.name = "Coin \(self.coins.count)"
            //print(self.coins.count - 1)
            coin.position = atPosition
            self.coins.append(coin)
            self.addChild(coin)
        
         print("COINS")
        //return coins
    }
//objects spawn
    func spawObjects(position: CGPoint)
    {
        let texture = SKTexture(imageNamed: "object")
        let size = CGSize(width: 60, height: 60)
        let object = SKSpriteNode.init(texture: texture, size: size)
        object.physicsBody = SKPhysicsBody(rectangleOf: size)
        object.physicsBody?.affectedByGravity = true
        object.physicsBody?.allowsRotation = false
        object.physicsBody?.categoryBitMask = physicsCategory.Object
        object.physicsBody?.contactTestBitMask = physicsCategory.Player | physicsCategory.Sword
        object.physicsBody?.collisionBitMask =  physicsCategory.Player | physicsCategory.Sword
        object.zPosition = -1
        object.position = position
        object.name = "Object \(objects.count)"
        self.objects.append(object)
        self.scene?.addChild(object)
    }
//Kinelet
    
    func bolt(thePlayer: PlayerClass, kinelet: KineletClass)
    {
        let animationBody: SKAction = SKAction(named: "kineletCast")!
        self.kinelet.body.run(animationBody)
        let texture: SKTexture = SKTexture(imageNamed: "bolt1")
        let size: CGSize = CGSize.init(width: 60 , height: 60)
        let bolt: SKSpriteNode = SKSpriteNode.init(texture: texture, size: size)
        bolt.zRotation = 0
        bolt.physicsBody = SKPhysicsBody(rectangleOf: size)
        bolt.physicsBody?.allowsRotation = false
        bolt.physicsBody?.affectedByGravity = true
        bolt.physicsBody?.categoryBitMask = physicsCategory.Sword
        bolt.physicsBody?.contactTestBitMask = physicsCategory.Sword | physicsCategory.Player
        bolt.physicsBody?.collisionBitMask = physicsCategory.Sword | physicsCategory.Player
        bolt.name = "Missile \(self.missile.count) Arrow"
        bolt.position = kinelet.body.position
        bolt.position.y += 70
        let moveAction = SKAction.move(to: thePlayer.lowerTorso.position, duration: 0.2)
        let animation: SKAction = SKAction(named: "boltCast")!
        bolt.run(animation)
        {
            bolt.run(moveAction)
        }
        
        self.scene?.addChild(bolt)
        self.missile.append(bolt)
    }
    func ultimate(thePlayer: PlayerClass)
    {
        let texture = SKTexture(imageNamed: "crystalStorm")
        let size = CGSize.init(width: 1280, height: 720)
        let storm: SKSpriteNode = SKSpriteNode.init(texture: texture, size: size)
        storm.position = self.kinelet.body.position
        if(self.kinelet.body.xScale < 0)
        {
            storm.xScale = -storm.xScale
        }
        let animation = SKAction(named: "storm")
        storm.run(animation!)
        {
            self.thePlayer.health -= 0.3
            self.scene?.removeChildren(in: [storm])
        }
        self.addChild(storm)
    
    }
//enemy objects
    
    func shot(thePlayer: PlayerClass, archer: ArcherClass)
    {
        let texture: SKTexture = SKTexture(imageNamed: "arrow")
        let size: CGSize = CGSize.init(width: 90, height: 10)
        let arrow: SKSpriteNode = SKSpriteNode.init(texture: texture, size: size)
        arrow.zRotation = 0
        arrow.physicsBody = SKPhysicsBody(rectangleOf: size)
        arrow.physicsBody?.allowsRotation = false
        arrow.physicsBody?.affectedByGravity = true
        arrow.physicsBody?.categoryBitMask = physicsCategory.Sword
        arrow.physicsBody?.contactTestBitMask = physicsCategory.Sword | physicsCategory.Player
        arrow.physicsBody?.collisionBitMask = physicsCategory.Sword | physicsCategory.Player
        arrow.name = "Missile \(self.missile.count) Arrow"
        arrow.position = archer.body.position
        arrow.position.y += 2
        
        let moveAction = SKAction.move(to: thePlayer.lowerTorso.position, duration: 0.1)
        arrow.run(moveAction)
        self.scene?.addChild(arrow)
        self.missile.append(arrow)
    }
    func spawnArcher(enemies: [ArcherClass],atPosition: CGPoint) -> [ArcherClass]
    {
        var enemyArray = enemies
        let enemy: ArcherClass! = ArcherClass.init()
        let texture: SKTexture = SKTexture(imageNamed: "archer")
        var size: CGSize = enemy.body.size
        size.width = 90
        enemy.body.physicsBody = SKPhysicsBody(rectangleOf: size)
        enemy.body.physicsBody?.allowsRotation = false
    
        enemy.body.texture = texture
        enemy.body.physicsBody?.categoryBitMask = physicsCategory.Sword
        enemy.body.physicsBody?.contactTestBitMask = physicsCategory.Sword | physicsCategory.Player
        //enemy.body.physicsBody?.collisionBitMask = physicsCategory.Sword | physicsCategory.Player
        enemy.body.name = "Enemy \(enemies.count) Archer"
        
        enemy.body.position = atPosition
        enemyArray.append(enemy)
        self.scene?.addChild(enemy.body)
        if(enemyArray.count == 1 && self.enemies.count == 0)
            {
                if let musicURL = Bundle.main.url(forResource: "enemy", withExtension: "mp3")
                {
                    self.scene?.removeChildren(in: [audio])
                    audio = SKAudioNode(url: musicURL)
                    self.scene?.addChild(audio)
                }
            }
        print("archer added")
        return enemyArray
    }
    
    
    func spawnEnemy(enemies: [Enemy], atPosition: CGPoint) -> [Enemy]
    {
        var enemyArray = enemies
        let enemy: Enemy! = Enemy.init()
        let texture: SKTexture = SKTexture(imageNamed: "testEnemy")
        var size: CGSize = enemy.body.size
        size.width = 90
        enemy.body.physicsBody = SKPhysicsBody(rectangleOf: size)
        enemy.body.physicsBody?.allowsRotation = false
        
        enemy.body.texture = texture
        enemy.body.physicsBody?.categoryBitMask = physicsCategory.Sword
        enemy.body.physicsBody?.contactTestBitMask = physicsCategory.Sword | physicsCategory.Player
       // enemy.body.physicsBody?.collisionBitMask = physicsCategory.Sword | physicsCategory.Player
        enemy.body.name = "Enemy \(enemyArray.count) Enemy"
        enemy.body.position = atPosition
        enemyArray.append(enemy)
        self.scene?.addChild(enemy.body)
        if(enemyArray.count == 1)
        {
            if let musicURL = Bundle.main.url(forResource: "enemy", withExtension: "mp3") {
                self.scene?.removeChildren(in: [audio])
                audio = SKAudioNode(url: musicURL)
                self.scene?.addChild(audio)
            }
        }
        print("enemy added")
        return enemyArray
    }
    
   
    
    override func didMove(to view: SKView)
    {
        
        var camera: SKCameraNode!
        self.physicsWorld.contactDelegate = self
       // letter
        
        floor = childNode(withName: "floor")
        floor.name = "floor"
        dialogScene = childNode(withName: "dialog")
        
        thePlayer.lowerTorso = childNode(withName: "torso_lower")
        thePlayer.lowerTorso.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.lowerTorso.physicsBody?.collisionBitMask = 0
        thePlayer.lowerTorso.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.lowerTorso.name = "Player"
        
        thePlayer.upperTorso = thePlayer.lowerTorso.childNode(withName: "torso_upper")
        thePlayer.upperTorso.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.upperTorso.physicsBody?.collisionBitMask = 0
        thePlayer.upperTorso.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.upperTorso.name = "Player"
        
        thePlayer.upperArmFront = thePlayer.upperTorso.childNode(withName: "arm_upper_front")
        thePlayer.upperArmFront.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.upperArmFront.physicsBody?.collisionBitMask = 0
        thePlayer.upperArmFront.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.upperArmFront.name = "Player"
        
        thePlayer.lowerArmFront = thePlayer.upperArmFront.childNode(withName: "arm_lower_front")
        thePlayer.lowerArmFront.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.lowerArmFront.physicsBody?.collisionBitMask = 0
        thePlayer.lowerArmFront.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.lowerArmFront.name = "Player"
        
        thePlayer.upperArmBack = thePlayer.upperTorso.childNode(withName: "arm_upper_back")
        thePlayer.upperArmBack.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.upperArmBack.physicsBody?.collisionBitMask = 0
        thePlayer.upperArmBack.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.upperArmBack.name = "Player"
        
        
        thePlayer.lowerArmBack = thePlayer.upperArmBack.childNode(withName: "arm_lower_back")
        thePlayer.lowerArmBack.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.lowerArmBack.physicsBody?.collisionBitMask = 0
        thePlayer.lowerArmBack.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.lowerArmBack.name = "Player"
        
        thePlayer.upperLegBack = thePlayer.lowerTorso.childNode(withName: "leg_upper_back")
        thePlayer.upperLegBack.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.upperLegBack.physicsBody?.collisionBitMask = 0
        thePlayer.upperLegBack.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.upperLegBack.name = "Player"
        
        thePlayer.upperLegFront = thePlayer.lowerTorso.childNode(withName: "leg_upper_front")
        thePlayer.upperLegFront.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.upperLegFront.physicsBody?.collisionBitMask = 0
        thePlayer.upperLegFront.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.upperLegFront.name = "Player"
        
        thePlayer.lowerLegBack = thePlayer.upperLegBack.childNode(withName: "leg_lower_back")
        thePlayer.lowerLegBack.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.lowerLegBack.physicsBody?.collisionBitMask = 0
        thePlayer.lowerLegBack.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.lowerLegBack.name = "Player"
        
        thePlayer.lowerLegFront = thePlayer.upperLegFront.childNode(withName: "leg_lower_front")
        thePlayer.lowerLegFront.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.lowerLegFront.physicsBody?.collisionBitMask = 0
        thePlayer.lowerLegFront.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.lowerLegFront.name = "Player"
        
        thePlayer.head = thePlayer.upperTorso.childNode(withName: "head")
        thePlayer.head.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.head.physicsBody?.collisionBitMask = 0
        thePlayer.head.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.head.name = "Player"
        
        
        
        thePlayer.sword = thePlayer.lowerArmFront.childNode(withName: "sword")
        thePlayer.sword.physicsBody?.categoryBitMask = physicsCategory.Sword
        thePlayer.sword.physicsBody?.collisionBitMask = 0
        thePlayer.sword.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.sword.name = "Sword"
        
        thePlayer.fistBack = thePlayer.lowerArmBack.childNode(withName: "fist_back")
        thePlayer.fistFront = thePlayer.sword.childNode(withName: "fist_front")
        thePlayer.goNAX = thePlayer.lowerTorso.childNode(withName: "goNAX")
        thePlayer.fistLegBack = thePlayer.lowerLegBack.childNode(withName: "fist_leg_right")
        thePlayer.fistLegFront = thePlayer.lowerLegFront.childNode(withName: "fist_leg_left")
        
       //typeWriterLabel = dialogScene.childNode(withName: "text") as! SKLabelNode
        camera = childNode(withName: "1") as! SKCameraNode
        camera?.position.x = 0
        healthBar = camera.childNode(withName: "life") as! SKSpriteNode
        
        waterBar = camera.childNode(withName: "water") as! SKSpriteNode
        waterBar.name = "WaterBar"

        
        waterBarBG = camera.childNode(withName: "water_bg") as! SKSpriteNode
        waterBarBG.name = "WaterBar"
        waterBarBG.physicsBody = SKPhysicsBody(rectangleOf: CGSize.init(width: 285, height: 40.5))
        waterBarBG.physicsBody?.isDynamic = false
        waterBarBG.physicsBody?.allowsRotation = false
        waterBarBG.physicsBody?.affectedByGravity = false
       // waterBar.physicsBody?.pinned = true
        waterBarBG.physicsBody?.categoryBitMask = physicsCategory.WaterBar
        waterBarBG.physicsBody?.collisionBitMask = 0
        waterBarBG.physicsBody?.contactTestBitMask = physicsCategory.Coins
        
        questLabel = camera.childNode(withName: "Quest") as! SKLabelNode
        
         if let musicURL = Bundle.main.url(forResource: songLocationName.last, withExtension: "mp3") {
         audio = SKAudioNode(url: musicURL)
         //audio.alpha = 0.5
         addChild(audio)
            
        
                typeWriterLabel = self.dialogScene.childNode(withName: "labelText") as! SKLabelNode
    
                typeWriterLabel.addChild(letter.labelNode)
        }
    }
    

  
//Управление
    override func mouseDown(with event: NSEvent) {
        if(thePlayer.canDo)
        {
            thePlayer.punch()
        }
    }
    
    override func keyDown(with event: NSEvent)
    {
        switch event.keyCode
        {
              case 16:
                   spawObjects(position: CGPoint.init(x: (thePlayer.lowerTorso.position.x) + 300, y: 0))
        case 2:
            if(thePlayer.canDo)
            {
                if(thePlayer.lowerTorso.position.x < thePlayer.rightWall)
                {
                    thePlayer.rightMove()
                    if event.keyCode == 13
                    {
                        thePlayer.plJump()
                    }
                }
                
            }
        case 0:
            if(thePlayer.canDo)
            {
                if(thePlayer.lowerTorso.position.x > thePlayer.leftWall)
                {
                    thePlayer.leftMove()
                    if event.keyCode == 13
                    {
                        thePlayer.plJump()
                    }
                }
            }
        case 13:
            if(thePlayer.canDo)
            {
               // thePlayer.canJump = false
                thePlayer.plJump()
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
//Колизии + Обновление состояний
    func didBegin(_ contact: SKPhysicsContact)
    {
        let firstbody = contact.bodyA.node as! SKSpriteNode
        let secondbody = contact.bodyB.node as! SKSpriteNode
        let firstName = firstbody.name?.split(separator: " ")
        let secontname = secondbody.name?.split(separator: " ")
        if(firstbody.name == "Player" && secondbody.name == "Kinelet")
        {
           // let plus: CGFloat = 30
            var plusX: CGFloat = 30
            if (thePlayer.rotate == "l")
            {
                plusX = -plusX
            }
            
            thePlayer.health -= 0.05
            let moveAction = SKAction.moveBy(x: plusX, y: 0, duration: 0.2)
          //  let moveAction2 = SKAction.moveBy(x: 0, y: -plus, duration: 0.3)
            thePlayer.lowerTorso.run(moveAction)
          //  thePlayer.lowerTorso.run(moveAction2)
        }
        else if(secondbody.name == "Player" && firstbody.name == "Kinelet")
        {
            //let plus: CGFloat = 30
            var plusX: CGFloat = 30
            if (thePlayer.rotate == "l")
            {
                plusX = -plusX
            }
            thePlayer.health -= 0.05
            let moveAction = SKAction.moveBy(x: plusX, y: 0, duration: 0.2)
          //  let moveAction2 = SKAction.moveBy(x: 0, y: 0, duration: 0.3)
            thePlayer.lowerTorso.run(moveAction)
           // thePlayer.lowerTorso.run(moveAction2)
        }
        
        if(firstbody.name == "Sword" && secondbody.name == "Kinelet")
        {
            let plus: CGFloat = 30
            kinelet.hp -= 0.02
            
            let moveAction = SKAction.moveBy(x: -plus*kinelet.body.xScale, y: plus, duration: 0.2)
            let moveAction2 = SKAction.moveBy(x: 0, y: -plus, duration: 0.3)
            kinelet.body.run(moveAction)
            kinelet.body.run(moveAction2)
        }
        else if(secondbody.name == "Sword" && firstbody.name == "Kinelet")
        {
            let plus: CGFloat = 30
            kinelet.hp -= 0.02
            let moveAction = SKAction.moveBy(x: -plus*kinelet.body.xScale, y: plus, duration: 0.2)
            let moveAction2 = SKAction.moveBy(x: 0, y: -plus, duration: 0.3)
            kinelet.body.run(moveAction)
            kinelet.body.run(moveAction2)
        }
        
        if(firstName![0] == "Player" && secontname![0] == "Missile")
        {
           
            let plus: CGFloat = 30
            
            if(secontname![2] == "Arrow")
            {
                self.thePlayer.health -= 0.03
                self.removeChildren(in: [self.missile[Int(secontname![1])!]])
                var newArray: [SKSpriteNode] = []
                var point = 0
                for j in self.missile
                {
                    newArray.append(j)
                    newArray[point].name = "Missile \(point) Arrow"
                    point += 1
                }
                
                self.missile = newArray
            }
            else if (secontname![2] == "Bolt")
            {
                self.thePlayer.health -= 0.05
                self.removeChildren(in: [self.missile[Int(secontname![1])!]])
                var newArray: [SKSpriteNode] = []
                var point = 0
                for j in self.missile
                {
                    newArray.append(j)
                    newArray[point].name = "Missile \(point) Arrow"
                    point += 1
                }
                
                self.missile = newArray
            }
            
            let moveAction = SKAction.moveBy(x: 0, y: plus, duration: 0.2)
            let moveAction2 = SKAction.moveBy(x: 0, y: -plus, duration: 0.3)
            thePlayer.lowerTorso.run(moveAction)
            thePlayer.lowerTorso.run(moveAction2)
        }
        else if (firstName![0] == "Missile" && secontname![0] == "Player")
        {
           
            let plus: CGFloat = 30
           // if(thePlayer.rotate == "l")
           // {
           //     plus = -plus
           // }
           
            if(firstName![2] == "Arrow")
            {
                self.thePlayer.health -= 0.03
                self.removeChildren(in: [self.missile[Int(firstName![1])!]])
                var newArray: [SKSpriteNode] = []
                var point = 0
                for j in self.missile
                {
                    newArray.append(j)
                    newArray[point].name = "Missile \(point) Arrow"
                    point += 1
                }
                
                self.missile = newArray
            }
            else if (firstName![2] == "Bolt")
            {
                self.thePlayer.health -= 0.05
                self.removeChildren(in: [self.missile[Int(secontname![1])!]])
                var newArray: [SKSpriteNode] = []
                var point = 0
                for j in self.missile
                {
                    newArray.append(j)
                    newArray[point].name = "Missile \(point) Arrow"
                    point += 1
                }
                
                self.missile = newArray
            }
            let moveAction = SKAction.moveBy(x: 0, y: plus, duration: 0.2)
            let moveAction2 = SKAction.moveBy(x: 0, y: -plus, duration: 0.3)
            thePlayer.lowerTorso.run(moveAction)
            thePlayer.lowerTorso.run(moveAction2)
        }
        
        if(firstName![0] == "Player" && secontname![0] == "Enemy")
        {
           
            let plus: CGFloat = 30
            
            thePlayer.health -= 0.05
            
            let moveAction = SKAction.moveBy(x: 0, y: plus, duration: 0.2)
            let moveAction2 = SKAction.moveBy(x: 0, y: -plus, duration: 0.3)
            thePlayer.lowerTorso.run(moveAction)
            thePlayer.lowerTorso.run(moveAction2)
        }
        else if (firstName![0] == "Enemy" && secontname![0] == "Player")
        {
            
            let plus: CGFloat = 30
           
            thePlayer.health -= 0.05
            
            let moveAction = SKAction.moveBy(x: 0, y: plus, duration: 0.2)
            let moveAction2 = SKAction.moveBy(x: 0, y: -plus, duration: 0.3)
            thePlayer.lowerTorso.run(moveAction)
            thePlayer.lowerTorso.run(moveAction2)
        }
        
        if(firstbody.name == "Player" && secondbody.name == "floor")
        {
            thePlayer.canJump = true
        }
        else if (firstbody.name == "floor" && secondbody.name == "Player")
        {
            thePlayer.canJump = true
        }
        
        if(firstbody.name == "Player" && secondbody.name == "Player")
        {
            let moveAction = SKAction.moveBy(x: 0, y: 0, duration: 0.2)
            
            thePlayer.lowerTorso.run(moveAction)
        }
        
        if(firstbody.name == "Sword" && secontname![0] == "Enemy")
        {
            var plus:CGFloat = 50
            if(thePlayer.rotate == "r")
            {
                plus = -plus
            }
            let moveAction = SKAction.moveBy(x: 0, y: plus, duration: 0.2)
            
            
            if(secontname![2] == "Enemy")
            {
                self.enemies[Int(secontname![1])!].hp -= 20
            }
            else if (secontname![2] == "Archer")
            {
                print(self.enemies.count)
                print(secontname![1])
                self.archers[Int(secontname![1])!].hp -= 20
            }
            secondbody.run(moveAction)
        }
        else if (firstName![0] == "Enemy" && secondbody.name == "Sword")
        {
            var plus:CGFloat = 50
            if(thePlayer.rotate == "r")
            {
                plus = -plus
            }
            let moveAction = SKAction.moveBy(x: 0, y: plus, duration: 0.2)
            
            
            if(firstName![2] == "Enemy")
            {
                self.enemies[Int(firstName![1])!].hp -= 20
            }
            else if (firstName![2] == "Archer")
            {
                self.archers[Int(firstName![1])!].hp -= 20
            }
            firstbody.run(moveAction)
        }
        
        if(firstName![0] == "Missile" && (secondbody.name == "floor" || secondbody.name == "Sword") )
        {
            print("arrow falled")
            if(firstName![2] == "Arrow")
            {
                self.removeChildren(in: [self.missile[Int(firstName![1])!]])
                var newArray: [SKSpriteNode] = []
                var point = 0
                for j in self.missile
                {
                    newArray.append(j)
                    newArray[point].name = "Missile \(point) Arrow"
                    point += 1
                }
                
                self.missile = newArray
            }
        }
        else if((firstbody.name == "floor" || firstbody.name == "Sword") && secontname![0] == "Missile")
        {
            print("arrow falled")
            if(secontname![2] == "Arrow")
            {
                self.removeChildren(in: [self.missile[Int(secontname![1])!]])
                
                var newArray: [SKSpriteNode] = []
                var point = 0
                for j in self.missile
                {
                    newArray.append(j)
                    newArray[point].name = "Missile \(point) Arrow"
                    point += 1
                }
                
                self.missile = newArray
                
            }
        }
        if(firstName![0] == "Coin" && secondbody.name == "WaterBar")
        {
            print("kek")
            self.thePlayer.water += 0.1
            if(self.thePlayer.water > 1.0)
            {
                self.thePlayer.water = 1.0
            }
           
            self.removeChildren(in: [self.coins[Int(firstName![1])!]])
            self.coins.remove(at: Int(firstName![1])!)
            var newArray: [SKSpriteNode] = []
            var point = 0
            for j in self.coins
            {
                newArray.append(j)
                newArray[point].name = "Coin \(point)"
                point += 1
            }
            
            self.coins = newArray
          
        }
        else if(firstbody.name == "WaterBar" && secontname![0] == "Coin")
        {
            
            self.thePlayer.water += 0.1
            if(self.thePlayer.water > 1.0)
            {
                self.thePlayer.water = 1.0
            }
            
            self.removeChildren(in: [self.coins[Int(secontname![1])!]])
            self.coins.remove(at: Int(secontname![1])!)
            
            var newArray: [SKSpriteNode] = []
            var point = 0
            for j in self.coins
            {
                    newArray.append(j)
                    newArray[point].name = "Coin \(point)"
                    point += 1
            }
            
            self.coins = newArray
        }
        
        if(firstbody.name == "Sword" && secontname![0] == "Object")
        {
            
            self.removeChildren(in: [self.objects[Int(secontname![1])!]])
            self.spawnWater(atPosition: secondbody.position)
            self.objects.remove(at: Int(secontname![1])!)
            
            var newArray: [SKSpriteNode] = []
            var point = 0
            for j in self.objects
            {
                newArray.append(j)
                newArray[point].name = "Object \(point)"
                point += 1
            }
            
            self.objects = newArray
        }
        else if(firstName![0] == "Object" && secondbody.name == "Sword")
        {
            self.removeChildren(in: [self.objects[Int(firstName![1])!]])
            self.spawnWater(atPosition: secondbody.position)
            self.objects.remove(at: Int(secontname![1])!)
            var newArray: [SKSpriteNode] = []
            var point = 0
            for j in self.objects
            {
                newArray.append(j)
                newArray[point].name = "Object \(point)"
                point += 1
            }
            
            self.objects = newArray
            

            
        }
        
    }
    
    var one = true
    var two = true
    var three = true
    var dialogCount = 1000//1000
    var dialogMinus = 1
    var trySound = 5
    var kin = true

    override func update(_ currentTime: TimeInterval)
    {
        
//player control health and water
        if(thePlayer.canDo)
        {
           thePlayer.water -= thePlayer.howMushWaterINeew
        }
        waterBar.xScale = thePlayer.water
        if(thePlayer.health < 1)
        {
            thePlayer.health += thePlayer.regenereteNumber
        }
        healthBar.xScale = thePlayer.health
        
        if(thePlayer.health <= 0 || thePlayer.water <= 0)
        {
            self.scene?.removeAllChildren()
        }
        else
        {
        
            //moving camera
            if(thePlayer.lowerTorso.position.x >= 0 && enemies.count == 0 && thePlayer.lowerTorso.position.x <= 2080 && thePlayer.health > 0)
            {
                thePlayer.leftWall = -430
                thePlayer.rightWall = (camera?.position.x)! + 450
                camera?.position.x = thePlayer.lowerTorso.position.x
            }
            else if(enemies.count > 0)
            {
                thePlayer.leftWall = (camera?.position.x)! - 450
            }
            else if(thePlayer.lowerTorso.position.x >= 2500 && kin && thePlayer.health > 0)
            {
                thePlayer.lowerTorso.position.x = 3100
                self.camera?.position.x = 3500
                let pos = CGPoint(x: 4000, y: -150)
                questPointer += 1
                kin = false
                kinelet = KineletClass.init(8.0, thePlayer: thePlayer, scene: self.scene!, position: pos)
                
                
                self.songLocationName.append("dunge")
                if let musicURL = Bundle.main.url(forResource: songLocationName.last, withExtension: "mp3")
                {
                    self.scene?.removeChildren(in: [self.audio])
                    self.audio = SKAudioNode(url: musicURL)
                    self.scene?.addChild(self.audio)
                }
                thePlayer.leftWall = 3050
                thePlayer.rightWall = (camera?.position.x)! + 450
                //  camera?.position.x = thePlayer.lowerTorso.position.x
            }
            else if (thePlayer.lowerTorso.position.x >= 3500 && thePlayer.health > 0)
            {
                thePlayer.rightWall = (camera?.position.x)! + 450
                camera?.position.x = thePlayer.lowerTorso.position.x
            }
            
     //spawn enemies
            if(thePlayer.lowerTorso.position.x > 500 && one)
            {
                enemies = spawnEnemy(enemies: enemies, atPosition: CGPoint(x: -250, y: -247))
                enemies = spawnEnemy(enemies: enemies, atPosition: CGPoint(x: 1500, y: -247))
                archers = spawnArcher(enemies: archers, atPosition: CGPoint(x: 1520, y: -247))
                self.questLabel.text = Quests[questPointer]
                questPointer += 1
                one = false
                spawObjects(position: CGPoint(x: 1600, y: -247))
                spawObjects(position: CGPoint(x: 1680, y: -247))
                
            }
            
            if(thePlayer.lowerTorso.position.x > 1600 && three)
            {
                enemies = spawnEnemy(enemies: enemies, atPosition: CGPoint(x: 560, y: -247))
                archers = spawnArcher(enemies: archers, atPosition: CGPoint(x: 520, y: -247))
                archers = spawnArcher(enemies: archers, atPosition: CGPoint(x: 540, y: -247))
                three = false
            }
            
      //kinelet
            if(!kin)
            {
                kinelet.healthBar.xScale = kinelet.hp
                if(kinelet.hp > 0)
                {
                    kinelet.timer -= 1
                    kinelet.kick(thePlayer: thePlayer, scene: self.scene)
                    if(kinelet.timer % 200 == 0)
                    {
                        self.bolt(thePlayer: thePlayer, kinelet: self.kinelet)
                    }
                    else if(kinelet.timer % 1100 == 0)
                    {
                        self.ultimate(thePlayer: thePlayer)
                    }
                }
                else
                {
                    kinelet.hp = 0
                    self.scene?.removeChildren(in: [kinelet.body])
                }
            }
            
    //coins
            if(coins.count != 0)
            {
                for i in 0...coins.count - 1
                {
                    let point = CGPoint.init(x: (self.camera?.position.x)! - 390, y: (self.camera?.position.y)! + 239)
                    let moveAction = SKAction.move(to: point, duration: 0.2)
                    coins[i].run(moveAction)
                    
                }
            }
    //life and death enemy
            
            if(enemies.count > 0)
            {
                trySound = 5
                for i in 0...enemies.count - 1
                {
                    
                    if(enemies[i].hp <= 0)
                    {
                        spawnWater(atPosition: enemies[i].body.position)
      //                  playSound(resourse: "8-bit-agony")
                        self.scene?.removeChildren(in: [enemies[i].body])
                        
                        var newArray: [Enemy] = []
                        var point = 0
                        for j in enemies
                        {
                            if(j.hp > 0)
                            {
                                newArray.append(j)
                                newArray[point].body.name = "Enemy \(point) Enemy"
                                point += 1
                            }
                        }
                        
                        self.enemies = newArray
                        break
                        
                    }
                    enemies[i].kick(thePlayer: thePlayer)
                }
            }
            else
            {
                trySound -= 1
                if(trySound == 0)
                {
                    if let musicURL = Bundle.main.url(forResource: songLocationName.last, withExtension: "mp3") {
                        self.scene?.removeChildren(in: [audio])
                        audio = SKAudioNode(url: musicURL)
                        self.scene?.addChild(audio)
                    }
                }
            }
          
            if(archers.count > 0)
            {
                trySound = 5
                for i in 0...archers.count - 1
                {
                    
                    if(archers[i].hp <= 0)
                    {
                        spawnWater(atPosition: archers[i].body.position)
                        playSound(resourse: "8-bit-agony") 
                        self.scene?.removeChildren(in: [archers[i].body])
                        
                        var newArray: [ArcherClass] = []
                        var point = 0
                        for j in archers
                        {
                            if(j.hp > 0)
                            {
                                newArray.append(j)
                                newArray[point].body.name = "Enemy \(point) Archer"
                                point += 1
                            }
                        }
                        self.archers = newArray
                        break
                        
                    }
                    archers[i].timer -= 1
                    archers[i].kick(thePlayer: thePlayer)
                    if(archers[i].timer <= 0)
                    {
                        self.shot(thePlayer: thePlayer, archer: archers[i])
                        archers[i].refreshTimer()
                    }
                }
            }
            else
            {
                trySound -= 1
                if(trySound == 0)
                {
                    if let musicURL = Bundle.main.url(forResource: songLocationName.last, withExtension: "mp3") {
                        self.scene?.removeChildren(in: [audio])
                        audio = SKAudioNode(url: musicURL)
                        self.scene?.addChild(audio)
                    }
                }
            }
            
            
     //LOR
            if(thePlayer.lowerTorso.position.x > 0)
            {
                self.dialogScene.position.x = (self.thePlayer.lowerTorso.position.x)
            }
            dialogCount -= dialogMinus
            if(dialogCount == 600)
            {
                
               print("Dialog Pointer \(dialogPointer)")
                    typeWriterLabel.removeChildren(in: [letter.labelNode])
                    letter = DialogClass.init(Dialog[dialogPointer])
                    typeWriterLabel.addChild(letter.labelNode)
                //dialogPointer += 1
               
            }
            else if(dialogCount == 100)
            {
                
                typeWriterLabel.removeChildren(in: [letter.labelNode])
                letter = DialogClass.init(Dialog[dialogPointer])
                typeWriterLabel.addChild(letter.labelNode)
                self.questLabel.text = Quests[questPointer]
                
                print("Dialog Pointer \(dialogPointer)")
                questPointer += 1
            }
            else if(dialogCount == -400)
            {
                let moveAction = SKAction.moveBy(x: 0, y: 500, duration: 1)
                self.dialogScene.run(moveAction)
                
                thePlayer.canDo = true
                dialogCount = -500
                dialogMinus = 0
            }
            else if (dialogCount == -500 && thePlayer.lowerTorso.position.x > 1500 )
            {
             //   dialogPointer += 1
                dialogMinus = 1
               // dialogCount -= 5
                let moveAction = SKAction.moveBy(x: 0, y: -500, duration: 0.1)
                self.dialogScene.run(moveAction)
                print("Dialog Pointer \(dialogPointer)")
                typeWriterLabel.removeChildren(in: [letter.labelNode])
                letter = DialogClass.init(Dialog[dialogPointer])
                typeWriterLabel.addChild(letter.labelNode)

                thePlayer.canDo = false
            }
            else if (dialogCount == -1300)
            {
                let moveAction = SKAction.moveBy(x: 0, y: 500, duration: 1)
                self.dialogScene.run(moveAction)
                thePlayer.canDo = true
            }
            
            
        }
        
        
        
        
    }

}
