////
////  K1VC.swift
////  pg102
////
////  Created by hy110831 on 1/16/17.
////  Copyright © 2017 hy110831. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//class K1VC: BaseViewController {
//    
//    var scan_timeout:TimeInterval = 10
//    
//    var currentCameraDevice:AVCaptureDevice!
//    var session:AVCaptureSession!
//    var layer:AVCaptureVideoPreviewLayer!
//    
//    var overlayView:UIView!
//    var scanView:UIView!
//    
//    let MARGIN_LEFT:CGFloat = 400
//    let HEIGHT:CGFloat = 250
//    
//    let code2imgMap:[String:String] = [
//        "6903148079980": "6903148079980.jpg",
//        "6903148080009": "6903148080009.jpg",
//        "6903148080023": "6903148080023.jpg",
//        "6903148080054": "6903148080054.jpg",
//        "6903148080146": "6903148080146.jpg",
//        "6903148101261": "6903148101261.jpg",
//        "6903148174456": "6903148174456.jpg",
//        "6903148180440": "6903148180440.jpg",
//        "6903148218921": "6903148218921.jpg",
//        "6903148245972": "6903148245972.jpg",
//        "6903148253342": "6903148253342.jpg",
//        "6903148253359": "6903148253359.jpg",
//        "6903148253366": "6903148253366.jpg",
//        "6903148253380": "6903148253380.jpg"
//        ]
//    
//    private lazy var layoutOnce:Void = {
//        self.overlayClipping()
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = true
//        setupView()
//        
//        if let timeout = UserDefaults.standard.value(forKey: "scan_timeout") as? Int {
//            scan_timeout = TimeInterval(timeout)
//        }
//        
//        startToRootViewControllerCountDown()
//    }
//
//    
//    func startToRootViewControllerCountDown() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 15, execute: { [weak self] in
//            if let navigationController = self?.navigationController as? InteractNavVC {
//                if navigationController.fireInteractTimestamp > Date().timeIntervalSince1970 {
//                    self?.startToRootViewControllerCountDown()
//                } else {
//                    let _ = self?.navigationController?.popToRootViewController(animated: true)
//                    CC2541.shared.lightOffLed()
//                }
//            }
//        })
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func setupView() {
//        
//        session = AVCaptureSession()
//        session.sessionPreset = AVCaptureSessionPresetPhoto
//        
//        let availableCameraDevices = AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo)
//        for device in availableCameraDevices as! [AVCaptureDevice] {
//            if device.position == .front {
//                self.currentCameraDevice = device
////                do {
////                    session.beginConfiguration()
////                    try self.currentCameraDevice.lockForConfiguration()
////                    Logger.info("video max zoom factor: \(device.activeFormat.videoMaxZoomFactor)")
////                    self.currentCameraDevice.videoZoomFactor = 40
////                    if self.currentCameraDevice.isFocusModeSupported(.continuousAutoFocus) {
////                        self.currentCameraDevice.focusMode = AVCaptureFocusMode.continuousAutoFocus
////                    }
////                    self.currentCameraDevice.unlockForConfiguration()
////                    session.commitConfiguration()
//                    
////                } catch {
////                    Logger.error("setting camera with error")
////                }
//                break
//            }
//        }
//        
//        let possibleCameraInput: AnyObject?
//        do {
//            possibleCameraInput = try AVCaptureDeviceInput(device:self.currentCameraDevice)
//        } catch let error as NSError {
//            Logger.error(error)
//            possibleCameraInput = nil
//        } catch {
//            fatalError()
//        }
//        if let cameraInput = possibleCameraInput as? AVCaptureDeviceInput {
//            if self.session.canAddInput(cameraInput) {
//                self.session.addInput(cameraInput)
//            }
//        }
//        
//        
//        let output = AVCaptureMetadataOutput()
//        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//        if session.canAddOutput(output) {
//            self.session.addOutput(output)
//        }
//        output.metadataObjectTypes  = []
//        if (output.availableMetadataObjectTypes as! [NSString]).contains(AVMetadataObjectTypeEAN13Code as NSString) {
//            output.metadataObjectTypes.append(AVMetadataObjectTypeEAN13Code)
//        }
//        
//        
//        let image = UIImage(named: "bg_k1_scan.png", cached: false)
//        self.layer = AVCaptureVideoPreviewLayer(session: self.session)
//        self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill
//        self.layer.frame = CGRect(x: 0, y: 0, width: self.view.width, height: self.view.height - image.size.height)
//        self.view.layer.insertSublayer(layer, at: 0)
//        
//        self.scanView = ScanView()
//        self.scanView.frame = CGRect(x: MARGIN_LEFT, y: 100, width: self.view.width - MARGIN_LEFT * 2, height:HEIGHT)
//        self.view.addSubview(scanView)
//        
//        
//        self.overlayView = UIView(frame: self.view.bounds)
//        self.overlayView.alpha = 0.5
//        self.overlayView.backgroundColor = UIColor.black
//        self.view.addSubview(self.overlayView)
//        self.overlayView.frame = layer.frame
//        
//        session.startRunning()
//        
//        let previewLayerConnection = self.layer.connection
//        if previewLayerConnection?.isVideoOrientationSupported == true {
//            previewLayerConnection?.videoOrientation = .landscapeRight
//        }
//        
////        let rect = layer.metadataOutputRectOfInterest(for: CGRect(x:scanView.x + 50, y: scanView.y + 50, width: scanView.width - 100, height: scanView.height - 100))
////        let rect = layer.metadataOutputRectOfInterest(for: scanView.frame)
////        output.rectOfInterest = rect
//
//       
//        let imageView = UIImageView(image: image)
//        imageView.frame = CGRect(x: 0, y: self.view.height - image.size.height, width: self.view.width, height: image.size.height)
//        self.view.addSubview(imageView)
//        
//        let closeBtn = UIButton(frame: CGRect(x: 935, y: 49, width: 45, height:45))
//        closeBtn.setImage(UIImage(named: "close.png", cached: true), for: UIControlState.normal)
//        self.view.addSubview(closeBtn)
//        closeBtn.isExclusiveTouch = true
//        closeBtn.addTarget(.touchUpInside) {
//            [unowned self] in
//            let _ = self.navigationController?.popViewController(animated: true)
//        }
//        
//    }
//    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        let _ = layoutOnce
//    }
//    
//    
//    func overlayClipping() {
//        let maskLayer: CAShapeLayer = CAShapeLayer()
//        let path: CGMutablePath = CGMutablePath()
//        // Left side of the ratio view
//        path.addRect(CGRect(x:0, y:0, width: self.scanView.frame.origin.x, height: self.overlayView.frame.size.height))
//        // Right side of the ratio view
//        path.addRect(CGRect(x:self.scanView.frame.origin.x + self.scanView.frame.size.width, y:0, width: self.overlayView.frame.size.width - self.scanView.frame.origin.x - self.scanView.frame.size.width, height: self.overlayView.frame.size.height))
//        // Top side of the ratio view
//        path.addRect(CGRect(x:0, y:0, width: self.overlayView.frame.size.width, height: self.scanView.frame.origin.y))
//        // Bottom side of the ratio view
//        path.addRect(CGRect(x:0, y:self.scanView.frame.origin.y + self.scanView.frame.size.height, width: self.overlayView.frame.size.width, height: self.overlayView.frame.size.height - self.scanView.frame.origin.y + self.scanView.frame.size.height))
//        maskLayer.path = path
//        self.overlayView.layer.mask = maskLayer
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        CC2541.shared.lightOffLed()
//    }
//
//}
//
//extension K1VC: AVCaptureMetadataOutputObjectsDelegate {
//    
//    
//    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
//        if metadataObjects.count > 0 {
//            if let metadateObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
//                Logger.info(metadateObject.stringValue)
//                if let imageName = code2imgMap[metadateObject.stringValue] {
//                    let vc = CxVC.instantiateFromStoryboard()
//                    vc.imageName = imageName
//                    self.navigationController?.setViewControllers([E1VC.instantiateFromStoryboard(), vc], animated: true)
//                }
//            }
//        }
//    }
//    
//
//}
//
