//
//  Extension.swift
//  LQQRCodeSwift
//
//  Created by hhh on 2019/8/25.
//  Copyright © 2019 LQ. All rights reserved.
//

import UIKit

//二维码生成器
extension UIImage {
    
    // MAKR: - 二维码生成器 中间有图片
    class func LQLogoQRCodeGenerate(QRCodeInfo message:String,QRCodeImageSize size:CGSize,logo centerImage:UIImage) -> UIImage {
        
        let image = LQQRCodeGenerate(QRCodeInfo: message, QRCodeImageSize: size)
        UIGraphicsBeginImageContextWithOptions(image.size, true, UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        let logoWidth = min(image.size.width, image.size.height)/4.0
        let x         = (image.size.width - logoWidth)/2.0
        let y         = (image.size.height - logoWidth)/2.0
        let rect      = CGRect.init(x: x, y: y, width: logoWidth, height: logoWidth)
        let path      = UIBezierPath.init(roundedRect: rect, cornerRadius: logoWidth/5.0)
        path.lineWidth = 2.0
        UIColor.white.set()
        path.stroke()
        path.addClip()
        centerImage.draw(in: rect)
        let logoQRCodeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return logoQRCodeImage!
    }
    
   // MAKR: - 二维码生成器（中间没有图片）
   class func LQQRCodeGenerate(QRCodeInfo message:String,QRCodeImageSize size:CGSize) -> UIImage {
    
    assert(message.count > 0)
    assert(!size.equalTo(CGSize.zero))
    
    let infoData = message.data(using: .utf8)
    let filter   = CIFilter(name: "CIQRCodeGenerator")
    filter?.setValue(infoData!, forKey: "inputMessage")
    filter?.setValue("H", forKey: "inputCorrectionLevel")
    var ciImage  = filter?.outputImage
    let scaleX   = min(size.width, size.height)/(ciImage?.extent.size.width)!
    let scaleY   =  min(size.width, size.height)/(ciImage?.extent.size.height)!
    ciImage      = ciImage?.transformed(by: CGAffineTransform.init(scaleX: scaleX, y: scaleY))
    let image = UIImage.init(ciImage: ciImage!)
    return image
    }
    
}

//MARK: - 条形码生成器
extension UIImage {
    
    class func LQQRBarCodeGenerate(QRBarCodeInfo message:String,QRBarCodeImageSize size:CGSize) -> UIImage {
        
        assert(message.count > 0)
        assert(!size.equalTo(CGSize.zero))
        
        let infoData = message.data(using: .utf8)
        let filter   = CIFilter(name: "CICode128BarcodeGenerator")
        filter?.setValue(infoData!, forKey: "inputMessage")
        filter?.setValue(NSNumber(value: 0), forKey:"inputQuietSpace")
        var ciImage  = filter?.outputImage
        let scaleX   = min(size.width, size.height)/(ciImage?.extent.size.width)!
        let scaleY   =  min(size.width, size.height)/(ciImage?.extent.size.height)!
        ciImage      = ciImage?.transformed(by: CGAffineTransform.init(scaleX: scaleX, y: scaleY))
        let image = UIImage.init(ciImage: ciImage!)
        return image
    }
}
