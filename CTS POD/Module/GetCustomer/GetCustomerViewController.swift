//
//  GetCustomerViewController.swift
//  CTS POD
//
//  Created by Aman Prajapati on 8/17/23.
//

import UIKit
import SnapKit
import Combine

class GetCustomerViewController: UIViewController {
    
    private var viewModel: GetCustomerViewModel
    private var cancellable = Set<AnyCancellable>()
    
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
        view.addTarget(self, action: #selector(buttonGoTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var containerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [iconImage, lableTitle, infoLabel, txtCustomer, btnGo])
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
        activityIndicator.stopAnimating()
    }
    
    init(viewModel: GetCustomerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        view.backgroundColor = Colors.viewBackground
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
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(btnGo.snp.center)
        }
        
        containerView.setCustomSpacing(20, after: iconImage)
        containerView.setCustomSpacing(10, after: lableTitle)
        containerView.setCustomSpacing(30, after: infoLabel)
        containerView.setCustomSpacing(25, after: txtCustomer)
    }
    
    @objc
    func buttonGoTap() {
        guard let customerName = txtCustomer.text,
        customerName.count > 0 else { return }
        viewModel.fetchCustomer(name: customerName)
    }
    
    private func bind() {
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self else { return }
                switch value {
                case .loading:
                    self.activityIndicator.startAnimating()
                    self.btnGo.isHidden = true
                case .loaded:
                    self.activityIndicator.stopAnimating()
                    self.btnGo.isHidden = false
                case .error(let errorString):
                    self.showErrorAlert(message: errorString)
                    self.activityIndicator.stopAnimating()
                    self.btnGo.isHidden = false
                case .none: self.activityIndicator.stopAnimating()
                }
            }.store(in: &cancellable)
    }
    
    private func showErrorAlert(message: String) {
        
    }
}
