//
//  ScanQRCodeViewController.swift
//  LQQRCodeSwift
//
//  Created by hhh on 2019/8/25.
//  Copyright © 2019 LQ. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRCodeViewController: UIViewController {
     let width  = UIScreen.main.bounds.size.width
     let height = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black

        AVCaptureDevice.requestAccess(for: .video) { granted in
            if (!granted) {
                print("没有相机访问权限")
                return;
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                self.captureSession.startRunning()
            })
        }
        
    }
    
    //MARK: - 捕获会话
    lazy var captureSession: AVCaptureSession = {
        let captureDevice  = AVCaptureDevice.default(for: .video)
        let deviceInput    = try! AVCaptureDeviceInput.init(device: captureDevice!)
        let metaDataOutput = AVCaptureMetadataOutput()
        metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metaDataOutput.rectOfInterest = self.scanRect
        let session = AVCaptureSession()
        session.sessionPreset = .high
        session.addInput(deviceInput)
        session.addOutput(metaDataOutput)
        metaDataOutput.metadataObjectTypes = self.metaDataObjectTypes
        let layer          = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        layer.frame        = UIScreen.main.bounds
        self.view.layer.insertSublayer(layer, below: self.maskLayer)
        
        return session
    }()

    
    //MARK: - scanRect
    lazy var scanRect: CGRect = {
        let size = CGSize(width: width/2, height: width/2)
        let rect = CGRect(x: width/4, y: (height - width/2)/2, width: size.width, height: size.height)
        return CGRect(x: rect.origin.y/height, y: rect.origin.x/width, width: rect.size.height/height, height: rect.size.width/width)
    }()
    
    //MARK： - QRCodeTypes
    
    lazy var metaDataObjectTypes: [AVMetadataObject.ObjectType] = {
        let types = [AVMetadataObject.ObjectType.qr,
                     AVMetadataObject.ObjectType.ean13,
                     AVMetadataObject.ObjectType.ean8,
                     AVMetadataObject.ObjectType.upce,
                     AVMetadataObject.ObjectType.code39,
                     AVMetadataObject.ObjectType.code39Mod43,
                     AVMetadataObject.ObjectType.code93,
                     AVMetadataObject.ObjectType.code128,
                     AVMetadataObject.ObjectType.pdf417]
        return types
    }()
    
    //MARK: - maskLayer
    lazy var maskLayer: CAShapeLayer = {
        let layer       = CAShapeLayer()
        let path        = UIBezierPath.init(roundedRect: self.view.bounds, cornerRadius: 0)
        
        let size = CGSize(width: width/2, height: width/2)
        let rect = CGRect(x: width/4, y: (height - width/2)/2, width: size.width, height: size.height)
        let circlePath  = UIBezierPath.init(roundedRect: rect, cornerRadius: 5)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        layer.path      = path.cgPath;
        layer.fillRule  = CAShapeLayerFillRule.evenOdd;
        layer.fillColor = UIColor.black.cgColor;
        layer.opacity   = 0.5;
        
        
        self.view.layer.addSublayer(layer)
        return layer
    }()
}

extension ScanQRCodeViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count > 0 {
            let metadataObject:AVMetadataObject = metadataObjects[0]
            self.captureSession.stopRunning()
            
            let alert = UIAlertController.init(title: nil, message:metadataObject.value(forKey: "stringValue") as? String , preferredStyle: .alert)
            
            alert.addAction(UIAlertAction.init(title: "知道了", style:.cancel, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
}
