
import UIKit

class ResetPasswordViewController: BaseViewController<ResetPasswordViewModel> {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "Reset Password"
        setupView()
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
        
        txtConfirmPassword.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(45)
        }
    }
}
