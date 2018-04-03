//
//  ViewController.swift
//  ARMeasure
//
//  Created by mac126 on 2018/4/3.
//  Copyright © 2018年 mac126. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var notReadyLabel: UILabel!
    @IBOutlet weak var aimLabel: UILabel!
    
    let vectorZero = SCNVector3()
    var measuring = false
    var startValue = SCNVector3()
    var endValue = SCNVector3()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        resetValue()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - initial method
    func updateResultLabel(_ value: Float) {
        let cm = value * 100.0
        let inch = cm * 0.3937007874
        resultLabel.text = String(format: "%.2f cm / %.2f \"", cm, inch)
    }
    
    func resetValue() {
        measuring = false
        startValue = SCNVector3Zero
        endValue = SCNVector3Zero
        
        updateResultLabel(0.0)
    }
    
    func detectObjects() {
        if let worlsPos = sceneView.realWorldVector(screenPostion: sceneView.center) {
            notReadyLabel.isHidden = true
            aimLabel.isHidden = false
            if measuring {
                if startValue == SCNVector3Zero {
                    startValue = worlsPos
                }
                endValue = worlsPos
                updateResultLabel(startValue.distance(from: endValue))
            }
        }
    }
    
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 重置
        resetValue()
        measuring = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        measuring = false
    }
}

// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.detectObjects()
        }
        
    }
}

extension ViewController: ARSessionObserver {
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
