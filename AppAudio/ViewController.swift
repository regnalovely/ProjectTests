//
//  ViewController.swift
//  AppAudio
//
//  Created by Shyn Regna on 02/01/2019.
//  Copyright © 2019 Shyn Regna. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var btnRecord: UIButton!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.defaultToSpeaker)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        print("Failed to record !")
                    }
                }
            }
        } catch {
            print("Failed to record")
        }
    }
    
    func loadRecordingUI(){
        btnRecord.setTitle("Record", for: .normal)
        btnRecord.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
    }
    
    func startRecording(){
        let audioFilename = getDocumentsDirectory().appendingPathComponent("record.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            btnRecord.setTitle("Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool){
        audioRecorder.stop()
        audioRecorder = nil
        btnRecord.setTitle("Record", for: .normal)
        
        if !success {
            print("Failed to record")
        }
    }
    
    @objc func recordTapped(){
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
        if !flag {
            finishRecording(success: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

