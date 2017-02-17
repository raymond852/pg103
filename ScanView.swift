//
//  ScanView.swift
//  pg102
//
//  Created by hy110831 on 1/17/17.
//  Copyright © 2017 hy110831. All rights reserved.
//

import UIKit
import pop

class ScanView: UIView {
    
    var scanLine:UIView!
    
    lazy var layoutOnce:Void = {
        self.scanLine.frame = CGRect(x: 0, y: 0.7, width: self.width, height: 1)
        let anim = POPBasicAnimation(propertyNamed: kPOPLayerTranslationY)
        anim?.fromValue = 0.7
        anim?.toValue = self.height - 0.7
        anim?.autoreverses = true
        anim?.repeatForever = true
        anim?.duration = 3
        
        self.scanLine.layer.pop_add(anim, forKey: "scan")
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        scanLine = UIView()
        scanLine.backgroundColor = UIColor(red: 168 / 255.0, green: 63 / 255.0, blue: 68 / 255.0, alpha: 1)
        self.addSubview(scanLine)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let _ = layoutOnce
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()!
        addWhiteBorder(withContext: context, rect: rect)
        addCornerLine(withContext: context, rect: rect)
    }
    
    func addWhiteBorder(withContext ctx: CGContext, rect:CGRect) {
        ctx.setStrokeColor(UIColor.white.cgColor)
        ctx.setLineWidth(0.8)
        ctx.stroke(rect)
    }
    
    func addCornerLine(withContext ctx: CGContext, rect: CGRect) {
        //画四个边角
        ctx.setLineWidth(CGFloat(2))
        ctx.setStrokeColor(red: 168 / 255.0, green: 63 / 255.0, blue: 68 / 255.0, alpha: 1)
        //绿色
        //左上角
        let pointsTopLeftA: [CGPoint] = [CGPoint(x: CGFloat(rect.origin.x + 0.7), y: CGFloat(rect.origin.y)), CGPoint(x: CGFloat(rect.origin.x + 0.7), y: CGFloat(rect.origin.y + 15))]
        let pointsTopLeftB: [CGPoint] = [CGPoint(x: CGFloat(rect.origin.x), y: CGFloat(rect.origin.y + 0.7)), CGPoint(x: CGFloat(rect.origin.x + 15), y: CGFloat(rect.origin.y + 0.7))]
        ctx.addLines(between: pointsTopLeftA)
        ctx.addLines(between: pointsTopLeftB)
        //左下角
        let pointsBottomLeftA: [CGPoint] = [CGPoint(x: CGFloat(rect.origin.x + 0.7), y: CGFloat(rect.origin.y + rect.size.height - 15)), CGPoint(x: CGFloat(rect.origin.x + 0.7), y: CGFloat(rect.origin.y + rect.size.height))]
        let pointsBottomLeftB: [CGPoint] = [CGPoint(x: CGFloat(rect.origin.x), y: CGFloat(rect.origin.y + rect.size.height - 0.7)), CGPoint(x: CGFloat(rect.origin.x + 0.7 + 15), y: CGFloat(rect.origin.y + rect.size.height - 0.7))]
        ctx.addLines(between: pointsBottomLeftA)
        ctx.addLines(between: pointsBottomLeftB)
        //右上角
        let pointsTopRightA: [CGPoint] = [CGPoint(x: CGFloat(rect.origin.x + rect.size.width - 15), y: CGFloat(rect.origin.y + 0.7)), CGPoint(x: CGFloat(rect.origin.x + rect.size.width), y: CGFloat(rect.origin.y + 0.7))]
        let pointsTopRightB: [CGPoint] = [CGPoint(x: CGFloat(rect.origin.x + rect.size.width - 0.7), y: CGFloat(rect.origin.y)), CGPoint(x: CGFloat(rect.origin.x + rect.size.width - 0.7), y: CGFloat(rect.origin.y + 15 + 0.7))]
        ctx.addLines(between: pointsTopRightA)
        ctx.addLines(between: pointsTopRightB)
        
        
        let pointsBottomRightA: [CGPoint] = [CGPoint(x: CGFloat(rect.origin.x + rect.size.width - 0.7), y: CGFloat(rect.origin.y + rect.size.height + -15)), CGPoint(x: CGFloat(rect.origin.x - 0.7 + rect.size.width), y: CGFloat(rect.origin.y + rect.size.height))]
        let pointsBottomRightB: [CGPoint] = [CGPoint(x: CGFloat(rect.origin.x + rect.size.width - 15), y: CGFloat(rect.origin.y + rect.size.height - 0.7)), CGPoint(x: CGFloat(rect.origin.x + rect.size.width), y: CGFloat(rect.origin.y + rect.size.height - 0.7))]
        ctx.addLines(between: pointsBottomRightA)
        ctx.addLines(between: pointsBottomRightB)
        
        
        ctx.strokePath()
    }

}
