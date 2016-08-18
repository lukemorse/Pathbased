//
//  IceCream.swift
//  pathBased
//
//  Created by Luke Morse on 8/18/16.
//  Copyright © 2016 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit

class IceCream: SKSpriteNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed: String) {
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: SKColor.whiteColor(), size: imageTexture.size())
        
        let body = SKPhysicsBody.init(rectangleOfSize: imageTexture.size())
        body.categoryBitMask = BodyType.iceCream.rawValue
        body.contactTestBitMask = BodyType.mouth.rawValue
        body.dynamic = false
        body.affectedByGravity = false
        
        self.physicsBody = body
        self.name = "iceCream"
        self.userInteractionEnabled = false
        self.setScale(0.06)
        
    }
    
    
}