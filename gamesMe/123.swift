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
//objects spawn
    func spawObjects(position: CGPoint)
    {
        let texture = SKTexture(imageNamed: "object")
        let size = CGSize(width: 60, height: 60)
        let object = SKSpriteNode(texture: texture, color: NSColor.red, size: size)
        object.physicsBody = SKPhysicsBody(rectangleOf: size)
        object.physicsBody?.affectedByGravity = false
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
    
//water spawn
    func spawnWater(enemy: Enemy)// -> [SKSpriteNode]
    {
        print("COINS")
        let texture: SKTexture = SKTexture(imageNamed: "WaterCoin")
        let size: CGSize = CGSize.init(width: 30, height: 30)
        //avar coins: [SKSpriteNode] = []
        for i in 0...(enemy.cost - 1)
        {
            self.coins.append(SKSpriteNode(texture: texture, size: size))
            self.coins[i].physicsBody = SKPhysicsBody(circleOfRadius: 15)
            self.coins[i].physicsBody?.allowsRotation = false
            self.coins[i].physicsBody?.affectedByGravity = false
            self.coins[i].zPosition = 99
            self.coins[i].physicsBody?.categoryBitMask = physicsCategory.Coins
            self.coins[i].physicsBody?.contactTestBitMask = physicsCategory.WaterBar
            self.coins[i].physicsBody?.collisionBitMask = physicsCategory.WaterBar
            self.coins[i].name = "Coin \(self.coins.count - 1)"
            print(self.coins.count - 1)
            self.coins[i].position = enemy.body.position
            self.coins[i].position.x += CGFloat(i)
            self.coins[i].position.y += CGFloat(i*10)
        
            self.addChild(coins[i])
        }
         print("COINS")
        //return coins
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
        print(arrow.name!)
        arrow.position = archer.body.position
        arrow.position.y += 2
        
        let moveAction = SKAction.move(to: thePlayer.lowerTorso.position, duration: 0.1)
        arrow.run(moveAction)
        self.scene?.addChild(arrow)
        print("shot")
        self.missile.append(arrow)
    }
    func spawnArcher(enemies: [ArcherClass], thePlayer: PlayerClass) -> [ArcherClass]
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
        enemy.body.physicsBody?.collisionBitMask = physicsCategory.Sword | physicsCategory.Player
        enemy.body.name = "Enemy \(enemies.count) Archer"
        
        enemy.body.position = thePlayer.lowerTorso.position
        enemy.body.position.x += 900
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
    
    
    func spawnEnemy(enemies: [Enemy], thePlayer: PlayerClass) -> [Enemy]
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
        enemy.body.physicsBody?.collisionBitMask = physicsCategory.Sword | physicsCategory.Player
        enemy.body.name = "Enemy \(enemyArray.count) Enemy"
        enemy.body.position = thePlayer.lowerTorso.position
        enemy.body.position.x += 1000
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
        thePlayer.lowerTorso.physicsBody?.collisionBitMask = physicsCategory.Enemy
        thePlayer.lowerTorso.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.lowerTorso.name = "Player"
        
        thePlayer.upperTorso = thePlayer.lowerTorso.childNode(withName: "torso_upper")
        thePlayer.upperTorso.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.upperTorso.physicsBody?.collisionBitMask = physicsCategory.Enemy
        thePlayer.upperTorso.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.upperTorso.name = "Player"
        
        thePlayer.upperArmFront = thePlayer.upperTorso.childNode(withName: "arm_upper_front")
        thePlayer.upperArmFront.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.upperArmFront.physicsBody?.collisionBitMask = physicsCategory.Enemy
        thePlayer.upperArmFront.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.upperArmFront.name = "Player"
        
        thePlayer.lowerArmFront = thePlayer.upperArmFront.childNode(withName: "arm_lower_front")
        thePlayer.lowerArmFront.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.lowerArmFront.physicsBody?.collisionBitMask = physicsCategory.Enemy
        thePlayer.lowerArmFront.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.lowerArmFront.name = "Player"
        
        thePlayer.upperArmBack = thePlayer.upperTorso.childNode(withName: "arm_upper_back")
        thePlayer.upperArmBack.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.upperArmBack.physicsBody?.collisionBitMask = physicsCategory.Enemy
        thePlayer.upperArmBack.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.upperArmBack.name = "Player"
        
        
        thePlayer.lowerArmBack = thePlayer.upperArmBack.childNode(withName: "arm_lower_back")
        thePlayer.lowerArmBack.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.lowerArmBack.physicsBody?.collisionBitMask = physicsCategory.Enemy
        thePlayer.lowerArmBack.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.lowerArmBack.name = "Player"
        
        thePlayer.upperLegBack = thePlayer.lowerTorso.childNode(withName: "leg_upper_back")
        thePlayer.upperLegBack.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.upperLegBack.physicsBody?.collisionBitMask = physicsCategory.Enemy
        thePlayer.upperLegBack.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.upperLegBack.name = "Player"
        
        thePlayer.upperLegFront = thePlayer.lowerTorso.childNode(withName: "leg_upper_front")
        thePlayer.upperLegFront.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.upperLegFront.physicsBody?.collisionBitMask = physicsCategory.Enemy
        thePlayer.upperLegFront.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.upperLegFront.name = "Player"
        
        thePlayer.lowerLegBack = thePlayer.upperLegBack.childNode(withName: "leg_lower_back")
        thePlayer.lowerLegBack.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.lowerLegBack.physicsBody?.collisionBitMask = physicsCategory.Enemy
        thePlayer.lowerLegBack.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.lowerLegBack.name = "Player"
        
        thePlayer.lowerLegFront = thePlayer.upperLegFront.childNode(withName: "leg_lower_front")
        thePlayer.lowerLegFront.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.lowerLegFront.physicsBody?.collisionBitMask = physicsCategory.Enemy
        thePlayer.lowerLegFront.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.lowerLegFront.name = "Player"
        
        thePlayer.head = thePlayer.upperTorso.childNode(withName: "head")
        thePlayer.head.physicsBody?.categoryBitMask = physicsCategory.Player
        thePlayer.head.physicsBody?.collisionBitMask = physicsCategory.Enemy
        thePlayer.head.physicsBody?.contactTestBitMask = physicsCategory.Enemy
        thePlayer.head.name = "Player"
        
        
        
        thePlayer.sword = thePlayer.lowerArmFront.childNode(withName: "sword")
        thePlayer.sword.physicsBody?.categoryBitMask = physicsCategory.Sword
        thePlayer.sword.physicsBody?.collisionBitMask = physicsCategory.Enemy
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
       // waterBar.physicsBody?.isDynamic = false
       // waterBar.physicsBody?.allowsRotation = false
       // waterBar.physicsBody?.affectedByGravity = false
        
        waterBarBG = camera.childNode(withName: "water_bg") as! SKSpriteNode
        waterBarBG.name = "WaterBar"
        waterBarBG.physicsBody = SKPhysicsBody(rectangleOf: CGSize.init(width: 285, height: 40.5))
        waterBarBG.physicsBody?.isDynamic = false
        waterBarBG.physicsBody?.allowsRotation = false
        waterBarBG.physicsBody?.affectedByGravity = false
       // waterBar.physicsBody?.pinned = true
        waterBarBG.physicsBody?.categoryBitMask = physicsCategory.WaterBar
        waterBarBG.physicsBody?.collisionBitMask = physicsCategory.Coins
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
        switch event.keyCode {
        case 16:
            self.archers = spawnArcher(enemies: archers, thePlayer: thePlayer)
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
        print("\(firstName![0]) \(secondbody.name!)")
        if(firstName![0] == "Player" && secontname![0] == "Missile")
        {
           
            let plus: CGFloat = 30
           // if(thePlayer.rotate == "l")
           // {
          //      plus = -plus
           // }
            thePlayer.health -= 0.05
            if(secontname![2] == "Arrow")
            {
                self.removeChildren(in: [self.missile[Int(secontname![1])!]])
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
            thePlayer.health -= 0.05
            if(firstName![2] == "Arrow")
            {
                self.removeChildren(in: [self.missile[Int(firstName![1])!]])
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
            }
        }
        else if((firstbody.name == "floor" || firstbody.name == "Sword") && secontname![0] == "Missile")
        {
            print("arrow falled")
            if(secontname![2] == "Arrow")
            {
                self.removeChildren(in: [self.missile[Int(secontname![1])!]])
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
            var i = 0
            while self.coins.count > i
            {
                self.removeChildren(in: [self.coins[i]])
                i += 1
             //   self.coins.remove(at: i)
            }
            self.removeChildren(in: self.coins)
            /*
            var newArray: [SKSpriteNode] = []
            var point = 0
            for j in self.coins
            {
                    newArray.append(j)
                    newArray[point].name = "Coin \(point)"
                    point += 1
            }
            
            */
            self.coins = []
        }
        else if(firstbody.name == "WaterBar" && secontname![0] == "Coin")
        {
              print("kek")
            self.thePlayer.water += 0.1
            if(self.thePlayer.water > 1.0)
            {
                self.thePlayer.water = 1.0
            }
            var i = 0
            while self.coins.count > i
            {
                self.removeChildren(in: [self.coins[i]])
                i += 1
              //  self.coins.remove(at: i)
            }
           self.removeChildren(in: self.coins)
            self.coins = []
        }
    }
    
    var one = true
    var two = true
    var three = true
    var dialogCount = 10//400
    var trySound = 5
    var howMushWaterINeew:CGFloat = 0.0002
    override func update(_ currentTime: TimeInterval)
    {
       
//player control health and water
        if(thePlayer.canDo)
        {
           thePlayer.water -= howMushWaterINeew
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
        
     //spawn enemies
            if(thePlayer.lowerTorso.position.x > 500 && one)
            {
                enemies = spawnEnemy(enemies: enemies, thePlayer: thePlayer)
                self.questLabel.text = Quests[questPointer]
                questPointer += 1
                one = false
                var position: CGPoint = CGPoint.init(x: 1000, y: thePlayer.lowerTorso.position.y)
                spawObjects(position: position)
                position.x += 200
                spawObjects(position: position)
                
            }
            if(thePlayer.lowerTorso.position.x > 600 && two)
            {
                archers = spawnArcher(enemies: archers, thePlayer: thePlayer)
                two = false
            }
            if(thePlayer.lowerTorso.position.x > 1500 && three)
            {
                enemies = spawnEnemy(enemies: enemies, thePlayer: thePlayer)
                archers = spawnArcher(enemies: archers, thePlayer: thePlayer)
                archers = spawnArcher(enemies: archers, thePlayer: thePlayer)
                three = false
            }
            
    //coins
            if(coins.count != 0)
            {
                for i in 0...coins.count - 1
                {
                   // let vector: CGVector = CGVector.init(dx:  - coins[i].position.x, dy:  - coins[i].position.y)
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
                        spawnWater(enemy: enemies[i])
                        playSound(resourse: "8-bit-agony")
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
                        spawnWater(enemy: archers[i])
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
            dialogCount -= 1
            if(dialogCount == 0)
            {
               
                    typeWriterLabel.removeChildren(in: [letter.labelNode])
                    letter = DialogClass.init(Dialog[dialogPointer])
                    typeWriterLabel.addChild(letter.labelNode)
                    dialogPointer += 1
            }
            else if(dialogCount == -100)
            {
                typeWriterLabel.removeChildren(in: [letter.labelNode])
                letter = DialogClass.init(Dialog[dialogPointer])
                typeWriterLabel.addChild(letter.labelNode)
                self.questLabel.text = Quests[questPointer]
                questPointer += 1
            }
            else if(dialogCount == -200)
            {
                let moveAction = SKAction.moveBy(x: 0, y: 500, duration: 1)
                self.dialogScene.run(moveAction)
                thePlayer.canDo = true
            }
            
    //moving camera
            if(thePlayer.lowerTorso.position.x >= 0 && enemies.count == 0 && thePlayer.lowerTorso.position.x <= 2080)
            {
                thePlayer.leftWall = -430
                thePlayer.rightWall = (camera?.position.x)! + 450
                camera?.position.x = thePlayer.lowerTorso.position.x
            }
            else if(enemies.count > 0)
            {
                thePlayer.leftWall = (camera?.position.x)! - 450
                //self.questLabel.text = Quests[questPointer]
              //  questPointer += 1
            }
            else if(thePlayer.lowerTorso.position.x >= 3500)
            {
                
                thePlayer.leftWall = -430
                thePlayer.rightWall = (camera?.position.x)! + 450
                camera?.position.x = thePlayer.lowerTorso.position.x
            }
            else if(thePlayer.lowerTorso.position.x >= 2500 && thePlayer.lowerTorso.position.x <= 3000)
            {
                self.songLocationName.append("dunge")
                if let musicURL = Bundle.main.url(forResource: songLocationName.last, withExtension: "mp3")
                {
                    self.scene?.removeChildren(in: [self.audio])
                    self.audio = SKAudioNode(url: musicURL)
                    self.scene?.addChild(self.audio)
                }
                
                self.camera?.position.x = 3400
                thePlayer.leftWall = -430
                thePlayer.rightWall = thePlayer.lowerTorso.position.x + 1000
            }
            
        }
        
        
        
    }
}
