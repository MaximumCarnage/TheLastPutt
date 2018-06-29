//
//  BallNode.swift
//  TheLastPutt
//
//  Created by John Paulo Abellanosa on 2018-06-28.
//  Copyright © 2018 Dean,Dylan,JP,Mark. All rights reserved.
//
//
import Foundation
import SpriteKit


class BallNode: SKScene {
    
    var ball = SKSpriteNode(imageNamed: "ball_generic1")
    // TODO: placeholders at the moment
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    
    var ballSpeed: CGFloat = 280.0
    var velocity = CGPoint.zero
    var swipeVelocity = CGPoint.zero
    var firstTouchLocation = CGPoint.zero
    var lastTouchLocation = CGPoint.zero
    var ballSelected: Bool = false
    
    override func didMove(to view: SKView) {
        // let ball = SKSpriteNode(imageNamed: "ball_generic1")
        // ballNode = childNode(withName: "golf_ball") as! BallNode
        
        ball.position = CGPoint(x: 0, y: 0)
        ball.setScale(2.0)
        addChild(ball)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        move(sprite: ball, velocity: swipeVelocity)
    }
    
    func move(sprite: SKSpriteNode, velocity: CGPoint) {
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
    }
    
    // parameters may change depending on the outcome
    func touchOffset(firstLocation: CGPoint, lastLocation: CGPoint) {
        
        // Theory: create a velocity between the two touch points,
        // then apply that velocity then add to the ball position
        // making them act parallel
        let swipeVectorOffset = CGPoint(x: lastLocation.x - firstLocation.x, y: lastLocation.y - firstLocation.y)
        let swipeLength = sqrt(Double(swipeVectorOffset.x * swipeVectorOffset.x + swipeVectorOffset.y * swipeVectorOffset.y))
        let swipeDirection = (x: swipeVectorOffset.x / CGFloat(swipeLength), y: swipeVectorOffset.y / CGFloat(swipeLength))
        
        swipeVelocity = CGPoint(x: swipeDirection.x * ballSpeed, y: swipeDirection.y * ballSpeed)
        
        //        ball.position = CGPoint(x: ball.position.x + swipeVelocity.x, y: ball.position.y + swipeVelocity.y)
    }
    
    //    func sceneTouched(firstTouch: CGPoint, lastTouch: CGPoint) {
    //        touchOffset(firstLocation: firstTouch, lastLocation: lastTouch)
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
}
