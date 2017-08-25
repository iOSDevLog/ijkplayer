//
//  Barcode.swift
//  ijkplayer-Swift
//
//  Created by iOS Dev Log on 2017/8/24.
//  Copyright © 2017年 iOSDevLog. All rights reserved.
//

import Foundation
import AVFoundation

class Barcode: NSObject {
    var metadataObject: AVMetadataMachineReadableCodeObject?
    var barcodeType: String = ""
    var barcodeData: String = ""
    var cornersPath: UIBezierPath?
    var boundingBoxPath: UIBezierPath?
    
    class func processMetadataObject(_ code: AVMetadataMachineReadableCodeObject) -> Barcode {
        // 1 create the obj
        let barcode = Barcode()
        // 2 store code type and string
        barcode.barcodeType = code.type
        barcode.barcodeData = code.stringValue
        barcode.metadataObject = code
        // 3 & 4 Create the path joining code's corners
        let cornersPath: CGMutablePath = CGMutablePath()
        // 5 Make point
        var point: CGPoint
        let dictionary = (code.corners![0] as! CGPoint).dictionaryRepresentation

        point = CGPoint(dictionaryRepresentation: dictionary)!
        // 6 Make path
        cornersPath.move(to: CGPoint(x: point.x, y: point.y), transform: .identity)
        // 7
        for i in 1..<code.corners.count {
            point = CGPoint(dictionaryRepresentation: code.corners![i] as! CFDictionary)!
            cornersPath.addLine(to: CGPoint(x: point.x, y: point.y), transform: .identity)
        }
        // 8 Finish box
        cornersPath.closeSubpath()
        // 9 Set path
        barcode.cornersPath = UIBezierPath(cgPath: cornersPath)
        // Create the path for the code's bounding box
        // 10
        barcode.boundingBoxPath = UIBezierPath(rect: code.bounds)
        // 11 return
        return barcode
    }
    
    func getType() -> String {
        return barcodeType
    }
    
    func getData() -> String {
        return barcodeData
    }
    
    func printData() {
        print("Barcode of type: \(String(describing: metadataObject?.type)) and data: \(barcodeData)")
    }
}
