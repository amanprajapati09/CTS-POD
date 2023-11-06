
import UIKit
import RxSwift
import Combine
import SignaturePad

class SignViewController: BaseViewController<SignViewModel> {
    
    private var isAllSelected = true
    private var cancellable = Set<AnyCancellable>()
    
    private lazy var buttonCancel: UIButton = {
        let view = UIButton()
        view.backgroundColor = Colors.colorPrimary
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.setTitle(viewModel.configuration.string.cancelTitle, for: .normal)
        view.snp.makeConstraints { $0.height.equalTo(40) }
        view.addTarget(self, action: #selector(buttonCancelTap), for: .touchUpInside)
        view.layer.cornerRadius = 10
        view.titleLabel?.font = Fonts.popRegular
        view.tag = 0
        return view
    }()
    
    private lazy var buttonClear: UIButton = {
        let view = UIButton()
        view.backgroundColor = Colors.colorPrimary
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.setTitle(viewModel.configuration.string.clearTitle, for: .normal)
        view.snp.makeConstraints { $0.height.equalTo(40)
        }
        view.addTarget(self, action: #selector(buttonClearTap), for: .touchUpInside)
        view.layer.cornerRadius = 10
        view.titleLabel?.font = Fonts.popRegular
        view.tag = 0
        return view
    }()
    
    private lazy var ButtonSave: UIButton = {
        let view = UIButton()
        view.backgroundColor = Colors.colorPrimary
        view.setTitleColor(Colors.colorWhite, for: .normal)
        view.setTitle(viewModel.configuration.string.saveTitle, for: .normal)
        view.snp.makeConstraints { $0.height.equalTo(40) }
        view.addTarget(self, action: #selector(buttonSaveTap), for: .touchUpInside)
        view.layer.cornerRadius = 10
        view.titleLabel?.font = Fonts.popRegular
        view.tag = 0
        return view
    }()
    
    private lazy var buttonContainer: UIStackView = {
        let view = UIStackView(arrangedSubviews: [buttonCancel, buttonClear, ButtonSave])
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 5
        return view
    }()
    
    private lazy var signaturePad: SignaturePad = {
        let view = SignaturePad()
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if #available(iOS 16.0, *) {
            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))
        } else {
            let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        setupView()
    }
    
    init(viewModel: SignViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        view.backgroundColor = Colors.forgotPasswordViewBackground
        
        view.addSubview(buttonContainer)
        buttonContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        view.addSubview(signaturePad)
        signaturePad.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(buttonContainer.snp.bottom).offset(10)
        }
    }
    
    @objc
    private func buttonCancelTap() {
        dismiss(animated: true)
    }
    
    @objc
    private func buttonClearTap() {
        signaturePad.clear()        
    }
    
    @objc
    private func buttonSaveTap() {
        if let signImage = signaturePad.getSignature() {
            if let data = signImage.pngData() {
                viewModel.updateJobs(signData: data)
            }
        }
    }
}

extension SignViewController: SignaturePadDelegate {
    func didStart() {}
    func didFinish() {}
}
