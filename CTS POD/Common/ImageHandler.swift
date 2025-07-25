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
        let resizedImage = resizeImageIfNeeded(image: self, maxDimension: resolution.size.width)
        
        guard let imageData = resizedImage.jpegData(compressionQuality: 0.8) else {
            return nil
        }
        
        return imageData.base64EncodedString()
    }

    func resizeImageIfNeeded(image: UIImage, maxDimension: CGFloat = 1600) -> UIImage {
        let originalSize = image.size
        let width = originalSize.width
        let height = originalSize.height

        // Check if resizing is necessary
        if width <= maxDimension && height <= maxDimension {
            return image // No need to resize
        }

        // Determine scale ratio while preserving aspect ratio
        let widthRatio = maxDimension / width
        let heightRatio = maxDimension / height
        let scaleFactor = min(widthRatio, heightRatio)

        let newSize = CGSize(width: width * scaleFactor, height: height * scaleFactor)

        // Resize the image using UIGraphics
        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }

        return resizedImage
    }

}

