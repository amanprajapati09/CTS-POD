
import UIKit
import SVPinView
import RxSwift
import Combine

class EnterCodeViewController: BaseViewController<EnterCodeViewModel> {

    private var cancellable = Set<AnyCancellable>()
    let disposeBag = DisposeBag()
    
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
        //view.addTarget(self, action: #selector(buttonForgotPasswordTap), for: .touchUpInside)
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
        return view
    }()
    
    private lazy var contentView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [codeView, btnDidNotReceiveCode, btnVerifyCode])
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
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "Enter Code"
        setupView()
        bind()
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
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalTo(btnVerifyCode.snp.center)
        }
        
        contentView.setCustomSpacing(20, after: codeView)
        contentView.setCustomSpacing(40, after: btnDidNotReceiveCode)
    }
    
    private func bind() {
        viewModel.$viewState
            .receive(on: DispatchQueue.main)
            .sink { value in
                switch value {
                case .loading:
                    self.activityIndicator.startAnimating()
                    self.btnVerifyCode.isHidden = true
                case .loaded(let otp):
                    self.activityIndicator.stopAnimating()
                    self.btnVerifyCode.isHidden = false
                    self.navigationController?.pushViewController(ResetPassword.build(customer: self.viewModel.customer, otp: otp), animated: true)
                case .error(let errorString):
                    self.showErrorAlert(message: errorString)
                    self.activityIndicator.stopAnimating()
                    self.btnVerifyCode.isHidden = false
                case .none: self.activityIndicator.stopAnimating()
                }
            }.store(in: &cancellable)
        
        btnVerifyCode.rx.tap.subscribe(onNext: { [unowned self] in
            self.viewModel.verifyOTP(otpValue: codeView.getPin())
        }).disposed(by: disposeBag)
    }
}
