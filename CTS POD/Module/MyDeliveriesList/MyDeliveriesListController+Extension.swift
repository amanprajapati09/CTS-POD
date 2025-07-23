//
//  MyDeliveriesListController+Extension.swift
//  CTS POD
//
//  Created by Aman Prajapati on 12/07/25.
//

import Foundation
import UIKit

extension MyDeliveriesListViewController {
    
    @objc
    func barcodeButtonTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = .black
        let titleFont = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .bold),
                         NSAttributedString.Key.foregroundColor: UIColor.black]

        let attributedTitle = NSAttributedString(string: "Select Sacn Mode", attributes: titleFont)
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.addAction(UIAlertAction(title: "Single Scan", style: .default, handler: { action in
            alert.dismiss(animated: true)
            self.presentBarcodeScannerController(mode: .single)
        }))
        alert.addAction(UIAlertAction(title: "Multiple Scan", style: .default, handler: { action in
            alert.dismiss(animated: true)
            self.presentBarcodeScannerController(mode: .multiple)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            alert.dismiss(animated: true)
        }))
        navigationController?.present(alert, animated: true)
    }
    
    private func presentBarcodeScannerController(mode: BarcodeScannerViewController.ScanMode) {
        let scannerVC = BarcodeScannerViewController()
        scannerVC.scanMode = mode
        scannerVC.onBarcodeDetected = { codes in
            if mode == .single {
                if let scannedJob = codes.first {
                    self.manageSingleScan(scannedID: scannedJob)
                }
            } else {
                self.manageMultipleScan(scannedIDs: codes)
            }
        }
        
        present(scannerVC, animated: true)
    }
    
    private func manageSingleScan(scannedID: String) {
        if let selectedJob = jobs?.filter({
            $0.job.deliveryNo == scannedID
        }).first {
            let joblist = [selectedJob.job]
            let controller = DeliverySubmit.build(jobs: joblist)
            navigationController?.pushViewController(controller, animated: true)
        } else {
            showErrorAlert(message: "Cannot find delivery number \(scannedID)")
        }
    }
    
    private func manageMultipleScan(scannedIDs: [String]) {
        var notScannedJob: [String] = []
        for updateItem in scannedIDs {
            if let index = jobs?.firstIndex(where: { $0.job.deliveryNo == updateItem }) {
                jobs?[index].isSelected = true
            } else {
                notScannedJob.append(updateItem)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                if !notScannedJob.isEmpty {
                    self.showNotScannedAlert(notScannedjobs: notScannedJob)
                }
            })
        }
        tableView.reloadData()
    }
    
    private func showNotScannedAlert(notScannedjobs: [String]) {
        let alert = UIAlertController(title: "Can not find delivery number", message: "\(notScannedjobs.joined(separator: "\n"))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
