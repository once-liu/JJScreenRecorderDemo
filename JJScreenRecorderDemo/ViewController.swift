//
//  ViewController.swift
//  JJScreenRecorderDemo
//
//  Created by melot on 2021/5/18.
//

import UIKit
import ReplayKit

class ViewController: UIViewController, RPPreviewViewControllerDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    
    var timer: Timer?
    var recorder: RPScreenRecorder!
    
    var recordingWindow: UIWindow?
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        recorder = RPScreenRecorder.shared()
        
    }
    
    func startTimer() {
        var count = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { Timer in
            count += 1
            self.timeLabel.text = "\(count)"
        })
    }
    func stopTimer() {
        timer?.invalidate()
        self.timeLabel.text = "0"
    }

    
    @IBAction func clickScreenRecoderAction(_ sender: UIButton) {
        if !sender.isSelected {
            self.startScreenRecorder()
        } else {
            self.stopScreenRecorder()
        }
        sender.isSelected = !sender.isSelected
    }
    
    func startScreenRecorder() {
        if recorder.isAvailable {
            recorder.startRecording { error in
                if error == nil {
                    DispatchQueue.main.async {
                        self.startTimer()
                    }
                } else {
                    print("---> Start Recorder Error: \(String(describing: error?.localizedDescription))")
                }
            }
        }
    }
    
    func stopScreenRecorder() {
        guard recorder.isRecording else {
            return
        }
        
        recorder.stopRecording { previewViewController, error in
            DispatchQueue.main.async {
                self.stopTimer()
            }
            
            if error == nil {
                
                 /**
                 let URL: URL = previewViewController?.value(forKey: "movieURL") as! URL
                 print("---> URL: \(URL)")
                 */
                
                
                 previewViewController?.previewControllerDelegate = self
                 self.present(previewViewController!, animated: true, completion: nil)
                 
                
            } else {
                print("---> Stop Recorder Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    // RPPreviewViewControllerDelegate
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        previewController.dismiss(animated: true, completion: nil)
    }
    
    func previewController(_ previewController: RPPreviewViewController, didFinishWithActivityTypes activityTypes: Set<String>) {
        print("\(activityTypes)")
        
        // ["com.apple.UIKit.activity.SaveToCameraRoll"]
    }
    
    
    
}

