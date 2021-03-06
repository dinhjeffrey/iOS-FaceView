//
//  ViewController.swift
//  FaceView
//
//  Created by jeffrey dinh on 6/9/16.
//  Copyright © 2016 jeffrey dinh. All rights reserved.
//

import UIKit

class FaceVC: UIViewController {
    // stored property
    var expression = FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Grin) {
        didSet {
            updateUI()
        }} // update every time after the first time hook up
    @IBOutlet weak var faceView: FaceView! { didSet {
        faceView.addGestureRecognizer(UIPinchGestureRecognizer(
            target: faceView,
            action: #selector(FaceView.changeScale(_:))
            ))
        
        let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self, action: #selector(FaceVC.increaseHappiness)
        )
        happierSwipeGestureRecognizer.direction = .Down
        faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
        let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self, action: #selector(FaceVC.decreaseHappiness)
        )
        sadderSwipeGestureRecognizer.direction = .Up
        faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
        
        updateUI()
        }} // update first time view hooked up
    
    @IBAction func toggleEyes(recognizer: UITapGestureRecognizer) {
        if recognizer.state == .Ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: expression.eyes = .Open
            }
        }
    }
    private struct Animation {
        static let ShakeAngle = CGFloat(M_PI/6)
        static let ShakeDuration = 0.5
    }
    @IBAction func headShake(sender: UITapGestureRecognizer) {
        UIView.animateWithDuration(
            Animation.ShakeDuration,
            animations: {
                self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, Animation.ShakeAngle)
            },
            completion: { finished in
                // what to do?
                if finished {
                    UIView.animateWithDuration(
                        Animation.ShakeDuration,
                        animations: {
                            self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, -Animation.ShakeAngle*2)
                        },
                        completion: { finished in
                            // what to do?
                            if finished {
                                UIView.animateWithDuration(
                                    Animation.ShakeDuration,
                                    animations: {
                                        self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, Animation.ShakeAngle)
                                    },
                                    completion: { finished in
                                        // what to do?
                                        if finished {
                                            
                                        }
                                    }
                                )
                            }
                        }
                    )
                }
            }
        )
    }
    
    func increaseHappiness() {
        expression.mouth = expression.mouth.happierMouth()
    }
    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown: -1.0, .Grin: 0.5, .Smile: 1.0, .Smirk: -0.5, .Neutral: 0.0]
    private var eyeBrowTilts = [FacialExpression.EyeBrows.Relaxed: 0.5, .Furrowed: -0.5, .Normal:0.0]
    
    private func updateUI() {
        if faceView != nil { // works because we do update UI when our model gets set (didSet) and also when outlet gets set, so faceView (the outlet), will not be nil by then
            switch expression.eyes {
            case .Squinting: faceView.eyesOpen = false
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
            faceView.eyeBrowTilt = eyeBrowTilts[expression.eyeBrows] ?? 0.0
        }
    }
    
    
    
    
}

