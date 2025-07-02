//
//  ImageHandler.swift
//  CTS POD
//
//  Created by Aman Prajapati on 02/07/25.
//

import UIKit

enum ImageResolution {
    case high
    case medium
    case low
    
    var size: CGSize {
        switch self {
        case .high:
            return CGSize(width: 1600, height: 1600)
        case .medium:
            return CGSize(width: 1000, height: 800)
        case .low:
            return CGSize(width: 819, height: 460)
        }
    }
}

extension UIImage {
    func resizeAndConvertToBase64(resolution: ImageResolution) -> String? {
        let targetSize = resolution.size
        
        // Resize image
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
        self.draw(in: CGRect(origin: .zero, size: targetSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let resized = resizedImage,
              let imageData = resized.jpegData(compressionQuality: 0.9) else {
            return nil
        }
        
        return imageData.base64EncodedString()
    }
}

