//
//  LoadingOverlay.swift
//  CTS POD
//
//  Created by Aman Prajapati on 20/07/25.
//


import UIKit

class LoadingOverlay {
    static let shared = LoadingOverlay()

    private var overlayView = UIView()
    private var activityIndicator = UIActivityIndicatorView(style: .large)

    private init() {
        overlayView.frame = UIScreen.main.bounds
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        overlayView.isUserInteractionEnabled = true

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        overlayView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ])
    }

    func show(over view: UIView? = nil) {
        guard let targetView = view ?? UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }

        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            targetView.addSubview(self.overlayView)
        }
    }

    func hide() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.overlayView.removeFromSuperview()
        }
    }
}
