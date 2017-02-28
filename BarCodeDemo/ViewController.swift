//
//  ViewController.swift
//  BarCodeDemo
//
//  Created by IndrajitSinh Rayjada on 28/02/17.
//  Copyright © 2017 IndrajitSinh Rayjada. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var bacodeController : BarCodeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func barCodeDetectButtonTapped(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.bacodeController  =   (story.instantiateViewController(withIdentifier: "barcodeVC") as! BarCodeViewController)
        self.bacodeController?.delegate = self
        self.present(bacodeController!, animated: true, completion: nil)
    }
    
}

extension ViewController : BarcodeDelegate {
    
    func barcodeDetected(barcode: String) {
        let messageController =  UIAlertController(title: "Barcode Detected!", message: barcode, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        messageController.addAction(action)
        
        self.present(messageController, animated: true, completion: nil)
    }
}


