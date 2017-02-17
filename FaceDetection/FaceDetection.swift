//
//  FaceDetection.swift
//  pg
//
//  Created by hy110831 on 7/29/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import SwiftyJSON

// Make nil comparable
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class FaceDectection:NSObject {
    
    static let NOTIF_FACE_DETECTION_STATE_CHANGED = "StateChanged"
    
    enum FaceDetectionState:Int {
        case detectingGender = 1
        case detectedGender = 2
        case detectRetry = 3
        case noFace = 0
    }
    
    fileprivate var currentCameraDevice:AVCaptureDevice?
    var session:AVCaptureSession!
    fileprivate var backCameraDevice:AVCaptureDevice?
    fileprivate var frontCameraDevice:AVCaptureDevice?
    
    fileprivate var videoOutput:AVCaptureVideoDataOutput!
    fileprivate var stillCameraOutput:AVCaptureStillImageOutput!
    fileprivate var metadataOutput:AVCaptureMetadataOutput!
    
    fileprivate var consecutiveNoFaceCounter:Int = 0
    
    fileprivate var layer:AVCaptureVideoPreviewLayer!
    
    fileprivate var isRunning:Bool {
        return self.session.isRunning
    }
    
    fileprivate lazy var isNotificationMute:Bool = false
    
    fileprivate var fireNoFaceTimestamp:TimeInterval?
    

    var fakeFaces:[CGRect] = []
    
    
    fileprivate lazy var sessionQueue:DispatchQueue = DispatchQueue(label: "session_queue", attributes: [])
    fileprivate lazy var imageProcessingQueue:DispatchQueue! =  DispatchQueue(label: "image_processing_queue", attributes: [])
    
    let DEFAULT_ORIENTATION = AVCaptureVideoOrientation.landscapeRight
    
    fileprivate(set) var detectionState : FaceDetectionState {
        didSet {
            DispatchQueue.main.async {
                if self.detectionState != .detectedGender && oldValue != self.detectionState {
                    if !self.isNotificationMute {
                        let notifs = Notification(name: Notification.Name(rawValue: FaceDectection.NOTIF_FACE_DETECTION_STATE_CHANGED), object: self)
                        NotificationCenter.default.post(notifs)
                        Logger.debug("FaceDetection: \(self.detectionState)")
                    }
                } else {
                    Logger.error("Error: Duplicate state")
                }
            }
        }
    }
    
    var faceModel:FaceModel?
    
    lazy var faceDetector:FaceDetector = FacePPDetector()
    
    fileprivate(set) var hasFaces:Bool = false
    
    fileprivate var savedCount = 10
    
    fileprivate func loadConfig() {
        if FaceDetectionConfig.FACE_DETECTION_MODE == FACE_DETECTION_MODE_TIMER {
        }
    }
    
    fileprivate func initSession() {
        // Create the session
        session = AVCaptureSession()
        
        // Configure the session to produce lower resolution video frames, if your
        // processing algorithm can cope.
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        switch authorizationStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                if granted {
                    self.configureSession()
                } else {
                    
                }
            })
        case .authorized:
            configureSession()
        case .denied, .restricted:
            break
        }
    }
    
    
    func offlineDetectFaceWIthImage(_ image:UIImage)->[CIFeature] {
        let coreImg = CIImage(image: image)!
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        return detector!.features(in: coreImg)
    }
    
    func observeInterfaceOrientationChanged() {
        NotificationCenter.default.addObserver(self, selector: #selector(FaceDectection.orientationDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: self)
    }
    
    
    func captureStillImage(completionHandler handler: @escaping ((_ jpegImageData:Data) -> Void)) {
        sessionQueue.async { () -> Void in
            
            let connection = self.stillCameraOutput.connection(withMediaType: AVMediaTypeVideo)
            
            connection?.videoOrientation = self.interfaceOrientation2AVOrientation(UIApplication.shared.statusBarOrientation)
            
            self.stillCameraOutput.captureStillImageAsynchronously(from: connection) {
                (imageDataSampleBuffer, error) -> Void in
                
                if error == nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                    
                    handler(imageData!)
                }
                else {
                    Logger.error("FaceDetection: error while capturing still image: \(error)")
                }
            }
        }
    }
    
    func startRunning() {
        performConfiguration { () -> Void in
            self.session.startRunning()
        }
    }
    
    func stopRunning() {
        performConfiguration { () -> Void in
            self.session.stopRunning()
        }
    }
    
    func muteNotification() {
        self.isNotificationMute = true
    }
    
    func unmuteNotification() {
        self.isNotificationMute = false
    }
    
    func interfaceOrientation2AVOrientation(_ orientation:UIInterfaceOrientation)-> AVCaptureVideoOrientation {
        switch orientation {
        case .portrait:
            return AVCaptureVideoOrientation.portrait
        case .portraitUpsideDown:
            return AVCaptureVideoOrientation.portraitUpsideDown
        case .landscapeLeft:
            return AVCaptureVideoOrientation.landscapeLeft
        case .landscapeRight:
            return AVCaptureVideoOrientation.landscapeRight
        case .unknown:
            return DEFAULT_ORIENTATION
        }
    }
    
    override init() {
        self.detectionState = .noFace
        super.init()
        loadConfig()
        initSession()
        
    }
    
    static var sharedInstance = FaceDectection()
}


// MARK:  Handle device orientation changed
extension FaceDectection {
    
    func orientationDidChange(_ notification:Notification) {
//        let currentOrientation = UIApplication.sharedApplication().statusBarOrientation
//        let connection = self.session.c
//        if interfaceOrientation2AVOrientation(currentOrientation) != connection.videoOrientation {
//            if connection.supportsVideoOrientation {
//                session.beginConfiguration()
//                connection.videoOrientation = interfaceOrientation2AVOrientation(currentOrientation)
//                session.commitConfiguration()
//            }
//        }
    }
}


// MARK: Handle Camera Output
extension FaceDectection: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didDrop sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if let obj = CMGetAttachment(sampleBuffer, kCMSampleBufferAttachmentKey_DroppedFrameReason, nil) {
            Logger.warning(obj)
        }
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if hasFaces {
            if FaceDetectionConfig.FACE_DETECTION_MODE == FACE_DETECTION_MODE_COUNTER {
                consecutiveNoFaceCounter = 0
            } else {
                if fireNoFaceTimestamp != nil {
                    Logger.info("FaceDetection: face timer stop count down with fire date \(fireNoFaceTimestamp)")
                }
                fireNoFaceTimestamp = nil

            }
            
            if self.detectionState == .detectedGender || self.detectionState == .detectingGender {
                return
            }
            imageProcessingQueue.async(execute: { [unowned self] in
                autoreleasepool(invoking: {
                    if self.detectionState == .detectedGender || self.detectionState == .detectingGender {
                        return
                    }
                    
                    if self.detectionState == .noFace {
                        self.detectionState = .detectingGender
                    }
                        
                    let image = self.imageFromSampleBuffer(sampleBuffer)
                    let data = UIImageJPEGRepresentation(image, 0.7)!
                    
                    if !self.faceDetector.isDetectingFace() {
                    
                    self.faceDetector.detectFaceWithImageData(data, complectionBlock: { [unowned self] (faces, error) in
                                
                                self.imageProcessingQueue.async(execute: { [unowned self] in
                                    
                                    // only DetectingGender and DetectRetry can transition to DetectedGender
                                    if self.detectionState != .detectingGender && self.detectionState != .detectRetry {
                                        return
                                    }
                                    
                                    if error != nil {
                                        Logger.error("FaceDetection: \(error!)")
                                        self.detectionState = .detectRetry
                                    }
                                    else if error == nil && 0 < faces?.count{
            
                                        self.detectionState = .detectedGender
                                        self.faceModel = faces![0]
                                        if !self.isNotificationMute {
                                            Logger.debug("FaceDetection: \(self.detectionState) Gender: \(faces![0].gender)")
                                            
                                            DispatchQueue.main.async {
                                            let notificaiton = Notification(name: Notification.Name(rawValue: FaceDectection.NOTIF_FACE_DETECTION_STATE_CHANGED), object: self, userInfo: ["model":faces![0]])
                                        
                                        
                                            NotificationCenter.default.post(notificaiton)
                                            }
                                        }
                                    } else {
                                        self.detectionState = .detectRetry
                                    }
                                })
                            })
                    }
                })
            })
        } else {
            if self.detectionState != .noFace {
                if FaceDetectionConfig.FACE_DETECTION_MODE == FACE_DETECTION_MODE_COUNTER {
                    if consecutiveNoFaceCounter > FaceDetectionConfig.FACE_DETECTION_COUNTER_COUNT {
                        self.imageProcessingQueue.async(execute: {
                            self.detectionState = .noFace
                        })
                    } else {
                        consecutiveNoFaceCounter += 1
                    }

                } else {
                    if fireNoFaceTimestamp == nil {
                        fireNoFaceTimestamp = Date().timeIntervalSince1970 + FaceDetectionConfig.FACE_DETECTION_TIMER_WAIT_TIME
                        Logger.info("FaceDetection: face timer start count down with fire date \(fireNoFaceTimestamp)")
                    } else {
                        let currentTime = Date().timeIntervalSince1970
                        if fireNoFaceTimestamp < currentTime {
                            self.nofaceTimerFulfill()
                            self.fireNoFaceTimestamp = nil
                        }
                    }
                }
            }
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        var hasFaces = false
        for metadataObject in metadataObjects as! [AVMetadataObject] {
            if metadataObject.type == AVMetadataObjectTypeFace {
                if let faceObj = metadataObject as? AVMetadataFaceObject {
                    let faceSize = faceObj.bounds.size
                    if faceSize.width < 0.15 && faceSize.height < 0.15  {
                        continue
                    } else {
                        hasFaces = true
                    }
                }
            }
        }
        self.hasFaces = hasFaces
    }
    
    func imageDataFromSampleBuffer(_ sampleBuffer: CMSampleBuffer)-> Data {
        let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        let bytesPerRow: size_t = CVPixelBufferGetBytesPerRow(imageBuffer)
        let _: size_t = CVPixelBufferGetWidth(imageBuffer)
        let height: size_t = CVPixelBufferGetHeight(imageBuffer)
        let src_buff = CVPixelBufferGetBaseAddress(imageBuffer)
        let src_buff_final = UnsafeRawPointer(src_buff)
        let data: Data = Data(bytes: src_buff_final!, count: bytesPerRow * height)
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        return data
    }
    
    // Create a UIImage from sample buffer data
    func imageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage {
        // Get a CMSampleBuffer's Core Video image buffer for the media data
        let imageBuffer: CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        // Get the number of bytes per row for the pixel buffer
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)
        // Get the number of bytes per row for the pixel buffer
        let bytesPerRow: size_t = CVPixelBufferGetBytesPerRow(imageBuffer)
        // Get the pixel buffer width and height
        let width: size_t = CVPixelBufferGetWidth(imageBuffer)
        let height: size_t = CVPixelBufferGetHeight(imageBuffer)
        // Create a device-dependent RGB color space
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        // Create a bitmap graphics context with the sample buffer data
        let context: CGContext = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue  |  CGImageAlphaInfo.premultipliedFirst.rawValue)!
        // Create a Quartz image from the pixel data in the bitmap graphics context
        let quartzImage: CGImage = context.makeImage()!
        // Unlock the pixel buffer
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        // Create an image object from the Quartz image
        let image: UIImage = UIImage(cgImage:quartzImage)
        return (image)
    }
    
    func nofaceTimerFulfill() {
        self.faceDetector.cancelDetection()
        self.faceModel = nil
        Logger.info("FaceDetection: NofaceTimerFulfill, cancel face detection")
        imageProcessingQueue.async { [unowned self] in
            self.detectionState = .noFace
        }
    }
}

// MARK: - Private

private extension FaceDectection {
    
    func performConfiguration(_ block: @escaping (() -> Void)) {
        sessionQueue.async { () -> Void in
            block()
        }
    }
    
    
    func performConfigurationOnCurrentCameraDevice(_ block: @escaping ((_ currentDevice:AVCaptureDevice) -> Void)) {
        if let currentDevice = self.currentCameraDevice {
            performConfiguration { () -> Void in
                do {
                    try currentDevice.lockForConfiguration()
                    block(currentDevice)
                    currentDevice.unlockForConfiguration()
                } catch let error as NSError {
                    Logger.error(error)
                } catch {
                    fatalError()
                }
            }
        }
    }
    
    
    func configureSession() {
        configureDeviceInput()
        configureStillImageCameraOutput()
        configureFaceDetection()
        configPreviewLayer()
        configureVideoOutput()
    }
    
    func configureStillImageCameraOutput() {
        performConfiguration { () -> Void in
            self.stillCameraOutput = AVCaptureStillImageOutput()
            self.stillCameraOutput.outputSettings = [
                AVVideoCodecKey  : AVVideoCodecJPEG,
                AVVideoQualityKey: 0.9
            ]
            
            if self.session.canAddOutput(self.stillCameraOutput) {
                self.session.addOutput(self.stillCameraOutput)
            }
        }
    }
    
    
    func configureDeviceInput() {
        performConfiguration { () -> Void in
            
            let availableCameraDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
            for device in availableCameraDevices as! [AVCaptureDevice] {
                if device.position == .back {
                    self.backCameraDevice = device
                }
                else if device.position == .front {
                    self.frontCameraDevice = device
                }
            }
            
            
            // set the front camera as the initial device
            self.currentCameraDevice = self.frontCameraDevice
            
            let possibleCameraInput: AnyObject?
            do {
                possibleCameraInput = try AVCaptureDeviceInput(device:self.currentCameraDevice)
            } catch let error as NSError {
                Logger.error(error)
                possibleCameraInput = nil
            } catch {
                fatalError()
            }
            if let backCameraInput = possibleCameraInput as? AVCaptureDeviceInput {
                if self.session.canAddInput(backCameraInput) {
                    self.session.addInput(backCameraInput)
                }
            }
        }
    }
    
    
    func configureVideoOutput() {
        performConfiguration { [unowned self] () -> Void in
            self.videoOutput = AVCaptureVideoDataOutput()
            let rgbOutputSettings: [AnyHashable: Any] = [kCVPixelBufferPixelFormatTypeKey as AnyHashable: Int(kCMPixelFormat_32BGRA)]
            
            self.videoOutput.videoSettings = rgbOutputSettings
            self.videoOutput.setSampleBufferDelegate(self, queue: self.sessionQueue)
            if self.session.canAddOutput(self.videoOutput) {
                self.session.addOutput(self.videoOutput)
            }
            let connection = self.videoOutput.connection(withMediaType: AVMediaTypeVideo)
            if (connection?.isVideoOrientationSupported)! {
                connection?.videoOrientation = self.interfaceOrientation2AVOrientation(UIApplication.shared.statusBarOrientation)
            }
        }
    }
    
    
    func configureFaceDetection() {
        performConfiguration { [unowned self] () -> Void in
            self.metadataOutput = AVCaptureMetadataOutput()
            self.metadataOutput.setMetadataObjectsDelegate(self, queue: self.sessionQueue)
            
            if self.session.canAddOutput(self.metadataOutput) {
                self.session.addOutput(self.metadataOutput)
            }
            
            if (self.metadataOutput.availableMetadataObjectTypes as! [NSString]).contains(AVMetadataObjectTypeFace as NSString) {
                self.metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeFace]
            }
        }
    }
    
    func configPreviewLayer() {
        self.layer = AVCaptureVideoPreviewLayer(session: self.session)
        self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.layer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
}
