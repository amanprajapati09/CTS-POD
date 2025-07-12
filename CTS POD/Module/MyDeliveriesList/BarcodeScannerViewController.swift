//
//  BarcodeScannerViewController.swift
//  CTS POD
//
//  Created by Aman Prajapati on 12/07/25.
//

import UIKit
import AVFoundation

import UIKit
import AVFoundation

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITableViewDataSource, UITableViewDelegate {

    enum ScanMode {
        case single
        case multiple
    }

    var scanMode: ScanMode = .single
    var onBarcodeDetected: (([String]) -> Void)?

    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var foundBarcodes = [String]()

    // UI Elements
    private let tableView = UITableView()
    private let doneButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupCamera()
        setupTableView()
        if scanMode == .multiple {
            setupDoneButton()
        }
    }

    // MARK: - Camera Setup
    private func setupCamera() {
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput) else {
            print("Failed to set up camera")
            return
        }

        captureSession.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .qr, .code128, .code39, .pdf417]
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    // MARK: - Table View Setup
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BarcodeCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.heightAnchor.constraint(equalToConstant: 200),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Done Button
    private func setupDoneButton() {
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        doneButton.layer.cornerRadius = 8
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(finishMultiScan), for: .touchUpInside)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            doneButton.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -12),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 100),
            doneButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    // MARK: - Metadata Delegate
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        for metadata in metadataObjects {
            guard let readable = metadata as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readable.stringValue else { continue }

            if scanMode == .single {
                captureSession.stopRunning()
                onBarcodeDetected?([stringValue])
                dismiss(animated: true)
                return
            } else {
                if !foundBarcodes.contains(stringValue) {
                    foundBarcodes.append(stringValue)
                    tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Finish Multi-Scan
    @objc func finishMultiScan() {
        captureSession.stopRunning()
        onBarcodeDetected?(foundBarcodes)
        dismiss(animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundBarcodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarcodeCell", for: indexPath)
        cell.textLabel?.text = foundBarcodes[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .clear
        return cell
    }
}
