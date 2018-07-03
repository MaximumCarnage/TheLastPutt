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
        //ball.position = CGPoint(x: 50, y: 50)
        ball.setScale(2.0)
        addChild(ball)
        
        // setupWorldPhysics()
        
    }
    
//    func setupWorldPhysics() {
//        background.physicsBody = SKPhysicsBody(edgeLoopFrom: background.frame)
//    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                // the ball has been selected
                // find out where the finger has landed
        
        
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
        
        
        touchOffset(firstLocation: firstTouchLocation, lastLocation: lastTouchLocation)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        
        ball.move(velocity: swipeVelocity)
        // move(sprite: ball, velocity: swipeVelocity)


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
