//
//  FaceDetector.swift
//  pg
//
//  Created by hy110831 on 7/31/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import SwiftyJSON

typealias FaceDetectorCompletionBlock = ((_ faces:[FaceModel]?, _ error:NSError?) -> Void)

protocol FaceDetector {
    func detectFaceWithImageData(_ data:Data, complectionBlock: @escaping FaceDetectorCompletionBlock)
    func cancelDetection()
    func isDetectingFace()->Bool
}

class FaceModel:NSObject {
    
    init(gender:Gender, confidence:Double) {
        self.gender = gender
        self.confidence = confidence
        super.init()
    }
    
    enum Gender {
        case male
        case female
    }
    
    var gender:Gender
    var confidence:Double
}



