//
//  ScanningViewController.swift
//  QRCode
//
//  Created by zs on 16/6/20.
//  Copyright © 2016年 zs. All rights reserved.
//

import UIKit
import AVFoundation

class ScanningViewController: UIViewController {

    @IBOutlet weak var scanLineBottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var scanBgView: UIView!
    
    var session : AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startScanAnimation()
    }
  
}
// MARK:- 扫描动画
extension ScanningViewController {
   
    private func startScanAnimation() {
        //1.修改约束
        scanLineBottomCons.constant = 0
       
        //2.开始动画
        UIView.animateWithDuration(1.5) { 
            UIView.setAnimationRepeatCount(HUGE)
           self.scanBgView.layoutIfNeeded()
        }
    }
   
    private func startScanning() {
        //1.创建输入
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        guard let input = try?AVCaptureDeviceInput(device: device) else {
            print("获取摄像头过程中有异常")
            return
        }
        
        //2.创建输出
       let output = AVCaptureMetadataOutput()
        
        output.setMetadataObjectsDelegate(self, queue:dispatch_get_main_queue())
        
        //3.创建会话.联系输入和输出
        let session = AVCaptureSession()
        session.addInput(input)
        session.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        self.session =  session
        
        //4.添加预览图片
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.frame = view.bounds
        self.view.layer.insertSublayer(layer, atIndex: 0)
        
        // 5.执行扫描区域
        // x/y/w/h --> 比例
        /*
         x: (屏幕的高度 – 240) * 0.5 / 屏幕的高度
         y:(屏幕的宽度 – 240) * 0.5 / 屏幕的高度
         w: 240 / 屏幕的高度
         h: 240 / 屏幕的宽度
         */
        let screenSize = UIScreen.mainScreen().bounds.size
        let x : CGFloat = (screenSize.height - 240) * 0.5 / screenSize.height
        let y : CGFloat = (screenSize.width - 240) * 0.5 / screenSize.width
        let w : CGFloat = 240 / screenSize.height
        let h : CGFloat = 240 / screenSize.width
        output.rectOfInterest = CGRect(x: x, y: y, width: w, height: h)
        
        //6.开始扫描
        session.startRunning()
    }
    
}

extension ScanningViewController : AVCaptureMetadataOutputObjectsDelegate {
  
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
//        print("扫描结果")
        for objc in metadataObjects {
         
            let qrCodeObject = objc as! AVMetadataMachineReadableCodeObject
            print(qrCodeObject.stringValue)
        
        }
    }

}
