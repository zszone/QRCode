//
//  DetectorViewController.swift
//  QRCode
//
//  Created by zs on 16/6/20.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit

class DetectorViewController: UIViewController {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var resultLabel: UILabel!
//        {
//        didSet{
//          
//            // 1.获取当前显示的图片
//            let currentImage = imageView.image!
//            
//            // 2.将UIImage转成CIImage
//            let ciImage = CIImage(image: currentImage)!
//            
//            // 3.创建探测器
//            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
//            
//            // 4.弹出ciImage中所有的二维码
//            let resultArray = detector.featuresInImage(ciImage)
//            
//            // 5.遍历数据,拿到所有的二维码
//            for feature in resultArray {
//                let qrCodeFeature = feature as! CIQRCodeFeature
//                resultLabel!.text = qrCodeFeature.messageString
//        
//        }
//    
//    }
//
//}
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //1.获取当前显示的图片
        let currentImage = imageView.image!
        
        //2.将UIImage转换成CIImage
        let ciImage = CIImage(image: currentImage)!
        
        //3.创建探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        
        //4.弹出ciImage中所有的二维码
        let resultArray = detector.featuresInImage(ciImage)
        
        //5.遍历数据,拿到所有的二维码
        for feature in resultArray {
          let qrCodeFeature = feature as! CIQRCodeFeature
            resultLabel!.text = qrCodeFeature.messageString
        
        }
        
    }
}
extension DetectorViewController {
   
    
    @IBAction func photoPicker() {
          //1.判断照片源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        
        //2.创建图片选择控制器
        let ipc = UIImagePickerController()
        
        //3.设置照片来源
        ipc.sourceType = .PhotoLibrary
        
        //4.设置代理(在代理方法中拿到用户选中的照片)
        ipc.delegate = self
        
        //5.弹出控制器
        presentViewController(ipc, animated: true, completion: nil)
    }
  
}


extension DetectorViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //获取选中的图片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //将图片显示在imageView中
        imageView.image = image
        
        //退出控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
