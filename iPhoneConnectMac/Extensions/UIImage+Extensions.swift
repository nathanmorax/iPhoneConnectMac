//
//  UIImage+Extensions.swift
//  iPhoneConnectMac
//
//  Created by Jesus Mora on 27/08/25.
//
import SwiftUI

extension UIImage {
    func dominantColor() -> UIColor? {
        
        guard let inputImage = CIImage(image: self) else { return .gray }
        
        let extent = inputImage.extent
        
        let context = CIContext()
        
        guard let colorData = context.createCGImage(inputImage, from: extent)?.dataProvider?.data else { return nil }
        
        let bitmap = CGContext(
            data: nil,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        
        bitmap?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        guard let data = bitmap?.data else { return .gray }
        
        let ptr = data.bindMemory(to: UInt8.self, capacity: 4)
        
        return UIColor(
            red: CGFloat(ptr[0]) / 255,
            green: CGFloat(ptr[1]) / 255,
            blue: CGFloat(ptr[2]) / 255,
            alpha: 1
        )
    }
}
