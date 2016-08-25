//
//  Mouth.swift
//  pathBased
//
//  Created by Luke Morse on 8/18/16.
//  Copyright © 2016 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit

protocol SpriteOffScreenDelegate {
    func spriteOffScrene()
}

class Mouth:SKSpriteNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: SKColor.whiteColor(), size: imageTexture.size())
        
        zPosition = 2
        
        let body = SKPhysicsBody.init(rectangleOfSize: imageTexture.size())
        body.categoryBitMask = BodyType.mouth.rawValue
        body.contactTestBitMask = BodyType.iceCream.rawValue | BodyType.redSquare.rawValue
        body.collisionBitMask = BodyType.redSquare.rawValue
        body.affectedByGravity = false
        body.density = 5.0
        
        self.physicsBody = body
        self.name = "mouth"
        self.userInteractionEnabled = false
        self.setScale(0.11)
    }
    
    
}