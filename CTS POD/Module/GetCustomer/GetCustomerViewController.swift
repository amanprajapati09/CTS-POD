//
//  GetCustomerViewController.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/17/23.
//

import UIKit
import SnapKit

class GetCustomerViewController: UIViewController {

    var viewModel: GetCustomerViewModel
    
    private lazy var iconImage: UIImageView = {
        let view = UIImageView()
        view.image = viewModel.configuration.images.logo
        return view
    }()
    
    private lazy var lableTitle: UILabel = {
        let view = UILabel()
        view.font = Fonts.popSemiBold
        view.textColor = Colors.colorBlack
        view.textAlignment = .center
        view.text = viewModel.configuration.string.title
        return view
    }()
    
    private lazy var infoLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.popMedium
        view.textColor = Colors.colorGray
        view.textAlignment = .center
        view.text = viewModel.configuration.string.info
        return view
    }()
    
    private lazy var txtCustomer: UITextField = {
        let view = UITextField()
        view.font = Fonts.popSemiBold
        view.placeholder = viewModel.configuration.string.title
        return view
    }()
    
    private lazy var btnGo: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Fonts.popRegular
        view.backgroundColor = Colors.colorBlue
        view.setTitle(viewModel.configuration.string.buttonTitle, for: .normal)
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var containerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [iconImage, lableTitle, infoLabel, txtCustomer, btnGo])
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    init(viewModel: GetCustomerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.height.equalTo(300)
        }
        
        iconImage.snp.makeConstraints {
            $0.height.width.equalTo(100)
        }
        
        btnGo.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(60)
        }
        
        txtCustomer.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        containerView.setCustomSpacing(20, after: iconImage)
        containerView.setCustomSpacing(10, after: lableTitle)
        containerView.setCustomSpacing(30, after: infoLabel)
        containerView.setCustomSpacing(25, after: txtCustomer)
    }
}
