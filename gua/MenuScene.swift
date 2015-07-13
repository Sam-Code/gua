//
//  GameScene.swift
//  gua
//
//  Created by Sam on 11/13/14.
//  Copyright (c) 2014 samcode. All rights reserved.
//

import SpriteKit
import AVFoundation

class MenuScene: SKScene, SKPhysicsContactDelegate {
    
    let vFondo = SKSpriteNode(imageNamed: "fondo")
    let vNave = SKSpriteNode(imageNamed: "cohete")
    
    let _alpha = 0.05;
    
    var recorder: AVAudioRecorder!
    var _timer = NSTimer()
    
    var sonidoResBajos = 0.0
    
    override func didMoveToView(view: SKView) {
        
        println("Inicia el juego...")
        
        vFondo.setScale(0.8)
        vFondo.position = CGPointMake(self.size.width/2, self.size.height/2)
        
        self.addChild(vFondo)
        
    }
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        var scene = JuegoScene(size: self.size)
        scene.scaleMode = .AspectFill
        
        self.view?.presentScene(scene, transition: SKTransition.doorsOpenHorizontalWithDuration(2.0))
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }

}



