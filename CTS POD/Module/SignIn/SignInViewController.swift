
import UIKit
import Combine

class SignInViewController: BaseViewController<SignInViewModel> {

    private var cancellable = Set<AnyCancellable>()
    
    private lazy var iconImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
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
    
    private lazy var subTitleLabel: UILabel = {
        let view = UILabel()
        view.font = Fonts.popMedium
        view.textColor = Colors.colorGray
        view.textAlignment = .center
        view.text = viewModel.configuration.string.subTitle
        return view
    }()
    
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
    
    private lazy var txtPassword: UITextField = {
        let view = UITextField()
        view.font = Fonts.popSemiBold
        view.placeholder = viewModel.configuration.string.password
        view.isSecureTextEntry = true
        view.backgroundColor = .white
        view.borderStyle = .none
        view.layer.cornerRadius = 5
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: view.frame.height))
        view.leftView = paddingView
        view.leftViewMode = .always
        return view
    }()
    
    private lazy var headerStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [iconImage, lableTitle, subTitleLabel])
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    private lazy var textFieldsStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [txtUserName, txtPassword])
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    private lazy var containerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [iconImage, lableTitle, subTitleLabel, txtUserName, txtPassword, btnSignIn, btnForgotPassword])
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .fill
        return view
    }()
    
    private lazy var btnSignIn: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Fonts.popRegular
        view.backgroundColor = Colors.colorBlue
        view.setTitle(viewModel.configuration.string.signIn, for: .normal)
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(buttonSignInTap), for: .touchUpInside)
        return view
    }()
    
    private lazy var btnForgotPassword: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Fonts.popRegular
        view.setTitle(viewModel.configuration.string.forgotPassword, for: .normal)
        view.setTitleColor(Colors.colorGray, for: .normal)
        view.addTarget(self, action: #selector(buttonForgotPasswordTap), for: .touchUpInside)
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
        setLogo()
        bind()
    }
    
    init(viewModel: SignInViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLogo() {
        if let imageData = Data(base64Encoded: viewModel.customer.logo) {
            iconImage.image = UIImage(data: imageData)
        }
    }
    
    private func setupView() {
        view.backgroundColor = Colors.viewBackground
        view.addSubview(containerView)
        containerView.addArrangedSubview(headerStackView)
        containerView.addArrangedSubview(textFieldsStackView)

        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }

        iconImage.snp.makeConstraints {
            $0.height.width.equalTo(70)
        }
        
        textFieldsStackView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        txtUserName.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        txtPassword.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(45)
        }

        view.addSubview(btnSignIn)
        btnSignIn.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(containerView.snp.bottom).offset(30)
            $0.height.equalTo(50)
            $0.width.equalTo(100)
        }

        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(btnSignIn.snp.center)
        }
        
        view.addSubview(btnForgotPassword)
        btnForgotPassword.snp.makeConstraints {
            $0.top.equalTo(btnSignIn.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(30)
        }

        headerStackView.setCustomSpacing(30, after: iconImage)
        headerStackView.setCustomSpacing(10, after: lableTitle)
        containerView.setCustomSpacing(30, after: headerStackView)
        textFieldsStackView.setCustomSpacing(30, after: txtUserName)
    }
    
    private func bind() {
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .loading:
                    self.activityIndicator.startAnimating()
                    self.btnSignIn.isHidden = true
                case .loaded:
                    self.activityIndicator.stopAnimating()
                    self.btnSignIn.isHidden = false
                    self.navigationController?.popViewController(animated: true)
                case .error(let errorString):
                    self.showErrorAlert(message: errorString)
                    self.activityIndicator.stopAnimating()
                    self.btnSignIn.isHidden = false
                case .none: self.activityIndicator.stopAnimating()
                }
            }.store(in: &cancellable)
    }
    
    @objc
    func buttonSignInTap() {
        guard let userName = txtUserName.text, let password = txtPassword.text,
                (userName.count > 0 && password.count > 0) else { return }
        viewModel.signIn(username: userName, password: password)
    }
    
    @objc
    func buttonForgotPasswordTap() {
        self.navigationController?.pushViewController(ForgotPassword.build(customer: viewModel.customer), animated: true)
    }
}
