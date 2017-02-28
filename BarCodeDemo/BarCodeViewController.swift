//
//  BarCodeViewController.swift
//  BarCodeDemo
//
//  Created by IndrajitSinh Rayjada on 28/02/17.
//  Copyright © 2017 IndrajitSinh Rayjada. All rights reserved.
//

import UIKit
import AVFoundation

protocol BarcodeDelegate {
    func barcodeDetected(barcode: String)
}

class BarCodeViewController: UIViewController {
    
    var delegate: BarcodeDelegate?
    
    var videoCaptureDevice: AVCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    var device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    var output = AVCaptureMetadataOutput()
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var captureSession = AVCaptureSession()
    var code: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        setupCamera()
        // Do any additional setup after loading the view.
    }
    
    private func setupCamera() {
        
        let input = try? AVCaptureDeviceInput(device: videoCaptureDevice)
        
        if self.captureSession.canAddInput(input) {
            self.captureSession.addInput(input)
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        if let videoPreviewLayer = self.previewLayer {
            videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer.frame = self.view.bounds
            view.layer.addSublayer(videoPreviewLayer)
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if self.captureSession.canAddOutput(metadataOutput) {
            self.captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode,
                                                  AVMetadataObjectTypeCode39Code,
                                                  AVMetadataObjectTypeCode39Mod43Code,
                                                  AVMetadataObjectTypeEAN13Code,
                                                  AVMetadataObjectTypeEAN8Code,
                                                  AVMetadataObjectTypeCode93Code,
                                                  AVMetadataObjectTypeCode128Code,
                                                  AVMetadataObjectTypePDF417Code,
                                                  AVMetadataObjectTypeQRCode,
                                                  AVMetadataObjectTypeAztecCode]
            
        } else {
            print("Could not add metadata output")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if (captureSession.isRunning == false) {
            captureSession.startRunning();
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        if (captureSession.isRunning == true) {
            captureSession.stopRunning();
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension BarCodeViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        for metadata in metadataObjects {
            let readableObject = metadata as! AVMetadataMachineReadableCodeObject
            let code = readableObject.stringValue
            
            
            self.dismiss(animated: true, completion: nil)
            self.delegate?.barcodeDetected(barcode: code!)
            print(code!)
        }
    }
    
}
