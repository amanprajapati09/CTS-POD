
import UIKit
import RxSwift
import Combine

class ResetPasswordViewController: BaseViewController<ResetPasswordViewModel> {

    private var cancellable = Set<AnyCancellable>()
    let disposeBag = DisposeBag()
    
    private lazy var btnResetpPassword: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Fonts.popRegular
        view.backgroundColor = Colors.colorBlue
        view.setTitle(viewModel.configuration.string.resetPassword, for: .normal)
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var txtPassword: UITextField = {
        let view = UITextField()
        view.font = Fonts.popSemiBold
        view.placeholder = viewModel.configuration.string.newPassword
        view.borderStyle = .none
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: view.frame.height))
        view.leftView = paddingView
        view.leftViewMode = .always
        return view
    }()
    
    private lazy var txtConfirmPassword: UITextField = {
        let view = UITextField()
        view.font = Fonts.popSemiBold
        view.placeholder = viewModel.configuration.string.confirmPassword
        view.borderStyle = .none
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: view.frame.height))
        view.leftView = paddingView
        view.leftViewMode = .always
        return view
    }()
    
    private lazy var contentView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [txtPassword, txtConfirmPassword, btnResetpPassword])
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
        navigationController?.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "Reset Password"
        setupView()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationItem.setHidesBackButton(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    init(viewModel: ResetPasswordViewModel) {
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
        
        btnResetpPassword.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
        
        contentView.setCustomSpacing(20, after: txtPassword)
        contentView.setCustomSpacing(40, after: txtConfirmPassword)
        
        txtPassword.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(btnResetpPassword.snp.center)
        }
        
        txtConfirmPassword.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
    }
    
    private func bind() {
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .loading:
                    self.activityIndicator.startAnimating()
                    self.btnResetpPassword.isHidden = true
                case .loaded:
                    self.activityIndicator.stopAnimating()
                    self.btnResetpPassword.isHidden = false
                    self.navigationController?.popToViewController(ofClass: DashboardViewController.self, animated: true)
                case .error(let errorString):
                    self.showErrorAlert(message: errorString)
                    self.activityIndicator.stopAnimating()
                    self.btnResetpPassword.isHidden = false
                case .none: self.activityIndicator.stopAnimating()
                }
            }.store(in: &cancellable)
        
        btnResetpPassword.rx.tap.subscribe(onNext: { [unowned self] in
            guard let password = txtPassword.text, password.count >= 4 else {
                showErrorAlert(message: "Please enter more then 4 count value.")
                return
            }
            guard let conformPass = txtConfirmPassword.text, conformPass == password else {
                showErrorAlert(message: "Please match password and confirm password.")
                return }
            self.viewModel.resetPassword(newPassword: txtPassword.text ?? "", conformPassword: txtConfirmPassword.text ?? "")
        }).disposed(by: disposeBag)
    }
}
