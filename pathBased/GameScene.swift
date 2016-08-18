//
//  GameScene.swift
//  pathBased
//
//  Created by Luke Morse on 8/11/16.
//  Copyright (c) 2016 Luke Morse. All rights reserved.
//

import SpriteKit


enum BodyType:UInt32 {
    case iceCream = 1
    case mouth = 2
    case redSquare = 4
    case spike = 8
    case hole = 16
    case toothbrush = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0
    var mouth: Mouth?
    var iceCream: IceCream?
    var redSquare: RedSquare?
    
    var mouthShootAnimation: SKAction?
    let tapRecognizer = UITapGestureRecognizer()
    
//    let iceCreamCategory:UInt32 = 0x1 << 0
//    let mouthCategory:UInt32 = 0x1 << 1
    
    var backgroundMusic: SKAudioNode!
    var highHatSound: SKAudioNode!
    var coinSound: SKAudioNode!
    var thereAreNoMouths = true
    
    override func didMoveToView(view: SKView) {
        
        self.anchorPoint = CGPointMake(0.0, 0.0)
        self.backgroundColor = SKColor.blackColor()
        physicsWorld.contactDelegate = self
        
        
        setUpAnimation()
        
        createIceCream()
        
        if let musicURL = NSBundle.mainBundle().URLForResource("background", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(URL: musicURL)
            addChild(backgroundMusic)
        }
        
        tapRecognizer.addTarget(self, action:#selector(GameScene.shootMouth(_:)))
        self.view!.addGestureRecognizer(tapRecognizer)
    }
    
    
//    func initPhysics() {
//        physicsWorld.contactDelegate = self
////        self.physicsWorld.gravity = CGVector.zero
//        
//    }
    
    func createIceCream() {
        
        iceCream = IceCream(imageNamed: "ice cream")
        
        let RandW = CGFloat(Int(rand()) % Int(self.view!.bounds.width))
        let RandH = CGFloat(Int(rand()) % Int(self.view!.bounds.height))
        let initPos = CGPointMake(RandW,RandH)
        
        addChild(iceCream!)
        iceCream!.position = initPos
        
        moveIceCream(initPos)
        
    }
    
    func moveIceCream(initPos:CGPoint) {
        
        var randomPoints:Array = generateFourRandomPoints()
        randomPoints.insert(initPos, atIndex: 0)
        
        let times = generateTimes(randomPoints)
        
        let point2 = randomPoints[1], point3 = randomPoints[2], point4 = randomPoints[3], point5 = randomPoints[4]
        
        let time1 = times[0], time2 = times[1], time3 = times[2], time4 = times[3], time5 = times[4]
        
        let move1 = SKAction.moveTo(point2, duration: NSTimeInterval(time1))
        let move2 = SKAction.moveTo(point3, duration: NSTimeInterval(time2))
        let move3 = SKAction.moveTo(point4, duration: NSTimeInterval(time3))
        let move4 = SKAction.moveTo(point5, duration: NSTimeInterval(time4))
        let move5 = SKAction.moveTo(initPos, duration: NSTimeInterval(time5))
        
        
//        print(randomPoints)
//        print(times)
        
        
        let seq = SKAction.sequence([move1, move2, move3, move4, move5])
        iceCream!.runAction(SKAction.repeatActionForever(seq))
        
    }
    
    
    func generateTimes(points: [CGPoint]) -> [Float] {
        
        let xDiff1 = abs(points[1].x - points[0].x)
        let yDiff1 = abs(points[1].y - points[0].y)
        let time1 = Float(sqrt(pow(xDiff1, 2) + pow(yDiff1, 2)) / 200)
        
        let xDiff2 = abs(points[2].x - points[1].x)
        let yDiff2 = abs(points[2].y - points[1].y)
        let time2 = Float(sqrt(pow(xDiff2, 2) + pow(yDiff2, 2)) / 200)
        
        let xDiff3 = abs(points[3].x - points[2].x)
        let yDiff3 = abs(points[3].y - points[2].y)
        let time3 = Float(sqrt(pow(xDiff3, 2) + pow(yDiff3, 2)) / 200)
        
        let xDiff4 = abs(points[4].x - points[3].x)
        let yDiff4 = abs(points[4].y - points[3].y)
        let time4 = Float(sqrt(pow(xDiff4, 2) + pow(yDiff4, 2)) / 200)
        
        let xDiff5 = abs(points[0].x - points[4].x)
        let yDiff5 = abs(points[0].y - points[4].y)
        let time5 = Float(sqrt(pow(xDiff5, 2) + pow(yDiff5, 2)) / 200)
        
        return [time1, time2, time3, time4, time5]
        
    }
    
    
    func generateFourRandomPoints() -> [CGPoint] {
        
        let widthMax = self.view!.bounds.width - 10
        let heightMax = self.view!.bounds.height / 2
        
        let RandW1 = CGFloat(Int(rand()) % Int(widthMax)) + CGFloat(5)
        let RandH1 = CGFloat(Int(rand()) % Int(heightMax)) + heightMax
        let point1 = CGPoint(x: RandW1, y: RandH1)
        
        let RandW2 = CGFloat(Int(rand()) % Int(widthMax)) + CGFloat(5)
        let RandH2 = CGFloat(Int(rand()) % Int(heightMax)) + heightMax
        let point2 = CGPoint(x: RandW2, y: RandH2)
        
        let RandW3 = CGFloat(Int(rand()) % Int(widthMax)) + CGFloat(5)
        let RandH3 = CGFloat(Int(rand()) % Int(heightMax)) + heightMax
        let point3 = CGPoint(x: RandW3, y: RandH3)
        
        let RandW4 = CGFloat(Int(rand()) % Int(widthMax)) + CGFloat(5)
        let RandH4 = CGFloat(Int(rand()) % Int(heightMax)) + heightMax
        let point4 = CGPoint(x: RandW4, y: RandH4)
        
        return [point1, point2, point3, point4]
    }
    
    
    func setUpAnimation() {
        
        let atlas = SKTextureAtlas (named: "mouth")
        
        var array = [String]()
        
        for i in 1 ... 7 {
            
            let nameString = String(format: "mouth%i", i)
            array.append(nameString)
            
        }
        
        //create another array this time with SKTexture as the type (textures being the .png images)
        var atlasTextures:[SKTexture] = []
        
        for i in 0 ..< array.count {
            
            let texture:SKTexture = atlas.textureNamed( array[i] )
            atlasTextures.insert(texture, atIndex:i)
            
        }
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/30, resize: false , restore:false )
        
        mouthShootAnimation =  SKAction.repeatActionForever(atlasAnimation)
        
    }
    
    
    
    func shootMouth(sender:UITapGestureRecognizer) {
        
        if thereAreNoMouths {
            
            thereAreNoMouths = false
            
            var tapLocation = sender.locationInView(sender.view)
            tapLocation = self.convertPointToView(tapLocation)
            
            mouth = Mouth(imageNamed: "mouth1")
            addChild(mouth!)
            mouth!.position = CGPoint(x: self.view!.bounds.width / 2, y: 0)
            
            let shootAction = SKAction.moveTo(tapLocation, duration: 1.0)
            let wait = SKAction.waitForDuration(1.0)
            let remove = SKAction.runBlock {self.mouth!.removeFromParent()}
            let resetMouthBool = SKAction.runBlock {self.thereAreNoMouths = true}
            
            if let soundURL = NSBundle.mainBundle().URLForResource("highHatRoll", withExtension: "mp3") {
                highHatSound = SKAudioNode(URL: soundURL)
                addChild(highHatSound)
            }
            removeSound(highHatSound, waitTime: 1.0)
            
            mouth!.runAction(mouthShootAnimation!)
            let seq = SKAction.sequence([shootAction, remove])
            mouth!.runAction(seq)
            
            let seq2 = SKAction.sequence([wait, resetMouthBool])
            self.runAction(seq2)
            //        mouth!.runAction(shootAction)
            //        mouth!.runAction(mouthShootAnimation!)
            
        }
    }
    
    
    func removeSound(sound:SKAudioNode, waitTime: NSTimeInterval) -> () {
        
        let removeSound = SKAction.runBlock {sound.removeFromParent()}
        let wait = SKAction.waitForDuration(waitTime)
        runAction(SKAction.sequence([wait,removeSound]))
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        
        
        if (contact.bodyA.categoryBitMask == BodyType.iceCream.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.mouth.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.mouth.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.iceCream.rawValue){
            
            let contactPoint = contact.contactPoint
            
            score += 1
            
            // EXPLOSION //
            
            if let explosion1 = SKEmitterNode(fileNamed: "Explosion.sks"),
                let explosion2 = SKEmitterNode(fileNamed: "Explosion.sks"),
                let explosion3 = SKEmitterNode(fileNamed: "Explosion.sks") {
                
                let greenSprinkleBundlePath = NSBundle.mainBundle().pathForResource("greenSprinkle", ofType: "png")
                let yellowSprinkleBundlePath = NSBundle.mainBundle().pathForResource("yellowSprinkle", ofType: "png")
                
                let greenSprinkle = UIImage(contentsOfFile: greenSprinkleBundlePath!)
                let yellowSprinkle = UIImage(contentsOfFile: yellowSprinkleBundlePath!)
                
                explosion2.particleTexture = SKTexture.init(image: greenSprinkle!)
                explosion3.particleTexture = SKTexture.init(image: yellowSprinkle!)
                
                explosion1.position = contactPoint
                explosion2.position = contactPoint
                explosion3.position = contactPoint
                
                iceCream!.removeAllActions()
                iceCream!.removeFromParent()
                
                mouth!.removeAllActions()
                mouth!.removeFromParent()
                removeSound(highHatSound, waitTime: 0.0)
                
                if let soundURL = NSBundle.mainBundle().URLForResource("coin", withExtension: "mp3") {
                    coinSound = SKAudioNode(URL: soundURL)
                    addChild(coinSound)
                }
                removeSound(coinSound, waitTime: 1)
                
                self.addChild(explosion1)
                self.addChild(explosion2)
                self.addChild(explosion3)
                
                let removeExplotion = SKAction.runBlock({
                    explosion1.removeFromParent()
                    explosion2.removeFromParent()
                    explosion3.removeFromParent()
                })
                
                let wait = SKAction.waitForDuration(1)
                
                
                explosion1.runAction(SKAction.sequence([wait, removeExplotion]))
                explosion2.runAction(SKAction.sequence([wait, removeExplotion]))
                explosion3.runAction(SKAction.sequence([wait, removeExplotion]))
                
                if score == 10 {
                    
                    createRedSquare()
                    self.createIceCream()
                    
                } else {
                    self.createIceCream()
                }
                
            }
            
            //  END EXPLOSION //
            
        }
        
    }
    
    func createRedSquare() {
        
        redSquare = RedSquare(imageNamed: "red square")
        
//        let RandW = CGFloat(Int(rand()) % Int(self.view!.bounds.width))
//        let RandH = CGFloat(Int(rand()) % Int(self.view!.bounds.height))
//        let initPos = CGPointMake(RandW,RandH)
        
        addChild(redSquare!)
        let position = CGPoint(x: size.width / 2, y: size.height / 2)
        redSquare!.position = position
    }
    
    func winLabel() {
        
        let label = SKLabelNode.init(text: "YOU WIN!")
        label.color = SKColor.redColor()
        label.horizontalAlignmentMode = .Center
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
