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
        // Resize image
        let resizedImage = resizeImage(image: self, maxWidth: resolution.size.width, maxHeight: resolution.size.height)!
        
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        
        return imageData.base64EncodedString()
    }

    func resizeImage(image: UIImage, maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage? {
        let originalSize = image.size

        let widthRatio  = maxWidth / originalSize.width
        let heightRatio = maxHeight / originalSize.height
        let scaleFactor = min(widthRatio, heightRatio)

        // If the image is smaller than the max size, return original
        if scaleFactor >= 1 {
            return image
        }

        let newSize = CGSize(
            width: originalSize.width * scaleFactor,
            height: originalSize.height * scaleFactor
        )

        // Redraw the image at the new size
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }

}

