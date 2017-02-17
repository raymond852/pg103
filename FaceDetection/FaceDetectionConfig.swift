//
//  Config.swift
//  pg
//
//  Created by hy110831 on 8/13/16.
//  Copyright © 2016 hy110831. All rights reserved.
//

import Foundation

let FACE_DETECTION_MODE_TIMER = 0
let FACE_DETECTION_MODE_COUNTER = 1

class FaceDetectionConfig {
    static let FACE_DETECTION_MODE = FACE_DETECTION_MODE_TIMER
    static let FACE_DETECTION_TIMER_WAIT_TIME:TimeInterval = 15
    static let FACE_DETECTION_COUNTER_COUNT = 5
}
