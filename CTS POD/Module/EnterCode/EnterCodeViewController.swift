//
//  EnterCodeViewController.swift
//  CTS POD
//
//  Created by jayesh kanzariya on 23/08/23.
//

import UIKit
import SVPinView

class EnterCodeViewController: BaseViewController<EnterCodeViewModel> {

    private lazy var codeView: SVPinView = {
        let pinView = SVPinView()
        pinView.pinLength = 6
        pinView.interSpace = 15
        pinView.textColor = UIColor.black
        pinView.shouldSecureText = false
        pinView.style = .underline
        pinView.borderLineThickness = 1
        pinView.activeBorderLineThickness = 2
        pinView.font = Fonts.popRegular ?? UIFont.systemFont(ofSize: 12)
        return pinView
    }()
    
    private lazy var btnDidNotReceiveCode: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Fonts.popRegular
        view.setTitle(viewModel.configuration.string.didNotReceiveCode, for: .normal)
        view.setTitleColor(Colors.colorGray, for: .normal)
//        view.addTarget(self, action: #selector(buttonForgotPasswordTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var btnVerifyCode: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Fonts.popRegular
        view.backgroundColor = Colors.colorBlue
        view.setTitle(viewModel.configuration.string.verifyCode, for: .normal)
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
  //      view.addTarget(self, action: #selector(buttonSignInTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var contentView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [codeView, btnDidNotReceiveCode, btnVerifyCode])
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "Enter Code"
        setupView()
    }
    
    init(viewModel: EnterCodeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let safearea = view.safeAreaLayoutGuide
        view.backgroundColor = Colors.forgotPasswordViewBackground
        
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(safearea).inset(20)
            make.leading.trailing.equalTo(safearea).inset(20)
        }
        
        btnVerifyCode.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
        
        contentView.setCustomSpacing(20, after: codeView)
        contentView.setCustomSpacing(40, after: btnDidNotReceiveCode)
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
