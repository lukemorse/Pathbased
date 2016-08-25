//
//  RedSquare.swift
//  pathBased
//
//  Created by Luke Morse on 8/18/16.
//  Copyright © 2016 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit

class RedSquare:SKSpriteNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: SKColor.whiteColor(), size: imageTexture.size())
        
        let body = SKPhysicsBody.init(rectangleOfSize: imageTexture.size())
        
        body.categoryBitMask = BodyType.redSquare.rawValue
//        body.contactTestBitMask = BodyType.mouth.rawValue
        body.collisionBitMask = BodyType.mouth.rawValue
        
        body.affectedByGravity = false
        body.dynamic = false
        body.mass = 1000
        
        self.physicsBody = body
        self.name = "redSquare"
        self.userInteractionEnabled = false
        self.setScale(0.9)
    }
    
}