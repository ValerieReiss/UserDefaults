//
//  GameScene.swift
//  UserDefaults
//
//  Created by Valerie on 30.03.23.
//

// augment the playerCoins by touching the player

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let player         : UInt32 = 0x1 << 1
    static let object         : UInt32 = 0x1 << 2
}

enum CollisionType: UInt32 {
    case player = 1
    case object = 2
}

var object = SKSpriteNode(imageNamed: "Planisferius")
var player = SKSpriteNode(imageNamed: "Planisferius")
var backgroundColorCustom = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
var playerSize = CGSize(width: 10, height: 10)

let normalPlayerPositionX = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreCoins: SKLabelNode!
    var playerCoins = Int()
    
// UserDefaults: set scoreKey
    let scoreKey = "scoreKey"
    
    override func didMove(to view: SKView) {
        self.backgroundColor = backgroundColorCustom
        
// UserDefaults: set var to key
        let userDefaults = UserDefaults.standard
        playerCoins = userDefaults.integer(forKey: scoreKey)
        userDefaults.synchronize()
        
        scoreCoins = SKLabelNode(fontNamed: "Chalkduster")
        scoreCoins.setScale(2)
        scoreCoins.zPosition = 5
        scoreCoins.text = "\(playerCoins)"
        scoreCoins.position = CGPoint(x: self.frame.midX-500, y: self.frame.midY+420)
        addChild(scoreCoins)
        
        let links = SKShapeNode(circleOfRadius: 100)
        links.fillColor = .systemRed
        links.name = "links"
        links.zPosition = 6
        links.position = CGPoint(x: self.frame.midX-550, y: self.frame.midY-280)
        links.setScale(1)
        self.addChild(links)
        
        let rechts = SKShapeNode(circleOfRadius: 100)
        rechts.fillColor = .systemGreen
        rechts.name = "rechts"
        rechts.zPosition = 6
        rechts.position = CGPoint(x: self.frame.midX+550, y: self.frame.midY-280)
        rechts.setScale(1)
        self.addChild(rechts)
        
        spawnPlayer()
        spawnObject()
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let location = touch.location(in: self)
           
            let node = self.atPoint(location)

            if (node.name == "links") {
                let bla = SKAction.moveTo(x: player.position.x-100, duration: 0.3)
                bla.timingFunction = {
                    time in return simd_smoothstep(0, 1, time)
                }
                let blub = SKAction.moveTo(x: CGFloat(normalPlayerPositionX), duration: 2.0)
                blub.timingFunction = {
                    time in return simd_smoothstep(0, 1, time)
                }
                let sequence = SKAction.sequence([bla, blub])
                player.run(sequence)
            } else if (node.name == "rechts") {
                let bla = SKAction.moveTo(x: player.position.x+100, duration: 0.3)
                bla.timingFunction = {
                    time in return simd_smoothstep(0, 1, time)
                }
                let blub = SKAction.moveTo(x: CGFloat(normalPlayerPositionX), duration: 2.0)
                blub.timingFunction = {
                    time in return simd_smoothstep(0, 1, time)
                }
                let sequence = SKAction.sequence([bla, blub])
                player.run(sequence)
            } else if (node.name == "player"){
// augment the playerCoins by touching the player
                playerCoins += 1
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
            
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        let sortedNodes = [nodeA, nodeB].sorted {$0.name ?? "" < $1.name ?? ""}
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        if secondNode.name == "object"{
            print("object")
            playerCoins += 1}
        else if firstNode.name == "object" {
            print("object1")
            playerCoins += 1}
        else if firstNode.name == "player" {
            print("player")
            playerCoins += 1}
        else if secondNode.name == "player" {
            print("player1")
            playerCoins += 1}
        else { return }
    }

// User Defaults: update and save to dictionary
    override func update(_ currentTime: TimeInterval) {
        scoreCoins.text = "\(playerCoins)"
        
        let defaults = UserDefaults.standard
        defaults.set(playerCoins, forKey: scoreKey)
        print("playerCoins gespeichert in scoreKey = \(playerCoins)")
    }
    
    func spawnPlayer(){
        player.name = "player"
        player.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.contactTestBitMask = CollisionType.object.rawValue
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.position = CGPointMake(self.frame.midX, self.frame.midY)
        player.setScale(0.1)
        self.addChild(player)
    }
    
    func spawnObject(){
        object.name = "object"
        object.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        object.physicsBody = SKPhysicsBody(texture: object.texture!, size: object.texture!.size())
        object.physicsBody?.affectedByGravity = false
        object.physicsBody?.isDynamic = false
        object.physicsBody?.contactTestBitMask = CollisionType.player.rawValue
        object.physicsBody?.categoryBitMask = CollisionType.object.rawValue
        object.position = CGPointMake(self.frame.midX - 400, self.frame.midY)
        object.setScale(0.05)
        self.addChild(object)
    }
    
}
