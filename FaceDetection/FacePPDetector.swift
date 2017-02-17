//
//  FacePPDetector.swift
//  pg
//
//  Created by hy110831 on 9/4/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation
import SwiftyJSON

class FacePPDetector: FaceDetector {
    internal func detectFaceWithImageData(_ data: Data, complectionBlock: @escaping ([FaceModel]?, NSError?) -> Void) {
        lock.wait(timeout: DispatchTime.distantFuture)
        
        operation = BlockOperation(block: {
            let result = FaceppAPI.detection().detect(withURL: nil, orImageData: data, mode: FaceppDetectionModeNormal, attribute:  Int32(FaceppDetectionAttributeGender))
            
            if true == result?.success {
                var faces = [FaceModel]()
                let content = JSON(result?.content)
                let facesJson = content["face"]
                for (_ , subJson):(String, JSON) in facesJson {
                    if let val = subJson["attribute"]["gender"]["value"].string, let confidence = subJson["attribute"]["gender"]["confidence"].double {
                        if confidence < 85 {
                            complectionBlock(nil, NSError(domain: "FacePP", code: 101, userInfo: ["error_msg":"low confidence"]))
                            return
                        }
                        let gender =  val == "Male" ? FaceModel.Gender.male : FaceModel.Gender.female
                        let model = FaceModel(gender:gender, confidence:confidence)
                        faces.append(model)
                    }
                }
                
                
                if faces.count > 0 {
                    return complectionBlock(faces, nil)
                }
                complectionBlock(nil, NSError(domain: "FacePP", code: 100, userInfo: ["error_msg":"No face found"]))
            } else if let err = result?.error {
                complectionBlock(nil, NSError(domain: "FacePP", code: Int(err.errorCode), userInfo: ["error_msg":err.message]))
            } else {
                complectionBlock(nil, NSError(domain: "FacePP", code: -1, userInfo: ["error_msg":"Unknown error"]))
            }
        })
        
        faceDetectQueue.addOperation(operation!)
        
        lock.signal()
    }

    
    fileprivate lazy var faceDetectQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "face_detect_queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    var operation:Operation?
    
    var lock:DispatchSemaphore = DispatchSemaphore(value: 1)
    
    init() {
        initFacePP()
    }
    
    func initFacePP() {
        let key = "801a7ab80db1c3bed13f78fda402c583"
        let secret = "Wa73snNus70ntTqHT6jkEse_buqMfas6"
        FaceppAPI.initWithApiKey(key, andApiSecret: secret, andRegion: APIServerRegionCN)
    }
    
    
    
    func cancelDetection() {
        lock.wait(timeout: DispatchTime.distantFuture)
        
        operation?.cancel()
        operation = nil
        
        lock.signal()
    }
    
    func isDetectingFace() -> Bool {
        return faceDetectQueue.operationCount > 0
    }
    
    deinit {
        operation = nil
        faceDetectQueue.cancelAllOperations()
    }
}
