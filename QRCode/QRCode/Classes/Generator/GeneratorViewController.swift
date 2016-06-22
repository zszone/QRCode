//
//  GeneratorViewController.swift
//  QRCode
//
//  Created by zs on 16/6/20.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit

private let ImageViewW : CGFloat = 240
class GeneratorViewController: UIViewController {

    @IBOutlet weak var textFiled: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

// MARK:- 生成二维码
extension GeneratorViewController {
  
    @IBAction func generateBtnClick() {
        //0.退出编辑
        view.endEditing(true)
        //1.获取用户输入的内容
       guard let inputMsg = textFiled.text else{
        print("没有输入任何内容")
          return
        }
        guard inputMsg.characters.count != 0 else{
          print("没有输入具体内容")
          return
        }
        
        //2.将内容生成二维码
        //2.1 创建过滤器(滤镜) :CIQRCodeGenerator -- 它是创建二维码的过滤器

        
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        //2.2 给滤镜设置内容(KVC)
        let inputData = inputMsg.dataUsingEncoding(NSUTF8StringEncoding)
        filter?.setValue(inputData, forKeyPath: "inputMessage")
        
        //设置二维码的容错等级
        filter?.setValue("H", forKeyPath: "inputCorrectionLevel")
        
        //2.3.获取生成的二维码图片
        guard let outputImage = filter?.outputImage else {
          
            return
        }
//        print(outputImage)
        //3.生成高清图片
        
        let hdImage = createHDImage(outputImage,ratio : ImageViewW / outputImage.extent.width)
        
        //获取前景图片
        let fgImage = UIImage(named: "gao")
        
        let newImage = createImageWithFGImage(hdImage, fgImage: fgImage!)
        // 将生成的二维码在imageView中显示
        imageView.image = newImage
    }
    
    private func createHDImage(ciImage : CIImage,ratio : CGFloat) -> UIImage {
    
       //1.放大图片
        let transform = CGAffineTransformMakeScale(ratio, ratio)
        let newCiImage = ciImage.imageByApplyingTransform(transform)
        
        //2.创建image对象
        return UIImage(CIImage: newCiImage)
    }
    
    private func createImageWithFGImage(hdimage : UIImage, fgImage : UIImage) -> UIImage{
       //0.获取高清二维码图片的size
        let size = hdimage.size
        //1.开启上下文
        UIGraphicsBeginImageContext(size)
        
        //2.将高清图片画到上下文
        hdimage.drawInRect(CGRect(origin: CGPointZero, size: size))
        
        //3.将前景图片画到上下文
        let w : CGFloat  = 60
        let h : CGFloat  = 60
        let x : CGFloat  = (size.width - w) * 0.5
        let y : CGFloat  = (size.height - h) * 0.5
        
        
        fgImage.drawInRect(CGRect(x: x, y: y, width: w, height: h))
        
        //4.从上下文中取出图片
        let newImage =  UIGraphicsGetImageFromCurrentImageContext()
        
        //5.关闭上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
    

}