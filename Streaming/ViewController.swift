//
//  ViewController.swift
//  Streaming
//
//  Created by Kant on 2021/05/24.
//

import UIKit
import AVFoundation
import HaishinKit
import VideoToolbox

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initPermission()
        initSettings()
    }

    func initPermission() {
        let session = AVAudioSession.sharedInstance()
        do {
            // https://stackoverflow.com/questions/51010390/avaudiosession-setcategory-swift-4-2-ios-12-play-sound-on-silent
            if #available(iOS 10.0, *) {
                try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            } else {
                session.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord, with: [
                    AVAudioSession.CategoryOptions.allowBluetooth,
                    AVAudioSession.CategoryOptions.defaultToSpeaker]
                )
                try session.setMode(.default)
            }
            try session.setActive(true)
        } catch {
            print(error)
        }
    }
    
    func initSettings() {
        let rtmpConnection = RTMPConnection()
        let rtmpStream = RTMPStream(connection: rtmpConnection)
        rtmpStream.attachAudio(AVCaptureDevice.default(for: AVMediaType.audio)) { error in
            // print(error)
        }
//        rtmpStream.attachCamera(DeviceUtil.device(withPosition: .back)) { error in
//            // print(error)
//        }
//        rtmpStream.attachCamera(nil) { error in
//            // print(error)
//        }
        

        let hkView = HKView(frame: view.bounds)
        hkView.videoGravity = AVLayerVideoGravity.resizeAspectFill
        hkView.attachStream(rtmpStream)

        // add ViewController#view
        view.addSubview(hkView)

        rtmpConnection.connect("rtmp://rtmpmanager-freecat.afreeca.tv/app/")
        rtmpStream.publish("eileenyoo-1478784500")
        
//        rtmpConnection.connect("rtmp://localhost/appName/instanceName")
//        rtmpStream.publish("streamName")
        // if you want to record a stream.
        // rtmpStream.publish("streamName", type: .localRecord)
        

        rtmpStream.captureSettings = [
//            .fps: 30, // FPS
            .sessionPreset: AVCaptureSession.Preset.hd1280x720, // input video width/height
            // .isVideoMirrored: false,
            // .continuousAutofocus: false, // use camera autofocus mode
            // .continuousExposure: false, //  use camera exposure mode
            // .preferredVideoStabilizationMode: AVCaptureVideoStabilizationMode.auto
        ]
        rtmpStream.audioSettings = [
            .muted: false, // mute audio
            .bitrate: 32 * 1000,
        ]
        rtmpStream.videoSettings = [
            .width: 640, // video output width
            .height: 360, // video output height
//            .bitrate: 160 * 1000, // video output bitrate
            .profileLevel: kVTProfileLevel_H264_Baseline_3_1, // H264 Profile require "import VideoToolbox"
//            .maxKeyFrameIntervalDuration: 2, // key frame / sec
        ]
        // "0" means the same of input
        rtmpStream.recorderSettings = [
            AVMediaType.audio: [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 0,
                AVNumberOfChannelsKey: 0,
                AVEncoderBitRateKey: 128000,
            ],
            AVMediaType.video: [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoHeightKey: 0,
                AVVideoWidthKey: 0,
                /*
                AVVideoCompressionPropertiesKey: [
                    AVVideoMaxKeyFrameIntervalDurationKey: 2,
                    AVVideoProfileLevelKey: AVVideoProfileLevelH264Baseline30,
                    AVVideoAverageBitRateKey: 512000
                ]
                */
            ],
        ]

        // 2nd arguemnt set false
        rtmpStream.attachAudio(AVCaptureDevice.default(for: AVMediaType.audio), automaticallyConfiguresApplicationAudioSession: false)
    }
    
    
    
}

