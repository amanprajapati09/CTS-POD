//
//  ForgotPasswordViewController.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 22/08/23.
//

import UIKit
import RxSwift
import RxCocoa

class ForgotPasswordViewController: BaseViewController<ForgotPasswordViewModel> {
    
    enum ForgotPasswordOption {
        case regenerateCode
        case existingCode
    }
    
    private lazy var selectOptionStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [generateCodeView, existingCodeView])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 20
        return view
    }()
    
    private lazy var generateCodeView = RadioButtonView(isSelected: true, title: "Generate Code") { [unowned self] isSelected in
        selectedValue = .regenerateCode
    }
    
    private lazy var existingCodeView = RadioButtonView(isSelected: false , title: "Existing Code") { [unowned self] isSelected in
        selectedValue = .existingCode
    }
    
    open var selectedValue: ForgotPasswordOption = .regenerateCode {
        didSet {
            switch selectedValue {
            case .regenerateCode:
                self.existingCodeView.btnRadio.isSelected = false
                self.generateCodeView.btnRadio.isSelected = true
            case .existingCode:
                self.existingCodeView.btnRadio.isSelected = true
                self.generateCodeView.btnRadio.isSelected = false
                navigateToEnterCode()
            }
        }
    }
    
    private lazy var txtUserName: UITextField = {
        let view = UITextField()
        view.font = Fonts.popSemiBold
        view.placeholder = viewModel.configuration.string.userName
        view.borderStyle = .none
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: view.frame.height))
        view.leftView = paddingView
        view.leftViewMode = .always
        return view
    }()
    
    private lazy var txtCustomerName: UITextField = {
        let view = UITextField()
        view.font = Fonts.popSemiBold
        view.borderStyle = .none
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        view.isEnabled = false
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: view.frame.height))
        view.leftView = paddingView
        view.leftViewMode = .always
        return view
    }()
    
    private lazy var btnForgotPassword: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Fonts.popRegular
        view.backgroundColor = Colors.colorBlue
        view.setTitle(viewModel.configuration.string.generateCode, for: .normal)
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var noteLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.popRegular
        view.textColor = Colors.colorGray
        view.textAlignment = .center
        view.text = viewModel.configuration.string.note
        view.numberOfLines = 0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "Forgot Password"
        setupView()
    }
    
    init(viewModel: ForgotPasswordViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let safearea = view.safeAreaLayoutGuide
        view.backgroundColor = Colors.forgotPasswordViewBackground
        view.addSubview(selectOptionStackView)
        
        selectOptionStackView.snp.makeConstraints { make in
            make.top.equalTo(safearea).inset(20)
            make.leading.trailing.equalTo(safearea).inset(20)
        }
        
        view.addSubview(txtUserName)
        
        txtUserName.snp.makeConstraints { make in
            make.top.equalTo(selectOptionStackView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(safearea).inset(20)
            make.height.equalTo(45)
        }
        
        view.addSubview(txtCustomerName)
        txtCustomerName.snp.makeConstraints { make in
            make.top.equalTo(txtUserName.snp.bottom).offset(20)
            make.leading.trailing.equalTo(safearea).inset(20)
            make.height.equalTo(45)
        }
        
        view.addSubview(btnForgotPassword)
        btnForgotPassword.snp.makeConstraints { make in
            make.top.equalTo(txtCustomerName.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        view.addSubview(noteLabel)
        noteLabel.snp.makeConstraints { make in
            make.bottom.equalTo(safearea).inset(20)
            make.leading.trailing.equalTo(safearea).inset(30)
        }
        
        txtCustomerName.text = viewModel.customer.domainname
        
    }
    
    func navigateToEnterCode() {
        self.navigationController?.pushViewController(EnterCode.build(customer: viewModel.customer), animated: true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ForgotPasswordViewController {
    class RadioButtonView: UIView {
        
        let disposeBag = DisposeBag()
        
        var onChanged: ((Bool) -> Void)?
        
        private lazy var lableTitle: UILabel = {
            let view = UILabel()
            view.font = Fonts.popSemiBold
            view.textColor = Colors.colorBlack
            view.textAlignment = .left
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
            return view
        }()
        
        public lazy var btnRadio: UIButton = {
            let view = UIButton()
            view.setImage(UIImage(named: "icn_radio_on"), for: .selected)
            view.setImage(UIImage(named: "icn_radio_off"), for: .normal)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            return view
        }()
        
        
        private lazy var contentView: UIStackView = {
            let view = UIStackView(arrangedSubviews: [btnRadio, lableTitle])
            view.axis = .horizontal
            view.distribution = .fill
            view.alignment = .center // Use .center alignment
            view.spacing = 10
            return view
        }()
                
        init(isSelected: Bool, title: String, onChanged: ((Bool) -> Void)? = nil) {
            super.init(frame: .zero)
            self.onChanged = onChanged
            btnRadio.isSelected = isSelected
            lableTitle.text = title
            setupView()
        }
        
        private func setupView() {
            self.addSubview(contentView)
            
            contentView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            btnRadio.snp.makeConstraints { make in
                make.width.equalTo(20)
            }
                        
            btnRadio.rx.tap.subscribe(onNext: { [unowned self] in
                if !self.btnRadio.isSelected {
                    self.onChanged?(true)
                }
            }).disposed(by: disposeBag)
        }
        
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
