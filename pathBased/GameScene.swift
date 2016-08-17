//
//  GameScene.swift
//  pathBased
//
//  Created by Luke Morse on 8/11/16.
//  Copyright (c) 2016 Luke Morse. All rights reserved.
//

import SpriteKit

var aksheeOnay: SKAction?
var score = 0
var mouth: SKSpriteNode?
var iceCream: SKSpriteNode?

var mouthShootAnimation: SKAction?
let tapRecognizer = UITapGestureRecognizer()

let iceCreamCategory:UInt32 = 0x1 << 0
let mouthCategory:UInt32 = 0x1 << 1

var backgroundMusic: SKAudioNode!
var highHatSound: SKAudioNode!
var coinSound: SKAudioNode!

class GameScene: SKScene, SKPhysicsContactDelegate {
    
//    let playBackgroundMusic = SKAction.playSoundFileNamed("background", waitForCompletion: true)
//    let playHighHat = SKAction.playSoundFileNamed("highHatRoll", waitForCompletion: true)
//    let playCoin = SKAction.playSoundFileNamed("coin", waitForCompletion: true)
    
    override func didMoveToView(view: SKView) {
        
        self.anchorPoint = CGPointMake(0.0, 0.0)
        self.backgroundColor = SKColor.blackColor()
        
        mouth?.physicsBody?.contactTestBitMask = mouthCategory
        iceCream?.physicsBody?.contactTestBitMask = iceCreamCategory
        
        setUpAnimation()
        
        createEnemy()
        
        initPhysics()
        
        if let musicURL = NSBundle.mainBundle().URLForResource("background", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(URL: musicURL)
            addChild(backgroundMusic)
        }
            
        
        
        tapRecognizer.addTarget(self, action:#selector(GameScene.shootMouth(_:)))
        self.view!.addGestureRecognizer(tapRecognizer)
    }
    
    func initPhysics() {
        physicsWorld.contactDelegate = self
//        self.physicsWorld.gravity = CGVector.zero
        
    }
    
    func createEnemy() {
        
        iceCream = SKSpriteNode(imageNamed: "ice cream")
        iceCream!.name = "iceCream"
        iceCream!.userInteractionEnabled = false
        iceCream!.setScale(0.08)
        iceCream!.physicsBody = SKPhysicsBody.init(rectangleOfSize: iceCream!.size)
        iceCream!.physicsBody!.contactTestBitMask = 0x00000000
        
        let RandW = CGFloat(Int(rand()) % Int(self.view!.bounds.width))
        let RandH = CGFloat(Int(rand()) % Int(self.view!.bounds.height))
        
        iceCream!.position = CGPointMake(RandW,RandH)
        addChild(iceCream!)
        
        let randomPoints = generateFourRandomPoints()
        let times = generateTimes(randomPoints)
        
        let point1 = randomPoints[0], point2 = randomPoints[1], point3 = randomPoints[2], point4 = randomPoints[3]
        
        let time1 = times[0], time2 = times[1], time3 = times[2], time4 = times[3]
        
        let move1 = SKAction.moveTo(point1, duration: NSTimeInterval(time1))
        let move2 = SKAction.moveTo(point2, duration: NSTimeInterval(time2))
        let move3 = SKAction.moveTo(point3, duration: NSTimeInterval(time3))
        let move4 = SKAction.moveTo(point4, duration: NSTimeInterval(time4))
        
        
        let seq = SKAction.sequence([move1, move2, move3, move4])
        iceCream!.runAction(SKAction.repeatActionForever(seq))
        
    }
    
    
    func generateTimes(points: [CGPoint]) -> [Float] {
        
        let xDiff1 = abs(points[1].x - points[0].x)
        let yDiff1 = abs(points[1].y - points[0].y)
        let distance1 = Float(sqrt(pow(xDiff1, 2) + pow(yDiff1, 2)) / 200)
        
        let xDiff2 = abs(points[2].x - points[1].x)
        let yDiff2 = abs(points[2].y - points[1].y)
        let distance2 = Float(sqrt(pow(xDiff2, 2) + pow(yDiff2, 2)) / 200)
        
        let xDiff3 = abs(points[3].x - points[2].x)
        let yDiff3 = abs(points[3].y - points[2].y)
        let distance3 = Float(sqrt(pow(xDiff3, 2) + pow(yDiff3, 2)) / 200)
        
        let xDiff4 = abs(points[0].x - points[3].x)
        let yDiff4 = abs(points[0].y - points[3].y)
        let distance4 = Float(sqrt(pow(xDiff4, 2) + pow(yDiff4, 2)) / 200)
        
        return [distance1, distance2, distance3, distance4]
        
    }
    
    
    func generateFourRandomPoints() -> [CGPoint] {
        
        let RandW1 = CGFloat(Int(rand()) % Int(self.view!.bounds.width))
        let RandH1 = CGFloat(Int(rand()) % Int(self.view!.bounds.height))
        let point1 = CGPoint(x: RandW1, y: RandH1)
        
        let RandW2 = CGFloat(Int(rand()) % Int(self.view!.bounds.width))
        let RandH2 = CGFloat(Int(rand()) % Int(self.view!.bounds.height))
        let point2 = CGPoint(x: RandW2, y: RandH2)
        
        let RandW3 = CGFloat(Int(rand()) % Int(self.view!.bounds.width))
        let RandH3 = CGFloat(Int(rand()) % Int(self.view!.bounds.height))
        let point3 = CGPoint(x: RandW3, y: RandH3)
        
        let RandW4 = CGFloat(Int(rand()) % Int(self.view!.bounds.width))
        let RandH4 = CGFloat(Int(rand()) % Int(self.view!.bounds.height))
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
        
        let atlasAnimation = SKAction.animateWithTextures(atlasTextures, timePerFrame: 1.0/30, resize: true , restore:false )
        
        mouthShootAnimation =  SKAction.repeatAction(atlasAnimation, count:3)
        
    }
    
    
    
    func shootMouth(sender:UITapGestureRecognizer) {
        
//        if sender.state == .
        var tapLocation: CGPoint = sender.locationInView(sender.view)
        tapLocation = self.convertPointToView(tapLocation)
        mouth = SKSpriteNode(imageNamed: "mouth1")
        mouth!.position = CGPoint(x: self.view!.bounds.width / 2, y: 0)
        mouth!.setScale(0.15)
        
        mouth!.physicsBody = SKPhysicsBody.init(rectangleOfSize: mouth!.size)
        mouth!.physicsBody!.contactTestBitMask = 0x00000001
        
        addChild(mouth!)
        
        let shootAction = SKAction.moveTo(tapLocation, duration: 1.0)
        let wait = SKAction.waitForDuration(1.0)
        let remove = SKAction.runBlock { 
            mouth!.removeFromParent()
        }
        
        if let soundURL = NSBundle.mainBundle().URLForResource("highHatRoll", withExtension: "mp3") {
            highHatSound = SKAudioNode(URL: soundURL)
            addChild(highHatSound)
        }
        removeSound(highHatSound, waitTime: 1.0)
        
        mouth!.runAction(SKAction.sequence([shootAction,mouthShootAnimation!,wait,remove]))
//        mouth!.runAction(shootAction)
//        mouth!.runAction(mouthShootAnimation!)
        
        
    }
    
    
    func removeSound(sound:SKAudioNode, waitTime: NSTimeInterval) -> () {
        
        let removeSound = SKAction.runBlock {sound.removeFromParent()}
        let wait = SKAction.waitForDuration(waitTime)
        runAction(SKAction.sequence([wait,removeSound]))
    }
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        print("contact")
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
                
                explosion1.position = iceCream!.position
                explosion2.position = iceCream!.position
                explosion3.position = iceCream!.position
                
                iceCream!.removeAllActions()
                iceCream!.hidden = true
                iceCream!.removeFromParent()
                
                mouth!.removeAllActions()
                mouth!.hidden = true
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
                
                if score >= 10 {
                    self.winLabel()
                } else {
                    self.createEnemy()
                }
                
            }
            
            //  END EXPLOSION //
        
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
