//
//  Gameoverscene.swift
//  NightBallGame
//
//  Created by Jeffrey Zhang on 2017-08-28.
//  Copyright © 2017 Keener Studio. All rights reserved.
//
import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, won:Bool, score: Int) {
        
        super.init(size: size)
        
        // 1
        backgroundColor = SKColor.white
        
        // 2
        let message = won ? "You Won!" : "You Lose :["
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        
        // Display Score
        let label2 = SKLabelNode(fontNamed: "Chalkduster")
             label2.text = "Points = " + String(score)
             label2.fontSize = 20
             label2.fontColor = SKColor.black
             label2.position = CGPoint(x: size.width/2, y: size.height/3)
             addChild(label2)
        // 4
        run(SKAction.sequence([
            SKAction.wait(forDuration: 3.0),
            SKAction.run() {
                // 5
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
