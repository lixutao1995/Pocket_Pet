//
//  ColorSlider.swift
//  Pocket_Pet
//
//  Created by Xutao Li on 29/11/18.
//

import UIKit
import Foundation

class ColorSlider: UISlider{
   
    var colorTrackIV:UIImageView?
    var arrowView:UIImageView?
    var thumbImage: String?
    var isSetTimer:Bool?
    
    func
//    func initilizeInterface(sliderImageName: String, thumbImageName: String, isSetTimer: Bool) {
//        colorTrackIV = UIImageView(image: UIImage(named: sliderImageName))
//        colorTrackIV!.transform = CGAffineTransform(scaleX: -1, y: 1) // 这里是翻转滑动条图片，因为下面使用的 UIColor 的方法产生的颜色正好是图片翻转之后的颜色顺序。
//        arrowView = UIImageView(image: UIImage(named: thumbImageName))
//
////        self.colorTrackIV!.frame = CGRect((arrowView?.frame.width)! / 2, (arrowView?.frame.height)! - 18, (arrowView?.frame.width)! - (arrowView?.frame.width)! + 5, 2) // 确定滑动条的位置，大家可以根据自己的需求调整。
//        colorTrackIV?.frame=CGRect(x: (arrowView?.frame.width)! / 2, y: (arrowView?.frame.height)! - 18, width: (arrowView?.frame.width)! - (arrowView?.frame.width)! + 5, height: 2)
//        self.addSubview(colorTrackIV!)
////        self.setThumbImage(UIImage(named: thumbImageName)!.tintAnyColor(self.colorFromCurrentValue()), for: .Normal) // 设置滑块图片
//        self.setThumbImage(UIImage(named: "thumbImageName"), for: .normal)
//        // 下面两句代码是隐藏原本的 UISlider 的滑动条，若不加的话，就是下图的效果
//        self.setMinimumTrackImage(self.imageFormColor(color: UIColor.clear), for: .normal)
//        self.setMaximumTrackImage(self.imageFormColor(color: UIColor.clear), for: .normal)
//        self.thumbImage = thumbImageName
//        self.isSetTimer = isSetTimer
//    }
//    // 返回纯色图片
//    private func imageFormColor(color: UIColor) -> UIImage {
//        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
//        UIGraphicsBeginImageContext(rect.size)
//        let context = UIGraphicsGetCurrentContext()
//        context!.setFillColor(color.cgColor)
//        context!.fill(rect)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image!
//    }
//    func colorFromCurrentValue() -> UIColor {
//        return UIColor(hue: CGFloat(self.value), saturation: 1, brightness: 1.0, alpha: 1.0)
//    }
//    override func beginTracking(_ touch: UITouch, with  event: UIEvent?) -> Bool {
//        let tracking = super.beginTracking(touch, with: event)
//        // 设置滑块图片，tintAnyColor 是渲染图片方法
//        self.setThumbImage(UIImage(named: self.thumbImage!)!., for: .normal)
//        return tracking
//    }
//
//    // 持续触摸
//    override func continueTracking(_ touch: UITouch, with  event: UIEvent?) -> Bool {
//        let con = super.continueTracking(touch, with: event)
//        self.setThumbImage(UIImage(named: self.thumbImage!)!, for: .normal)
////        thumbImage
//        return con
//
//    }
//    // 结束触摸
//    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
//        super.endTracking(touch, with: event)
//        self.setThumbImage(UIImage(named: self.thumbImage!)!, for: .normal)
//    }
    
    

//    func didChangeValue<Value>(for keyPath: KeyPath<ColorSlider, Value>) {
//        <#code#>
//    }
//    func sliderValueDidChange(sender:UISlider) {
//        print("value--\(sender.value)")
//        if sender.value <= 0.3 {
//            colorSlider.minimumTrackTintColor = UIColor.greenColor()
//        } else if sender.value > 0.3 && sender.value <= 0.6 {
//            colorSlider.minimumTrackTintColor = UIColor.yellowColor()
//        } else {
//            colorSlider.minimumTrackTintColor = UIColor.redColor()
//        }
//    }

    }
}
