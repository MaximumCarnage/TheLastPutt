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

class GameScene: SKScene {
    
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
    var currentLevel: Int = 0
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
    }
    
    override func didMove(to view: SKView) {
//        print("Running")
//        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }

        //ball.position = CGPoint(x: 50, y: 50)
        ball.setScale(2.0)
        addChild(ball)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }

    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }

    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }

        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }

        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        lastTouchLocation = touchLocation
        touchOffset(firstLocation: firstTouchLocation, lastLocation: lastTouchLocation)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }

    }


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime

        //move(sprite: ball, velocity: swipeVelocity)


    }
    func tile(in tileMap: SKTileMapNode,  at coordinates: TileCoordinates)
        -> SKTileDefinition? {
            return tileMap.tileDefinition(atColumn: coordinates.column,row: coordinates.row)
    }
    func setupObstaclePhysics() {
        guard let obstaclesTileMap = obstaclesTileMap else { return }
        for row in 0..<obstaclesTileMap.numberOfRows {
            for column in 0..<obstaclesTileMap.numberOfColumns {
                // 2
                guard let tile = tile(in: obstaclesTileMap, at: (column, row))
                    else { continue }
                guard tile.userData?.object(forKey: "obstacle") != nil
                    else { continue }
                // 3
                let node = SKNode()
                node.physicsBody = SKPhysicsBody(rectangleOf: tile.size)
                node.physicsBody?.isDynamic = false
                node.physicsBody?.friction = 0
                node.position = obstaclesTileMap.centerOfTile(
                    atColumn: column, row: row)
                obstaclesTileMap.addChild(node)
            }
        }
    }

    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))

        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
    }

    // parameters may change depending on the outcome
    func touchOffset(firstLocation: CGPoint, lastLocation: CGPoint) {

        let swipeVectorOffset = CGPoint(x: lastLocation.x - firstLocation.x, y: lastLocation.y - firstLocation.y)
        let swipeLength = sqrt(Double(swipeVectorOffset.x * swipeVectorOffset.x + swipeVectorOffset.y * swipeVectorOffset.y))
        let swipeDirection = (x: swipeVectorOffset.x / CGFloat(swipeLength), y: swipeVectorOffset.y / CGFloat(swipeLength))

        swipeVelocity = CGPoint(x: swipeDirection.x * ballSpeed, y: swipeDirection.y * ballSpeed)

        // ball.position = CGPoint(x: ball.position.x + swipeVelocity.x, y: ball.position.y + swipeVelocity.y)
    }
    
//    func golfBounds() {
//        let leftRIghtBounds = CGPoint.zero
//        let topBottomBounds = CGPoint(x: size.width, y: size.height)
//
//        if ball.position.x <= topBottomBounds.x {
//            ball.position = topBottomBounds.x
//            velocity.x = -velocity.x
//        }
//    }
    
}
