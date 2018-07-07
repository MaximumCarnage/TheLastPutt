//
//  GameScene.swift
//  TheLastPutt
//
//  Created by Dylan Bruton on 2018-06-20.
//  Copyright © 2018 Dean,Dylan,JP,Mark. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    //var WaterNode = SKNode()
    // Ball Properties
    var ball = BallNode()
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var ballSpeed: CGFloat = 280.0
    var velocity = CGPoint.zero
    var swipeVelocity = CGPoint.zero
    var firstTouchLocation = CGPoint.zero
    var lastTouchLocation = CGPoint.zero
    var ballSelected: Bool = false
    var background: SKTileMapNode!
    var obstaclesTileMap: SKTileMapNode?
    var currentLevel: Int = 1
    var playerX:CGFloat
    var playerY:CGFloat
    var levelProg = [Bool]()
    var highScores = [Int]()
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var swingsLabel = SKLabelNode()
    //var swings = 0
    var swings: Int = 10
    
    
    let treeTexture = SKTexture(imageNamed: "TreeDarkBig2")
    let userDefaults = UserDefaults.standard
    
    required init?(coder aDecoder: NSCoder) {
        self.playerX = 0
        self.playerY = 0
        super.init(coder: aDecoder)
        background = childNode(withName: "background") as! SKTileMapNode
        obstaclesTileMap = childNode(withName: "obstacles") as? SKTileMapNode
        playerX = userData?.object(forKey: "playerX") as! CGFloat
        playerY = userData?.object(forKey: "playerY") as! CGFloat
        levelProg = userDefaults.object(forKey: "levelStatus") as? [Bool] ?? [Bool]()
        highScores = userDefaults.object(forKey: "highScores") as? [Int] ?? [Int]()
    }
    func UpdateStrokes(){
        
        
    }
    

    

    override func didMove(to view: SKView) {
        ball.position = CGPoint(x: playerX, y: playerY)
        ball.setScale(2.0)
        addChild(ball)
        
        swingsLabel.text = "Swings: X"
        swingsLabel.fontColor = SKColor.black
        swingsLabel.fontSize = 50

        swingsLabel.verticalAlignmentMode = .bottom
        swingsLabel.horizontalAlignmentMode = .left
        swingsLabel.zPosition = 150
        
        addChild(swingsLabel)
        
        setupWorldPhysics()
       // setupObstaclePhysics()
        setupGrassCollider()
        //setupTreeCollider()
        
        physicsWorld.contactDelegate = self
        
    }
    
    func setupWorldPhysics() {
        background.physicsBody = SKPhysicsBody(edgeLoopFrom: background.frame)
    }
    
    func setupGrassCollider() {
        for node in self.children {
            if (node.name == "Collider") {
                let grassCollider = node.calculateAccumulatedFrame()
                node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: grassCollider.width, height: grassCollider.height), center: CGPoint.zero)
                node.physicsBody?.affectedByGravity = false
                node.physicsBody?.collisionBitMask = PhysicsCategory.Player
                node.physicsBody?.categoryBitMask = PhysicsCategory.collider
                
                node.physicsBody?.isDynamic = false
                node.physicsBody?.allowsRotation = false
                node.physicsBody?.restitution = 1.15
                swipeVelocity.y = -swipeVelocity.y
                swipeVelocity.x = -swipeVelocity.x
                
            }
            
            if (node.name == "Collision") {
                let winCollider = node.calculateAccumulatedFrame()
                node.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: winCollider.width, height: winCollider.height), center: CGPoint.zero)
                node.physicsBody!.categoryBitMask = PhysicsCategory.Goal
                node.physicsBody?.isDynamic = false
                node.physicsBody?.affectedByGravity = false
                node.physicsBody?.allowsRotation = false
                
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

//        if ballSelected {
//            firstTouchLocation = ball.position
//        }
        
        guard let touch = touches.first else {
            return
        }
        firstTouchLocation = touch.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
                // y-value (uncertain) of arrow sprite will increase as the player moves touch away from ball
            }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                // will launch ball in direction the finger was dragged to with velocity
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        lastTouchLocation = touchLocation
        
        ball.move(velocity: swipeVelocity)
        touchOffset(firstLocation: firstTouchLocation, lastLocation: lastTouchLocation)
        
        swings -= 1
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        // move(sprite: ball, velocity: swipeVelocity)
        
        swingsLabel.text = "Swings: \(swings)"
        
    }
    
    func win() {

        if currentLevel < 18 {
            levelProg[currentLevel] = true
            currentLevel += 1
            userDefaults.set(levelProg, forKey: "levelStatus")
//            transitionLevel(level: currentLevel)
        }
        transitionLevel(level: currentLevel)
    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        print("contact")
        print(String(contact.bodyA.categoryBitMask))
        print(String(contact.bodyB.categoryBitMask))
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Player | PhysicsCategory.Goal {
            print("Finish Level")
            win()
        }
        
        if collision == PhysicsCategory.Player | PhysicsCategory.collider {
            print("hit wall")
        }
    }
    
    func tile(in tileMap: SKTileMapNode,  at coordinates: TileCoordinates)
        -> SKTileDefinition? {
            return tileMap.tileDefinition(atColumn: coordinates.column,row: coordinates.row)
    }
 

//    func move(sprite: SKSpriteNode, velocity: CGPoint) {
//        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
//
//        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
//    }

    // parameters may change depending on the outcome
    func touchOffset(firstLocation: CGPoint, lastLocation: CGPoint) {

        let swipeVectorOffset = CGPoint(x: lastLocation.x - firstLocation.x, y: lastLocation.y - firstLocation.y)
        let swipeLength = sqrt(Double(swipeVectorOffset.x * swipeVectorOffset.x + swipeVectorOffset.y * swipeVectorOffset.y))
        let swipeDirection = (x: swipeVectorOffset.x / CGFloat(swipeLength), y: swipeVectorOffset.y / CGFloat(swipeLength))

        swipeVelocity = CGPoint(x: swipeDirection.x * ballSpeed, y: swipeDirection.y * ballSpeed)

        // ball.position = CGPoint(x: ball.position.x + swipeVelocity.x, y: ball.position.y + swipeVelocity.y)
    }
    

    func transitionLevel(level: Int) {
        guard let newLevel = SKScene(fileNamed: "Level\(level)") as? GameScene else {
            fatalError("Level \(level) not found")
        }
        newLevel.currentLevel = level
        newLevel.scaleMode = .aspectFit
        view?.presentScene(newLevel)
    }

}
