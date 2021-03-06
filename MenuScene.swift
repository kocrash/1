//
//  MenuScene.swift
//  NightBallGame
//
//  Created by Jeffrey Zhang on 2017-08-30.
//  Copyright © 2017 Keener Studio. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameplayKit
import GameKit
import SwiftyStoreKit
import StoreKit

var sharedSecret = "f7bf998ad4774783b94f943942a8ee46"

class NetworkActivityIndicatorManage: NSObject{
    private static var loadingCount = 0
    
    class func NetworkOperationStarted(){
        if(loadingCount == 0){
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
    }
    
    class func networkOperationFinished(){
        if loadingCount > 0 {
            loadingCount -= 1
        }
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
class MenuScene: SKScene,GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    // Access global AppDelegate
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //Scale Factor
    let iPhone5sScreenHeight:CGFloat = 568
    let iPhone5sScreenWidth:CGFloat = 320
    // Music
    var AudioPlayer3 = AVAudioPlayer()
    
    // Music for Gamescene
    var AudioPlayer1 = AVAudioPlayer()
    var AudioPlayer2 = AVAudioPlayer()
    var AudioPlayer4 = AVAudioPlayer()
    
    // Play button image
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "Playbutton")
    let midnightPlayButtonTex = SKTexture(imageNamed: "MidnightPlayButton")
    var modeButton = SKSpriteNode()
    let modeTex = SKTexture(image: #imageLiteral(resourceName: "Mode"))
    let mode2Tex = SKTexture(image: #imageLiteral(resourceName: "Mode2"))
    let lockIcon:SKSpriteNode = SKSpriteNode(imageNamed: "LockIcon")
    let restoreIcon: SKSpriteNode = SKSpriteNode(imageNamed: "RestoreIcon")
    let shoppingCartIcon:SKSpriteNode = SKSpriteNode(imageNamed: "ShoppingCart")
    var midnightOn: Bool = false
    var soundIcon = SKSpriteNode()
    let soundIconTex = SKTexture(imageNamed: "SoundIcon")
    let SoundmuteTex = SKTexture (imageNamed: "Soundmute")
    var lockIconExists:Bool = true
    let bundleID = "com.keener.nightball.midnightPurchase"    
    let leaderboard: SKSpriteNode = SKSpriteNode(imageNamed:"Leaderboard")
    let title: SKSpriteNode = SKSpriteNode(imageNamed: "moonhouseNightBallTitle")
    let fade1: SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground1")
    let fade2: SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground2")
    let fade3: SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground3")
    let fade4: SKSpriteNode = SKSpriteNode(imageNamed: "StarBackground4")
    let menuBackground: SKSpriteNode = SKSpriteNode(imageNamed: "MenuBackgroundNew")
    
    init(size:CGSize, shouldLockIconShow: Bool,shouldVerifyPurchase: Bool) {
        super.init(size: size)
        if(shouldLockIconShow && shouldVerifyPurchase){
            lockIcon.alpha = 0.7
            self.insertSKSpriteNode(object: lockIcon, positionWidth: self.size.width * 0.2, positionHeight: self.size.height * 0.73, scaleWidth: self.size.width * 0.09, scaleHeight: self.size.width * 0.09, zPosition: 5)
            verifyPurchase()
        }else if (shouldLockIconShow){
            lockIcon.alpha = 0.7
            self.insertSKSpriteNode(object: lockIcon, positionWidth: self.size.width * 0.2, positionHeight: self.size.height * 0.73, scaleWidth: self.size.width * 0.09, scaleHeight: self.size.width * 0.09, zPosition: 5)
            isMidnightModeEnabled()
        }else{
            isMidnightModeEnabled()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {

        var soundIconHeightScale:CGFloat = size.height * 0.048
        var leaderboardIconHeightScale:CGFloat = size.height * 0.06
        var shoppingCartIconHeightScale:CGFloat = size.height * 0.063
        var restoreIconHeightScale:CGFloat = size.height * 0.065
        var titleHeightScale:CGFloat = size.height * 0.13
        var bottomIconHeightPosition:CGFloat = size.height * 0.12
        var soundIconHeightPosition:CGFloat = size.height * 0.112
        if(UIScreen.main.bounds.height == 812){
            soundIconHeightPosition = size.height * 0.116
            soundIconHeightScale = size.height * 0.042
            leaderboardIconHeightScale = size.height * 0.053
            shoppingCartIconHeightScale = size.height * 0.055
            restoreIconHeightScale = size.height * 0.057
            titleHeightScale = size.height * 0.11
            bottomIconHeightPosition = size.height * 0.123
        }
        // Add Background
        menuBackground.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        menuBackground.size = self.frame.size;
        menuBackground.zPosition = -6
        self.addChild(menuBackground)
        
        // Insert Title
        insertSKSpriteNode(object: title, positionWidth: size.width * 0.5, positionHeight: size.height * 0.88,scaleWidth:size.width * 0.8,scaleHeight: titleHeightScale, zPosition: 1)

        // Insert change mode button
        modeButton = SKSpriteNode(texture: modeTex)
        insertSKSpriteNode(object: modeButton, positionWidth: size.width * 0.2, positionHeight: size.height * 0.73, scaleWidth: size.width * 0.28, scaleHeight: size.width * 0.17, zPosition: 4)
        
        //Insert Shopping Cart Icon
        insertSKSpriteNode(object: shoppingCartIcon, positionWidth: size.width * 0.61, positionHeight: bottomIconHeightPosition, scaleWidth: size.width * 0.12, scaleHeight: shoppingCartIconHeightScale, zPosition: 4)
        
        //Insert Restore Icon
        insertSKSpriteNode(object: restoreIcon, positionWidth: size.width * 0.83, positionHeight: bottomIconHeightPosition, scaleWidth: size.width * 0.12, scaleHeight: restoreIconHeightScale, zPosition: 4)
        
        // Insert Play button
        playButton = SKSpriteNode(texture: playButtonTex)
        insertSKSpriteNode(object: playButton, positionWidth:frame.midX, positionHeight:frame.midY, scaleWidth:size.width * 0.6, scaleHeight: size.width * 0.6, zPosition: 4)
        
        // Insert Leaderboard button
        insertSKSpriteNode(object: leaderboard, positionWidth: size.width * 0.39, positionHeight: bottomIconHeightPosition, scaleWidth:size.width * 0.11, scaleHeight: leaderboardIconHeightScale, zPosition: 4)
       
        let  ismuted = appDelegate.ismuted
        
        if ismuted! {
            // Add Muted Icon
            soundIcon = SKSpriteNode(texture: SoundmuteTex)
            insertSKSpriteNode(object: soundIcon, positionWidth:size.width * 0.17, positionHeight: soundIconHeightPosition,scaleWidth: size.width * 0.13,scaleHeight: soundIconHeightScale, zPosition: 4)
        } else {
            // Add Sound Icon
            soundIcon = SKSpriteNode(texture: soundIconTex)
            insertSKSpriteNode(object: soundIcon, positionWidth: size.width * 0.17, positionHeight:soundIconHeightPosition,scaleWidth:size.width * 0.13,scaleHeight: soundIconHeightScale, zPosition: 4)
        }

        // Star backgrounds
        animateFade(fade: fade1, delay: 2, duration: 1.7, startingAlpha: 1, width: size.width * 0.8, height: size.height * 0.8,positionWidth: size.width * 0.3,positionHeight: size.height * 0.7)
        animateFade(fade: fade2, delay: 0, duration: 5.7, startingAlpha: 0.3, width: size.width * 0.8, height: size.height * 0.8,positionWidth: size.width * 0.7,positionHeight: size.height * 0.7)
        animateFade(fade: fade3, delay: 1, duration: 2.6, startingAlpha: 0.7, width: size.width * 0.8, height: size.height * 0.8,positionWidth: size.width * 0.3,positionHeight: size.height * 0.3)
        animateFade(fade: fade4, delay: 0, duration: 3.2, startingAlpha: 0.1, width: size.width * 0.8, height: size.height * 0.8,positionWidth: size.width * 0.7,positionHeight: size.height * 0.3)
        
        // Add Music
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "Hypnothis", ofType: "mp3")!)
        AudioPlayer3 = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer3.prepareToPlay()
        AudioPlayer3.numberOfLoops = -1
        
        if !ismuted! {
            AudioPlayer3.play()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var soundIconHeightScale = size.height * 0.048
        var soundIconHeightPosition = size.height * 0.112

        if(UIScreen.main.bounds.height == 812) {
            soundIconHeightScale = size.height * 0.042
            soundIconHeightPosition = size.height * 0.116
        }
        // If the play button is touched enter game scene
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                if view != nil {
                    let fadeOutAction = SKAction.fadeOut(withDuration: 5)
                    playButton.run(fadeOutAction)
                    let transition:SKTransition = SKTransition.crossFade(withDuration: 2)
                    AudioPlayer3.stop()
                    if midnightOn {
                        let scene:SKScene = MidnightGameScene(size: self.size,audio: !AudioPlayer3.isPlaying,shouldLockIconShow: !lockIcon.isHidden)
                        self.view?.presentScene(scene, transition: transition)
                    } else {
                        let scene:SKScene = GameScene(size: self.size,audio: !AudioPlayer3.isPlaying,shouldLockIconShow: !lockIcon.isHidden)
                        self.view?.presentScene(scene, transition: transition)
                    }
                }
            }
            
            if (node == modeButton && (lockIcon.isHidden || !lockIconExists)){
                modeButton.removeFromParent()
                playButton.removeFromParent()
                if midnightOn {
                    modeButton = SKSpriteNode(texture: modeTex)
                    insertSKSpriteNode(object: modeButton, positionWidth: size.width * 0.2, positionHeight: size.height * 0.73, scaleWidth: size.width * 0.28, scaleHeight: size.width * 0.17, zPosition: 4)
                    playButton = SKSpriteNode(texture: playButtonTex)
                    insertSKSpriteNode(object: playButton, positionWidth:frame.midX, positionHeight:frame.midY, scaleWidth:size.width * 0.6, scaleHeight: size.width * 0.6, zPosition: 4)
                    midnightOn = false
                } else {
                    modeButton = SKSpriteNode(texture: mode2Tex)
                    insertSKSpriteNode(object: modeButton, positionWidth: size.width * 0.2, positionHeight: size.height * 0.73, scaleWidth: size.width * 0.28, scaleHeight: size.width * 0.17, zPosition: 4)
                    playButton = SKSpriteNode(texture: midnightPlayButtonTex)
                    insertSKSpriteNode(object: playButton, positionWidth:frame.midX, positionHeight:frame.midY, scaleWidth:size.width * 0.6, scaleHeight: size.width * 0.6, zPosition: 4)
                    midnightOn = true
                }
            }
            
            if(node == lockIcon){
                fadeInGameModeLockedLabel()
            }
            
            if node == soundIcon {
                // retrieve ismuted bool from global AppDelegate
                let ismuted = appDelegate.ismuted
                // Remove Mute Sound Icon
                soundIcon.removeFromParent()
                if ismuted! {
                    // Replace Mute Sound Icon with Sound Icon
                    soundIcon = SKSpriteNode(texture: soundIconTex)
                    insertSKSpriteNode(object: soundIcon, positionWidth: size.width * 0.17, positionHeight:soundIconHeightPosition,scaleWidth:size.width * 0.13,scaleHeight: soundIconHeightScale, zPosition: 4)
                    appDelegate.ismuted = false
                    AudioPlayer3.play()
                } else {
                    //Add Mute Sound Icon
                    soundIcon = SKSpriteNode(texture: SoundmuteTex)
                    insertSKSpriteNode(object: soundIcon, positionWidth: size.width * 0.17, positionHeight:soundIconHeightPosition,scaleWidth:size.width * 0.13,scaleHeight: soundIconHeightScale, zPosition: 4)
                    appDelegate.ismuted = true
                    AudioPlayer3.pause()
                }
            }
            if node == leaderboard {
                showLeader()
            }
            if node == shoppingCartIcon{
                purchase()
            }
            if node == restoreIcon{
                restorePurchases()
            }
        }
    }
    
    func insertSKSpriteNode(object: SKSpriteNode, positionWidth: CGFloat, positionHeight: CGFloat,scaleWidth: CGFloat,scaleHeight: CGFloat, zPosition: CGFloat) {
        object.position = CGPoint(x:positionWidth, y: positionHeight)
        object.scale(to: CGSize(width:scaleWidth, height:scaleHeight))
        object.zPosition = zPosition
        self.addChild(object)
    }
    func showLeader() {
        let viewControllerVar = self.view?.window?.rootViewController
        let gKGCViewController = GKGameCenterViewController()
        gKGCViewController.gameCenterDelegate = self
        gKGCViewController.leaderboardIdentifier = "com.score.nightball"
        viewControllerVar?.present(gKGCViewController, animated: true, completion: nil)
    }
    
    func isMidnightModeEnabled() {
        if(UserDefaults().integer(forKey: "HIGHSCORE") >= 200){
            fadeLockIconOut()
        }else{
            lockIcon.isHidden = false
        }
    }
    func fadeInGameModeLockedLabel() {
        let gameModeLocked: SKSpriteNode = SKSpriteNode(imageNamed: "popUp")
        gameModeLocked.position = CGPoint(x:size.width * 0.5, y: size.height * 0.5)
        gameModeLocked.scale(to: CGSize(width: size.width * 0.6, height: size.width * 0.6))
        gameModeLocked.zPosition = 6
        gameModeLocked.alpha = 0
        let animateLabel = SKAction.sequence([SKAction.fadeIn(withDuration: 1.0),SKAction.wait(forDuration: 1.0),SKAction.fadeOut(withDuration: 1.0)])
        gameModeLocked.run(animateLabel)
        self.addChild(gameModeLocked)
    }
    
    //MARK: In App Purchase Logic
    func getInfo(purchase : String ){
        NetworkActivityIndicatorManage.NetworkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([bundleID], completion: {
            result in
            NetworkActivityIndicatorManage.networkOperationFinished()
            self.showAlert(alert: self.forProductRetrievalInfo(result:result))
        })
    }
    func purchase(){
        NetworkActivityIndicatorManage.NetworkOperationStarted()
        SwiftyStoreKit.purchaseProduct(bundleID, completion: {
            result in
            NetworkActivityIndicatorManage.networkOperationFinished()
            
            if case .success(let product) = result {
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
                self.fadeLockIconOut()
                self.showAlert(alert: self.alertForPurchaseResult(result: result))
            }
            else {
                self.showAlert(alert: self.alertForPurchaseResult(result: result))
            }
        })
    }
    func restorePurchases(){
        NetworkActivityIndicatorManage.NetworkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true, completion:{
            result in
            NetworkActivityIndicatorManage.networkOperationFinished()
            
            for product in result.restoredPurchases {
                if product.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(product.transaction)
                }
            }
            self.showAlert(alert: self.alertForRestorePurchases(result: result))
        })
    }

    func verifyPurchase(){
        NetworkActivityIndicatorManage.NetworkOperationStarted()
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator,forceRefresh: true, completion: {
            result in
            NetworkActivityIndicatorManage.networkOperationFinished()
            switch result {
            case .success(let receipt):
                print("Verify receipt success: \(receipt)")
                let productID = self.bundleID
                let purchaseResult = SwiftyStoreKit.verifyPurchase(productId: productID, inReceipt: receipt)
                self.fadeLockIconOut()
            case .error(let error):
                self.lockIconExists = true
                self.fadeLockIconIn()
                self.isMidnightModeEnabled()
                print("Verify receipt failed: \(error)")
            }
        })
    }
    func alertForVerifyPurchase(result: VerifyPurchaseResult) -> UIAlertController {
        switch result {
        case .purchased:
            return alertWithTitle(title: "Product is Purchased", message: "Product will not expire")
        case .notPurchased:
            return alertWithTitle(title: "Product is not Purchased", message: "Product has never been pruchased")
        }
    }
    func alertForRestorePurchases(result : RestoreResults) -> UIAlertController {
        if result.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(result.restoreFailedPurchases)")
            return alertWithTitle(title: "Restore Failed", message: "Unknown Error")
        }
        else if result.restoredPurchases.count > 0 {
            fadeLockIconOut()
            return alertWithTitle(title: "Purchases Restored", message: "All purchases have been restored")
        }
        else{
            return alertWithTitle(title: "Nothing To Restore", message: "No previous purchases were made")
        }
    }
    
    func fadeLockIconOut(){
        lockIcon.run(SKAction.fadeOut(withDuration: 0.1)){ () in
            self.lockIcon.isHidden = true
            print("LockIcon is faded out HIDDEN Status:\(self.lockIcon.isHidden)")
        }
        self.lockIconExists = false
    }
    func fadeLockIconIn(){
        lockIcon.run(SKAction.fadeIn(withDuration: 0.1)){ () in
            self.lockIcon.isHidden = false
            self.lockIcon.alpha = 0.7
            print("LockIcon is faded in HIDDEN Status:\(self.lockIcon.isHidden)")
        }
        self.lockIconExists = true
    }
}

extension SKScene {
    func animateFade(fade: SKSpriteNode, delay: Double, duration: Double, startingAlpha: CGFloat,width:CGFloat,height:CGFloat,positionWidth:CGFloat,positionHeight:CGFloat) {
        fade.position = CGPoint(x: positionWidth, y: positionHeight)
        fade.scale(to: CGSize(width: width, height: height))
        fade.zPosition = -5
        fade.alpha = startingAlpha
        let waitAction = SKAction.wait(forDuration: delay)
        let animateList = SKAction.sequence([waitAction, SKAction.fadeIn(withDuration: duration), SKAction.fadeOut(withDuration: duration)])
        let repeatFade: SKAction = SKAction.repeatForever(animateList)
        fade.run(repeatFade)
        addChild(fade)
    }
    func alertWithTitle(title:String, message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    func showAlert(alert : UIAlertController){
        guard let _ = self.scene else{
            return
        }
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    func forProductRetrievalInfo(result: RetrieveResults) -> UIAlertController {
        if let product = result.retrievedProducts.first{
            let priceString = product.localizedPrice
            return alertWithTitle(title: product.localizedTitle, message: "\(product.localizedDescription) - \(String(describing: priceString))")
        }
        else{
            let errorString = result.error?.localizedDescription ?? "Unknown Error."
            return alertWithTitle(title: "Could not retrieve product info", message: errorString)
        }
    }
    func alertForPurchaseResult(result: PurchaseResult) ->UIAlertController {
        switch result{
        case .success(let product):
            print("Purchase Succesful: \(product.productId)")
            return alertWithTitle(title: "Thank You", message: "Purchase Completed")
        case .error(let error):
            print("Purchase Failed: \(error)")
            return alertWithTitle(title: "Purchase Failed", message: "Error Occured")
        }
    }
    func alertForVerifyReceipt(result: VerifyReceiptResult) -> UIAlertController {
        switch result{
        case.success(let receipt):
            return alertWithTitle(title: "Receipt Verified", message: "Receipt Verified Remotely")
        
        case.error(let error):
            return alertWithTitle(title: "Receipt verification", message: "Receipt Verification failed")
        }
    }
}
