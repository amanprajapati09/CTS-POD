//
//  DashboardViewController.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/20/23.
//

import UIKit

class DashboardViewController: UIViewController {
    
    private let viewModel: DashboardViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        view.backgroundColor = Colors.colorPrimary
    }
}
