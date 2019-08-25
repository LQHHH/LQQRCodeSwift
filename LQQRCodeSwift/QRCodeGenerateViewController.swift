//
//  QRCodeGenerateViewController.swift
//  LQQRCodeSwift
//
//  Created by hhh on 2019/8/25.
//  Copyright © 2019 LQ. All rights reserved.
//

import UIKit

class QRCodeGenerateViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var barImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - 点击生成二维码的方法
    @IBAction func click(_ sender: UIButton) {
        if textField.text!.count == 0 {
            print("清先输入想要转换的文字")
            return
        }
        textField.resignFirstResponder()
        
        let image = UIImage.LQQRCodeGenerate(QRCodeInfo: textField.text!, QRCodeImageSize: CGSize.init(width: 200, height:200))
        imageView.image = image
    }
    
    //MARK: - 点击生成logo二维码的方法
    @IBAction func clickToMakeLogoQRCode(_ sender: UIButton) {
        if textField.text!.count == 0 {
            print("清先输入想要转换的文字")
            return
        }
        textField.resignFirstResponder()
        
        let image = UIImage.LQLogoQRCodeGenerate(QRCodeInfo: textField.text!, QRCodeImageSize: CGSize.init(width: 200, height:200), logo: UIImage(named: "logo.png")!)
        imageView.image = image
    }
    
    //MARK: - 生成条形码
    @IBAction func clickMakeBar(_ sender: UIButton) {
        if textField.text!.count == 0 {
            print("清先输入想要转换的文字")
            return
        }
        textField.resignFirstResponder()
        
        let image = UIImage.LQQRBarCodeGenerate(QRBarCodeInfo: textField.text!, QRBarCodeImageSize: CGSize.init(width: self.view.frame.size.width, height:100))
        barImageView.image = image
    }
    
}

//MARK: - touchesBegan
extension QRCodeGenerateViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
}
