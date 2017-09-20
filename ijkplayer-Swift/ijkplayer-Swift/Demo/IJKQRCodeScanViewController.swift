//
//  IJKQRCodeScanViewController.swift
//  ijkplayer-Swift
//
//  Created by iOS Dev Log on 2017/8/24.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import UIKit

class IJKQRCodeScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var previewView: UIView!
    var allowedBarcodeTypes = [String]()
    
    private var captureSession: AVCaptureSession?
    private var videoDevice: AVCaptureDevice?
    private var videoInput: AVCaptureDeviceInput?
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var running: Bool = false
    private var metadataOutput: AVCaptureMetadataOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Scan QRCode"
        setupCaptureSession()
        previewLayer?.frame = previewView.bounds
        previewView.layer.addSublayer(previewLayer!)
        // listen for going into the background and stop the session
        // set default allowed barcode types, remove types via setings menu if you don't want them to be able to be scanned
        allowedBarcodeTypes = [String]()
        allowedBarcodeTypes.append("org.iso.QRCode")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        previewLayer?.frame = previewView.bounds
        setupCaptureOrientation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopRunning()
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - AV capture methods
    func setupCaptureSession() {
        if captureSession != nil {
            return
        }
        videoDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if videoDevice == nil {
            return
        }
        captureSession = AVCaptureSession()
        videoInput = try? AVCaptureDeviceInput(device: videoDevice)
        if (captureSession?.canAddInput(videoInput))! {
            captureSession?.addInput(videoInput)
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession ?? AVCaptureSession())
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        // capture and process the metadata
        metadataOutput = AVCaptureMetadataOutput()
        metadataOutput?.setMetadataObjectsDelegate(self as AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
        if (captureSession?.canAddOutput(metadataOutput))! {
            captureSession?.addOutput(metadataOutput)
        }
    }
    
    func setupCaptureOrientation() {
        if (previewLayer?.connection?.isVideoOrientationSupported)! {
            var orientation: AVCaptureVideoOrientation
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:
                orientation = .landscapeLeft
            case .landscapeRight:
                orientation = .landscapeRight
            default:
                orientation = .landscapeLeft
            }
            
            previewLayer?.connection?.videoOrientation = orientation
        }
    }
    
    func startRunning() {
        if running {
            return
        }
        captureSession?.startRunning()
        metadataOutput?.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        //_metadataOutput.availableMetadataObjectTypes;
        running = true
    }
    
    func stopRunning() {
        if !running {
            return
        }
        captureSession?.stopRunning()
        running = false
    }
    
    func applicationWillEnterForeground(_ note: Notification) {
        startRunning()
    }
    
    func applicationDidEnterBackground(_ note: Notification) {
        stopRunning()
    }
    
    // MARK: - Delegate functions
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        (metadataObjects as NSArray).enumerateObjects({
            (enumItem, idx, stop) -> Void in
            let obj = enumItem as! AVMetadataObject
            if (obj is AVMetadataMachineReadableCodeObject) {
                let code: AVMetadataMachineReadableCodeObject? = (self.previewLayer?.transformedMetadataObject(for: obj) as? AVMetadataMachineReadableCodeObject)
                let barcode = Barcode.processMetadataObject(code!)
                for str: String in self.allowedBarcodeTypes {
                    if (barcode.barcodeType == str) {
                        self.validBarcodeFound(barcode)
                        return
                    }
                }
            }
        })
    }
    
    func validBarcodeFound(_ barcode: Barcode) {
        stopRunning()
        showBarcodeAlert(barcode)
    }
}

extension IJKQRCodeScanViewController: UIAlertViewDelegate{
    func showBarcodeAlert(_ barcode: Barcode) {
        let message = UIAlertView(title: "", message: barcode.getData(), delegate: self, cancelButtonTitle: "Scan Again", otherButtonTitles: "Play")
        message.show()
    }
    
    func alertView(_ alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == alertView.cancelButtonIndex {
            startRunning()
        }
        else {
            let url = URL(string: alertView.message!)
            IJKPlayerViewController.present(from: self, withTitle: "URL: \(String(describing: url))", url: url!, completion: {() -> Void in
                self.navigationController?.popViewController(animated: false)
            })
        }
    }
}
