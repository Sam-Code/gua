//
//  MenuScene.swift
//  gua
//
//  Created by Sam on 11/14/14.
//  Copyright (c) 2014 samcode. All rights reserved.
//

import SpriteKit
import AVFoundation


class JuegoScene: SKScene, SKPhysicsContactDelegate {
    
    let vFondo = SKSpriteNode(imageNamed: "fondo")
    let vNave = SKSpriteNode(imageNamed: "cohete")
    
    let _alpha = 0.05;
    
    var recorder: AVAudioRecorder!
    var _timer = NSTimer()
    
    var sonidoResBajos = 0.0
    
    override func didMoveToView(view: SKView) {
        
        //Configuracion grabacion
        var vConfGrabacion = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 320000,
            AVNumberOfChannelsKey: 1,
            AVSampleRateKey : 44100.0
        ]
        
        var vDirectorios = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var vDocDir: AnyObject = vDirectorios[0]
        
        var vURLArchivo = NSURL(fileURLWithPath: vDocDir.stringByAppendingPathComponent("tmpGrabacion.m4a"))
        
        var vError: NSError?
        
        recorder = AVAudioRecorder(URL: vURLArchivo!, settings: vConfGrabacion, error: &vError)
        
        if let e = vError {
            println(e.localizedDescription)
        } else {
            recorder.prepareToRecord()
            recorder.meteringEnabled = true
            recorder.record()
            _timer = NSTimer.scheduledTimerWithTimeInterval(
                0.03, target: self, selector: "analizaSonido:", userInfo: nil, repeats: true)
            
        }
        
        // Configurando gravedad
        self.physicsWorld.gravity = CGVectorMake( 0.0, -2.0 )
        self.physicsWorld.contactDelegate = self
        
        // Agregando fondo
        vFondo.setScale(0.8)
        vFondo.position = CGPointMake(self.size.width/2, self.size.height/2)
        
        self.addChild(vFondo)
        
        // Agregando nave
        vNave.xScale = 0.4; vNave.yScale = 0.4
        vNave.position =
            CGPointMake(self.size.width/2, vNave.size.height/2 + 20)
        
        self.addChild(vNave)
        
        // Agregando Nubes con movimiento
        let vNubes = SKTexture(imageNamed: "nubes")
        vNubes.filteringMode = .Nearest
        
        let moveGroundSprite = SKAction.moveByX(-vNubes.size().width * 2.0, y: 0, duration: NSTimeInterval(0.02 * vNubes.size().width * 2.0))
        let resetGroundSprite = SKAction.moveByX(vNubes.size().width * 2.0, y: 0, duration: 0.0)
        let moveGroundSpritesForever = SKAction.repeatActionForever(SKAction.sequence([moveGroundSprite,resetGroundSprite]))
        
        let sprite = SKSpriteNode(texture: vNubes)
        //sprite.setScale(0.5)
        sprite.position = CGPointMake(2 * sprite.size.width, self.frame.size.height - sprite.size.height)
        sprite.runAction(moveGroundSpritesForever)
        
        self.addChild(sprite)
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        var scene = JuegoScene(size: self.size)
        scene.scaleMode = .AspectFill
        
        self.view?.presentScene(scene, transition: SKTransition.doorsOpenHorizontalWithDuration(2.0))
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        println("\(vNave.position.y) valor \(vNave.size.height)")
        
        if ( (vNave.position.y - vNave.size.height) <= (-vNave.size.height + 60) ){
            vNave.physicsBody?.affectedByGravity = false
            vNave.physicsBody?.dynamic = false
            vNave.position = CGPointMake(self.size.width/2, vNave.size.height/2 + 20)
        }
        
        if ( (vNave.position.y - vNave.size.height) >= (self.size.height - vNave.size.height - 60) ){
            vNave.physicsBody?.affectedByGravity = false
            vNave.physicsBody?.dynamic = false
            vNave.physicsBody?.velocity = CGVectorMake(0, 0)
            _timer.invalidate()
            vNave.position = CGPointMake(self.size.width/2, vNave.size.height/2 + 20)
        }
        
    }
    
    func analizaSonido(timer:NSTimer!) {
        
        recorder.updateMeters()
        
        var vPPFC = pow(10.0,
            (0.05 * Double(recorder.peakPowerForChannel(0)) ));
        
        sonidoResBajos =
            (_alpha * vPPFC + (1.0 - _alpha) * sonidoResBajos)
        
        if (sonidoResBajos > 0.95){
            impulsarArriba(vNave,valImpulso: 80)
        }else{
            vNave.physicsBody?.velocity = CGVectorMake(0, -50)
        }
        
    }
    
    func impulsarArriba(spNode:SKSpriteNode, valImpulso:CGFloat){
        spNode.physicsBody = SKPhysicsBody(rectangleOfSize: spNode.size)
        spNode.physicsBody?.dynamic = true
        spNode.physicsBody?.velocity = CGVectorMake(0, 0)
        spNode.physicsBody?.applyImpulse(CGVectorMake(0, valImpulso))
    }

    
}