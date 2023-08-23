
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
        return view
    }()
    
    private lazy var txtPassword: UITextField = {
        let view = UITextField()
        view.font = Fonts.popSemiBold
        view.placeholder = viewModel.configuration.string.password
        return view
    }()
    
    private lazy var containerView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [iconImage, lableTitle, subTitleLabel, txtUserName, txtPassword, btnSignIn])
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
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupView()
        setLogo()
        bind()
    }
    
    init(viewModel: SignInViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
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

        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }

        iconImage.snp.makeConstraints {
            $0.height.width.equalTo(70)
        }
        
        txtUserName.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        txtPassword.snp.makeConstraints {
            $0.width.equalToSuperview()
        }

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

        containerView.setCustomSpacing(30, after: iconImage)
        containerView.setCustomSpacing(10, after: lableTitle)
        containerView.setCustomSpacing(30, after: subTitleLabel)
        containerView.setCustomSpacing(30, after: txtUserName)
        containerView.setCustomSpacing(40, after: txtPassword)
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
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            alert.dismiss(animated: true)
        }))
        navigationController?.present(alert, animated: true)
    }
    

}
